# Debian を bookworm に固定する (php:8.3-apache の既定は trixie に移行済み)。
# 派生イメージの apt パッケージ・node のメジャーを変えずに PHP だけ上げるため。
ARG PHP_IMAGE=php:8.3-apache-bookworm
FROM ${PHP_IMAGE}

# timezone environment
ENV TZ=UTC \
    # locale
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    # composer environment
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer

COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

RUN apt-get update && \
    apt-get -y install git libicu-dev libonig-dev libzip-dev unzip locales npm \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8 && \
    localedef -f UTF-8 -i en_US en_US.UTF-8 && \
    mkdir /var/run/php-fpm && \
    docker-php-ext-install -j$(nproc) intl pdo_mysql zip bcmath && \
    docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    composer config -g process-timeout 3600 && \
    composer config -g repos.packagist composer https://packagist.org

# PHP2Shell (CVE-2026-109618/109619) 緩和。conf.d は php.ini より後に読まれるので、
# 派生イメージが自前の php.ini を /usr/local/etc/php/php.ini に置いても上書きされない。
COPY php/zz-php2shell-hardening.ini /usr/local/etc/php/conf.d/zz-php2shell-hardening.ini
