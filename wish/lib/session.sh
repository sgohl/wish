## COOKIE (session)
SESSION=$(echo "${HTTP_COOKIE}" | grep -o session=.* | cut -f2 -d'=' | cut -f1 -d';' | tr -d '"')

if [[ ! -f ${PATH_SESSION}/${SESSION} ]]
then
	unset SESSION
fi

Public() {

	## a list of public URLs accessible without Login
 	## while they're secured by Guard/Role

	if [[ -f /www/app/public.txt ]]
 	then
		if grep -q -o ${URI} /www/app/public.txt
	        then
	
	                return 0
	
	        fi
	 fi

}

Guard() {

	## To show an element for only logged-in users, Guard must be chained with &&
 	## or via if-block
	## example: Guard && Fragment foobar

 	Public

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

User() {

	## returns the name of logged-in user (content of session file)

	if [[ -z ${SESSION} ]] || [[ ! -f ${PATH_SESSION}/${SESSION} ]]
	then
		return 1
	fi

	cat ${PATH_SESSION}/${SESSION}

}

LoggedUser() {
	## compatibility
        User
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
        echo "set-cookie: session=${UUID}; Path=/; Expires=\"$(date -d "+${COOKIE_LIFETIME:-30} days" +"%a, %d %b %Y %H:%M:%S GMT")\"; SameSite=${COOKIE_SAMESITE:-Strict}"                                                                                                                                                                                                                                                                                                                                                     
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

