Nginx and PHP for Docker

## 最新版本
nginx: **1.15.7**   
php:   **7.2.13**

## Docker Hub   
**Nginx-PHP7:** [https://hub.docker.com/r/skiychan/nginx-php7](https://hub.docker.com/r/skiychan/nginx-php7)  

**[Example](https://github.com/skiy-dockerfile/nginx-php7/wiki/Example)** 
   
## 安装使用
从 Docker 拉取镜像
```sh
docker pull skiychan/nginx-php7:latest
```

拉取测试版:   
```
docker pull skiychan/nginx-php7:nightly
```

## 启动
使用镜像启动基础容器
```sh
docker run --name nginx -p 8080:80 -d skiychan/nginx-php7
```
你可以通过浏览器访问```http://\<docker_host\>:8080``` 查看 ```PHP``` 配置信息。

## 添加自定义目录
如果你想自定义网站目录，你可以使用以下方式启动。
```sh
docker run --name nginx -p 8080:80 -v /your_code_directory:/data/www -d skiychan/nginx-php7
```

## 让网站支持 HTTPS
```sh
docker run -d --name=nginx \
-p 80:80 -p 443:443 \
-v your_crt_key_files_folder:/usr/local/nginx/conf/ssl \
-e PROXY_WEB=On \
-e PROXY_CRT=your_crt_name \
-e PROXY_KEY=your_key_name \
-e PROXY_DOMAIN=your_domain \
skiychan/nginx-php7
```

## 添加 PHP 扩展
添加 **ext-xxx.ini** 到目录 ```/your_php_extension_ini``` 和相应的扩展文件代码到 ```/your_php_extension_file``` 中，使用使用以下命令启动。   
```sh
docker run --name nginx \
-p 8080:80 -d \
-v /your_php_extension_ini:/data/phpextini \
-v /your_php_extension_file:/data/phpextfile \
skiychan/nginx-php7
```
```extini/ext-xxx.ini``` 文件中的内容为
```
extension=mongodb.so
```
扩展编译代码基本编写内容如下，详情请查看```extfile/extension.sh```文件：
```
curl -Lk https://pecl.php.net/get/mongodb-1.4.2.tgz | gunzip | tar x -C /home/extension && \
cd /home/extension/mongodb-1.4.2 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```

[English README](README.md)

## [更新日志](changelogs.md) 

## 作者
Author: Skiychan    
Email:  dev@skiy.net       
Link:   https://www.skiy.net
