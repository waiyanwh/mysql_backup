#!/bin/bash

# Database credentials
allinone=( ericsson fairyland idcreative mbuyy mcg naingtechlabs newstarlight nicestyletravel winmobileworld )
password=( bbj7mmv78zgcjdu1jp ykec37c3zkzwiyyqze 4gaxwdig61h0esmeur s88ipezryu3sn0d6ab qvnc5qjcegz0baighm sx5x4uvviwx6r4txd0 k5hc0pfbkvnk7sd8fe mb37iboogwjkfygu2j h4kzcxuvwhd85eav8h )

# Directory to save sql dump files
# opath=$HOME/paying_dbbackup
# mysql hosts
dns=".c4yqwynpry4t.ap-southeast-2.rds.amazonaws.com"
mysqlhost=()
for (( j=0; j < ${#allinone[@]}; j++ ))
do
	# echo "$i.c4yqwynpry4t.ap-southeast-2.rds.amazonaws.com"
	mysqlhost[j]="${allinone[j]}$dns"
done


# Date in dd-mm-yy formate
suffix=$(date +%d-%m-%Y)
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

