-- Elisabeth & Acacia
-- test triggers for lab 2d
-- May 2, 2017

-- TEST FOR TRIGGER 1:
-- When an author is submitting a new manuscript to the system with an RICode for which 
-- there is no reviewer who handles that RICode you should raise an exception that informs 
-- the author the paper can not be considered at this time.

-- editor
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (101,"Silas","Diaz","editor");

-- 3 reviewers with RICode exist
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (51,"Montana","Forbes","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (52,"Kay","Jensen","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (53,"Rachel","Winters","reviewer");
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (51,51);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (52,51);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (53,51);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (61,"nonummy","2016-07-14 08:14:49","submitted",51,101);

-- only 2 reviewers with RICode exist
-- expect signal/error to be thrown
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (51,52);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (52,52);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (71,"nonummy","2016-07-14 08:14:49","submitted",52,101);

-- only 1 reviewer with RICode exists
-- expect signal/error to be thrown
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (51,53);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (81,"nonummy","2016-07-14 08:14:49","submitted",53,101);


-- TEST FOR TRIGGER 2:
-- When a reviewer resigns any manuscript in “UnderReview” state for which that reviewer was the only reviewer, 
-- that manuscript must be reset to “submitted” state and an apprpriate exception message displayed.

-- note that manuscripts 1, 2, 3, 4, 5 are all "under review"
SELECT * FROM manuscript; 

-- reviewer 71 is a reviewer for manuscripts 2, 3, and 4
SELECT * FROM reviewer_info ORDER BY reviewer_person_id ASC;

-- delete reviewer 71 
DELETE FROM person WHERE `person_id`=71;

-- note that manuscripts 2 and 3 have changed to a "submitted" man_status
SELECT * FROM manuscript; 

-- manuscript 4 is still "under review" because it still has 3 reviewers
SELECT * FROM reviewer_info ORDER BY manuscript_id ASC;


-- outputs errors from trigger1 tests and trigger2 tests.  There should be three errors in the table that results from the following query.
SELECT * FROM error_logs;



