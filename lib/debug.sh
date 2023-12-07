Debug() {
    echo -e "$(date +%Y%m%d\ %H:%M:%S) [$$ ${BASH_SOURCE[1]}]: ${1}" >> ${LOGFILE_DEBUG}
}

Stacktrace() {
    ERR_CODE=$? # capture last command exit code
    set +xv # turns off debug logging, just in case

    R="--- begin stacktrace ---"

    # only log stack trace if requested (set -e)
    # and last command failed
    LEN=${#BASH_LINENO[@]}
    for (( i=0; i<$LEN-1; i++ ))
    do
        FILE="${BASH_SOURCE[${i}+1]}"
        FUNCTION="${FUNCNAME[${i}+1]}"
        if [[ ${i} > 0 ]]
        then
            # commands in stack trace
            CMD="${FUNCNAME[${i}]}"
            LINE="${BASH_LINENO[${i}]}"
        else
            # command that failed
            CMD="${BASH_COMMAND}"
            LINE="${ERRO_LINENO}"
        fi
        R+="\n    ${FILE} at line ${LINE} ${FUNCTION}(): ${CMD}"

    done
    Debug "$R"
    Debug "--- end stacktrace ---"
}
