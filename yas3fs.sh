#!/bin/bash -eux
export S3_URL=$(echo "s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}")
(echo "*/1 * * * * /root/limit_size.sh ${AWS_S3_LOCAL_MOUNT_POINT} ${SIMPLE_QUOTA_LOWER_MB} ${SIMPLE_QUOTA_UPPER_MB} 2>&1 | logger" ) | crontab -
exec yas3fs -f --mkdir  $S3_URL $AWS_S3_LOCAL_MOUNT_POINT

