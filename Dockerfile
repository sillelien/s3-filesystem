FROM phusion/baseimage:0.9.16

ENV AWS_ACCESS_KEY_ID CHANGE_ME
ENV AWS_SECRET_ACCESS_KEY CHANGE_ME
ENV AWS_DEFAULT_REGION eu-west-1
ENV AWS_S3_LOCAL_MOUNT_POINT /var/s3
ENV AWS_S3_PATH /test

ENV SHARE_VOLUME /usr/local/var

ENV SIMPLE_QUOTA_MAX_FILES 100
ENV SIMPLE_QUOTA_LOWER_MB 100
ENV SIMPLE_QUOTA_UPPER_MB 1024

VOLUME ${SHARE_VOLUME}

RUN apt-get update && apt-get -y install inotify-tools rsync fuse python-pip && pip install yas3fs awscli && \
    sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf && \
    chmod a+r /etc/fuse.conf && yas3fs -h

ADD yas3fs.sh /etc/service/yas3fs/run
ADD backup_daily.sh /etc/cron.daily/backup
ADD backup_monthly.sh /etc/cron.monthly/backup
ADD update.sh /etc/service/update/run
RUN chmod 755 /etc/service/yas3fs/run /etc/cron.daily/backup /etc/cron.monthly/backup /etc/service/update/run

CMD ["/sbin/my_init"]
