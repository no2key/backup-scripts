#!/bin/bash

MYSQL_PASSWORD="root"
BUCKET="mybucketname"
PREFIX="server-01"

DBS=`mysql -u root -p${MYSQL_PASSWORD} -Bse 'show databases;'`

# Cleaning old backups
rm -Rfv /backup/mysql/*

for DB in $DBS
do
        if [ "$DB" = "information_schema" ] || [ "$DB" = "performance_schema" ] || [ "$DB" = "mysql" ] || [ "$DB" = "test" ]
        then
                continue
        fi

        FILE="${DB}_`date +'%Y-%m-%d_%H-%M-%S'`.sql"
        echo $FILE
        mysqldump -u root -p${MYSQL_PASSWORD} ${DB} | gzip > /backup/mysql/${FILE}
        s3cmd -c /backup/s3cfg put /backup/mysql/${FILE} s3://${BUCKET}/${PREFIX}/mysql/${FILE}
done