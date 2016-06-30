FROM php:7-apache
MAINTAINER Phil Dodd "tripper54@gmail.com"
ENV REFRESHED_AT 2016-06-30

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo_mysql

RUN apt-get install vim -y

# Python and aws cli to copy things from s3
RUN apt-get -y install python-pip
RUN pip install awscli

RUN a2enmod rewrite

