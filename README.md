### 正常启动，使用默认的 ```index.php``` 文件
```sh
docker run --name nginx -p 38080:80 -d skiychan/nginx-php7
```
http://docker.mmapp.cc:38080

------

### 使用指定的目录作为网站访问目录
```sh
docker run --name nginx1 -p 38081:80 -v /data/docker/www:/data/www -d skiychan/nginx-php7
```
http://docker.mmapp.cc:38081

------

### 绑定域名
```sh
docker run --name nginx2 -p 38082:80 -e PROXY_WEB=ON -e PROXY_DOMAIN=38082.docker.mmapp.cc -d skiychan/nginx-php7
```
http://38082.docker.mmapp.cc:38082   
http://docker.mmapp.cc:38082

------

### 使用 ```SSL``` 证书，让网站支持 ```HTTPS```
```sh
docker run -d --name=nginx443 -p 443:443 -v /data/docker/www:/data/www -v /data/docker/ssl:/usr/local/nginx/conf/ssl -e PROXY_WEB=ON -e WEB_HTTPS=ON -e PROXY_CRT=docker.mmapp.cc.fullchain.cer -e PROXY_KEY=docker.mmapp.cc.key -e PROXY_DOMAIN=443.docker.mmapp.cc skiychan/nginx-php7
```
将证书复制到 ```/data/ssl```目录下。   
使用宿主的 ```443```端口暴露则:         
https://443.docker.mmapp.cc

------

如果不使用 ```443```暴露端口，比如：   
```sh
docker run -d --name=nginx3 -p 38083:443 -v /data/docker/www:/data/www -v /data/docker/ssl:/usr/local/nginx/conf/ssl -e PROXY_WEB=ON -e WEB_HTTPS=ON -e PROXY_CRT=docker.mmapp.cc.fullchain.cer -e PROXY_KEY=docker.mmapp.cc.key -e PROXY_DOMAIN=38083.docker.mmapp.cc skiychan/nginx-php7
```
那么访问 ```https```时，必须添加端口如：      
https://38083.docker.mmapp.cc:38083   
http://docker.mmapp.cc:38083    

#### 环境变量说明
- PROXY_WEB: 启用域名和配置文件
- WEB_HTTPS: ON (启用HTTPS)
- PROXY_CRT: SSL证书公钥
- PROXY_KEY: SSL证书私钥
- PROXY_DOMAIN: 域名   

------

### 自定义扩展
```
docker run --name nginx4 -p 38084:80 -d -v /data/docker/www:/data/www -v /data/docker/extini:/data/phpextini -v /data/docker/extshell:/data/phpextfile skiychan/nginx-php7
```
1. 在 ```/data/docker/extini/``` 下创建文件 ```ext-swoole.ini``` ，内容为 ```extension=swoole.so```;   
2. 在 ```/data/docker/extshell/``` 下创建文件 ```extension.sh```(不能更改文件名)，内容如下：   
```sh
curl -Lk https://github.com/swoole/swoole-src/archive/v4.4.4.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.4.4 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```
http://docker.mmapp.cc:38084
