#!/bin/bash -eu
if [ -f /tmp/.running ]
then
    echo "Already running!!!"
    exit 0
fi

touch /tmp/.running
trap "rm /tmp/.running ; sleep 1 " EXIT

s3_dir=${AWS_S3_LOCAL_MOUNT_POINT}
local_dir=/usr/local/var
lower=${SIMPLE_QUOTA_LOWER_MB}
upper=${SIMPLE_QUOTA_UPPER_MB}
max_files=${SIMPLE_QUOTA_MAX_FILES}

dir_size=$( du -sm "$local_dir" | cut -f1 )
echo "$local_dir usage is currently ${dir_size}MB limit is ${lower}MB (hard limit ${upper}MB)"


while [ ! -d $s3_dir ]
do
    echo "Waiting for $s3_dir"
    sleep 1
done


if [ ! -f ${local_dir}/.syncinit ]
then
    echo "Copying from S3"
    rsync -arv --delete-after --temp-dir=/tmp --ignore-times --whole-file --backup --backup-dir=${local_dir}/.syncbackrev  --exclude ".sync*"  ${s3_dir}/ ${local_dir}/
    touch ${local_dir}/.syncinit
fi

#No wait for any files to change
inotifywait -e modify -e create -e move -e delete -e attrib -e close_write -t 3600 -r ${local_dir}


num_files=$(find $local_dir  -type f -not -path "${local_dir}/.sync*/*" | wc -l)


if (( ${num_files} > ${max_files} ))
then
    echo "Too many files: ${num_files} > ${max_files}"
fi

if (( ${dir_size} > ${lower} ))  ||  (( ${num_files} > ${max_files} ))
then
    echo "Quota exceeded"
    if [ ! -f ${local_dir}/.sync-quota-exceeded ]
    then
        touch ${local_dir}/.sync-quota-exceeded
    fi
    rm -rf ${local_dir}/.syncbackup || true
else
    echo "Within quota"
    if [ -f ${local_dir}/.sync-quota-exceeded ]
    then
        rm ${local_dir}/.sync-quota-exceeded
    fi
    touch ${local_dir}/.synclast
    rsync -arv  --delete --temp-dir=/tmp --checksum --timeout=60 --backup --backup-dir=${local_dir}/.syncbackup  --exclude ".sync*"   ${local_dir}/ ${s3_dir}/
fi

#When over upper quota, we delete the files created since we hit the lower quota
while [ $dir_size -gt ${upper} ] ; do
    echo "Purge files as upper limt exceeded"
    find $local_dir -type f -newer ${local_dir}/.sync-quota-exceeded -exec rm -f {} \;
    find $local_dir -type d -empty -delete
done

#We need to limit how often we update to s3
sleep ${S3_MAX_CHECK_FREQUENCY}