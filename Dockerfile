FROM php:7-apache
MAINTAINER Phil Dodd "phil@whooshkaa.com"
ENV REFRESHED_AT 2017-05-17

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	sox \
	libsox-fmt-mp3 \
	supervisor \
	python-pip \
	vim \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo_mysql

#supervisord
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Python and aws cli to copy things from s3
RUN pip install awscli

RUN a2enmod rewrite

CMD ["/usr/bin/supervisord"]

