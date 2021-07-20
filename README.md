
This example is based on the source code:   
[https://github.com/skiy/nginx-php7/tree/main/example](https://github.com/skiy/nginx-php7/tree/main/example)
   
English | [简体中文](./README_CN.md)

### docker-compose
```yaml
version: '3'
services:
  nginx-php7:
    image: skiychan/nginx-php7:latest
    ports:
      - "38080:80"
```

### Default
```
docker run -d -p 38080:80 \
skiychan/nginx-php7
```
[http://docker.mmapp.cc:38080](http://docker.mmapp.cc:38080)

------

### Custom website directory
```
docker run -d -p 38081:80 \
-v $(pwd)/wwwroot:/data/wwwroot \
skiychan/nginx-php7
```
[http://docker.mmapp.cc:38081](http://docker.mmapp.cc:38081)

------

### Bind the domain and the ```SSL``` certificate, make it to support ```HTTPS```.
```
docker run -d -p 38082:80 \
-p 38083:443 \
-v $(pwd)/wwwroot:/data/wwwroot \
-v $(pwd)/wwwlogs:/data/wwwlogs \
-v $(pwd)/vhost:/data/server/nginx/vhost \
-v $(pwd)/ssl:/data/server/nginx/ssl \
skiychan/nginx-php7
```       
[http://docker.mmapp.cc:38082](http://docker.mmapp.cc:38082)    
[https://docker.mmapp.cc:38083](https://docker.mmapp.cc:38083)    

------

### Custom extension
```
docker run -d -p 38084:80 \
-v $(pwd)/wwwroot:/data/wwwroot \
-v $(pwd)/wwwlogs:/data/wwwlogs \
-v $(pwd)/ini:/data/server/php/ini \
-v $(pwd)/extension:/data/server/php/extension \
skiychan/nginx-php7
```
1. Create the file ```ext-swoole.ini``` in the ```/$(pwd)/ini/``` directory: ```extension=swoole.so```      
2. Create a file ```extension.sh``` in the ```$(pwd)/extension/``` directory (you cannot change the file name):   
```
curl -Lk https://github.com/swoole/swoole-src/archive/v4.7.0.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.7.0 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```   
[http://docker.mmapp.cc:38084](http://docker.mmapp.cc:38084)