# codeserver-secure-s3-fs

Try it in fig using a fig.yaml

```yaml

fs:
  build: .
  privileged: true
  environment:
    AWS_S3_PATH: neilellis/codeserver-example/master
    AWS_ACCESS_KEY_ID: AKIAIS67827QF2ABCQNQ
    AWS_SECRET_ACCESS_KEY: "<SECRET>"
    AWS_S3_BUCKET: codeserverlocalvars
    AWS_S3_LOCAL_MOUNT_POINT: "/usr/local/var"


```
