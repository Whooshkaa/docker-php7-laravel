FROM php:7.1.23-apache-jessie
MAINTAINER Phil Dodd "phil@whooshkaa.com"
ENV REFRESHED_AT 2019-07-03

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libzip-dev \
        libpng-dev \
	sox \
	libsox-fmt-mp3 \
	supervisor \
	python-pip \
	vim \
	wget \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) bcmath \
    && pip install awscli

# ffmpeg is not available as a package for Debian Jessie,
# so we have to compile from source.

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\n" > /etc/apt/sources.list
RUN echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
RUN echo "deb-src http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes deb-multimedia-keyring && \
apt-get update && \
apt-get remove -y ffmpeg && \
apt-get install -y --force-yes build-essential libmp3lame-dev libvorbis-dev libtheora-dev libspeex-dev yasm pkg-config libfaac-dev libopenjpeg-dev libx264-dev
RUN mkdir software && \
	cd software && \
	wget http://ffmpeg.org/releases/ffmpeg-2.7.2.tar.bz2 && \
	cd .. && \
	mkdir src && \
	cd src && \
	tar xvjf ../software/ffmpeg-2.7.2.tar.bz2 && \
	rm ../software/ffmpeg-2.7.2.tar.bz2 && \
	cd ffmpeg-2.7.2 && \
	./configure --enable-gpl --enable-postproc --enable-swscale --enable-avfilter --enable-libmp3lame --enable-libvorbis --enable-libtheora --enable-libx264 --enable-libspeex --enable-shared --enable-pthreads --enable-libopenjpeg --enable-libfaac --enable-nonfree && \
	make && \
	make install && \
	/sbin/ldconfig && \
	cd .. && \
	rm -rf software && \
	rm -rf src 

#supervisord
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2enmod rewrite

COPY php-cli.ini /usr/local/etc/php/php.ini
RUN touch /var/log/php_errors.log

CMD ["/usr/bin/supervisord"]

