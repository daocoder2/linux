#!/bin/bash

currpath=$(cd $(dirname "$0"); pwd)
websites=("192.168.8.12:2000")                                 # 要监控的网站
adminmail=''                                   # 管理员电邮
expire=3600                                                    # 每次发送电邮的间隔秒数
now=$(date +%s)

function getWebRemark() {
    local remark
    if [ -f "$1" ] && [ -s "$1" ]; then # 是否是文件且非空
        remark=$(cat $1)
        if [ $(( $now - $remark )) -gt "$expire" ]; then 
            rm -f $1
            remark=""
        fi
    else
        remark=""
    fi
    echo ${remark}
}

# 循环判断每个site
for site in ${websites[*]}; do
    # 可以设置连接时间和最大超时时间，请求失败会返回000
    httpcode=$(curl -o /dev/null -s --connect-timeout 30 -m 50 -w %{http_code} "http://${site}/tongji/logdir")
    echo "$(date '+%Y-%m-%d %H:%M') ${site}'s httpcode:$httpcode"
    
    # 记录时否发送过通知电邮，如发送过则半小>时内不再发送
    simpleweb=$(echo $site | awk -F '.' '{print $4}')
    webtime="${currpath}/${simpleweb}-mailtime.txt"
    weblog="${currpath}/${simpleweb}-web-log.txt"
    webhttplog="${currpath}/${simpleweb}-web-http-log.txt"
    remark=$(getWebRemark ${webtime})
    
    webname=$(cat ${currpath}/web-list.txt | grep "${site} ")
    if [ "$remark" = "" ]; then
        if [ "$httpcode" != "200" ]; then
            if [ "$httpcode" -eq "000" ]; then
                # 发送电邮且记录发送时间
                echo "$(date +%Y-%m-%d' '%H:%M) ${webname} can not access." | mailx -s 'server-warning' ${adminmail}
                echo "$(date +%s)" > "${webtime}"
            else
                echo "`date +"%Y-%m-%d %H:%M"` ${webname} can access, but the httpcode is $httpcode " >> "${webhttplog}"
            fi
        else
            web_load_time=$(curl -o /dev/null -s -w "time_connect: %{time_connect}\ntime_starttransfer: %{time_starttransfer}\ntime_total: %{time_total}" "http://${site}/tongji/logdir")
            time_total=${web_load_time##*:}
            time_int=$(echo ${time_total} | awk -F '.' '{print $1}')
            # 访问总时间较慢、日志记录（30s为标准）
            if [ ${time_int} -gt 30 ]; then
                echo "`date +"%Y-%m-%d %H:%M"` ${webname} access use time ${time_total} " >> "${weblog}"
            else
                echo -e "access ${webname} use time just $time_int seconds \n"
            fi
        fi
    fi
done
exit 0
