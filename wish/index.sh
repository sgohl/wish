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

## Load Environment
Include env.sh

## Load libs
Include lib
Include app/lib
Include app/plug

## Routes

case ${URI} in

        api/*)
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

    		case ${COMMAND} in
	
			login)
		
				Login
		
			;;
		
			logout)
		
				Logout
		
			;;

   		esac

                if [[ -f app/api.sh ]]
		then
			Include app/api.sh
		#else
  			#View ${URI}
     			## I cant remember why?
		fi

                for API in $(find app/plug -type f -name api.sh)
                do
                        Include $API
                done
        ;;

        *)

                if [[ -f app/index.sh ]]
		then
			Include app/index.sh
		else
  			View ${URI}
		fi

        ;;

esac

