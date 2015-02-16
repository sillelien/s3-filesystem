FROM phusion/baseimage:0.9.16
VOLUME /usr/local/var

RUN apt-get update && apt-get -y install ntp fuse python-pip && pip install yas3fs && \
    sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf && \
    chmod a+r /etc/fuse.conf && yas3fs -h

ADD yas3fs.sh /etc/service/yas3fs/run
RUN chmod 755 /etc/service/yas3fs/run

CMD ["/sbin/my_init"]