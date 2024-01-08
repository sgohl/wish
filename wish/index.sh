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

	else
 		return 1
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
Include app/plug

# ## Include Plugs
# for LIB in $(find app/plug/*/lib -type f -name "*.sh" 2>/dev/null | sort -n)
# do
# 	Include ${LIB}
# done

## Include final app index.sh
#Include app/index.sh

case ${URI} in

        api*)
                URI=${URI#*/}

                # split URI path into array ${URIPATH[@]}
                IFS='/'; read -ra URIPATH <<< "$URI"; unset IFS
                COMMAND=${URIPATH[0]}

                ## array GETARGS = ${GETARGS[@]}
		
		Trap() {
		    View 500
		    exit 1
		}
		
		trap Trap ERR
  		set -e -o pipefail

                Include app/api.sh

                for API in $(find app/plug -type f -name api.sh)
                do
                        Include $API
                done
        ;;

        admin*)

                Role admin || Redirect
                
		ACTION=${URIPATH[1]}

		case $ACTION in

			users)

				if [[ ! -f ${DBF}/roles/${r}/${u} ]]
				then
					echo "user $u in role $role not found"
					exit 1
				fi

				Redirect back
			;;

		esac

        ;;

 	login)

		Login

	;;

	logout)

		Logout

	;;

        *)

                Include app/index.sh || View ${URI}

        ;;

esac

