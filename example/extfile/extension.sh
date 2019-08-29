#!/bin/sh
#########################################################################
# Add PHP Extension
# File Name: extension.sh
# Author: Skiychan
# Email:  dev@skiy.net
# Version:
# Created Time: 2016/08/03
#########################################################################

#Add extension mongodb
curl -Lk https://pecl.php.net/get/mongodb-1.4.2.tgz | gunzip | tar x -C /home/extension && \
cd /home/extension/mongodb-1.4.2 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install