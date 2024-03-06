#!/bin/bash

## runs at container start by supervisor service
## this file will be placed as /www/docker-entrypoint.sh

source /www/boot.sh

for PLUGBIN in $(find app/plug -type d -not -path '*/.*' -name bin)
do
  PATH=${PATH}:${PLUGBIN}
done

## Crontabs
find /www/app -type f -not -path '*/.*' -mindepth 1 -maxdepth 3 -name "cron*" | xargs cat | crontab -

## Chain app entrypoint
source /www/app/docker-entrypoint.sh

## Chain plug entrypoints
for ENTRYPOINT in $(find app/plug -type f -not -path '*/.*' -name docker-entrypoint.sh)
do
  source ${ENTRYPOINT}
done
