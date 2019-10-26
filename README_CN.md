# Nginx and PHP7.3 for Docker

[English](./README.md) | 简体中文

# 最新版本
NGINX: **1.17.5**   
PHP:   **7.3.11**

> **PHP 7.2.** 请访问 [v2](https://github.com/skiy/nginx-php7/tree/v2) 分支。

# Docker Hub   
**Nginx-PHP7:** [https://hub.docker.com/r/skiychan/nginx-php7](https://hub.docker.com/r/skiychan/nginx-php7)  

**[Example](https://github.com/skiy/nginx-php7/wiki/Example)** 

# 构建
```sh
git pull origin https://github.com/skiy/nginx-php7.git
cd nginx-php7
docker build -t nginx-php7 .
```
   
# 安装使用
从 Docker 拉取镜像
```sh
docker pull skiychan/nginx-php7:latest
```

拉取测试版:   
```
docker pull skiychan/nginx-php7:nightly
```

# 启动
使用镜像启动基础容器
```sh
docker run --name nginx -p 8080:80 -d skiychan/nginx-php7
```
你可以通过浏览器访问```http://\<docker_host\>:8080``` 查看 ```PHP``` 配置信息。

# 添加自定义目录
如果你想自定义网站目录，你可以使用以下方式启动。
```sh
docker run --name nginx -p 8080:80 -v /your_code_directory:/data/www -d skiychan/nginx-php7
```

<details>
    <summary><mark>更多</mark></summary>

```
docker run --name nginx -p 8080:80 \
-v /your_code_directory:/data/wwwroot \
-v /your_nginx_log_path:/data/wwwlogs \
-v /your_nginx_conf_path:/data/server/nginx \
-v /your_php_extension_ini:/data/server/php/ini \
-v /your_php_extension_file:/data/server/php/extension \
-d skiychan/nginx-php7
```

# 添加 PHP 扩展
添加 **ext-xxx.ini** 到目录 ```/your_php_extension_ini``` 和相应的扩展文件代码到 ```/your_php_extension_file``` 中，使用使用以下命令启动。   
```sh
docker run --name nginx \
-p 8080:80 -d \
-v /your_php_extension_ini:/data/server/php/ini \
-v /your_php_extension_file:/data/server/php/extension \
skiychan/nginx-php7
```
```/your_php_extension_ini/ext-xxx.ini``` 文件中的内容为
```
extension=mongodb.so
```
扩展编译代码基本编写内容如下，详情请查看```/your_php_extension_file/extension.sh```文件：
```
curl -Lk https://pecl.php.net/get/mongodb-1.4.2.tgz | gunzip | tar x -C /home/extension && \
cd /home/extension/mongodb-1.4.2 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```
</details>

# 作者
Author: Skiychan    
Email:  dev@skiy.net       
Link:   https://www.skiy.net

# 感谢
<a href="https://www.jetbrains.com/?from=nginx-php7" target="_blank"><img src="https://camo.githubusercontent.com/d4143cfccf26532a30c578a2689bafcc5aa41572/68747470733a2f2f676f6672616d652e6f72672f696d616765732f6a6574627261696e732e706e67" width="100" alt="JetBrains"/></a>