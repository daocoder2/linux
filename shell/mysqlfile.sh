#!/bin/bash

pidfile="/usr/local/mysql/var/localhost.localdomain.pid" 
if [ ! -f "$pidfile" ]; then
	killall mysqld
	service nginx stop 
	service php-fpm stop
	touch "$pidfile"
	echo 3906 > "$pidfile"
	chown -R mysql:mysql /usr/local/mysql/var
	chmod -R 755 /usr/local/mysql/var
	echo "pid file is not exist;"
else
	echo "pid file is exist;"
fi
