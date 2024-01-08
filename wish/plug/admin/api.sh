case ${COMMAND} in

    admin)

		Role admin || Redirect

		case $URI in

			admin/users/rm)

				if [[ -f ${DBF}/roles/${r}/${u} ]]
				then
					rm -f ${DBF}/roles/${r}/${u}
				fi

				Redirect back

			;;

			admin/users/addrole)

				touch ${DBF}/roles/${v_role}/${v_user}

				Redirect back
					
			;;

		esac

    ;;

esac
