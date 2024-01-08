case ${COMMAND} in

    admin)

		Role admin || Redirect

		ACTION=${URIPATH[1]}

		case $ACTION in

			users)

				if [[ -f ${DBF}/roles/${r}/${u} ]]
				then
					rm -f ${DBF}/roles/${r}/${u}
				fi

				Redirect back

		;;

		esac

    ;;

esac
