FROM alpine:3.2
MAINTAINER Nung Bedell	<nung.bedell@vtcsecure.com>

RUN apk --update add unzip lighttpd php-cgi php-ctype php-dom php-pdo_sqlite php-pdo_mysql php-xml openssl \
    && rm -rf /var/cache/apk/*

ENV VERSION		0.3.5
ENV CHECKSUM	cd69c7ba3488fd23f701d985fe741686

RUN wget -O baikal.zip https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-$VERSION.zip \
    && echo "$CHECKSUM  baikal.zip" && md5sum -c - \
    && unzip baikal.zip -d / \
    && rm baikal.zip \
    && chmod 755 /baikal \
    && chown -R lighttpd:lighttpd /baikal \
    && sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php/php.ini

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY files/ENABLE_INSTALL /baikal/Specific/ENABLE_INSTALL

# Add in the config files
ADD files /baikal/Specific/

RUN mkdir -p /baikal/Specific/db \
    && chmod 755 /baikal/Specific/db

#COPY db/db.sqlite /baikal/Specific/db/db.sqlite


#RUN chown -R lighttpd:lighttpd /baikal

#RUN chown -R lighttpd:lighttpd /baikal \
#    && chmod 755 /baikal/Specific/db/db.sqlite

EXPOSE 80

VOLUME /baikal/Specific

STOPSIGNAL SIGINT

ENV \
        PROJECT_DB_MYSQL_HOST=mysqlhost:3306 \
        PROJECT_DB_MYSQL_DBNAME=cardav \
        PROJECT_DB_MYSQL_USERNAME=root \
        PROJECT_DB_MYSQL_PASSWORD=topsecret

CMD "/start.sh"
