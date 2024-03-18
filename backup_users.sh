#!/bin/bash

OUTPUT_FILE=/mysql_backup/backup_users.sql
MYSQL_USER=batch
MYSQL_PASS=BATCH

echo "-- USERS" > ${OUTPUT_FILE}
mysql -u${MYSQL_USER} -p${MYSQL_PASS} --silent --skip-column-names --execute "SELECT CONCAT('CREATE USER \'',User,'\'@\'',Host,'\' IDENTIFIED BY \'',authentication_string,'\' ;') FROM mysql.user WHERE User NOT LIKE 'mysql.%'" | sort >> ${OUTPUT_FILE}

echo -e "\n-- GRANTS" >> ${OUTPUT_FILE}
mysql -u${MYSQL_USER} -p${MYSQL_PASS} --silent --skip-column-names --execute "select concat('\'',User,'\'@\'',Host,'\'') as User from mysql.user WHERE User NOT LIKE 'mysql.%'" | sort | while read u; do echo "-- $u"; mysql -u${MYSQL_USER} -p${MYSQL_PASS} --silent --skip-column-names --execute "show grants for $u" | sed 's/$/ ;/' ; done >> ${OUTPUT_FILE}

chmod 660 ${OUTPUT_FILE}
