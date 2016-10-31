FROM alpine:3.4
MAINTAINER Rômulo Guimarães <romulo1984@gmail.com>

# Timezone
ENV TIMEZONE America/Sao_Paulo \
    PHP_MEMORY_LIMIT 512M \
    MAX_UPLOAD 50M \
    PHP_MAX_FILE_UPLOAD 200 \
    PHP_MAX_POST 100M

WORKDIR /var/www/html

RUN apk add --update nginx bash curl git gzip tar nodejs wget ca-certificates && \
    apk add tzdata && \
    apk add --update \
    php5-fpm \
    php5-mcrypt \
    php5-mysqli \
    php5-curl \
    php5-gd \
    php5-json \
    php5-gmp \
    php5-sqlite3 \
    php5-xml \
    php5-zlib \
    php5-openssl \
    php5-pdo \
    php5-zip \
    php5-mysql \
    php5-pgsql \
    php5-opcache \
    php5-posix \
    php5-exif \
    php5-ctype \
    php5-dom \
    php5-phar \
    php5-pdo_pgsql \
    php5-pdo_mysql \
    php5-pdo_sqlite && \
    sed -i "s|;date.timezone =.*|date.timezone = ${TIMEZONE}|" /etc/php5/php.ini && \
    sed -i "s|memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|" /etc/php5/php.ini && \
    sed -i "s|upload_max_filesize =.*|upload_max_filesize = ${MAX_UPLOAD}|" /etc/php5/php.ini && \
    sed -i "s|max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|" /etc/php5/php.ini && \
    sed -i "s|post_max_size =.*|max_file_uploads = ${PHP_MAX_POST}|" /etc/php5/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/php.ini && \
    chown -R nobody:nobody . && \
    chown nobody:root -R /var/lib/nginx && \
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    ln -sf /dev/stdout /var/log/fpm-access.log && \
    ln -sf /dev/stderr /var/log/fpm-error.log


COPY files /

EXPOSE 80

CMD php-fpm && nginx -g 'daemon off;'
