#!/bin/sh
#########################################################################
# START
# File Name: start.sh
# Author: Skiychan
# Email:  dev@skiy.net
# Version:
# Created Time: 2015/12/13
#########################################################################

# Add PHP Extension
if [ -f "/data/phpextfile/extension.sh" ]; then
    #Add support
    yum install -y gcc \
        gcc-c++ \
        autoconf \
        automake \
        libtool \
        make \
        cmake && \

        mkdir -p /home/extension && \

    sh /data/phpextfile/extension.sh

    mv -rf /data/phpextfile/extension.sh /data/phpextfile/extension_back.sh

    #Clean OS
    yum remove -y gcc \
        gcc-c++ \
        autoconf \
        automake \
        libtool \
        make \
        cmake && \
        yum clean all && \
        rm -rf /tmp/* /var/cache/{yum,ldconfig} /etc/my.cnf{,.d} && \
        mkdir -p --mode=0755 /var/cache/{yum,ldconfig} && \
        find /var/log -type f -delete && \
        rm -rf /home/extension/*
fi

Nginx_Install_Dir=/usr/local/nginx
DATA_DIR=/data/www

set -e
chown -R www.www $DATA_DIR

if [[ -n "$PROXY_WEB" ]]; then

    [ -f "${Nginx_Install_Dir}/conf/vhost" ] || mkdir -p $Nginx_Install_Dir/conf/vhost

    if [ -z "$PROXY_DOMAIN" ]; then
            echo >&2 'error:  missing PROXY_DOMAIN'
            echo >&2 '  Did you forget to add -e PROXY_DOMAIN=... ?'
            exit 1
    fi

    cat > ${Nginx_Install_Dir}/conf/vhost/website.conf << EOF
server {
    listen 80;
    server_name $PROXY_DOMAIN;

    root   $DATA_DIR;
    index  index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        root           /data/www;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        include        fastcgi.conf;

        set \$real_script_name \$fastcgi_script_name;
        if (\$fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
                set $real_script_name $1;
                set $path_info $2;
        }
        fastcgi_param SCRIPT_FILENAME \$document_root\$real_script_name;
        fastcgi_param SCRIPT_NAME \$real_script_name;
        fastcgi_param PATH_INFO \$path_info;       
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$ {
        expires 30d;
        access_log off;
    }

    location ~ .*\.(js|css)?$ {
        expires 7d;
        access_log off;
    }

    location ~ /\.(ht|git|vscode|idea) {
        deny all;
    }
}
EOF

    # USAGE HTTPS
    if [[ "$WEB_HTTPS" == "ON" ]]; then

        [ -f "${Nginx_Install_Dir}/conf/ssl" ] || mkdir -p $Nginx_Install_Dir/conf/ssl

        if [ -z "$PROXY_CRT" ]; then
            echo >&2 'error:  missing PROXY_CRT'
            echo >&2 '  Did you forget to add -e PROXY_CRT=... ?'
            exit 1
        fi

        if [ -z "$PROXY_KEY" ]; then
                echo >&2 'error:  missing PROXY_KEY'
                echo >&2 '  Did you forget to add -e PROXY_KEY=... ?'
                exit 1
        fi

        if [ ! -f "${Nginx_Install_Dir}/conf/ssl/${PROXY_CRT}" ]; then
                echo >&2 'error:  missing PROXY_CRT'
                echo >&2 "  You need to put ${PROXY_CRT} in ssl directory"
                exit 1
        fi

        if [ ! -f "${Nginx_Install_Dir}/conf/ssl/${PROXY_KEY}" ]; then
                echo >&2 'error:  missing PROXY_CSR'
                echo >&2 "  You need to put ${PROXY_KEY} in ssl directory"
                exit 1
        fi

        cat > ${Nginx_Install_Dir}/conf/vhost/website.conf << EOF
server {
    listen 80;
    server_name $PROXY_DOMAIN;
    return 301 https://$PROXY_DOMAIN\$request_uri;
    }

server {
    listen 443 ssl;
    server_name $PROXY_DOMAIN;

    ssl on;
    ssl_certificate ssl/${PROXY_CRT};
    ssl_certificate_key ssl/${PROXY_KEY};
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    keepalive_timeout 70;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    root   $DATA_DIR;
    index  index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        root           /data/www;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        include        fastcgi.conf;

        set \$real_script_name \$fastcgi_script_name;
        if (\$fastcgi_script_name ~ "^(.+?\.php)(/.+)$") {
                set $real_script_name $1;
                set $path_info $2;
        }
        fastcgi_param SCRIPT_FILENAME \$document_root\$real_script_name;
        fastcgi_param SCRIPT_NAME \$real_script_name;
        fastcgi_param PATH_INFO \$path_info;        
    }

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|flv|ico)$ {
        expires 30d;
        access_log off;
    }

    location ~ .*\.(js|css)?$ {
        expires 7d;
        access_log off;
    }

    location ~ /\.(ht|git|vscode|idea) {
        deny all;
    }
}
EOF
    fi
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
