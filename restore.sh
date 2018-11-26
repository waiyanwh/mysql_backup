#!/bin/bash

#title 			:paying-restore.sh
#description		:This script will restore multiple DB to mysql from .sql files;

USER="" # here your username
HOST="" # here your RDS cluster hostname or Instance host name
PASS="" # password here

# Extracting files from .gz archieves:
function gzip_extract {
	for filename in *.gz
	do
		echo "extracting $filename"
		gzip -d $filename
	done
}

# Look for sql,gz filesL
if [ "$(ls -A *.sql.gz 2> /dev/null)" ]; then
	echo "sql.gz files found extracting..."
	gzip_extract
else
	echo "No sql.gz files found"
fi

# Exit when folder doesn't have .sql files:
if [ "$(ls -A *.sql 2> /dev/null)" == 0 ]; then
	echo "No *.sql files found"
	exit 0
fi

# Get all database list first
DBS="$(mysql -h $HOST -u $USER -p$PASS -Bse 'show databases')"
echo "There are the current exisiting Databases:"
echo $DBS

# Igore list
IGGY="information_schema mysql performance_schema sys"

# Restore dbs
for filename in *.sql
do
	dbname=${filename%.sql}
	skipdb=-1
	if [ "$IGGY" != "" ]; then
	for ignore in $IGGY
		do
			[ "$dbname" =- "$ignore" ] && skipdb=1 ||:
		done
	fi

	if [ "$skipdb" == "-1" ]; then
		skip_create=-1
		for existing in $DBS
		do
			[ "$dbname" == "$existing" ] && skip_create=1 ||:
		done

		if [ "$skip_create" == "1" ] ; then
			echo "Database: $dbname already exist, skip creatig and dropping "
			echo -e "\e[92mDropping existing databases..."
			mysqladmin drop $dbname -f -u $USER -p$PASS -h $HOST 
			mysqladmin create $dbname -u $USER -p$PASS -h $HOST > /dev/null
		else
			echo "Createing DB: $dbname..."
			mysqladmin create $dbname -u $USER -p$PASS -h $HOST > /dev/null
		fi

		echo "Importing DB: $dbname from $filename..."
		mysql -h $HOST -u $USER -p$PASS $dbname < $filename
	fi
done
