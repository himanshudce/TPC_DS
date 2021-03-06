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
$MYSQL -e "create database tpcds"
MYSQL="$MYSQL tpcds"
echo "# database created \n"


$MYSQL < ./tpcds_kit/tools/tpcds.sql
echo "# table schema defiened \n"



echo "# Loading data into the table"
TOTAL_MSECS=$SECONDS
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
	printf "loaded the table '$f' \n" 
done
ELAPSED_TIME=$(($SECONDS - $TOTAL_MSECS))
echo "LOAD TIME FOR SCALE FACTOR $(($SF)) IS $(($ELAPSED_TIME)) SEC"   


echo "# runnning the python file to run all the queries"
TOTAL_MSECS=$SECONDS
python3 run_all_queries.py
ELAPSED_TIME=$(($SECONDS - $TOTAL_MSECS))
echo "TOTAL RUN TIME TO EXECUTE ALL QUEREIES FOR $(($SF)) IS $(($ELAPSED_TIME)) SEC" 
