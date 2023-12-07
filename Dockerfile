FROM msoap/shell2http
ENV PATH=${PATH}:/www/app/bin

WORKDIR /www
ENTRYPOINT []
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf", "--pidfile", "/var/run/supervisord.pid"]

RUN apk upgrade
RUN apk add -U --no-cache bash supervisor curl jq jo coreutils util-linux libc6-compat nginx
RUN apk add -U --no-cache --allow-untrusted --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community/ cronie

## bash-tpl rendering engine
RUN curl -Lso /bin/bash-tpl https://github.com/TekWizely/bash-tpl/releases/download/v0.7.1/bash-tpl \
&&  chmod +x /bin/bash-tpl

## docker-dist
COPY docker-dist /

## wish + example-app
COPY . /www
RUN chmod +x /www/index.sh

## cleanup (until docker supports COPY --exclude=) 
RUN rm -rf /www/docker-dist

## SUPERVISOR SERVICES
ENV SPV_NGINX=true
ENV SPV_SHELL2HTTP=true
ENV SPV_CRON=false
ENV SPV_ENTRYPOINT=true

