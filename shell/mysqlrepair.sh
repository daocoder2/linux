#!/bin/sh  
export LANG=zh_CN.UTF-8

# 修改数据库配置 
SERVER_MARK="database"
DB_SOCKET_PATH="/tmp"
DB_ROOT_USER="root"
DB_ROOT_PASS="test"

# 数据库数组 可以加多个数据库  
databases=(${SERVER_MARK}123456)
for database in ${databases[@]}
do
	find /usr/local/mysql/var/$database/ -type f -name '*.TM*' -print0 | xargs -i -0 rm -f {}
	echo /usr/local/mysql/var/$database/
    tables=$(mysql --default-character-set=utf8 --socket=${DB_SOCKET_PATH}/mysql.sock -u${DB_ROOT_USER} -p${DB_ROOT_PASS} ${database} -A -Bse "show tables" )
    for arg in $tables
    do
        check_status=$(mysql --default-character-set=utf8 --socket=${DB_SOCKET_PATH}/mysql.sock -u${DB_ROOT_USER} -p${DB_ROOT_PASS} ${database} -A -Bse  "check table $arg" | awk '{ print $4 }' )
    if [ "$check_status" = "OK" ]
    then
        echo "$arg is ok"  
    else  
        echo $(mysql --default-character-set=utf8 --socket=${DB_SOCKET_PATH}/mysql.sock -u${DB_ROOT_USER} -p${DB_ROOT_PASS} ${database} -A -Bse "repair table $arg") >> /mysqlrepair
    fi      
        echo $(mysql --default-character-set=utf8 --socket=${DB_SOCKET_PATH}/mysql.sock -u${DB_ROOT_USER} -p${DB_ROOT_PASS} ${database} -A -Bse "optimize table $arg")  
    done    
done       
  
echo "all down!"
