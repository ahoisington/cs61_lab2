#!/bin/bash


# export CLASSPATH=/Users/acaciah/Documents/acacia/dart_classes/17S/cosc61/lab2/mysql-connector-java-5.1.17-bin.jar:$CLASSPATH



java: frontend.java
	javac frontend.java
	java frontend




clean: 
	rm -rf frontend *.class