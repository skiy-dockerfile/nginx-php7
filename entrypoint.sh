#!/bin/sh
#########################################################################
# START
# File Name: entrypoint.sh
# Author: Skiychan
# Email:  dev@skiy.net
# Created: 2019/09/02
#########################################################################

InstallTools() {
    yum install -y gcc \
    gcc-c++ \
    autoconf \
    automake \
    make \
    cmake
}

# Add PHP Extension
if [ -f "${PHP_EXTENSION_SH_PATH}/extension.sh" ]; then
    ## Install Tools
    InstallTools

    sh ${PHP_EXTENSION_SH_PATH}/extension.sh
    mv -rf ${PHP_EXTENSION_SH_PATH}/extension.sh ${PHP_EXTENSION_SH_PATH}/extension_back.sh
fi

# Clear OS
yum remove -y gcc \
gcc-c++ \
autoconf \
automake \
libtool \
make \
cmake && \
yum clean all && \
rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
find /var/log -type f -delete

# /usr/local/php/sbin/php-fpm -F
/usr/local/php/sbin/php-fpm -D

# /usr/local/nginx/sbin/nginx -g
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
