case ${URI} in

        api/*)
                URI=${URI#*/}

                ## split URI path into array ${URIPATH[@]}
                IFS='/'; read -ra URIPATH <<< "$URI"; unset IFS
                COMMAND=${URIPATH[0]}

                source app/api.sh
        ;;

        admin*)

                Role admin || Redirect
                View ${URI}

        ;;


        *)
                #Guard login

                View ${URI}

        ;;

esac
