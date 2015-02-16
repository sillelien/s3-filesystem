FROM phusion/baseimage:0.9.16
VOLUME /usr/local/var

RUN apt-get update && apt-get -y install ntp fuse python-pip && pip install yas3fs && \
    sed -i'' 's/^# *user_allow_other/user_allow_other/' /etc/fuse.conf && \
    chmod a+r /etc/fuse.conf && yas3fs -h

ADD yas3fs.sh /etc/service/yas3fs/run
RUN chmod 755 /etc/service/yas3fs/run

export GITHUB_USER=neilellis
export GITHUB_PROJECT=codeserver-example
export GITHUB_BRANCH=master

export AWS_ACCESS_KEY_ID=CHANGE_ME
export AWS_SECRET_ACCESS_KEY=CHANGE_ME
export AWS_DEFAULT_REGION="eu-west-1"

CMD ["/sbin/my_init"]