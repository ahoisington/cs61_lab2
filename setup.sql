
USE acaciah_db;
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

DROP VIEW IF EXISTS reviewer_info;


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

-- --
-- -- Table structure for table `RICodes`
-- --
CREATE TABLE    RICodes
  ( RICode      MEDIUMINT NOT NULL AUTO_INCREMENT,
    interest    varchar(64) NOT NULL,
    PRIMARY KEY (RICode)
  );

INSERT INTO RICodes (interest) VALUES
('Agricultural engineering'),
('Biochemical engineering'),
('Biomechanical engineering'),
('Ergonomics'),
('Food engineering'),
('Bioprocess engineering'),
('Genetic engineering'),
('Human genetic engineering'),
('Metabolic engineering'),
('Molecular engineering'),
('Neural engineering'),
('Protein engineering'),
('Rehabilitation engineering'),
('Tissue engineering'),
('Aquatic and environmental engineering'),
('Architectural engineering'),
('Civionic engineering'),
('Construction engineering'),
('Earthquake engineering'),
('Earth systems engineering and management'),
('Ecological engineering'),
('Environmental engineering'),
('Geomatics engineering'),
('Geotechnical engineering'),
('Highway engineering'),
('Hydraulic engineering'),
('Landscape engineering'),
('Land development engineering'),
('Pavement engineering'),
('Railway systems engineering'),
('River engineering'),
('Sanitary engineering'),
('Sewage engineering'),
('Structural engineering'),
('Surveying'),
('Traffic engineering'),
('Transportation engineering'),
('Urban engineering'),
('Irrigation and agriculture engineering'),
('Explosives engineering'),
('Biomolecular engineering'),
('Ceramics engineering'),
('Broadcast engineering'),
('Building engineering'),
('Signal Processing'),
('Computer engineering'),
('Power systems engineering'),
('Control engineering'),
('Telecommunications engineering'),
('Electronic engineering'),
('Instrumentation engineering'),
('Network engineering'),
('Neuromorphic engineering'),
('Engineering Technology'),
('Integrated engineering'),
('Value engineering'),
('Cost engineering'),
('Fire protection engineering'),
('Domain engineering'),
('Engineering economics'),
('Engineering management'),
('Engineering psychology'),
('Ergonomics'),
('Facilities Engineering'),
('Logistic engineering'),
('Model-driven engineering'),
('Performance engineering'),
('Process engineering'),
('Product Family Engineering'),
('Quality engineering'),
('Reliability engineering'),
('Safety engineering'),
('Security engineering'),
('Support engineering'),
('Systems engineering'),
('Metallurgical Engineering'),
('Surface Engineering'),
('Biomaterials Engineering'),
('Crystal Engineering'),
('Amorphous Metals'),
('Metal Forming'),
('Ceramic Engineering'),
('Plastics Engineering'),
('Forensic Materials Engineering'),
('Composite Materials'),
('Casting'),
('Electronic Materials'),
('Nano materials'),
('Corrosion Engineering'),
('Vitreous Materials'),
('Welding'),
('Acoustical engineering'),
('Aerospace engineering'),
('Audio engineering'),
('Automotive engineering'),
('Building services engineering'),
('Earthquake engineering'),
('Forensic engineering'),
('Marine engineering'),
('Mechatronics'),
('Nanoengineering'),
('Naval architecture'),
('Sports engineering'),
('Structural engineering'),
('Vacuum engineering'),
('Military engineering'),
('Combat engineering'),
('Offshore engineering'),
('Optical engineering'),
('Geophysical engineering'),
('Mineral engineering'),
('Mining engineering'),
('Reservoir engineering'),
('Climate engineering'),
('Computer-aided engineering'),
('Cryptographic engineering'),
('Information engineering'),
('Knowledge engineering'),
('Language engineering'),
('Release engineering'),
('Teletraffic engineering'),
('Usability engineering'),
('Web engineering'),
('Systems engineering');



--
-- Table structure for table `manuscript`
--
CREATE TABLE manuscript
(
	manuscript_id INT NOT NULL,
	title VARCHAR(100) NOT NULL,
	date_submitted DATETIME NOT NULL,
	man_status VARCHAR(45) NOT NULL,
	RICode MEDIUMINT,
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
	RICode MEDIUMINT NOT NULL,
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


--
-- reviewer_info: outputs info on reviewer and all manuscripts he/she is writing feedback for.
-- 
CREATE VIEW reviewer_info
AS
SELECT manuscript.manuscript_id AS manuscript_id, feedback.person_id AS reviewer_person_id, fname AS reviewer_fname, lname AS reviewer_lname, date_submitted
FROM feedback
JOIN manuscript ON feedback.manuscript_id = manuscript.manuscript_id AND manuscript.man_status = 'under review'
JOIN person ON feedback.person_id = person.person_id; -- reviewers
    

