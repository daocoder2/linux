#!/bin/bash

# pgrep -x mysqld &> /dev/null
/usr/bin/mysql -uroot -test --connect_timeout=5 -e "show databases;" &>/dev/null 2>&1
if [ $? -ne 0 ]
then
        echo "At time `date` : MySQL server is down ." >> /home/wwwroot/lftcj/log/caiji/mysqlmonitor
	killall mysqld
        . /shell/mysqlfile.sh
	find /usr/local/mysql/var/ -type f -name '*.TMD' -print0 | xargs -i -0 rm -f {}
        service mysql start
        service nginx start
        service php-fpm start
        . /shell/mysqlrepair.sh
        echo "mysql has been repaired ."
else
        echo "MySQL server is running ."
fi

