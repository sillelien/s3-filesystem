#!/bin/bash
cd /tmp
stamp=$(date +"%Y-%m")
tar czf monthly.tar.gz $AWS_S3_LOCAL_MOUNT_POINT
aws s3 cp monthly.tar.gz s3://${AWS_S3_BUCKET}/monthly_backups/${AWS_S3_PATH}/monthly-${stamp}.tar.gz
rm monthly.tar.gz

