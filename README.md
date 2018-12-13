# docker-mytinytodo-php5-fpm
This docker image comes from my custom php5-fpm image.

It embedds the mytinytodo program (http://www.mytinytodo.net/)

The locales and timezone are french.

This php image should be used with a web server container and a database container (for example, mysql).

## docker-compose
You will find below an example of my docker-compose file.
I use a nginx web server and a mysql instance.
As the configuration of the databse is stored in the php files, I use a volume to make the persistence.
I use a second volume to persist the database

```
version: '2'
services:
        nginx:
                image: akkro/nginx:latest
                container_name: mytinytodo_nginx_prod
                restart: always
                ports:
                        - "8081:80"
                volumes:
                        - ./conf_files/site.conf:/etc/nginx/conf.d/site.conf:ro
                volumes_from:
                        - php
                links:
                        - php

        php:
                image: gerault/docker-mytinytodo-php5-fpm:latest
                container_name: mytinytodo_php_prod
                restart: always
                volumes:
                        - myphpdata:/var/www/html/mytinytodo
                links:
                        - mysql-db

        mysql-db:
                image: mysql:5.7
                container_name: mytinytodo_mysql_prod
                restart: always
                volumes:
                        - mysqldata:/var/lib/mysql
                environment:
                        - MYSQL_ROOT_PASSWORD=root
                        - MYSQL_DATABASE=mytinytodo
                        - MYSQL_USER=mytinytodouser
                        - MYSQL_PASSWORD=mytinytodopwd


# docker volumes to store data
volumes:
        myphpdata:
        mysqldata:
```

Here is the content of the nginx conf file (**conf_files/site.conf**)
```
server {
    listen 80;
    server_name todo.akkro-libre.org;

    index index.php index.html;
    root /var/www/html/mytinytodo;

    location ~ \.php$ {
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass php:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}

```
