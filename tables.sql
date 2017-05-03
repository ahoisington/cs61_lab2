-- Elisabeth & Acacia
-- create tables for lab 2c
-- April 22, 2017

USE epills_db;
SHOW TABLES;

DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS reviewer;
DROP TABLE IF EXISTS editor;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS accepted_man;
DROP TABLE IF EXISTS issue_to_man;
DROP TABLE IF EXISTS person_to_RICode;
DROP TABLE IF EXISTS man_to_author;
DROP TABLE IF EXISTS person_to_affiliation;
DROP TABLE IF EXISTS affiliation;
DROP TABLE IF EXISTS issue;
DROP TABLE IF EXISTS manuscript;
DROP TABLE IF EXISTS RICodes;
DROP TABLE IF EXISTS person;

--
-- Table structure for table `person`
--
CREATE TABLE person
(
	person_id INT NOT NULL,
	fname VARCHAR(45) NOT NULL,
	lname VARCHAR(45) NOT NULL,
	person_job VARCHAR(45) NOT NULL,
	PRIMARY KEY (person_id)
);

--
-- Table structure for table `RICodes`
--
-- CREATE TABLE RICodes
-- (
-- 	RICode INT NOT NULL,
-- 	RIString VARCHAR(45) NOT NULL,
-- 	PRIMARY KEY (RICode)
-- );
-- 

-- FROM PALMER'S RIcodes.sql
CREATE TABLE RICodes
( 
	RICode      INT NOT NULL AUTO_INCREMENT,
    interest	varchar(64) NOT NULL,
    PRIMARY KEY (RICode)
);

--
-- Table structure for table `manuscript`
--
CREATE TABLE manuscript
(
	manuscript_id INT NOT NULL,
	title VARCHAR(100) NOT NULL,
	date_submitted DATETIME NOT NULL,
	man_status VARCHAR(45) NOT NULL,
	RICode INT,
	person_id INT NOT NULL,
	PRIMARY KEY (manuscript_id),
    FOREIGN KEY (RICode) REFERENCES RICodes(RICode),
    FOREIGN KEY (person_id) REFERENCES person(person_id)
);



--
-- Table structure for table `author`
--
CREATE TABLE author
(
	person_id INT NOT NULL,
	email VARCHAR(45) NOT NULL ,
	mailing_address VARCHAR(45) NOT NULL,
    PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);

--
-- Table structure for table `reviewer`
--
CREATE TABLE reviewer
(
	person_id INT NOT NULL,
	email VARCHAR(45) NOT NULL,
    PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);

--
-- Table structure for table `editor`
--
CREATE TABLE editor
(
	person_id INT NOT NULL,
    PRIMARY KEY (person_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);

--
-- Table structure for table `person_to_RICode`
--
CREATE TABLE person_to_RICode
(
	person_id INT NOT NULL,
	RICode INT NOT NULL,
    PRIMARY KEY (person_id, RICode),
	FOREIGN KEY (person_id) REFERENCES person(person_id),
	FOREIGN KEY (RICode) REFERENCES RICodes(RICode)
);



--
-- Table structure for table `feedback`
--
CREATE TABLE feedback
(
	manuscript_id INT NOT NULL,
	person_id INT NOT NULL,
	date_assigned DATETIME NOT NULL,
	appropriateness INT,
	clarity INT,
	methodology INT,
	contribution_to_field INT,
	recommendation VARCHAR(45),
	date_completed DATETIME,
	PRIMARY KEY (manuscript_id, person_id),
	FOREIGN KEY (manuscript_id) REFERENCES manuscript(manuscript_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);

--
-- Table structure for table `accepted_man`
--
CREATE TABLE accepted_man
(
	manuscript_id INT NOT NULL,
	date_of_acceptance DATETIME NOT NULL,
	num_pages INT,
	PRIMARY KEY (manuscript_id),
	FOREIGN KEY (manuscript_id) REFERENCES manuscript(manuscript_id)
);


--
-- Table structure for table `man_to_author`
--
CREATE TABLE man_to_author
(
	manuscript_id INT NOT NULL,
	person_id INT NOT NULL,
	author_order_num INT NOT NULL,
	PRIMARY KEY (manuscript_id, person_id),
	FOREIGN KEY (manuscript_id) REFERENCES manuscript(manuscript_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);

--
-- Table structure for table `issue`
--
CREATE TABLE issue
(
	issue_id INT NOT NULL,
	print_date DATETIME,
	pub_period_num INT,
	pub_year DATETIME,
	person_id INT NOT NULL,   
	PRIMARY KEY (issue_id),
	FOREIGN KEY (person_id) REFERENCES person(person_id)
);


--
-- Table structure for table `issue_to_man`
--
CREATE TABLE issue_to_man
(
	manuscript_id INT NOT NULL,
	issue_id INT NOT NULL,
	page_num INT,
	position_in_issue INT,
	PRIMARY KEY (manuscript_id),
	FOREIGN KEY (manuscript_id) REFERENCES manuscript(manuscript_id),
	FOREIGN KEY (issue_id) REFERENCES issue(issue_id)
);

--
-- Table structure for table `affiliation`
--
CREATE TABLE affiliation
(
	affiliation_code INT NOT NULL, 
    affiliation VARCHAR(45),
	PRIMARY KEY (affiliation_code)
);

--
-- Table structure for table `person_to_affiliation`
--
CREATE TABLE person_to_affiliation
(
	person_id INT NOT NULL,  
	affiliation_code INT NOT NULL,  
	PRIMARY KEY (person_id, affiliation_code),
	FOREIGN KEY (person_id) REFERENCES person(person_id),
    FOREIGN KEY (affiliation_code) REFERENCES affiliation(affiliation_code)
);



