# Nginx and PHP7.4 for Docker

English | [简体中文](./README_CN.md)

# Last Version
NGINX: **1.20.0**   
PHP:   **7.4.18**

# Docker Hub   
**Nginx-PHP7:** [https://hub.docker.com/r/skiychan/nginx-php7](https://hub.docker.com/r/skiychan/nginx-php7)   

**[Documents](https://github.com/skiy/nginx-php7/wiki/Example)**

# Build
```sh
git clone https://github.com/skiy/nginx-php7.git
cd nginx-php7
docker build -t nginx-php7 .
```
   
# Installation
Pull the image from the docker index rather than downloading the git repo. This prevents you having to build the image on every docker host.

```sh   
docker pull skiychan/nginx-php7:latest
```

To pull the develop Version:   
```
docker pull skiychan/nginx-php7:dev
```

# Running
To simply run the container:

```sh
docker run --name nginx -p 8080:80 -d skiychan/nginx-php7
```
You can then browse to ```http://\<docker_host\>:8080``` to view the default install files.

# Volumes
If you want to link to your web site directory on the docker host to the container run:

```sh
docker run --name nginx -p 8080:80 -v /your_code_directory:/data/wwwroot -d skiychan/nginx-php7
```

<details>
    <summary><mark>More</mark></summary>

```
docker run --name nginx -p 8080:80 \
-v /your_code_directory:/data/wwwroot \
-v /your_nginx_log_path:/data/wwwlogs \
-v /your_nginx_conf_path:/data/server/nginx \
-v /your_php_extension_ini:/data/server/php/ini \
-v /your_php_extension_file:/data/server/php/extension \
-d skiychan/nginx-php7
```

# Enabling Extensions With Source
Add **ext-xxx.ini** to folder ```/your_php_extension_ini```, source ```/your_php_extension_file```. then run the command:   
```sh
docker run --name nginx \
-p 8080:80 -d \
-v /your_php_extension_ini:/data/server/php/ini \
-v /your_php_extension_file:/data/server/php/extension \
skiychan/nginx-php7
```

**/your_php_extension_ini/ext-xxx.ini** file content:   
```
extension=mongodb.so
```

**/your_php_extension_file/extension.sh** file content:   
```
curl -Lk https://github.com/swoole/swoole-src/archive/v4.4.14.tar.gz | gunzip | tar x -C /home/extension && \
cd /home/extension/swoole-src-4.4.14 && \
/usr/local/php/bin/phpize && \
./configure --with-php-config=/usr/local/php/bin/php-config && \
make && make install
```

</details>

# License
This project is licensed under the [MIT license](https://github.com/skiy/nginx-php7/blob/master/LICENSE).   

# Thanks
<a href="https://www.jetbrains.com/?from=nginx-php7" target="_blank"><img src="https://camo.githubusercontent.com/d4143cfccf26532a30c578a2689bafcc5aa41572/68747470733a2f2f676f6672616d652e6f72672f696d616765732f6a6574627261696e732e706e67" width="100" alt="JetBrains"/></a>
