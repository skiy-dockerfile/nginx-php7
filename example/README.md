## Example
```sh
cd example && \
docker run -p 8080:80 \
-p 8443:443 \
-v $(pwd)/wwwroot:/data/wwwroot \
-v $(pwd)/wwwlogs:/data/wwwlogs \
-v $(pwd)/vhost:/data/server/nginx/vhost \
-v $(pwd)/ssl:/data/server/nginx/ssl \
-v $(pwd)/ini:/data/server/php/ini \
-v $(pwd)/extension:/data/server/php/extension \
-d skiychan/nginx-php7
```

### WEB
- **HTTP**: http://127.0.0.1:8080   
- **HTTPS**: https://127.0.0.1:8443

If you modify the hosts, you can open the website with the domain.
- https://docker.mmapp.cc:8443
```sh
echo '0.0.0.0 docker.mmapp.cc' >> /etc/hosts
```