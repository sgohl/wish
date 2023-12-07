## COOKIE (session)
SESSION=$(echo "${HTTP_COOKIE}" | grep -o session=.* | cut -f2 -d'=' | cut -f1 -d';')

if [[ ! -f ${PATH_SESSION}/${SESSION} ]]
then
	unset SESSION
fi

Guard() {

	## To show an element for only logged-in users, Guard must be chained with &&
	## example: Guard && Fragment foobar

	if [[ ! -f ${PATH_SESSION}/${SESSION} ]]
	then
		case $1 in
			login)
				Redirect login
			;;
		esac

		return 1
	fi

}

LoggedUser() {

	## returns the name of logged-in user (content of session file)

	if [[ -z ${SESSION} ]]
	then
		return 1
	fi

	if [[ ! -f ${PATH_SESSION}/${SESSION} ]]
	then
		return 1
	fi

	cat ${PATH_SESSION}/${SESSION}

}

Session() {

	set -eu

	[[ -n ${1} ]] || return 1
	USERNAME="${1}"

	## generate uuid as session-id
	UUID=$(uuidgen)

	## session cleanup
	if [[ $(grep -r -l "${USERNAME}" ${PATH_SESSION} | wc -l) -gt 0 ]]
	then
		grep -r -l "${USERNAME}" ${PATH_SESSION} | xargs -r rm -f
	fi

	## save username in new session object
	echo "${USERNAME}" > ${PATH_SESSION}/${UUID}

	## return uuid to browser for storing in cookie
	echo ${UUID}

}

Logout() {

	if [[ ${SESSION} ]] 
	then

		rm -f ${PATH_SESSION}/${SESSION}

	fi

	Redirect login

}
