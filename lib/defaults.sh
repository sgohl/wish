## DBF == Database Files (folder); flat-file storage for simple non-relational data
if [[ -z ${DBF} ]]
then
    DBF=/www/db
fi

## PATH(folder) where session ids are stored. make sure folder exists. you may use app/lib/_hook-pre.sh for 'mkdir -p ${PATH_SESSION}'
if [[ -z ${PATH_SESSION} ]]
then
    PATH_SESSION=${DBF}/session
fi

