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

	if [[ -z ${1} ]]
 	then
 		return 1
   	fi
    
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

	## add response header "set-cookie" for storing session in browser cookie
 	## MUST be the first lines of output/response (no body before)
  	## two additional empty lines are required to terminate HEADERS and start BODY
	echo "set-cookie: session=${UUID}"
 	echo ""
  	echo ""

}

Logout() {

	if [[ ${SESSION} ]] 
	then
		rm -f ${PATH_SESSION}/${SESSION}
	fi

 	echo "set-cookie: session=; expires=Thu, 01 Jan 1970 00:00:00 GMT"
 	echo ""
  	echo ""

	Redirect login

}

