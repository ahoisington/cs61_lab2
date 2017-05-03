-- Elisabeth & Acacia
-- create views for lab 2c
-- April 24, 2017

DROP VIEW IF EXISTS LeadAuthorManuscripts;
DROP VIEW IF EXISTS AnyAuthorManuscripts;
DROP VIEW IF EXISTS PublishedIssues;
DROP VIEW IF EXISTS author_info;
DROP VIEW IF EXISTS reviewer_info;
DROP VIEW IF EXISTS ReviewQueue;
DROP VIEW IF EXISTS WhatsLeft;
DROP VIEW IF EXISTS ReviewStatus;

--
-- LeadAuthorManuscripts: information about primary author for manuscripts 
-- 
CREATE VIEW LeadAuthorManuscripts
AS
SELECT man_to_author.person_id AS person_id, fname, lname, email, mailing_address, manuscript.manuscript_id AS manuscript_id, title, man_status, date_submitted
FROM person 
JOIN manuscript ON person.person_id = manuscript.person_id
JOIN author ON person.person_id = author.person_id
JOIN man_to_author ON man_to_author.person_id = author.person_id AND author_order_num = 1
ORDER BY lname ASC, date_submitted ASC;

--
-- AnyAuthorManuscripts: information about all authors for manuscripts 
-- 
CREATE VIEW AnyAuthorManuscripts
AS
SELECT man_to_author.person_id AS person_id, fname, lname, manuscript.manuscript_id AS manuscript, title, man_status, date_submitted
FROM person 
JOIN manuscript ON person.person_id = manuscript.person_id 
JOIN man_to_author ON person.person_id = man_to_author.person_id
ORDER BY lname ASC, date_submitted ASC;

--
-- PublishedIssues: issue_id, publication yr, publication period number, manuscript id, title, page number for all published issues
-- 
CREATE VIEW PublishedIssues
AS
SELECT issue.issue_id AS issue_id, pub_year, pub_period_num, manuscript.manuscript_id AS manuscript_id, title, page_num
FROM issue
JOIN issue_to_man ON issue.issue_id = issue_to_man.issue_id
JOIN manuscript ON manuscript.manuscript_id = issue_to_man.manuscript_id
WHERE man_status = 'published'
ORDER BY issue_id ASC, date_submitted ASC;

--
-- reviewer_info: helper for ReviewQueue. needed because no other way to differentiate author fname and reviewer fname
-- 
CREATE VIEW reviewer_info
AS
SELECT manuscript.manuscript_id AS manuscript_id, feedback.person_id AS reviewer_person_id, fname AS reviewer_fname, lname AS reviewer_lname, date_submitted
FROM feedback
JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review'
JOIN person ON feedback.person_id = person.person_id; -- reviewers
    
--
-- author_info: helper for ReviewQueue. needed because no other way to differentiate author fname and reviewer fname
-- 
CREATE VIEW author_info
AS
SELECT man_to_author.person_id AS primary_author_person_id, fname AS author_fname, lname AS author_lname, manuscript.manuscript_id AS manuscript_id
FROM feedback 
JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review'
JOIN man_to_author ON manuscript.manuscript_id = man_to_author.manuscript_id AND author_order_num = 1
JOIN person ON man_to_author.person_id = person.person_id;

--
-- ReviewQueue: shows primary author, reviewers, and date submitted for all manuscripts "under review"
-- 
CREATE VIEW ReviewQueue 
AS
SELECT reviewer_info.manuscript_id AS manuscript_id, primary_author_person_id,author_fname, author_lname, reviewer_person_id, reviewer_fname, reviewer_lname, date_submitted
FROM author_info
JOIN reviewer_info ON reviewer_info.manuscript_id = author_info.manuscript_id
ORDER BY date_submitted ASC;


--
-- WhatsLeft: manuscripts and their remaining steps
-- 
CREATE VIEW WhatsLeft
AS
SELECT date_submitted, manuscript_id, title, 
CASE 
	WHEN man_status = 'submitted' THEN 'under review' 
	WHEN man_status = 'under review' THEN 'rejected' 
    WHEN man_status = 'rejected' THEN 'accepted' 
    WHEN man_status = 'accepted' THEN 'in typesetting' 
    WHEN man_status = 'in typesetting' THEN 'scheduled for publication' 
    WHEN man_status = 'scheduled for publication' Then 'published' 
    WHEN man_status = 'published' THEN NULL
    END AS next_step
FROM manuscript
ORDER BY date_submitted ASC;

--
-- ReviewStatus: manuscript id and title and all feedback on those manuscripts as well as ReviewQueue
-- 
CREATE VIEW ReviewStatus
AS
SELECT date_assigned, manuscript.manuscript_id, title, appropriateness, clarity, methodology, contribution_to_field, recommendation
FROM feedback 
JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id
ORDER BY  date_submitted ASC;










