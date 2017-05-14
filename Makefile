#!/bin/bash


all: mysql java

mysql: setup.sql views.sql triggers.sql  insert_test.sql
	mysql -u acaciah --password='Password1' acaciah_db -h sunapee.cs.dartmouth.edu < ./setup.sql 
	mysql -u acaciah --password='Password1' acaciah_db -h sunapee.cs.dartmouth.edu < ./views.sql
	mysql -u acaciah --password='Password1' acaciah_db -h sunapee.cs.dartmouth.edu < ./triggers.sql 
	mysql -u acaciah --password='Password1' acaciah_db -h sunapee.cs.dartmouth.edu < ./insert_test.sql


java: frontend.java
	javac frontend.java
	java frontend

clean: 
	rm -rf frontend *.class
