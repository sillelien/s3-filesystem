NB: experimental, use at your own risk :-)

Creates am S3 backed filesystem using yas3fs which can then be mounted by other Docker containers for fun and profit.

Features

* S3 backed filesystem
* Daily/monthly tarball backups to S3
* Simple quota system

Try it in fig using a fig.yml

```yaml

fs:
  build: .
  privileged: true
  environment:
    AWS_S3_PATH: neilellis/codeserver-example/master
    AWS_ACCESS_KEY_ID: AKIAIS67827QF2ABCQNQ
    AWS_SECRET_ACCESS_KEY: "<SECRET>"
    AWS_S3_BUCKET: mybucket
    AWS_S3_LOCAL_MOUNT_POINT: "/usr/local/var"
    SHARE_VOLUME: "/usr/local/var"
    SIMPLE_QUOTA_LOWER_MB: 100
    SIMPLE_QUOTA_UPPER_MB: 1024
    SIMPLE_QUOTA_MAX_FILES: 100

```


