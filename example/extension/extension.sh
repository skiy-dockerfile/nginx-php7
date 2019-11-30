#!/bin/bash

mkdir /home/extension

curl -Lk https://github.com/swoole/swoole-src/archive/v4.4.12.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.4.12 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install

rm -rf /home/extension
