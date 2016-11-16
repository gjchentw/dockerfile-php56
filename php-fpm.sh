#!/bin/bash

PHP_MAJOR_VERSION=$(php -r 'echo PHP_MAJOR_VERSION;')

for i in ${PHP_EXT_ENABLED}
do
  if [ -f /etc/php${PHP_MAJOR_VERSION}/mods-available/${i}.ini ]; then
  case "$i" in
    opcache)
      ln -s /etc/php${PHP_MAJOR_VERSION}/mods-available/opcache.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/05-opcache.ini
      ;;
    pdo)
      ln -s /etc/php${PHP_MAJOR_VERSION}/mods-available/pdo.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/10-opcache.ini
      ;;
    http)
      ln -s /etc/php${PHP_MAJOR_VERSION}/mods-available/http.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/30-http.ini
      ;;
    *)
      ln -s /etc/php${PHP_MAJOR_VERSION}/mods-available/${i}.ini /etc/php${PHP_MAJOR_VERSION}/conf.d/20-${i}.ini
      ;;
  esac
  fi
done

php -m

php-fpm${PHP_MAJOR_VERSION} -y /etc/php${PHP_MAJOR_VERSION}/php-fpm-www.conf

