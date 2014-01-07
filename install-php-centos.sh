#!/bin/bash

PHP_VERSION="5.5.7"

yum -y install \
    curl-devel.x86_64 \
    libmcrypt-devel.x86_64 \
    libxml2-devel.x86_64 \
    libtool-ltdl-devel.x86_64 \
    pcre-devel.x86_64 \
    zlib-devel.x86_64

wget -c http://www.php.net/get/php-${PHP_VERSION}.tar.gz/from/this/mirror
#wget -c http://xxx/php.ini
#wget -c http://xxx/php-fpm.conf

tar zxvf php-${PHP_VERSION}.tar.gz

cd php-${PHP_VERSION}

PHP_PREFIX=/usr/local/php-${PHP_VERSION}

./configure \
    --prefix=${PHP_PREFIX} \
    --with-config-file-path=${PHP_PREFIX}/etc \
    --disable-debug \
    --enable-inline-optimization \
    --disable-all \
    --enable-fpm \
    --enable-libxml \
    --enable-session \
    --enable-xml \
    --enable-hash \
    --enable-mbstring \
    --with-layout=GNU \
    --enable-filter \
    --with-pcre-regex \
    --with-zlib \
    --enable-json \
    --enable-mysqlnd \
    --enable-pdo \
    --with-mysql=mysqlnd \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-simplexml \
    --enable-dom \
    --enable-phar \
    --enable-tokenizer \
    --enable-posix \
    --enable-xmlwriter \
    --enable-xmlreader \
    --with-curl \
    --with-iconv \
    --with-mcrypt \
    --enable-ctype \
    --enable-opcache


make
make install

/bin/cp -f php.ini-production ${PHP_PREFIX}/etc/php.ini
/bin/cp -f sapi/fpm/php-fpm.conf ${PHP_PREFIX}/etc/php-fpm.conf
/bin/cp -f sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm-${PHP_VERSION}

chmod +x /etc/init.d/php-fpm-${PHP_VERSION}

cd ..

if [ -e ./php.ini ]; then
    /bin/cp -f ./php.ini ${PHP_PREFIX}/etc/php.ini
fi

if [ -e ./php-fpm.conf ]; then
    /bin/cp -f ./php-fpm.conf ${PHP_PREFIX}/etc/php-fpm.conf
fi

/bin/rm -rf ./php-${PHP_VERSION}

mkdir ${PHP_PREFIX}/log
chown -R nobody:root ${PHP_PREFIX}/log

########################
# Install libmemcached #
########################

wget -c --no-check-certificate https://launchpad.net/libmemcached/1.0/1.0.4/+download/libmemcached-1.0.4.tar.gz

tar zxvf libmemcached-1.0.4.tar.gz
cd libmemcached-1.0.4
./configure --prefix=/usr/local/libmemcached-1.0.4
make
make install
cd ..
rm -rf ./libmemcached-1.0.4

#########################
# Install php memcached #
#########################

wget -c http://pecl.php.net/get/memcached-2.1.0.tgz

tar zxvf memcached-2.1.0.tgz
cd memcached-2.1.0
${PHP_PREFIX}/bin/phpize
./configure --with-php-config=${PHP_PREFIX}/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached-1.0.4
make
make install
cd ..
rm -rf ./memcached-2.1.0

#####################
# Install php redis #
#####################

wget -c --no-check-certificate -O phpredis-2.2.3.tar.gz https://github.com/nicolasff/phpredis/archive/2.2.3.tar.gz
tar zxvf phpredis-2.2.3.tar.gz
cd phpredis-2.2.3
${PHP_PREFIX}/bin/phpize
./configure --with-php-config=${PHP_PREFIX}/bin/php-config
make
make install
cd ..
rm -rf ./phpredis-2.2.3
