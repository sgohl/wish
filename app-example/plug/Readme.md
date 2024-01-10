# Plugins

wishplugs have almost the same structure as the main app, besides some exceptions

supported:

- pages
- fragments
- lib

*not* supported:

- views


If you choose to bundle plugs with your application, consider the following:

- you want all external plugs locally for development
- but if your prod app will be built using a pipeline and your plugs are installed via Dockerfile, this will fail because the folder already exists from your local development
- you can install external wish plugs via `app/docker-entrypoint.sh` for local dev like this, for example

```
if [[ ! $APPENV == 'prod' ]]
then

    if [[ -d /www/app/plug/admin ]]
    then
        git --work-tree /www/app/plug/admin/ --git-dir /www/app/plug/admin/.git pull        
    else
        wish plug admin https://github.com/sgohl/wish-admin.git
    fi

fi
```

and then add this plug into `.gitignore`
```
admin/
```

That way, it does not cuase collisions with a build pipeline.

