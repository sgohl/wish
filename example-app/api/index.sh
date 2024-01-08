set -e -o pipefail

Trap() {
    View 500
    exit 1
}

trap Trap ERR

#echo FULL URI PATH = ${URIPATH[@]}
#echo GETARGS = ${GETARGS[@]}

case ${COMMAND} in

	'')

		exit

	;;

	ping)

		echo "pong"

	;;

	login)

		Login

	;;

	logout)

		Logout

	;;

	admin*)

		Role admin

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

	*)

		exit

	;;

esac
