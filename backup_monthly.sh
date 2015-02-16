#!/bin/bash
cd /tmp
stamp=$(date +"%Y-%m")
if [[ "$AWS_ACCESS_KEY_ID" != "none" ]]
then
    tar czf monthly-var.tar.gz /usr/local/var
    aws s3 cp monthly-var.tar.gz s3://codeserver-backup/monthly/svc/${SERVICE_ID}/var-backup-${stamp}.tar.gz
    rm monthly-var.tar.gz
fi
