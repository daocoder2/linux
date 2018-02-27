#! /bin/bash

ip_array=("192.168.8.118")

user="root"
port="22"
remote_sh="sh /home/web/lftshell/svncommit.sh"
password="test"
 
for ip in ${ip_array[@]} 
do 
    /usr/bin/expect << EOF
    spawn ssh -t -p $port $user@$ip
    expect {
        "*yes/no" { send "yes\r"; exp_continue }
	"*password:" { send "$password\r" }
    }
    expect  "*#" { send "$remote_sh\r" }
    expect eof
EOF
done  

echo 'all city svn has been updated.'
