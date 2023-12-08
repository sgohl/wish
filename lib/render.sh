Render() {

	if [[ ${1} ]]
	then
    		source <(bash-tpl ${1})

	else
 		if read -t 0
   		then
			STDIN=$(cat -)
	  		source <(echo ${STDIN} | bash-tpl)
		fi
	fi

}


View() {

	## View is a rendered HTML page and has/yields (possibly multiple) Page(s) and/or Fragment(s)

	VIEW=${1%.html}

	if [[ ! -f app/views/${VIEW}.html ]]
	then

		VIEW="index"

	fi

	Render app/views/${VIEW}.html

}

Page() {

	## Page is the content rendered within a View

	PAGE=${1%.html}

	## if $1 is empty and no URI, always Render index

	if [[ -z ${PAGE} ]] && [[ -z ${URI} ]]
	then

		Render app/pages/index.html

	else

		## if URI is given but file does not exist

		if [[ ! -f app/pages/${PAGE}.html ]]
		then

			## URI is directory, Render subdir-index

			if [[ -d app/pages/${URI} ]]
			then

				Render app/pages/${URI}/index.html
				return
			
			fi

			## $URI_LAST might be positional argument. check for parent html file

			PARENT="app/pages/$(dirname ${URI}).html"

			if [[ -f ${PARENT} ]]
			then
			
				Render ${PARENT}
				return
			
			else
			
				## PARENT also not found. Render 404
				
				Render app/pages/404.html
				return
			
			fi
		
		else

			Render app/pages/${PAGE}.html

		fi

	fi


}

Fragment() {

	FRAGMENT=app/fragments/${1%.html}.html

	if [[ -f ${FRAGMENT} ]]
	then
		Render ${FRAGMENT}
	fi
	
}

Logo() {

	echo ${LOGO_URL}

}

