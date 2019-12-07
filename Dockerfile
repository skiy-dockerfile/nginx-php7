FROM centos:7
MAINTAINER Skiychan <dev@skiy.net>

ENV NGINX_VERSION 1.17.6
ENV PHP_VERSION 7.4.0

ENV PRO_SERVER_PATH=/data/server
ENV NGX_WWW_ROOT=/data/wwwroot
ENV NGX_LOG_ROOT=/data/wwwlogs
ENV PHP_EXTENSION_SH_PATH=/data/server/php/extension
ENV PHP_EXTENSION_INI_PATH=/data/server/php/ini

## mkdir folders
RUN mkdir -p /data/{wwwroot,wwwlogs,server/php/ini,server/php/extension,}

RUN yum install -y epel-release

## install libraries
RUN set -x && \
yum install -y gcc \
gcc-c++ \
autoconf \
automake \
libtool \
make \
cmake \
#
# install PHP libraries
## libmcrypt-devel DIY
# rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
zlib \
zlib-devel \
openssl \
openssl-devel \
pcre-devel \
sqlite sqlite-devel \
oniguruma oniguruma-devel \
libxml2 \
libxml2-devel \
libcurl \
libcurl-devel \
libpng-devel \
libjpeg-devel \
freetype-devel \
libmcrypt-devel \
openssh-server && \ 
#
# make temp folder
mkdir -p /home/nginx-php && \
# install nginx
curl -Lk https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
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
# add user
useradd -r -s /sbin/nologin -d ${NGX_WWW_ROOT} -m -k no www && \
# ln nginx
cd ${PRO_SERVER_PATH} && ln -s /usr/local/nginx/conf nginx && \
curl -Lk https://github.com/kkos/oniguruma/releases/download/v6.9.4/onig-6.9.4.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/onig-6.9.4 && \
./configure && \
make && make install && \
#
# install php
curl -Lk https://php.net/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
# curl -Lk http://172.17.0.1/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/php-$PHP_VERSION && \  
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--with-config-file-scan-dir=${PHP_EXTENSION_INI_PATH} \
--with-fpm-user=www \
--with-fpm-group=www \
--enable-fpm \
--disable-fileinfo \
--enable-opcache \
--enable-mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-iconv-dir=/usr/local \
--with-freetype \
--with-jpeg \
--with-zlib \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-exif \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--enable-mbregex \
--enable-mbstring \
--with-password-argon2 \
--with-sodium=/usr/local \
--enable-gd \
--with-openssl \
--with-mhash \
--enable-pcntl \
--enable-sockets \
--with-xmlrpc \
--enable-ftp \
--enable-intl \
--with-xsl \
--with-gettext \
--enable-zip \
--without-libzip \
--enable-soap \
--disable-debug && \
make && make install && \
#
# install php-fpm
cd /home/nginx-php/php-$PHP_VERSION && \
cp php.ini-production /usr/local/php/etc/php.ini && \
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf && \
rm -rf /home/nginx-php && \
#
# remove temp folder
rm -rf /home/nginx-php && \
#
# clean os
# RUN yum remove -y gcc \
# gcc-c++ \
# autoconf \
# automake \
# libtool \
# make \
# cmake && \
yum clean all && \
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
RUN chown -R www:www ${NGX_WWW_ROOT} && \
chmod +x /entrypoint.sh

# Set port
EXPOSE 80 443

# CMD ["/usr/local/php/sbin/php-fpm", "-F", "daemon off;"]
# CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]

# Start it
ENTRYPOINT ["/entrypoint.sh"]
