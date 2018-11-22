#!/bin/bash

# Title 	: Backup multiple database on multiple hosts
# Database credentials
# for multi database and multihost
# I made this script only for aws rds
# Please make some changes to do with your work
allinone=("All RDS instance name go here" ) # please RDS instances name in array format
password=("All password for RDS go here" ) # passwords in array

# Directory to save sql dump files
# opath=$HOME/paying_dbbackup
# mysql hosts
dns="Your RDS DNS go here" # RDS instance dns name 
mysqlhost=()
for (( j=0; j < ${#allinone[@]}; j++ ))
do
	mysqlhost[j]="${allinone[j]}$dns"
done


# Date in dd-mm-yy formate
# suffix=$(date +%d-%m-%Y)
for (( i=0; i < ${#allinone[@]}; i++))
do
	SQLFILE=${allinone[$i]}.sql.gz

	mysqldump -h ${mysqlhost[$i]} -u ${allinone[$i]} -p${password[$i]} -C ${allinone[$i]} 2>error | gzip > $SQLFILE
	if [ -s error ]
	then
		printf "WARNING: An error occured while attempting to backup %s \n\tError:\n\t" ${allinone[$i]}
	else
		printf "%s was backed up successfully to %s\n\n" ${allinone[$i]} $SQLFILE
	fi
done

# echo ${mysqlhost[@]}

