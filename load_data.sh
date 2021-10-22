#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Usage: $0 <scale factor>"
	exit 1
fi

SF=$1
DATADIR='tpcdata'

if [ ! -d $DATADIR ]
then
	echo "Data at $DATADIR not found"
	exit 1
fi


USER=root
MYSQL="mysql -u $USER"

echo "# Create database"
$MYSQL -e "create database tpcds"
MYSQL="$MYSQL tpcds"

echo "# Create tables"
$MYSQL < ./tpcds_kit/tools/tpcds.sql

TOTAL_MSECS=0
echo "# Load data into table"
for f in `ls $DATADIR`
do
	t=`echo $f | sed -e "s/_[0-9]_[0-9]//"`
	t=`echo $t | sed -e "s/.dat//"`
	f="./$DATADIR/"$f
	$MYSQL -e "LOAD DATA LOCAL INFILE '$f' INTO TABLE $t FIELDS TERMINATED BY '|';"
	if [ $? -ne 0 ]
	then
		echo "FAIL"
		exit 1
	fi
	printf "loaded the table \n" 
done


ELAPSED_TIME=$(($SECONDS - $START_TIME))
echo "LOAD TIME FOR SCALE FACTOR $(($SF)) IS $(($ELAPSED_TIME)) SEC"   





