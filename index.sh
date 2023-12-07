#!/bin/bash -ea
##
##
##

SOURCE="${BASH_SOURCE[0]}" ; while [ -h "$SOURCE" ]; do
 DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
 SOURCE="$(readlink "$SOURCE")" ; [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done ; DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )" ; cd $DIR

Include() {

	if [[ -f "${1}" ]]
	then

		source "${1}"

	elif [[ -d "${1}" ]]
	then

		for LIB in $(find "${1}" -type f -name "*.sh" | sort -n)
		do

			Include ${LIB}

		done

	fi
	
}

## Load sane application defaults
Include lib/defaults.sh

## Load .env (copied from .env.dist)
Include .env

## Load APP specific .env
Include app/.env

## Load APPENV dependent .env (dev, prod, ...)
Include .env.${APPENV}
Include app/.env.${APPENV}

## Include distributed libs
for LIB in $(find lib -type f -not -name ".*" -not -name "defaults.sh" -name "*.sh" | sort -n)
do
	Include ${LIB}
done

## Source APP specific libs
Include app/lib/_pre.sh

for LIB in $(find app/lib -type f -not -name ".*" -not -name "_pre.sh" -not -name "_post.sh" -name "*.sh" | sort -n)
do
        Include ${LIB}
done

Include app/lib/_post.sh

## Source final app index.sh
Include app/index.sh
