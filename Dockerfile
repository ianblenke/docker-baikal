FROM alpine:3.2
MAINTAINER Nung Bedell	<nung.bedell@vtcsecure.com>

RUN apk --update add gettext unzip lighttpd php-cgi php-ctype php-dom \
                     php-pdo_sqlite php-pdo_mysql php-xml openssl \
    && rm -rf /var/cache/apk/*

ENV VERSION		0.3.5
ENV CHECKSUM	cd69c7ba3488fd23f701d985fe741686

RUN wget -O baikal.zip https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-$VERSION.zip \
    && echo "$CHECKSUM  baikal.zip" && md5sum -c - \
    && unzip baikal.zip -d / \
    && rm baikal.zip \
    && sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/php.ini

COPY files /

RUN mkdir -p /var/log/lighttpd \
    && mkdir -p /baikal/Specific/db \
    && chmod -R 755 /baikal \
    && touch /var/log/lighttpd/error.log /var/log/lighttpd/access.log /var/run/lighttpd.pid \
    && chown -R lighttpd:lighttpd /baikal /var/log/lighttpd /var/run/lighttpd.pid


EXPOSE 8080

STOPSIGNAL SIGKILL

ENV \
        PROJECT_DB_MYSQL_HOST=mysqlhost:3306 \
        PROJECT_DB_MYSQL_DBNAME=sabredav \
        PROJECT_DB_MYSQL_USERNAME=root \
        PROJECT_DB_MYSQL_PASSWORD=topsecret

USER lighttpd
CMD "/start.sh"
