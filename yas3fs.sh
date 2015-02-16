#!/bin/bash
export S3_URL=$(echo "s3://codeserverlocalvars/${GITHUB_USER}.${GITHUB_PROJECT}.${GITHUB_BRANCH}" | tr  -d '-')


exec yas3fs -df --region eu-west-1 $S3_URL /usr/local/var
