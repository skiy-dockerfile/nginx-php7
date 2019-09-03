FROM centos:7
MAINTAINER Skiychan <dev@skiy.net>

ENV NGINX_VERSION 1.17.3
ENV PHP_VERSION 7.3.9

ENV PRO_SERVER_PATH=/data/server
ENV NGX_WWW_ROOT=/data/wwwroot
ENV NGX_LOG_ROOT=/data/wwwlogs
ENV PHP_EXTENSION_SH_PATH=/data/server/php/extension
ENV PHP_EXTENSION_INI_PATH=/data/server/php/ini

RUN set -x && \
yum install -y gcc \
gcc-c++ \
autoconf \
automake \
libtool \
make \
cmake \
#
# Install PHP library
## libmcrypt-devel DIY
# rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
zlib \
zlib-devel \
openssl \
openssl-devel \
pcre-devel \
libxml2 \
libxml2-devel \
libcurl \
libcurl-devel \
libpng-devel \
libjpeg-devel \
freetype-devel \
libmcrypt-devel \
openssh-server

# Download nginx & php
RUN mkdir -p /data/{wwwroot,wwwlogs,server/php/ini,server/php/extension,} && \
mkdir -p /home/nginx-php

# Make install nginx
RUN curl -Lk https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
# RUN curl -Lk http://172.17.0.1/download/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/nginx-$NGINX_VERSION && \
./configure --prefix=/usr/local/nginx \
--user=www --group=www \
--error-log-path=${NGX_LOG_ROOT}/nginx_error.log \
--http-log-path=${NGX_LOG_ROOT}/nginx_access.log \
--pid-path=/var/run/nginx.pid \
--with-pcre \
--with-http_ssl_module \
--with-http_v2_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--with-http_gzip_static_module && \
make && make install && \
#
# Make install php
curl -Lk https://php.net/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
# curl -Lk http://172.17.0.1/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/php-$PHP_VERSION && \  
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--with-config-file-scan-dir=${PHP_EXTENSION_INI_PATH} \
--with-fpm-user=www \
--with-fpm-group=www \
--with-mysqli \
--with-pdo-mysql \
--with-openssl \
--with-gd \
--with-iconv \
--with-zlib \
--with-gettext \
--with-curl \
--with-png-dir \
--with-jpeg-dir \
--with-freetype-dir \
--with-xmlrpc \
--with-mhash \
--enable-fpm \
--enable-xml \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex \
--enable-mbstring \
--enable-ftp \
--enable-mysqlnd \
--enable-pcntl \
--enable-sockets \
--enable-soap \
--enable-session \
--enable-opcache \
--enable-bcmath \
--enable-exif \
--enable-fileinfo \
--disable-rpath \
--enable-ipv6 \
--disable-debug \
--without-pear \
--enable-zip --without-libzip && \
make && make install

# Install php-fpm
RUN cd /home/nginx-php/php-$PHP_VERSION && \
cp php.ini-production /usr/local/php/etc/php.ini && \
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf && \
rm -rf /home/nginx-php && \
#
# Add user
useradd -r -s /sbin/nologin -d ${NGX_WWW_ROOT} -m -k no www && \
chown -R www:www ${NGX_WWW_ROOT} && \
# ln nginx
cd ${PRO_SERVER_PATH} && ln -s /usr/local/nginx/conf nginx

#Clean OS
# RUN yum remove -y gcc \
# gcc-c++ \
# autoconf \
# automake \
# libtool \
# make \
# cmake && \
RUN yum clean all && \
rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
find /var/log -type f -delete

VOLUME ["/data/wwwroot", "/data/wwwlogs", "/data/server/php/ini", "/data/server/php/extension", "/data/server/nginx"]

# NGINX
ADD nginx.conf /usr/local/nginx/conf/
ADD vhost /usr/local/nginx/conf/vhost

ADD www ${NGX_WWW_ROOT}

# Start
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set port
EXPOSE 80 443

# CMD ["/usr/local/php/sbin/php-fpm", "-F", "daemon off;"]
# CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Start it
ENTRYPOINT ["/entrypoint.sh"]
