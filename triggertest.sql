-- Elisabeth & Acacia
-- test triggers for lab 2d
-- May 2, 2017

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











