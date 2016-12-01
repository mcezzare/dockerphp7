#
# Debian with apache and PHP7
# 
#
FROM debian:stable

MAINTAINER Mario Cezzare Angelicola Chiodi <mcezzare@gmail.com>

#1: Initial setup: get apache 2
RUN apt-get update && apt-get install -y apache2-bin apache2.2-common --no-install-recommends 

#2: add dotdeb packages
RUN apt-get update \
  && echo 'deb http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && echo 'deb-src http://packages.dotdeb.org jessie all' >> /etc/apt/sources.list \
  && apt-get install -y wget \
  && wget https://www.dotdeb.org/dotdeb.gpg \
  && apt-key add dotdeb.gpg \
  && apt-get update 

#3: php7 packages, separated command to preserve layers already cached 
RUN apt-get install -y php7.0-mysql php7.0-mcrypt php7.0-json php7.0-curl \
php7.0-cli php7.0-gd php7.0-imagick php7.0-xdebug libapache2-mod-php7.0

#EXTRA STUFF, if need redis,memcached, etc
RUN apt-get install -y php7.0-redis

#For php tools
RUN apt-get install zip unzip git curl -yqq
RUN curl --silent --show-error https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
#End php tools

#4: some apache env vars
ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

#5: Load apache vars
RUN set -ex \
&& sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS" \
    \
# setup directories and permissions
    && . "$APACHE_ENVVARS" \
    && for dir in \
        "$APACHE_LOCK_DIR" \
        "$APACHE_RUN_DIR" \
        "$APACHE_LOG_DIR" \
        /var/www/html \
    ; do \
        rm -rvf "$dir" \
        && mkdir -p "$dir" \
        && chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
    done

#6: Optimization Apache + PHP requires preforking Apache for best results
RUN a2dismod mpm_event && a2enmod mpm_prefork

#7: Logs should go to stdout / stderr
RUN set -ex \
    && . "$APACHE_ENVVARS" \
    && ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

#8: PHP files should be handled by PHP, and should be preferred over any other file type
RUN { \
        echo '<FilesMatch \.php$>'; \
        echo '\tSetHandler application/x-httpd-php'; \
        echo '</FilesMatch>'; \
        echo; \
        echo 'DirectoryIndex disabled'; \
        echo 'DirectoryIndex index.php index.html'; \
        echo; \
        echo '<Directory /var/www/>'; \
        echo '\tOptions -Indexes'; \
        echo '\tAllowOverride All'; \
        echo '</Directory>'; \
    } | tee "$APACHE_CONFDIR/conf-available/docker-php.conf" \
    && a2enconf docker-php

#9: setup vhost for development
ADD 000-default.conf /etc/apache2/sites-available/

#10: Setup Home Dir if log on container 
WORKDIR /var/www/html

#11: turn on rewrite, used on common dispatchers
RUN a2enmod rewrite

#12: prepare the bootstrap do execute apache in foreground
RUN mkdir /bootstrap
ADD start.sh /bootstrap/start.sh
RUN chmod 755 /bootstrap/start.sh

#13: remove the apt lists to reduce image size
RUN rm -rf /var/lib/apt/lists/*

#14: Expose port
EXPOSE 80

#15: Read apache env vars and load apache2 in foreground
ENTRYPOINT ["/bootstrap/start.sh"]