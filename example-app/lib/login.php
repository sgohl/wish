Login_failed() {

  ## example fail action
  #

  echo "you shall not pass."
  exit 1

}

Login() {

  ## your custom Login function. On success, call "Session" with form-username
  #

  FORM_USERNAME=${v_username}
  FORM_PASSWORD=${v_password}

  true || Login_failed

  ## will add cookie resp.header
  Session ${FORM_USERNAME}

  ## after Login, redirect to default index page
  Redirect  

}
