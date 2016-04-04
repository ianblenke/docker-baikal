#!/bin/sh -e

BAIKAL_DIR=${BAIKAL_DIR:-/baikal/Specific}

if [ ! -z "$ENABLE_SQLLITE" ] ; then
    cp /db $BAIKAL_DIR
    chown lighttpd:lighttpd ${BAIKAL_DIR}/db/db.sqlite
    chmod 755 ${BAIKAL_DIR}/db/db.sqlite
fi

PATCH="patch -N -p0"
for p in /*.patch ; do
  if ${PATCH} --dry-run < $p ; then
    ${PATCH} < $p
  fi
done
envsubst <${BAIKAL_DIR}/config.system.php.template >${BAIKAL_DIR}/config.system.php
lighttpd -D -f /etc/lighttpd/lighttpd.conf &
exec tail -f /var/log/lighttpd/*

