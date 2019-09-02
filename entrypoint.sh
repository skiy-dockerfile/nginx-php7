#!/bin/sh
#########################################################################
# START
# File Name: entrypoint.sh
# Author: Skiychan
# Email:  dev@skiy.net
# Created: 2019/09/02
#########################################################################

# Add PHP Extension
if [ -f "${PHP_EXTENSION_SH_PATH}/extension.sh" ]; then
    sh ${PHP_EXTENSION_SH_PATH}/extension.sh
    # mv -rf ${PHP_EXTENSION_SH_PATH}/extension.sh ${PHP_EXTENSION_SH_PATH}/extension_back.sh
fi

# /usr/local/php/sbin/php-fpm -F
/usr/local/php/sbin/php-fpm -D

# /usr/local/nginx/sbin/nginx -g
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
