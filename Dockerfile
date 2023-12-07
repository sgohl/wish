FROM msoap/shell2http
RUN ln -s /app/shell2http /bin/shell2http

WORKDIR /www
ENTRYPOINT []
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf", "--pidfile", "/var/run/supervisord.pid"]

RUN apk upgrade
RUN apk add -U --no-cache bash supervisor curl jq jo coreutils util-linux libc6-compat nginx
RUN apk add -U --no-cache --allow-untrusted --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community/ cronie

## bash-tpl rendering engine
RUN curl -Lso /bin/bash-tpl https://github.com/TekWizely/bash-tpl/releases/download/v0.7.1/bash-tpl \
&&  chmod +x /bin/bash-tpl

COPY docker-dist /

COPY lib /www/lib
COPY index.sh /www/index.sh
RUN chmod +x /www/index.sh
COPY app /opt/app

## SUPERVISOR SERVICES
ENV SPV_NGINX=true
ENV SPV_CRON=false
ENV SPV_ENTRYPOINT=true

