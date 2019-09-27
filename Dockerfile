FROM php:7.2-fpm-stretch

ENV CADDY_HOSTNAME=0.0.0.0

RUN curl --silent --show-error --fail --location \
    --header "Accept: application/tar+gzip, application/x-gzip, application/octeet-stream" -o - \
    "https://caddyserver.com/download/linux/amd64?plugins=http.expires,http.realip&license=personal&telemetry=off" \
    | tar --no-same-owner -C /usr/bin -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && caddy --version \
    && docker-php-ext-install mbstring pdo pdo_mysql

RUN apt-get update \
    && apt-get -y install procps

COPY Caddyfile /etc/Caddyfile

WORKDIR /srv/app

EXPOSE 80

CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--log", "stdout"]