#!/bin/bash

set -e

if [ "$1" = 'lsyncd' ]; then

    if [ ! -e /root/.s3cfg ]; then
          cat /s3cfg-sample > /root/.s3cfg

          if [[ -z "$S3CMD_ACCESS_KEY" ]] || [ -z "$S3CMD_SECRET_KEY" ]; then
            echo >&2 'error: missing S3CMD_ACCESS_KEY or S3CMD_SECRET_KEY environment variables'
            exit 1
          fi

          sed -i -e"s/access_key =/access_key = $S3CMD_ACCESS_KEY/" /root/.s3cfg  && \
          sed -i -e"s/secret_key =/secret_key = $S3CMD_SECRET_KEY/" /root/.s3cfg

          if [ -n "$S3CMD_BUCKET_LOCATION" ]; then
            sed -i -e"s/bucket_location = US/bucket_location = $S3CMD_BUCKET_LOCATION/" /root/.s3cfg
          fi

    fi

    if [ ! -e /lsyncd.conf ]; then

          if [ -n "$LSYNCD_SYNC" ]; then
            cat /lsyncd-sync.conf > /lsyncd.conf
          else
            cat /lsyncd-backup.conf > /lsyncd.conf
          fi


          if [[ -z "$LSYNCD_SOURCE" ]] || [ -z "$LSYNCD_TARGET" ]; then
            echo >&2 'error: missing LSYNCD_SOURCE or LSYNCD_TARGET environment variables'
            exit 1
          fi

          sed -i -e"s|source =|source = \"$LSYNCD_SOURCE\"|g" /lsyncd.conf && \
          sed -i -e"s|target =|target = \"$LSYNCD_TARGET\"|g" /lsyncd.conf

          if [ -n "$LSYNCD_DELAY" ]; then
            sed -i -e"s|delay = 5|delay = $LSYNCD_DELAY|g" /lsyncd.conf
          fi

          if [ -n "$LSYNCD_MAX_PROCESSES" ]; then
            sed -i -e"s|maxProcesses = 1|maxProcesses = $LSYNCD_MAX_PROCESSES|g" /lsyncd.conf
          fi

          if [ -n "$LSYNCD_ONSTARTUP_OFF" ]; then
            sed -i -e"s|onStartup = \"s3cmd sync \^source \^target\/\"\,||g" /lsyncd.conf
          fi
    fi
fi

exec "$@"
