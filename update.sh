#!/bin/bash -eux
local_dir=${2}
s3_dir=${1}
dir_size=$( du -sm "$local_dir" | cut -f1 )
echo "$local_dir usage is currently $dir_size limit is ${3}/${4} Mb"

if [ ! -f $2/.syncinit ]
then
    echo "Copying from S3"
    rsync -arv --delete-after --backup --backup-dir=${local_dir}/.syncbackrev  --exclude ".syncbackrev" --exclude ".syncbackup" --exclude ".syncinit"  ${s3_dir}/ ${local_dir}/
    touch $2/.syncinit
fi

if [ ${dir_size} -gt ${3} ]
then
    if [ ! -f ${local_dir}/.quota-exceeded ]
    then
        touch ${local_dir}/.quota-exceeded
    fi
    rm -rf ${local_dir}/.syncbackup || true
else
    rsync -arv --delete-after --backup --backup-dir=${local_dir}/.syncbackup  --exclude ".syncbackup" --exclude ".syncbackrev" --exclude ".syncinit"  ${local_dir}/ ${s3_dir}/
    if [ -f ${local_dir}/.quota-exceeded ]
    then
        rm ${local_dir}/.quota-exceeded
    fi
fi

#When over upper quota, we delete the files created since we hit the lower quota
while [ $dir_size -gt ${4} ] ; do
    find $local_dir -type f -newer ${local_dir}/.quota-exceeded -exec rm -f {} \;
    find $local_dir -type d -empty -delete
done