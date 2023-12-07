URI=${PATH_INFO#/}

if [[ -n $URI ]]
then
	# basename; the last part (slash delimiter) of URI 
	URI_LAST=$(basename ${URI})
else
	URI_LAST=
fi

## split QUERY_STRING into array and evaluate into addressable variables
## warning: this might be insecure and makes injection possible. still better than eval, though
IFS='&' read -r -a GETARGS <<< "$QUERY_STRING"; unset IFS
for ITEM in "${GETARGS[@]}"
do
	KEY=$(echo ${ITEM} | cut -f1 -d'=')
	VALUE=$(echo ${ITEM} | cut -f2 -d'=')
	export ${KEY}=${VALUE}
done


