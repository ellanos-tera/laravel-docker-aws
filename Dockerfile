FROM php:7.3.2-apache-stretch

LABEL maintainer="Gbenga Oni B. <onigbenga@yahoo.ca>" \
      version="1.0"

RUN apt-get update && apt-get full-upgrade -y
RUN apt-get autoclean

RUN useradd -o -u 1000 -g www-data -m -d /srv/app -s /bin/bash -c "App user" userapp && \
    chmod 755 /srv/app
COPY --chown=www-data:www-data . /srv/app
RUN chmod -R 775 /srv/app/storage

COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf 
RUN sed -s -i -e "s/80/8001/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf
RUN sed -s -i -e "s/443/8443/" /etc/apache2/ports.conf /etc/apache2/sites-available/*.conf

WORKDIR /srv/app

RUN docker-php-ext-install mbstring pdo pdo_mysql xdebug \
 && a2enmod rewrite negotiation \
 && docker-php-ext-install opcache \
 && docker-php-ext-enable xdebug

USER userapp
