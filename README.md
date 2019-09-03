
English | [简体中文](./README_CN.md)

### 正常启动，使用默认的 ```index.php``` 文件
```
docker run -d -p 38080:80 \
skiychan/nginx-php7
```
http://docker.mmapp.cc:38080

------

### 使用指定的目录作为网站访问目录
```
docker run -d -p 38081:80 \
-v $(pwd)/wwwroot:/data/wwwroot \
skiychan/nginx-php7
```
http://docker.mmapp.cc:38081

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
http://docker.mmapp.cc:38082    
https://docker.mmapp.cc:38083    

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
1. 在 ```/data/server/php/ini/``` 下创建文件 ```ext-swoole.ini``` ，内容为 ```extension=swoole.so```;   
2. 在 ```/data/server/php/extension/``` 下创建文件 ```extension.sh```(不能更改文件名)，内容如下：   
```
curl -Lk https://github.com/swoole/swoole-src/archive/v4.4.4.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.4.4 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```
http://docker.mmapp.cc:38084