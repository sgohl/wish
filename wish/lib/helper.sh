Expect() {

  ## usage: Expect <number-of-arguments> $@
  ##
  ## use this function to verify expected number of args

	EXPECTED_ARGS=$1
	shift
	shift

	if [[ $# -ne $EXPECTED_ARGS ]]
	then
		exit 111
	fi

}


Mail() {

    ## -f : From
    ## -t : To
    ## -s : Subject

    if read -t 0
    then

        CONTENT=$(cat -)

    fi

    if [[ ${MAIL_FROM} ]]
    then
        FROM="${MAIL_FROM}"
    else
        FROM="${APPNAME} <root@localhost>"
    fi
    
    while getopts ":ft:s:" opt; do
        case $opt in
            f) FROM="${OPTARG}";;
            t) TO="${OPTARG}";;
            s) SUBJECT="${OPTARG}";;
        esac
    done

    /usr/sbin/ssmtp -t << EOF
From: ${FROM}
To: ${TO}
Subject: ${SUBJECT}

${CONTENT}
EOF

}
