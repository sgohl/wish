Login_PIN() {

	if [[ -f db/pin/${v_pin} ]]
	then

		Session "$(cat db/pin/${v_pin})"

	else

		## unfortunately, shell2http does not allow HTTP status code from "inside", instead this code is in the response content
		echo 401

	fi

}
