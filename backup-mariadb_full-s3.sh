#!/bin/bash
# Usage: Put this script on crontab
# Aborts on unset variable
set -u

TELEGRAM_CHAT="<CHAT_ID>"
HOSTNAME=`hostname`
FILE=full-${HOSTNAME}
DATE=`date +%d%m%y-%H`
FILENAME=${FILE}_${DATE}
BUCKET="S3_BUCKET"

# Tests variables
: $FILENAME

# Delete old backups
/usr/bin/find /mnt/backup/${FILE}* -mtime +2 -delete

#Backup and send to S3
/usr/bin/mariabackup --slave-info --backup --compress --compress-threads=4 --stream=xbstream | s3cmd put - s3://${BUCKET}/${FILENAME}.mbstream
RC_Maria=$?

if [ $RC_Maria -ne 0 ]; then /opt/telegram_text.sh ${TELEGRAM_CHAT} "Last mariabackup failed with status ${RC_Maria} on ${HOSTNAME}"; fi

exit 0
