-- Elisabeth & Acacia
-- create triggers for lab 2d
-- May 2, 2017

DROP TRIGGER IF EXISTS check_revRICode;
DROP TRIGGER IF EXISTS resignedReviewer;
DROP TRIGGER IF EXISTS setManuscriptsToPublished;
DROP TABLE IF EXISTS error_logs;

-- table that keeps track of all the errors we test for and the output messages
-- decided to use a table bc signal error message would stop the rest of triggertest from running
CREATE TABLE    error_logs
  ( PK MEDIUMINT NOT NULL AUTO_INCREMENT,
	error_time DATETIME,
	trigger_num   INT,
    error_msg VARCHAR (128),
    PRIMARY KEY (PK)
  );

-- TRIGGER 1
DELIMITER ;;
CREATE TRIGGER check_revRICode BEFORE INSERT ON manuscript 
FOR EACH ROW 
BEGIN
	DECLARE num_reviewers INT;
	DECLARE signal_message VARCHAR(128);
    
    -- get num of reviewers with RICode that matches the given manuscript val
	SET num_reviewers = (SELECT COUNT(RICode) FROM person_to_RICode WHERE RICode = new.RICode GROUP BY RICode);
    IF num_reviewers < 3 THEN
		SET signal_message = CONCAT('Unfortunately, your paper cannot be considered at this time. Thank you for the submission.');
 		SIGNAL SQLSTATE '45000' SET message_text = signal_message;
    END IF;
END;;
  
-- TRIGGER 2
DELIMITER $$
CREATE TRIGGER resignedReviewer BEFORE DELETE ON person FOR EACH ROW
BEGIN
    DECLARE man_id int;
    DECLARE num_reviewers int;
    
    -- Variables related to cursor:
    --    1. 'done' will be used to check if all the rows in the cursor 
    --       have been read
    --    2. 'curRes' will be the cursor: it will fetch each row
    --    3. The 'continue' handler will update the 'done' variable
    DECLARE done int default false;
    DECLARE curRes cursor for
        SELECT DISTINCT manuscript_id FROM reviewer_info WHERE reviewer_person_id = OLD.person_id; -- This is the query used by the cursor.
    DECLARE continue handler for not found -- This handler will be executed if no row is found in the cursor (for example, if all rows have been read).
        SET done = true;

    -- Open the cursor: This will put the cursor on the first row of its
    -- rowset.
    open curRes;
    -- Begin the loop (that 'loop_res' is a label for the loop)
    loop_res: loop
        -- When you fetch a row from the cursor, the data from the current
        -- row is read into the variables, and the cursor advances to the
        -- next row. If there's no next row, the 'continue handler for not found'
        -- will set the 'done' variable to 'TRUE'
        fetch curRes into man_id;
        -- Exit the loop if you're done
        if done then
            leave loop_res;
        END if;
        -- Execute your desired query.
		SELECT COUNT(manuscript_id) INTO num_reviewers FROM reviewer_info WHERE manuscript_id = man_id;
		IF num_reviewers < 4 THEN
			UPDATE manuscript SET `man_status`='submitted' WHERE manuscript_id=man_id;
			INSERT INTO error_logs (error_time, trigger_num, error_msg) VALUES (SYSDATE(), 2, Concat('Manuscript #', man_id, ' is no longer under review.'));
		END IF;
    END LOOP;
    -- Don't forget to close the cursor when you finish
    close curRes;
END $$
DELIMITER ;

-- TRIGGER 3 - set the man_status for all manuscripts in an issue to "published" when editor publishes the issue
DELIMITER $$
CREATE TRIGGER setManuscriptsToPublished AFTER UPDATE ON issue FOR EACH ROW
BEGIN
    DECLARE man_id int;
    
    -- Variables related to cursor:
    --    1. 'done' will be used to check if all the rows in the cursor 
    --       have been read
    --    2. 'curRes' will be the cursor: it will fetch each row
    --    3. The 'continue' handler will update the 'done' variable
    DECLARE done int default false;
    DECLARE curRes cursor for
        SELECT manuscript_id FROM issue_to_man JOIN issue ON issue_to_man.issue_id=issue.issue_id WHERE issue.issue_id=OLD.issue_id AND issue.print_date IS NOT NULL; -- This is the query used by the cursor.
    DECLARE continue handler for not found -- This handler will be executed if no row is found in the cursor (for example, if all rows have been read).
        SET done = true;

    -- Open the cursor: This will put the cursor on the first row of its
    -- rowset.
    open curRes;
    -- Begin the loop (that 'loop_res' is a label for the loop)
    loop_res: loop
        -- When you fetch a row from the cursor, the data from the current
        -- row is read into the variables, and the cursor advances to the
        -- next row. If there's no next row, the 'continue handler for not found'
        -- will set the 'done' variable to 'TRUE'
        fetch curRes into man_id;
        -- Exit the loop if you're done
        if done then
            leave loop_res;
        END if;
        -- Execute your desired query.
		UPDATE manuscript SET `man_status`='published' WHERE manuscript_id=man_id;
		INSERT INTO error_logs (error_time, trigger_num, error_msg) VALUES (SYSDATE(), 3, Concat('Manuscript #', man_id, ' has been published.'));
    END LOOP;
    -- Don't forget to close the cursor when you finish
    close curRes;
END $$
DELIMITER ;
-- 
