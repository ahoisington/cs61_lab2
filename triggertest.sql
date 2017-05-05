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

-- editor
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (102,"Plato","Pace","editor");

-- reviewers
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (60,"Fay","Chan","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (61,"Montana","Forbes","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (62,"Kay","Jensen","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (63,"Rachel","Winters","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (64,"Thor","Simmons","reviewer");
INSERT INTO `person` (`person_id`,`fname`,`lname`,`person_job`) VALUES (65,"Vivian","Shelton","reviewer");

-- person_to_RICodes (sorted by RICode)
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (60,1);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (61,1);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (62,1);

INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (63,2);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (64,2);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (65,2);

INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (60,3);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (61,3);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (65,3);

INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (62,4);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (63,4);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (64,4);
INSERT INTO `person_to_RICode` (`person_id`,`RICode`) VALUES (65,4);

-- manuscripts under review
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (1,"Kemeny","2016-07-15 00:51:38","under review",1,102);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (2,"Sudikoff","2016-08-15 00:51:38","under review",2,102);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (3,"Carson","2016-09-15 00:51:38","under review",3,102);
INSERT INTO `manuscript` (`manuscript_id`,`title`,`date_submitted`,`man_status`,`RICode`,`person_id`) VALUES (4,"Fairchild","2016-10-15 00:51:38","under review",4,102);

-- feedback 
-- manu 1 has RICode 1
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (1,60,"2017-04-14 16:27:39",8,7,1,1,2,"2016-08-20 07:11:19");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (1,61,"2016-10-30 00:21:31",9,10,6,6,6,"2018-03-02 17:42:02");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (1,62,"2016-11-21 08:31:29",2,3,10,9,2,"2016-05-11 06:15:16");

-- manuscript 2 has RICode 2
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (2,63,"2017-02-09 06:00:53",7,1,2,8,9,"2016-06-10 17:07:47");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (2,64,"2017-04-23 17:40:25",2,8,1,9,5,"2017-04-21 00:45:16");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (2,65,"2016-08-18 10:27:55",7,5,4,5,5,"2017-04-08 00:39:44");

-- manuscript 3 has RICode 3
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (3,60,"2016-11-26 18:53:47",8,1,7,10,8,"2017-08-24 21:51:58");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (3,61,"2017-02-14 11:37:09",8,8,6,5,7,"2017-05-02 00:41:36");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (3,65,"2017-03-07 15:10:55",2,1,6,8,10,"2017-02-13 00:56:38");

-- manuscript 4 has RICode 4
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (4,62,"2016-10-09 10:57:07",6,4,5,1,4,"2017-04-01 02:39:19");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (4,63,"2017-04-12 20:42:33",2,1,3,10,2,"2017-01-07 22:20:11");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (4,64,"2017-03-20 23:02:15",6,10,5,10,7,"2018-01-29 19:37:17");
INSERT INTO `feedback` (`manuscript_id`,`person_id`,`date_assigned`,`appropriateness`,`clarity`,`methodology`,`contribution_to_field`,`recommendation`,`date_completed`) VALUES (4,65,"2017-03-20 23:02:15",6,10,5,10,7,"2018-01-29 19:37:17");

-- note that manuscripts 1, 2, 3, 4 are all "under review"
SELECT * FROM manuscript; 

-- reviewer 65 is a reviewer for manuscripts 2, 3, and 4
SELECT * FROM reviewer_info ORDER BY reviewer_person_id ASC;

-- delete reviewer 65 
DELETE FROM person WHERE `person_id`=65;

-- note that manuscripts 2 and 3 have changed to a "submitted" man_status
SELECT * FROM manuscript; 

-- manuscript 4 is still "under review" because it still has 3 reviewers
SELECT * FROM reviewer_info ORDER BY manuscript_id ASC;

-- CHECK LOG FOR TRIGGER MESSAGES
-- outputs errors from trigger1 tests and trigger2 tests.  There should be four errors in this table.
SELECT * FROM error_logs;
