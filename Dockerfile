FROM php:7.4.15-fpm-buster
MAINTAINER Phil Dodd "phil@whooshkaa.com"
ENV REFRESHED_AT 2020-01-22

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libzip-dev \
        libpng-dev \
	sox \
	libsox-fmt-mp3 \
	python-pip \
	vim \
	wget \
        libfcgi0ldbl \
        ffmpeg \
    && docker-php-ext-install -j$(nproc) iconv pdo_mysql zip bcmath opcache gd\ 
    && pip install awscli

RUN mkdir -p /var/log/php
COPY php-cli.ini /usr/local/etc/php/php.ini
COPY php-opcache.ini /usr/local/etc/php/conf.d/opcache.ini

