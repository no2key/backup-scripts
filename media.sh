#!/bin/bash

BUCKET="mybucketname"
PREFIX="server-01"

PROJECTS=`ls -1 /www`

# Cleaning old backups
rm -Rfv /backup/media/*

for PROJECT in $PROJECTS
do
        if [ "$PROJECT" = "lost+found" ]
        then
                continue
        fi

        FILE="${PROJECT}_`date +'%Y-%m-%d_%H-%M-%S'`.tar"
        echo $FILE
        tar cf /backup/media/${FILE} -C /www/${PROJECT} media
        s3cmd -c /backup/s3cfg put /backup/media/${FILE} s3://${BUCKET}/${PREFIX}/media/${FILE}
done