FROM debian:bullseye

RUN apt-get update && apt-get -y install --no-install-recommends \
    mariadb-server \
    dumb-init

RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

COPY ./tools/script.sh /tmp/script.sh

RUN  chmod +x /tmp/script.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf 

EXPOSE 3306

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["bash", "/tmp/script.sh"]