FROM php:8.1-apache

ENV APP_HOME /var/www/html

RUN apt-get update && apt-get install -y \
    default-mysql-client \
    git \
    zip \
    unzip \
    libicu-dev \
    zlib1g-dev \
    libxml2-dev \
    software-properties-common \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3 \
    && docker-php-ext-enable xmlrpc \
    && docker-php-ext-install \
    intl \
    pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && usermod -u 1000 www-data && groupmod -g 1000 www-data \
    && sed -i -e "s/html/html\/webroot/g" /etc/apache2/sites-enabled/000-default.conf \
    && a2enmod rewrite \
    && export DEBIAN_FRONTEND=noninteractive \
    && ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && apt-get install -y tzdata \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && curl -sL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install nodejs
