#!/bin/bash

## runs at container start by supervisor service
## this file will be placed as /www/docker-entrypoint.sh

for PLUGBIN in $(find app/plug -type d -name bin)
do
  PATH=${PATH}:${PLUGBIN}
done

## Chain app entrypoint
source /www/app/docker-entrypoint.sh

## Chain plug entrypoints
for ENTRYPOINT in $(find app/plug -type f -name docker-entrypoint.sh)
do
  source ${ENTRYPOINT}
done
