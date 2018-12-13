FROM gerault/docker-php5-fpm:latest 
MAINTAINER Mathieu GERAULT <mathieu.gerault@gmail.com>
LABEL Description="MyTinyTodo PHP from Mathieu GERAULT"

# change ownership to www-data
RUN chown www-data:www-data /var/www/html

# change user from root to www-data
USER www-data

# go to the web directory, download and unzip mytinytodo app
RUN cd /var/www/html \
	&& wget -O mytinytodo.zip https://bitbucket.org/maxpozdeev/mytinytodo/downloads/mytinytodo-v1.4.3.zip  \
	&& unzip mytinytodo.zip \
	&& rm mytinytodo.zip

# volume
VOLUME /var/www/html/mytinytodo
