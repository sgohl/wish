#!/bin/bash -ea
##
##
##

SOURCE="${BASH_SOURCE[0]}" ; while [ -h "$SOURCE" ]; do
 DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
 SOURCE="$(readlink "$SOURCE")" ; [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done ; DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )" ; cd $DIR

## Boot Application
source boot.sh

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

  		if [[ ${COMMAND} ]] && [[ -f app/plug/${COMMAND}/api.sh ]]
    		then
      
      			PLUG=${COMMAND}
	 		COMMAND=${URIPATH[@]:1}
      			Include app/plug/${PLUG}/api.sh
	 
		else

  			Include app/api.sh

     		fi

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

