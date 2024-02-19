## deploy ssh-key without mounting file
## instead giving id_rsa as ENV base encoded
##
## SSH_IDRSA = cat id_rsa | base64 -w0
## SSH_IDFILE = path to save id_rsa
##
## you may call this function in your 
## plug's docker-entrypoint.sh

sshkey() {
    if [[ ${SSH_IDRSA} ]] && [[ ${SSH_IDFILE} ]]
    then
        mkdir $(dirname ${SSH_IDFILE})
        echo ${SSH_IDRSA} | base64 -d > ${SSH_IDFILE}
        chmod 600 ${SSH_IDFILE}
    fi
}
