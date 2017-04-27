-- Elisabeth & Acacia
-- create view for lab 2c
-- April 24, 2017

CREATE VIEW LeadAuthorManuscripts
AS
SELECT person_id, fname, lname, email, mailing_address, manuscript_id, title, man_status, date_submitted
FROM person 
JOIN manuscript ON person.person_id = manuscript.person_id
JOIN author ON person.person_id = author.person_id
JOIN man_to_author ON person.person_id = manu_to_author.person_id
WHERE author_order_num = 1
ORDER BY lname ASC, date_submitted ASC;
/*give permission to editors
GRANT SELECT ON epills_db.LeadAuthorManuscripts TO ;
*/



CREATE VIEW AnyAuthorManuscripts
AS
SELECT person_id, fname, lname, manuscript_id, title, man_status, date_submitted
FROM person 
JOIN manuscript ON person.person_id = manuscript.person_id
JOIN man_to_author ON person.person_id = manu_to_author.person_id
ORDER BY lname ASC, date_submitted ASC;


CREATE VIEW PublishedIssues
AS
SELECT issue_id, pub_year, pub_period_num, manuscript_id, title, page_num
FROM issue
JOIN issue_to_man ON issue.issue_id = issue_to_man.issue_id
JOIN manuscript ON manuscript.manuscript_id = issue_to_man.manuscript_id
WHERE man_status = 'published'
ORDER BY issue_id ASC, date_submitted ASC;

/*MESSY CLEAN IT UP AND MAKE IT HAPPEN*/


-- CREATE VIEW ReviewQueue
-- AS
-- SELECT man_to_author.person_id AS primary_author_person_id, fname AS author_fname, lname AS author_lname, manuscript_id, 
-- 	feedback.person_id AS reviewer_person_id, fname AS reviewer_fname, lname AS author_lname
-- FROM feedback
-- JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review'
-- JOIN man_to_author ON manuscript.manuscript_id = author.manuscript_id AND author_order_num = 1
-- JOIN person ON man_to_author.person_id = person.person_id
-- ;

CREATE VIEW ReviewQueue
AS
(SELECT manuscript_id, feedback.person_id AS reviewer_person_id, fname AS reviewer_fname, lname AS reviewer_lname, date_submitted
	FROM feedback
    JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review') 
UNION 
(SELECT man_to_author.person_id AS primary_author_person_id, fname AS author_fname, lname AS author_lname 
	FROM feedback 
	JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review'
	JOIN man_to_author ON manuscript.manuscript_id = man_to_author.manuscript_id AND author_order_num = 1
	JOIN person ON man_to_author.person_id = person.person_id)
ORDER BY date_submitted ASC;


-- use function or case statements
-- CREATE VIEW WhatsLeft
-- AS
-- SELECT  
-- FROM w
-- JOIN  ON issue.issue_id = issue_to_man.issue_id
-- JOIN  ON manuscript.manuscript_id = issue_to_man.manuscript_id
-- WHERE 
-- ORDER BY issue_id ASC, date_submitted ASC;


-------------- --
CREATE VIEW ReviewStatus
AS
SELECT manuscript_id, title
FROM feedback
JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id

ORDER BY issue_id ASC, date_submitted ASC;




















