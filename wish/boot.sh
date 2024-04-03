set -a

Setenv() {
    if [[ $# -eq 2 ]]
    then
        KEY="${1}"
        VALUE="${2}"

        if [[ -z ${!KEY} ]]
        then
            export ${KEY}="${VALUE}"
        fi
    fi
}

Include() {                                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                                             
    if [[ -f "${1}" ]]
    then

        source "${1}"

    elif [[ -d "${1}" ]]
    then

        ## excludes docker-entrypoint.sh + api.sh

        for LIB in $(find "${1}" -type f -not -path '*/.*' -not -name "docker-entrypoint.sh" -not -name "api.sh" -name "*.sh" 2>/dev/null | sort -n)
        do

            Include ${LIB}

        done

    fi

}

## DBF == Database Files (folder); flat-file storage for simple non-relational data
Setenv DBF /www/db

## PATH(folder) where session ids are stored. make sure folder exists. you may use app/lib/_hook-pre.sh for 'mkdir -p ${PATH_SESSION}'
Setenv PATH_SESSION ${DBF}/session

## Cookie lifetime in days added to the current date used in Session()
Setenv COOKIE_LIFETIME 30

## see https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#samesitesamesite-value
Setenv COOKIE_SAMESITE Strict

## Load Plug .env
for ENV in $(find /www/app/plug -type f -mindepth 2 -maxdepth 2 -name ".env*")
do
    Include $ENV
done

## Load APP specific .env
Include /www/.env
Include /www/app/.env

## Load APPENV dependent .env (dev, prod, ...)
Include /www/.env.${APPENV}
Include /www/app/.env.${APPENV}

## Load LOCAL .env
Include /www/.env.local
Include /www/app/.env.local

## Load libs
Include /www/lib
Include /www/app/plug
Include /www/app/lib

