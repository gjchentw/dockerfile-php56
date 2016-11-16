#!/bin/bash

PHP_MAJOR_VERSION=$(php -r 'echo PHP_MAJOR_VERSION;')
INI_DIR="/etc/php${PHP_MAJOR_VERSION}/mods-available"
CONF_DIR="/etc/php${PHP_MAJOR_VERSION}/conf.d"

for i in ${PHP_EXT_ENABLED}
do
  INI_FILE=$(grep -il [\=\"\']${i}.so ${INI_DIR}/* | xargs basename)
  
  if [ -f ${INI_DIR}/${INI_FILE} ]; then
  case "$i" in
    opcache)
      ln -s ${INI_DIR}/${INI_FILE} ${CONF_DIR}/05-${INI_FILE}
      ;;
    pdo)
      ln -s ${INI_DIR}/${INI_FILE} ${CONF_DIR}/10-${INI_FILE}
      ;;
    http)
      ln -s ${INI_DIR}/${INI_FILE} ${CONF_DIR}/30-${INI_FILE}
      ;;
    *)
      ln -s ${INI_DIR}/${INI_FILE} ${CONF_DIR}/20-${INI_FILE}
      ;;
  esac
  fi
done

php -m

php-fpm${PHP_MAJOR_VERSION} -y /etc/php${PHP_MAJOR_VERSION}/php-fpm-www.conf

