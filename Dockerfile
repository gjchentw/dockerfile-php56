FROM gjchen/alpine:latest
MAINTAINER gjchen <gjchen.tw@gmail.com>

ENV	PHP_ERROR_LOG=syslog
ENV	PHP_LOG_ERRORS=1
ENV	PHP_DISPLAY_ERRORS=1
ENV	PHP_ERROR_REPORTING=-1
ENV	PHP_TIMEZONE="Asia/Taipei"
ENV	PHP_OPEN_SHORT_TAG=0
ENV	PHP_MAX_EXECUTION_TIME=30
ENV	PHP_MAX_INPUT_TIME=60
ENV	PHP_MEMORY_LIMIT=128M
ENV	PHP_CLI_MEMORY_LIMIT=512M
ENV	PHP_POST_MAX_SIZE=8M
ENV	PHP_UPLOAD_MAX_FILESIZE=2M
ENV	PHP_SESSION_NAME=PHPSESSID
ENV	PHP_SESSION_SAVE_HANDLER=files
ENV	PHP_SESSION_SAVE_PATH=/tmp
ENV	PHP_XDEBUG_HOST="172.17.0.1"

ENV	PHPFPM_LISTEN=127.0.0.1:9000
ENV	PHPFPM_USER=nobody
ENV	PHPFPM_GROUP=nobody
ENV	PHPFPM_PM=ondemand
ENV	PHPFPM_PM_MAX_CHILDREN=32
ENV	PHPFPM_PM_START_SERVERS=4
ENV	PHPFPM_PM_MIN_SPARE_SERVERS=2
ENV	PHPFPM_PM_MAX_SPARE_SERVERS=6
ENV	PHPFPM_PM_MAX_REQUESTS=16

RUN 	echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
	apk --no-cache --no-progress upgrade -f && \
	apk --no-cache --no-progress add nginx postfix geoip imagemagick libmemcached-libs \
	php5 php5-fpm php5-pear \
	php5-bcmath \
	php5-bz2 \
	php5-calendar \
	php5-cgi \
	php5-cli \
	php5-common \
	php5-ctype \
	php5-curl \
	php5-dba \
	php5-dbg \
	php5-doc \
	php5-dom \
	php5-embed \
	php5-enchant \
	php5-exif \
	php5-ftp \
	php5-gd \
	php5-gettext \
	php5-gmp \
	php5-iconv \
	php5-imap \
	php5-intl \
	php5-json \
	php5-ldap \
	php5-mcrypt \
	php5-mssql \
	php5-mysql \
	php5-mysqli \
	php5-odbc \
	php5-opcache \
	php5-openssl \
	php5-pcntl \
	php5-pdo \
	php5-pdo_dblib \
	php5-pdo_mysql \
	php5-pdo_odbc \
	php5-pdo_pgsql \
	php5-pdo_sqlite \
	php5-pgsql \
	php5-phar \
	php5-phpdbg \
	php5-posix \
	php5-pspell \
	php5-shmop \
	php5-snmp \
	php5-soap \
	php5-sockets \
	php5-sqlite3 \
	php5-sysvmsg \
	php5-sysvsem \
	php5-sysvshm \
	php5-wddx \
	php5-xml \
	php5-xmlreader \
	php5-xmlrpc \
	php5-xsl \
	php5-zip \
	php5-zlib \
	php5-memcache

# cli ready for pecl tool
ADD	php-cli.ini /etc/php5/php-cli.ini

