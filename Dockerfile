FROM codeserver/base

ENV AWS_ACCESS_KEY_ID CHANGE_ME
ENV AWS_SECRET_ACCESS_KEY CHANGE_ME
ENV AWS_DEFAULT_REGION eu-west-1
ENV AWS_S3_LOCAL_MOUNT_POINT /var/s3
ENV AWS_S3_PATH /test
ENV S3_MAX_CHECK_FREQUENCY 300

ENV SIMPLE_QUOTA_MAX_FILES 100
ENV SIMPLE_QUOTA_LOWER_MB 100
ENV SIMPLE_QUOTA_UPPER_MB 1024

#This goes to S3
VOLUME /usr/local/var
#This doesn't
VOLUME /usr/local/app
#This doesn't and can be emptied at any time
VOLUME /usr/local/tmp
#This doesn't either
VOLUME /usr/local/cache

RUN apt-get update && apt-get -y install inotify-tools rsync fuse python-pip && pip install yas3fs awscli && \
    sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf && \
    chmod a+r /etc/fuse.conf

ADD yas3fs.sh /etc/service/yas3fs/run
ADD backup_daily.sh /etc/cron.daily/backup
ADD backup_monthly.sh /etc/cron.monthly/backup
ADD update.sh /etc/service/update/run
RUN chmod 755 /etc/service/yas3fs/run /etc/cron.daily/backup /etc/cron.monthly/backup /etc/service/update/run
RUN chown  app:app /usr/local/var
RUN chown  app:app /usr/local/app
RUN chown  app:app /usr/local/tmp
RUN chown  app:app /usr/local/cache

CMD ["/sbin/my_init"]
