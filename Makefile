#!/bin/bash


all: mysql java

mysql: tables.sql
	mysql -u acaciah -p acaciah_db -h sunapee.cs.dartmouth.edu < ./setup.sql 
	mysql -u acaciah -p acaciah_db -h sunapee.cs.dartmouth.edu < ./triggers.sql 
	mysql -u acaciah -p acaciah_db -h sunapee.cs.dartmouth.edu < ./insert_test.sql


java: frontend.java
	javac frontend.java
	java frontend

clean: 
	rm -rf frontend *.class