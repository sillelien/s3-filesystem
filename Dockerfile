FROM vizzbuzz/base-alpine

ENV AWS_ACCESS_KEY_ID CHANGE_ME
ENV AWS_SECRET_ACCESS_KEY CHANGE_ME
ENV AWS_DEFAULT_REGION eu-west-1
ENV AWS_S3_LOCAL_MOUNT_POINT /s3
ENV AWS_S3_PATH /test

ENV SHARE_VOLUME /var/share

ENV SIMPLE_QUOTA_MAX_FILES 100
ENV SIMPLE_QUOTA_LOWER_MB 100
ENV SIMPLE_QUOTA_UPPER_MB 1024

VOLUME ${SHARE_VOLUME}


COPY build.sh /tmp/build.sh
RUN chmod 755 /tmp/build.sh
RUN /tmp/build.sh

COPY yas3fs.sh /etc/services.d/yas3fs/run
ADD backup_daily.sh /etc/cron.daily/backup
ADD backup_monthly.sh /etc/cron.monthly/backup
ADD update.sh /etc/services.d/update/run
RUN chmod 755 /etc/services.d/yas3fs/run /etc/cron.daily/backup /etc/cron.monthly/backup /etc/services.d/update/run
