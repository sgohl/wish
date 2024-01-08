#!/bin/bash

## runs at container start
## after main entrypoint (/www/docker-entrypoint.sh)
## this file will be placed as /www/app/docker-entrypoint.sh

## Plugs handling
#-find all bin folders and add to $PATH
#-tbd


## Chain app entrypoint
source /www/app/docker-entrypoint.sh
