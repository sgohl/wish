Render() {

	if [[ ${1} ]]
	then
    		source <(bash-tpl ${1})

	else
 		if read -t 0
   		then
	  		source <(cat - | bash-tpl)
		fi
	fi

}


View() {

	## View is a rendered HTML page and has/yields (possibly multiple) Page(s) and/or Fragment(s)
	## is the direct descendant/representation of URI
	## Plugs don't support views directly because of not solvable ambiguity in some conditions
	## you must yield the desired view from the main app view

	VIEW=${1%.html}

	if [[ ! -f app/views/${VIEW}.html ]]
	then

		VIEW="index"

	fi

	Render app/views/${VIEW}.html

}

Page() {

	## Page is the content rendered within a View
	## URI represents Page, if no view for URI exists

	PAGE=${1%.html}

	if [[ -z ${PAGE} ]]
	then

		## if arg1 not given, use URI as PAGE

		PAGE=${URI}
	
	fi

	if [[ -z ${PAGE} ]]
	then

		## PAGE still empty -> Render default Page index

		Render app/pages/index.html
		return

	fi

	## PAGE or URI given, traverse to find correct file

	DIRNAME=$(dirname ${PAGE})
	BASENAME=$(basename ${PAGE})

	SEARCH="app/plug/${DIRNAME}/pages/${URI} app/plug/$(dirname ${DIRNAME})/pages/${BASENAME} app/plug/$(dirname ${DIRNAME})/pages/$(basename $(dirname $PAGE)) app/plug/${DIRNAME}/pages/${BASENAME} app/plug/${DIRNAME}/pages app/pages/${URI} app/pages"

	## DEBUG
	#echo SEARCH "$SEARCH"

	for DIR in ${SEARCH}
	do

		#echo TEST ${DIR}/${BASENAME}.html

		if [[ -f ${DIR}/${BASENAME}.html ]]
		then

			Render ${DIR}/${BASENAME}.html
			return

		else	

			if [[ -f ${DIR}/index.html ]]
			then			

				Render ${DIR}/index.html
				return

			fi
		
		fi

	done

	## no exact file match found
	## $URI_LAST might be positional argument. check for parent html file
	## URI=yourcrud/edit/123 resolves to yourcrud/edit.html

	PARENT="app/pages/$(dirname ${URI}).html app/plug/${DIRNAME}/pages/$(dirname ${URI}).html"

	for FILE in ${PARENT}
	do

		if [[ -f ${FILE} ]]
		then

			Render ${FILE}
			return

		fi

	done

	## PATH might be directory, Render subdir-index

	SEARCH="app/pages/${URI} app/plug/${DIRNAME}/pages/${URI}"

	for DIR in ${SEARCH}
	do

		if [[ -d ${DIR} ]]
		then

			## URI is directory, Render subdir-index

			echo found $DIR

			Render ${DIR}/index.html
			return

		fi

	done

	## ¯\_(ツ)_/¯ (sur)render
	Page 404 || true

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


Redirect() {

	## for browser-based redirects

 	TARGET=${1:-}

	case ${TARGET} in
 
		back|refer)
   			TARGET=${HTTP_REFERER}
		;;
  
		*)
			TARGET="/${TARGET}"
		;;
  
	esac

 	echo '<html><meta http-equiv="refresh" content="0; URL='"${TARGET}"'" /></html>'

}

