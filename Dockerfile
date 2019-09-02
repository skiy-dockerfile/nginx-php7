FROM centos:7
MAINTAINER Skiychan <dev@skiy.net>

ENV NGINX_VERSION 1.17.3
ENV PHP_VERSION 7.2.22

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
cmake

# Install PHP library
## libmcrypt-devel DIY
RUN yum history sync && \
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm && \
yum install -y zlib \
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
openssh-server \
python-setuptools

# Download nginx & php
RUN mkdir -p /data/{wwwroot,wwwlogs,server/php/ini,server/php/extension,} && \
mkdir -p /home/nginx-php

# Make re2c
#RUN curl -SLO https://github.com/skvadrik/re2c/releases/download/1.2.1/re2c-1.2.1.tar.xz && tar xvJf re2c-1.2.1.tar.xz -C /home/nginx-php && \
# RUN curl -SLO https://github.com/skvadrik/re2c/releases/download/1.2.1/re2c-1.2.1.tar.xz && tar xvJf re2c-1.2.1.tar.xz -C /home/nginx-php && \
# cd /home/nginx-php/re2c-1.2.1 && \
# ./configure && make && make install

# Make libzip
# RUN curl -Lk https://libzip.org/download/libzip-1.4.0.tar.gz | gunzip | tar x -C /home/nginx-php && \
# cd /home/nginx-php/libzip-1.3.0 && \ 
# mkdir build && cd build && cmake .. && make && make install && \
# #cp /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h
# #ln -s /usr/local/lib/libzip/include/zipconf.h /usr/local/include/zipconf.h

# Make bison
# curl -Lk http://ftp.gnu.org/gnu/bison/bison-3.4.1.tar.gz | gunzip | tar x -C /home/nginx-php && \
# RUN curl -Lk http://172.17.0.1/download/bison-3.4.1.tar.gz | gunzip | tar x -C /home/nginx-php && \
# cd /home/nginx-php/bison-3.4.1 && \
# ./configure && make && make install

# Make install nginx
RUN curl -Lk https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/nginx-$NGINX_VERSION && \
./configure --prefix=/usr/local/nginx \
--user=www --group=www \
--error-log-path=${NGX_LOG_ROOT}/nginx_error.log \
--http-log-path=${NGX_LOG_ROOT}/nginx_access.log \
--pid-path=/var/run/nginx.pid \
--with-pcre \
--with-http_ssl_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--with-http_gzip_static_module && \
make && make install

# Make install php
RUN curl -Lk https://php.net/distributions/php-$PHP_VERSION.tar.gz | gunzip | tar x -C /home/nginx-php && \
cd /home/nginx-php/php-$PHP_VERSION && \  
./configure --prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--with-config-file-scan-dir=${PHP_EXTENSION_INI_PATH} \
--with-fpm-user=www \
--with-fpm-group=www \
# --with-libzip \
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
--enable-zip \
--enable-soap \
--enable-session \
--enable-opcache \
--enable-bcmath \
--enable-exif \
--enable-fileinfo \
--disable-rpath \
--enable-ipv6 \
--disable-debug \
--without-pear && \
make && make install

# Install php-fpm
RUN cd /home/nginx-php/php-$PHP_VERSION && \
cp php.ini-production /usr/local/php/etc/php.ini && \
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf

# Clean OS
RUN yum clean all && \
rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
find /var/log -type f -delete && \
rm -rf /home/nginx-php

# Add user
RUN useradd -r -s /sbin/nologin -d ${NGX_WWW_ROOT} -m -k no www && \
chown -R www:www ${NGX_WWW_ROOT}

RUN cd ${PRO_SERVER_PATH} && ln -s /usr/local/nginx/conf nginx

VOLUME [${NGX_WWW_ROOT}, ${PHP_EXTENSION_INI_PATH}, ${PHP_EXTENSION_SH_PATH}, ${PRO_SERVER_PATH}/nginx]

# NGINX
ADD nginx.conf /usr/local/nginx/conf/
ADD vhost /usr/local/nginx/conf/vhost

ADD www ${NGX_WWW_ROOT}

# Start
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Set port
EXPOSE 80 443

CMD ["/usr/local/php/sbin/php-fpm","-F","daemon off;"]
# CMD ["/usr/local/nginx/sbin/nginx","-g","daemon off;"]

# Start it
ENTRYPOINT ["/entrypoint.sh"]
