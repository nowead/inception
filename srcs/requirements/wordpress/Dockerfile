FROM debian:bullseye

RUN apt-get update && apt-get -y install --no-install-recommends \
    lsb-release \
    apt-transport-https \
    ca-certificates \
		wget \
    curl \
    gnupg && \
    curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/php-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(. /etc/os-release && echo $VERSION_CODENAME) main" | tee /etc/apt/sources.list.d/php.list && \
    apt-get update && apt-get -y install \
    php8.2 \
    php8.2-mysql \
    php8.2-fpm \
    php8.2-gd \
    php8.2-cli \
    php8.2-mbstring &&\
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY ./tools/init_wordpress.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_wordpress.sh

ENTRYPOINT ["/usr/local/bin/init_wordpress.sh"]

WORKDIR /var/www/html/

EXPOSE 9000
