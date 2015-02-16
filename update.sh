#!/bin/bash -eu
if [ -f /tmp/.running ]
then
    echo "Already running"
    exit 0
fi

touch /tmp/.running
trap "rm /tmp/.running || : " EXIT

local_dir=${2}
s3_dir=${1}
lower=${3}
upper=${4}
max_files=${5}

dir_size=$( du -sm "$local_dir" | cut -f1 )
echo "$local_dir usage is currently $dir_size limit is ${3}/${4} Mb"

if [ ! -f $2/.syncinit ]
then
    echo "Copying from S3"
    rsync -arv --delete-after --backup --backup-dir=${local_dir}/.syncbackrev  --exclude ".sync*"  ${s3_dir}/ ${local_dir}/
    touch $2/.syncinit
fi

changed=$(find $local_dir -newer ${local_dir}/.synclast -type f -not -path "${local_dir}/.sync*/*" | wc -l)


if (( $changed == 0 )) && [[ -f ${local_dir}/.synclast ]]
then
    echo "No changes"
    exit 0
fi

num_files=$(find $local_dir  -type f -not -path "${local_dir}/.sync*/*" | wc -l)


if (( ${dir_size} > ${lower} ))  ||  (( ${num_files} > ${max_files} ))
then
    if [ ! -f ${local_dir}/.sync-quota-exceeded ]
    then
        touch ${local_dir}/.sync-quota-exceeded
    fi
    rm -rf ${local_dir}/.syncbackup || true
else
    if [ -f ${local_dir}/.sync-quota-exceeded ]
    then
        rm ${local_dir}/.sync-quota-exceeded
    fi
    touch ${local_dir}/.synclast
    rsync -arv --delete-after --backup --backup-dir=${local_dir}/.syncbackup  --exclude ".sync*"   ${local_dir}/ ${s3_dir}/
fi

#When over upper quota, we delete the files created since we hit the lower quota
while [ $dir_size -gt ${upper} ] ; do
    find $local_dir -type f -newer ${local_dir}/.sync-quota-exceeded -exec rm -f {} \;
    find $local_dir -type d -empty -delete
done
