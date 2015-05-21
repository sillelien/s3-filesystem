NB: experimental, use at your own risk :-)

Creates an S3 backed up filesystem using yas3fs which is synced to a local volume which can then be mounted by other Docker containers for fun and profit.

Features

* Local volume continuously syncs to FUSE mounted S3 volume using rsync
* Local volume remains responsive and fast, but regularly updates to S3
* Local volume can be imported by other containers, S3 volume remains private
* Only syncs if local volume files have changed, uses inotify for immediate syncs
* Simple quota system, stops files being copied to S3 volume once limit is reached
* File count limit, because this is all very, very slow :-)
* Daily/monthly tarball backups to S3

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


