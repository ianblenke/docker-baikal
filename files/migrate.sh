#!/bin/sh -eu

PROJECT_DB_MYSQL_MIGRATIONS_PATH=${PROJECT_DB_MYSQL_MIGRATIONS_PATH:-/db}

MYSQL="mysql
    -u${PROJECT_DB_MYSQL_USERNAME}
    -p${PROJECT_DB_MYSQL_PASSWORD}
    -h${PROJECT_DB_MYSQL_HOST}
    -P${PROJECT_DB_MYSQL_PORT}
    -D${PROJECT_DB_MYSQL_DBNAME}"

MAX_TRIES=${MAX_TRIES:-5}
TRY_WAIT_TIME=${TRY_WAIT_TIME:-4}
TRIES=0

while ! ${MYSQL} -e "select 1;" && [ $TRIES -lt $MAX_TRIES ]; do
  TRIES=$( echo | awk "{ print $TRIES + 1 }" )
  echo Could not talk to mysql. I have tried $TRIES times out of $MAX_TRIES. Sleeping $TRY_WAIT_TIME seconds.
  sleep $TRY_WAIT_TIME
done

for migration in ${PROJECT_DB_MYSQL_MIGRATIONS_PATH}/*.sql ; do
  ${MYSQL} -c <$migration
done