RUN	mv /etc/php5/conf.d /etc/php5/mods-available && \
	mkdir -p /etc/php5/conf.d && \
	ln -s /etc/php5/mods-available/xml.ini /etc/php5/conf.d/10-xml.ini && \
	apk --no-cache --no-progress add --virtual pecl-build-tools \
	php5-dev autoconf build-base \
	geoip-dev \
	zlib-dev \
	imagemagick-dev \
	libtool \
	openssl-dev \
	libmemcached-dev \
	cyrus-sasl-dev \
	&& \
	pear config-set php_ini /etc/php5/mods-available/apcu.ini && \
	touch /etc/php5/mods-available/apcu.ini && \
	pear install http://pecl.php.net/get/apcu-4.0.11.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/apfd.ini && \
	touch /etc/php5/mods-available/apfd.ini && \
	pear install http://pecl.php.net/get/apfd-1.0.1.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/geoip.ini && \
	touch /etc/php5/mods-available/geoip.ini && \
	pear install http://pecl.php.net/get/geoip-1.1.1.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/raphf.ini && \
	touch /etc/php5/mods-available/raphf.ini && \
	pear install http://pecl.php.net/get/raphf-1.1.2.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/propro.ini && \
	touch /etc/php5/mods-available/propro.ini && \
	pear install http://pecl.php.net/get/propro-1.0.2.tar \
	&& \
	ln -s /etc/php5/mods-available/raphf.ini /etc/php5/conf.d/10-raphf.ini && \
	ln -s /etc/php5/mods-available/propro.ini /etc/php5/conf.d/10-propro.ini \
	&& \
	pear config-set php_ini /etc/php5/mods-available/http.ini && \
	touch /etc/php5/mods-available/http.ini && \
	pear install http://pecl.php.net/get/pecl_http-2.6.0RC1.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/igbinary.ini && \
	touch /etc/php5/mods-available/igbinary.ini && \
	pear install http://pecl.php.net/get/igbinary-1.2.1.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/imagick.ini && \
	touch /etc/php5/mods-available/imagick.ini && \
	pear install http://pecl.php.net/get/imagick-3.4.3RC1.tar \
	&& \
#	pear config-set php_ini /etc/php5/mods-available/memcache.ini && \
#	touch /etc/php5/mods-available/memcache.ini && \
#	pear install http://pecl.php.net/get/memcache-3.0.8.tar \
#	&& \
	pear config-set php_ini /etc/php5/mods-available/memcached.ini && \
	touch /etc/php5/mods-available/memcached.ini && \
	pear install http://pecl.php.net/get/memcached-2.2.0.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/mongo.ini && \
	touch /etc/php5/mods-available/mongo.ini && \
	pear install http://pecl.php.net/get/mongodb-1.1.9.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/msgpack.ini && \
	touch /etc/php5/mods-available/msgpack.ini && \
	pear install http://pecl.php.net/get/msgpack-0.5.7.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/OAuth.ini && \
	touch /etc/php5/mods-available/OAuth.ini && \
	pear install http://pecl.php.net/get/oauth-1.2.3.tar \
	&& \
	pear config-set php_ini /etc/php5/mods-available/xdebug.ini && \
	touch /etc/php5/mods-available/xdebug.ini && \
	pear install http://pecl.php.net/get/xdebug-2.5.0RC1.tar \
	&& \
	rm -rf /tmp/pear && \
	rm -f /etc/php5/conf.d/* && \	
	apk --no-progress del pecl-build-tools

RUN	echo xdebug.profiler_enable = On >> /etc/php5/mods-available/xdebug.ini && \
	echo xdebug.remote_enable = On >> /etc/php5/mods-available/xdebug.ini && \
	echo xdebug.remote_port = 9000 >> /etc/php5/mods-available/xdebug.ini && \
	echo xdebug.remote_handler = "dbgp" >> /etc/php5/mods-available/xdebug.ini

ENV	PHP_EXT_ENABLED="oauth apcu apfd bcmath bz2 calendar ctype curl dba dom enchant exif ftp gd geoip gettext gmp http iconv igbinary imagick imap intl ldap mcrypt memcache memcached mongodb msgpack mssql mysql mysqli odbc opcache openssl pcntl pdo pdo_dblib pdo_mysql pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix propro pspell raphf shmop snmp sqlite3 sysvmsg sysvsem sysvshm xdebug xml wddx xmlreader xmlrpc xsl zip zlib"

ADD	nginx_default_server.conf /etc/nginx/conf.d/default.conf
ADD	php-fpm-www.conf /etc/php5/
ADD	php-fpm.sh /usr/local/bin
ADD	index.php /app/index.php
RUN	echo 'pid /var/run/nginx.pid;' > /etc/nginx/modules/pid.conf && \
	chmod a+x /usr/local/bin/php-fpm.sh


VOLUME	["/app"]

CMD	rsyslogd; crond -b; php-fpm.sh; nginx -g "daemon off;";
