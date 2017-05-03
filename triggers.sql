-- Elisabeth & Acacia
-- create triggers for lab 2d
-- May 2, 2017

DELIMITER ;;
CREATE TRIGGER check_revRICode BEFORE INSERT ON manuscript 
FOR EACH ROW 
BEGIN
	DECLARE num_reviewers INT;
	DECLARE signal_message VARCHAR(128);
    
	SET num_reviewers = (SELECT COUNT(RICode) FROM person_to_RICode WHERE RICode = new.RICode GROUP BY RICode);
    IF num_reviewers < 3 THEN
		SET signal_message = CONCAT('Unfortunately, your paper cannot be considered at this time. Thank you for the submission.');
		SIGNAL SQLSTATE '45000' SET message_text = signal_message;
    END IF;
END;;
  
  
  
  
  
  
  
-- 
-- -- EXAMPLES
-- DELIMITER $$
-- 
-- CREATE TRIGGER staffOfficeNullReplacerTrigger BEFORE INSERT ON Staff
-- FOR EACH ROW BEGIN
--    IF (NEW.office IS NULL) THEN
--         INSERT INTO Staff(office) VALUES("N/A");
--    END IF;
-- END$$
-- DELIMITER;
-- 
-- CREATE TRIGGER check_for_aliens AFTER UPDATE ON takes
-- REFERENCING NEW ROW AS nrow 
-- BEGIN
-- UPDATE student
-- SET tot_cred = 0
-- WHERE name='Zaphod' AND takes.
-- 
--   
-- DELIMITER ;;
-- CREATE TRIGGER `ins_film` BEFORE INSERT ON `film` FOR EACH ROW BEGIN
--     INSERT INTO film_text (film_id, title, description)
--         VALUES (new.film_id, new.title, new.description);
--   END;;
--   
--   -- makes sure emp backup is same as emp
-- CREATE TRIGGER TRG_InsertSyncEmp 
-- ON dbo.EMPLOYEE
-- AFTER INSERT AS
-- BEGIN
-- INSERT INTO EMPLOYEE_BACKUP
-- SELECT * FROM INSERTED
-- END
-- 