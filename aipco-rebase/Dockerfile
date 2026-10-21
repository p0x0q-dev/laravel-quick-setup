# aipco-next-container の緊急リベース用 (PHP2Shell 対応)。
#
# ソース (aipco/aipco-next-container) は aipco org にあり、こちらからは push しない。
# そのため、稼働中のアプリイメージから aipco の Dockerfile が足した成果物だけを取り出し、
# 新しいベースイメージに載せ直す。vendor / ビルド済みアセットは同じ PHP 8.3 系で動く。
# 恒久対応は aipco 側でベースを更新して再ビルドすること。
ARG BASE_IMAGE=p0x0q/laravel-quick-setup:php8.3-apache
ARG SOURCE_IMAGE
FROM ${SOURCE_IMAGE} AS source

FROM ${BASE_IMAGE}

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# aipco の Dockerfile と同じく gmp を入れる
RUN apt-get update -yqq && \
    apt-get install -y libgmp-dev && \
    docker-php-ext-install -j$(nproc) gmp && \
    rm -rf /var/lib/apt/lists/*

COPY --from=source /usr/local/etc/php/php.ini /usr/local/etc/php/php.ini
COPY --from=source /etc/apache2/conf-enabled/apache.conf /etc/apache2/conf-enabled/apache.conf
COPY --from=source /docker-entrypoint.sh /docker-entrypoint.sh
COPY --from=source /var/www/html /var/www/html

WORKDIR /var/www/html
ENTRYPOINT ["/docker-entrypoint.sh"]
