#!/bin/bash -eux
export S3_URL=$(echo "s3://${AWS_S3_BUCKET}/${AWS_S3_PATH}")
exec yas3fs -f --mkdir  $S3_URL $AWS_S3_LOCAL_MOUNT_POINT

