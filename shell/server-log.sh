#!/bin/bash
# 监控硬件运行状况

# *** config start ***
# 当前目录路径
currpath=$(cd $(dirname "$0"); pwd)
# 当前服务器名、按实际改变
serverhost=$(ifconfig | grep "inet 192" | awk '{ print $2 }')
# log 文件路径
server_log="${currpath}/server-monitor-log.txt"
# 通知电邮列表
adminemail='327216245@qq.com'
# 发通知电邮间隔时间
now=$(date +%s)
# *** config end ***

# *** function start ***

# 获取CPU占用
function getCpu(){
    cpufree=$(vmstat 1 5 | sed -n '/3,$/p' | awk '{x = x + $15} END {print x/5}' | awk -F. '{print $1}')
    cpuused=$((100 - $cpufree))
    echo "${cpuused}"
}

# 获取内存使用情况
function getMem(){
    #               total        used        free      shared  buff/cache   available
    # Mem:           5807        5077         125          26         605         325
    # Swap:          3967        3667         300
    mem=$(free -m | sed -n '3,3p')
    used=$(echo $mem | awk -F ' ' '{print $3}')
    free=$(echo $mem | awk -F ' ' '{print $4}')
    total=$(($used + $free))
    limit=$(($total/10))
    echo "${total} ${used} ${free}"
}

# 获取load average
function getLoad() {
    #  09:37:32 up 1 day, 19:27,  3 users,  load average: 0.96, 0.94, 2.99
    load=$(uptime | awk -F 'load average: ' '{print $2}')
    m1=$(echo $load | awk -F ', ' '{print $1}')
    m5=$(echo $load | awk -F ', ' '{print $2}')
    m15=$(echo $load | awk -F ', ' '{print $3}')
    echo "${m1} ${m5} ${m15}"
}


cpuinfo=$(getCpu)
meminfo=$(getMem)
loadinfo=$(getLoad)

echo "`date +"%Y-%m-%d %H:%M"` cpu(cpuused): $cpuinfo ; swapmem(total used free): $meminfo ; load average(1 3 15): $loadinfo " >> "${server_log}"


exit 0
