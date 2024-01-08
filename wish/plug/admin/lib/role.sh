Role() {

	ROLE="${1}"

	if [[ ! -f ${DBF}/roles/${ROLE}/$(LoggedUser) ]] || ! LoggedUser >/dev/null
	then

		return 1

	fi

	Guard || return 1

}

RolesAll() {

	for ROLE in $(ls -d1 ${DBF}/roles/*)
	do
		echo $(basename ${ROLE})
	done

}

RoleUsers() {

	ROLE="${1}"

	if [[ "$(ls -A ${DBF}/roles/${ROLE})" ]]
	then

		for USER in $(ls -1 ${DBF}/roles/${ROLE}/*)
		do
			echo $(basename ${USER})
		done

	fi

}
