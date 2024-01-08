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

		for LIB in $(find "${1}" -type f -name "*.sh" 2>/dev/null | sort -n)
		do

			Include ${LIB}

		done

	fi
	
}

## Load sane application defaults
Include env.sh

## Load APP specific .env
Include app/.env

## Load APPENV dependent .env (dev, prod, ...)
Include app/.env.${APPENV}

Include lib
Include app/lib
Include app/plug/*/lib

# ## Include Plugs
# for LIB in $(find app/plug/*/lib -type f -name "*.sh" 2>/dev/null | sort -n)
# do
# 	Include ${LIB}
# done

## Include final app index.sh
Include app/index.sh
