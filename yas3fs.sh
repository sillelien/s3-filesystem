#!/bin/bash -eux
export S3_URL=$(echo "s3://codeserverlocalvars/${GITHUB_USER}/${GITHUB_PROJECT}/${GITHUB_BRANCH}" | tr '-' '.')
exec yas3fs -df --mkdir  $S3_URL /usr/local/var

