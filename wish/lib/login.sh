##
## this Login function causes Guard to return true
## and also shared amongst multiple visitors/users in different sessions. 
## you should definitely override this function to your desired login method
##

Login() {
	Session anonymous
}

