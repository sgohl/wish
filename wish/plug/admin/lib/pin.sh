PinsAll() {

	if [[ $(ls -1 db/pin | wc -l) -eq 0 ]]
	then
		return 1
	fi
	
	for PIN in $(ls -1 db/pin/*)
	do
		echo ${PIN}
	done

}
