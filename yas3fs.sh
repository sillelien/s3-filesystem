#!/bin/bash -eux
export S3_URL=$(echo "s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}")
(echo "*/1 * * * * /root/update.sh ${AWS_S3_LOCAL_MOUNT_POINT} ${SHARE_VOLUME} ${SIMPLE_QUOTA_LOWER_MB} ${SIMPLE_QUOTA_UPPER_MB} ${SIMPLE_QUOTA_MAX_FILES} 2>&1 | logger" ) | crontab -
exec yas3fs -f --mkdir  $S3_URL $AWS_S3_LOCAL_MOUNT_POINT

