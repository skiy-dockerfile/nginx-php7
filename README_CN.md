# Nginx and PHP7.4 for Docker

[English](./README.md) | 简体中文

# 最新版本
NGINX: **1.21.1**   
PHP:   **7.4.21**


# Docker Hub   
**Nginx-PHP7:** [https://hub.docker.com/r/skiychan/nginx-php7](https://hub.docker.com/r/skiychan/nginx-php7)  

**[文档](https://github.com/skiy/nginx-php7/wiki/Example)** 

# 构建
```sh
git clone https://github.com/skiy/nginx-php7.git
cd nginx-php7
docker build -t nginx-php7 .
```
   
# 安装使用
从 Docker 拉取镜像
```sh
docker pull skiychan/nginx-php7:latest
```

拉取开发版:   
```
docker pull skiychan/nginx-php7:dev
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

**/your_php_extension_ini/ext-xxx.ini** 文件的内容为:   
```
extension=swoole.so
```

**/your_php_extension_file/extension.sh** 文件的内容为:   
```
curl -Lk https://github.com/swoole/swoole-src/archive/v4.4.14.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.4.14 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```

</details>

# License
本项目遵循 [MIT 开源协议](https://github.com/skiy/nginx-php7/blob/master/LICENSE).

# 感谢
<a href="https://www.jetbrains.com/?from=nginx-php7" target="_blank"><img src="https://camo.githubusercontent.com/d4143cfccf26532a30c578a2689bafcc5aa41572/68747470733a2f2f676f6672616d652e6f72672f696d616765732f6a6574627261696e732e706e67" width="100" alt="JetBrains"/></a>
