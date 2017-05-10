#!/bin/bash


all: mysql java

mysql: tables.sql
	mysql -u acaciah -p acaciah_db -h sunapee.cs.dartmouth.edu < tables.sql

java: frontend.java
	javac frontend.java
	java frontend

clean: 
	rm -rf frontend *.class