#!/bin/bash
cd /tmp
stamp=$(date +"%m-%d")
tar czf daily.tar.gz $AWS_S3_LOCAL_MOUNT_POINT
aws s3 cp daily.tar.gz s3://${AWS_S3_BUCKET}/backups/${AWS_S3_PATH}/daily-${stamp}.tar.gz
rm daily.tar.gz
