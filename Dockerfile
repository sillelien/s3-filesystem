FROM phusion/baseimage:0.9.16

ENV AWS_ACCESS_KEY_ID CHANGE_ME
ENV AWS_SECRET_ACCESS_KEY CHANGE_ME
ENV AWS_DEFAULT_REGION eu-west-1
ENV AWS_S3_LOCAL_MOUNT_POINT /usr/local/var
ENV AWS_S3_PATH /

VOLUME ${AWS_S3_LOCAL_MOUNT_POINT}

RUN apt-get update && apt-get -y install ntp fuse python-pip && pip install yas3fs && \
    sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf && \
    chmod a+r /etc/fuse.conf && yas3fs -h

ADD yas3fs.sh /etc/service/yas3fs/run
RUN chmod 755 /etc/service/yas3fs/run


CMD ["/sbin/my_init"]