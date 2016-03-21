# ToS3

Backup or synchronize directories to S3.

## Using ToS3

The following environment variables are honored for configuring ToS3:

-	`-e AWS_ACCESS_KEY_ID=...` (AWS ACCESS KEY )
-	`-e AWS_SECRET_ACCESS_KEY=...` (AWS SECRET KEY)
-	`-e S3CMD_BUCKET_LOCATION=...` (defaults to "US")
-	`-e LSYNCD_SOURCE=...` (Source directory)
-	`-e LSYNCD_TARGET=...` (S3 bucket target)
-	`-e LSYNCD_SYNC=...` (Set to enable sync mode, deletes will take effect)
-	`-e LSYNCD_DELAY=...` (defaults to "5", lsyncd delay seconds)
-	`-e LSYNCD_ONSTARTUP_OFF=...` (Set to disable onStartup sync source target)

Quickstart:

    $ docker run -d \
        --name=tos3 \
        -e "AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX" \
        -e "LSYNCD_SOURCE=/var/www/html" \
        -e "LSYNCD_TARGET=s3://test.bucket/html" \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/tos3:latest


By default ToS3 starts in backup mode, this means
that removing local files won't take any action.
To enable sync mode, set LSYNCD_SYNC variable to any value.

## override lsyncd configuration

You can override lsyncd configuration by sharing or copying your own custom
configuration to /lsyncd.conf

Example:

		$ docker run -d \
        --name=tos3 \
        -e "AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX" \
        --volume=lsyncd.conf:/lsyncd.conf \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/tos3:latest


## override s3cmd configuration

You can override s3cmd configuration by sharing or copying your own custom
configuration to /root/.s3cfg

Example:

		$ docker run -d \
        --name=tos3 \
        -e "LSYNCD_SOURCE=/var/www/html" \
        -e "LSYNCD_TARGET=s3://test.bucket/html" \
        --volume=s3cfg:/root/.s3cfg \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/tos3:latest
