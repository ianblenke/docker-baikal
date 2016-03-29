#!/bin/bash -e

envsubst </config.system.php.template >/config.system.php
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf

