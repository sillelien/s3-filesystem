#!/usr/bin/env sh

apk -Uuv add inotify-tools rsync fuse python py-pip
pip install yas3fs awscli
sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf
chmod a+r /etc/fuse.conf && yas3fs -h
apk del py-pip
