FROM php:8.2-fpm

# 1. Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    vim \
    nano \
    libxslt-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath intl xsl

# 2. Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 2.5 Instalar Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# 3. Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# 4. Configuración opcional de usuario no root
ARG USER_ID
ARG GROUP_ID

RUN groupadd -g ${GROUP_ID} laravel && \
    useradd -u ${USER_ID} -g laravel -m laravel

WORKDIR /var/www
USER laravel

COPY ./docker/php/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

