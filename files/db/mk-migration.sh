#!/bin/bash -e

prefix=$(date +%m%d%Y%H%M%s)
if ls *.sql 2>/dev/null >/dev/null ; then
    for sql in *.sql; do
        if [[ "$sql" =~ "-" ]] ; then
    	echo skipping $sql
        else
            mv {,$prefix-}$sql
        fi
    done
fi
