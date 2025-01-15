FROM	debian:bullseye

RUN apt-get update && apt-get -y install --no-install-recommends \
    nginx \
    openssl

RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/damin.crt \
       -keyout /etc/nginx/ssl/damin.key \
       -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Gun/CN=localhost"

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN mkdir -p /run/nginx

EXPOSE	443

CMD ["nginx", "-g", "daemon off;"]