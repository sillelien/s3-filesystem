#!/bin/bash
cd /tmp
stamp=$(date +"%m-%d")
tar czf daily.tar.gz $SHARE_VOLUME
aws s3 cp daily.tar.gz s3://${AWS_S3_BUCKET}/daily_backups/${AWS_S3_PATH}/daily-${stamp}.tar.gz
rm daily.tar.gz
