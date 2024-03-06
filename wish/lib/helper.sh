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
