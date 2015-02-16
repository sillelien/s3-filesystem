#!/bin/bash
cd /tmp
stamp=$(date +"%m-%d")
if [[ "$AWS_ACCESS_KEY_ID" != "none" ]]
then
    tar czf daily-var.tar.gz /usr/local/var
    aws s3 cp daily-var.tar.gz s3://codeserver-backup/daily/svc/${SERVICE_ID}/var-backup-${stamp}.tar.gz
    rm daily-var.tar.gz
fi
