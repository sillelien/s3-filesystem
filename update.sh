#!/bin/bash -eu
if [ -f /tmp/.running ]
then
    echo "Already running!!!"
    exit 0
fi

touch /tmp/.running
trap "rm /tmp/.running ; sleep 1 " EXIT

s3_dir=${AWS_S3_LOCAL_MOUNT_POINT}
local_dir=${SHARE_VOLUME}
lower=${SIMPLE_QUOTA_LOWER_MB}
upper=${SIMPLE_QUOTA_UPPER_MB}
max_files=${SIMPLE_QUOTA_MAX_FILES}

dir_size=$( du -sm "$local_dir" | cut -f1 )
echo "$local_dir usage is currently ${dir_size}MB limit is ${lower}MB (hard limit ${upper}MB)"

if [ ! -f ${local_dir}/.syncinit ]
then
    echo "Copying from S3"
    rsync -arv --delete-after --backup --backup-dir=${local_dir}/.syncbackrev  --exclude ".sync*"  ${s3_dir}/ ${local_dir}/
    touch ${local_dir}/.syncinit
fi

inotifywait -t 60 -r ${local_dir}

changed=$(find $local_dir -newer ${local_dir}/.synclast -type f -not -path "${local_dir}/.sync*/*" | wc -l)


if (( $changed == 0 )) && [[ -f ${local_dir}/.synclast ]]
then
    echo "No changes"
    exit 0
fi

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
    sleep 1
    rsync -arv --delete-after --temp-dir=/tmp --whole-file --timeout=60 --delay-updates --backup --backup-dir=${local_dir}/.syncbackup  --exclude ".sync*"   ${local_dir}/ ${s3_dir}/
fi

#When over upper quota, we delete the files created since we hit the lower quota
while [ $dir_size -gt ${upper} ] ; do
    echo "Purge files as upper limt exceeded"
    find $local_dir -type f -newer ${local_dir}/.sync-quota-exceeded -exec rm -f {} \;
    find $local_dir -type d -empty -delete
done
