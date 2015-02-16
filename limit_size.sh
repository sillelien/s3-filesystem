#!/bin/bash -eux
dir=${1}
dir_size=$( du -sm "$dir" | cut -f1 )
echo "$dir usage is currently $dir_size limit is ${2}/${3} Mb"


if [ $dir_size -gt $2 ]
then
    if [ ! -f ${1}/.quota-exceeded ]
    then
        touch ${1}/.quota-exceeded
    fi
else
    if [ -f ${1}/.quota-exceeded ]
    then
        rm ${1}/.quota-exceeded
    fi
fi

#When over upper quota, we delete the files created since we hit the lower quota
while [ $dir_size -gt ${3} ] ; do
    find $dir -type f -newer ${1}/.quota-exceeded -exec rm -f {} \;
    find $dir -type d -empty -delete
done