ARG REGISTRY=ghcr.io
ARG REPOSITORY_PHP=melhorenvio/php-8.2-fpm-alpine

FROM ${REGISTRY}/${REPOSITORY_PHP}:latest as php

WORKDIR /var/www

COPY ./ ./

USER root

RUN apk add --update --no-cache git openssh

RUN apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug \
  && apk del pcre-dev ${PHPIZE_DEPS}

RUN adduser -S development -G root -u 1000

COPY --from=composer:2.3 /usr/bin/composer /usr/bin/composer

ENTRYPOINT ["/usr/bin/entrypointd.sh"]
