
这个例子基于源码:   
[https://github.com/skiy/nginx-php7/tree/main/example](https://github.com/skiy/nginx-php7/tree/main/example)
   
[English](./README.md) | 简体中文

### docker-compose
```yaml
version: '3'
services:
  nginx-php7:
    image: skiychan/nginx-php7:latest
    ports:
      - "38080:80"
```

### 默认
```
docker run -d -p 38080:80 \
skiychan/nginx-php7
```
[http://docker.mmapp.cc:38080](http://docker.mmapp.cc:38080)

------

### 自定义网站目录
```
docker run -d -p 38081:80 \
-v $(pwd)/wwwroot:/data/wwwroot \
skiychan/nginx-php7
```
[http://docker.mmapp.cc:38081](http://docker.mmapp.cc:38081)

------

### 绑定域名 和 使用 ```SSL``` 证书，让网站支持 ```HTTPS```
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

### 自定义扩展
```
docker run -d -p 38084:80 \
-v $(pwd)/wwwroot:/data/wwwroot \
-v $(pwd)/wwwlogs:/data/wwwlogs \
-v $(pwd)/ini:/data/server/php/ini \
-v $(pwd)/extension:/data/server/php/extension \
skiychan/nginx-php7
```
1. 在 ```$(pwd)/ini/``` 目录下创建文件 ```ext-swoole.ini``` ，内容为 ```extension=swoole.so```;   
2. 在 ```$(pwd)/extension/``` 目录下创建文件 ```extension.sh```(不可更改文件名)，内容如下：   
```
curl -Lk https://github.com/swoole/swoole-src/archive/v4.7.0.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.7.0 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```   
[http://docker.mmapp.cc:38084](http://docker.mmapp.cc:38084)