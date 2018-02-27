# linux常用快捷键

# 1、系统常用命令

df	-h 查看服务器全部的分区挂载情况
 
	[root@localhost ~]# df -h
	文件系统                 容量  已用  可用 已用% 挂载点
	/dev/mapper/centos-root   18G   12G  5.7G   68% /
	devtmpfs                 905M     0  905M    0% /dev
	tmpfs                    914M   92K  914M    1% /dev/shm
	tmpfs                    914M   17M  897M    2% /run
	tmpfs                    914M     0  914M    0% /sys/fs/cgroup
	/dev/sdb1                4.8G  315M  4.3G    7% /daocoder
	/dev/sda1                497M  120M  377M   25% /boot
	/dev/loop0               3.9G  3.9G     0  100% /mnt/centos7

mount 查看文件系统

	[root@localhost ~]# mount
	proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
	sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime,seclabel)
	tmpfs on /run type tmpfs (rw,nosuid,nodev,seclabel,mode=755)
	tmpfs on /sys/fs/cgroup type tmpfs (rw,nosuid,nodev,noexec,seclabel,mode=755)
	/dev/sdb1 on /daocoder type ext4 (rw,relatime,seclabel,data=ordered)
	/dev/sda1 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,noquota)
	fusectl on /sys/fs/fuse/connections type fusectl (rw,relatime)
	/opt/CentOS-7.0-1406-x86_64-DVD.iso on /mnt/centos7 type iso9660 (ro,relatime)

du -sh /daocoder		查看文件占用磁盘大小

	[root@localhost ~]# du -sh /daocoder
	295M	/daocoder
	[root@localhost daocoder]# du -sh *
	0	ad.txt
	4.0K	ip.txt
	0	log
	4.0K	lost+found
	113M	nmap-7.30
	8.6M	nmap-7.30.tar.bz2
	19M	php-7.0.11.tar.gz
	139M	Python-2.7.12
	17M	Python-2.7.12.tgz
	16K	test
	0	test.txt

du -h --max-depth=1 /daocoder		针对性查看某文件夹的被使用情况

	[root@localhost daocoder]# du -h --max-depth=1 /daocoder
	139M	/daocoder/Python-2.7.12
	4.0K	/daocoder/lost+found
	113M	/daocoder/nmap-7.30
	16K	/daocoder/test
	295M	/daocoder
	[root@localhost daocoder]# du -h --max-depth=1 /daocoder/Python-2.7.12
	17M	/daocoder/Python-2.7.12/Modules
	9.5M	/daocoder/Python-2.7.12/Objects
	552K	/daocoder/Python-2.7.12/PCbuild
	160K	/daocoder/Python-2.7.12/RISCOS
	2.2M	/daocoder/Python-2.7.12/Tools
	1.7M	/daocoder/Python-2.7.12/Demo
	12K	/daocoder/Python-2.7.12/Grammar
	8.4M	/daocoder/Python-2.7.12/Doc
	4.9M	/daocoder/Python-2.7.12/Mac
	34M	/daocoder/Python-2.7.12/Lib
	26M	/daocoder/Python-2.7.12/build
	2.6M	/daocoder/Python-2.7.12/PC
	640K	/daocoder/Python-2.7.12/Include
	7.0M	/daocoder/Python-2.7.12/Python
	1.5M	/daocoder/Python-2.7.12/Misc
	1.1M	/daocoder/Python-2.7.12/Parser
	139M	/daocoder/Python-2.7.12

w -f		查看系统负载和登录终端		系统已启动工作时间

	[root@localhost daocoder]# w -f
	 19:35:35 up 1 day,  7:31,  3 users,  load average: 0.00, 0.01, 0.05
	USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
	root     tty2                      1210月16  2days  0.15s  0.15s -bash
	root     pts/0    192.168.1.111    19:14    7.00s  0.31s  0.01s w -f
	root     tty1                      一17   21:27   0.29s  0.29s -bash

date 		查看系统时间

	[root@localhost daocoder]# date
	2016年 10月 19日 星期三 19:44:06 CST

date -s	19：44：15		设置系统时间

clock					硬件时间

	[root@localhost daocoder]# clock
	2016年10月19日 星期三 19时46分36秒  -0.558003 秒

hwclock	-w				同步系统与硬件时间

file 					查看文件类型

	[root@localhost daocoder]# file ip.txt 
	ip.txt: ASCII text

stat					查看文件状态

	[root@localhost daocoder]# stat ip.txt 
	  文件："ip.txt"
	  大小：130       	块：8          IO 块：4096   普通文件
	设备：811h/2065d	Inode：11          硬链接：1
	权限：(0644/-rw-r--r--)  Uid：(    0/    root)   Gid：(    0/    root)
	环境：unconfined_u:object_r:file_t:s0
	最近访问：2016-10-19 19:48:47.480862077 +0800
	最近更改：2016-09-21 09:00:39.000000000 +0800
	最近改动：2016-10-17 09:12:25.844444019 +0800
	创建时间：-


free -m					查看系统内存使用情况

	[root@localhost daocoder]# free -m
	             total       used       free     shared    buffers     cached
	Mem:          1826       1240        586         16          5        825
	-/+ buffers/cache:        409       1417
	Swap:         2047          0       2047


cat /proc/cpuinfo		查看cpu使用情况

	[root@localhost daocoder]# cat /proc/cpuinfo 
	processor	: 0							这个随处理器数目可增加
	vendor_id	: GenuineIntel
	cpu family	: 6
	model		: 94
	model name	: Intel(R) Core(TM) i5-6300HQ CPU @ 2.30GHz
	stepping	: 3
	microcode	: 0x76
	cpu MHz		: 2304.002
	cache size	: 6144 KB
	physical id	: 0
	siblings	: 4
	core id		: 0
	cpu cores	: 4
	apicid		: 0
	initial apicid	: 0
	fpu		: yes
	fpu_exception	: yes
	cpuid level	: 22
	wp		: yes
	flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology tsc_reliable nonstop_tsc aperfmperf eagerfpu pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch ida arat epb xsaveopt pln pts dtherm fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 invpcid rtm rdseed adx smap
	bogomips	: 4608.00
	clflush size	: 64
	cache_alignment	: 64
	address sizes	: 42 bits physical, 48 bits virtual
	power management:

cat /proc/meminfo		查看内存硬件信息

	[root@localhost daocoder]# cat /proc/meminfo 
	MemTotal:        1870784 kB
	MemFree:          600732 kB
	MemAvailable:    1400048 kB
	Buffers:            5664 kB
	Cached:           862372 kB
	SwapCached:           88 kB
	Active:           197980 kB
	Inactive:         779076 kB
	Active(anon):      44476 kB
	Inactive(anon):    81864 kB
	Active(file):     153504 kB
	Inactive(file):   697212 kB
	Unevictable:           0 kB
	Mlocked:               0 kB
	SwapTotal:       2097148 kB
	SwapFree:        2097060 kB
	Dirty:                 0 kB
	Writeback:             0 kB
	AnonPages:        108960 kB
	Mapped:            29504 kB
	Shmem:             17320 kB
	Slab:             176108 kB
	SReclaimable:     117536 kB
	SUnreclaim:        58572 kB
	KernelStack:        4360 kB
	PageTables:         6616 kB
	NFS_Unstable:          0 kB
	Bounce:                0 kB
	WritebackTmp:          0 kB
	CommitLimit:     3032540 kB
	Committed_AS:     489876 kB
	VmallocTotal:   34359738367 kB
	VmallocUsed:      202008 kB
	VmallocChunk:   34359508476 kB
	HardwareCorrupted:     0 kB
	AnonHugePages:     20480 kB
	HugePages_Total:       0
	HugePages_Free:        0
	HugePages_Rsvd:        0
	HugePages_Surp:        0
	Hugepagesize:       2048 kB
	DirectMap4k:      112512 kB
	DirectMap2M:     1984512 kB
	DirectMap1G:           0 kB

uname -r 			查看内核版本

	[root@localhost daocoder]# uname -r
	3.10.0-123.el7.x86_64

Kernel：3指主版本号；10指次版本号（偶数为稳定版、奇数为开发版）；123指这个kernel错误修订次数、共发布了123次。

cat	/etc/issue		查看系统版本

	[root@localhost daocoder]# cat /etc/issue
	CENTOS release 7.0
	Kernel \r on an \m

rpm -qa | grep release 	查看安装的rpm包并查看系统版本

	[root@localhost daocoder]# rpm -qa | grep release 
	centos-release-7-0.1406.el7.centos.2.3.x86_64

last			查看系统登录情况

	[root@localhost daocoder]# last
	root     pts/0        192.168.1.111    Wed Oct 19 19:14   still logged in   
	root     pts/1        192.168.0.25     Wed Oct 19 10:24 - 17:16  (06:51)    
	root     pts/0        192.168.0.25     Wed Oct 19 09:24 - 17:16  (07:52)    
	root     pts/0        192.168.1.111    Tue Oct 18 19:29 - 22:15  (02:45)    
	root     tty1                          Mon Oct 17 17:21   still logged in     
	godao    :0           :0               Wed Sep 21 08:51 - 09:43 (9+00:51)   
	(unknown :0           :0               Wed Sep 21 08:51 - 08:51  (00:00)    
	reboot   system boot  3.10.0-123.el7.x Wed Sep 21 08:50 - 09:43 (9+00:52)     
	root     pts/1        192.168.0.42     Wed Sep  7 10:37 - 10:59  (00:22)    
	root     pts/0        192.168.0.42     Wed Sep  7 08:48 - 17:46  (08:58)    
	root     pts/0        192.168.1.105    Tue Sep  6 21:18 - 22:40  (01:21)    
	root     tty2                          Tue Sep  6 20:58 - down  (1+12:04)   
	daocoder :0           :0               Tue Sep  6 20:57 - 09:02 (1+12:05)   
	(unknown :0           :0               Tue Sep  6 20:56 - 20:57  (00:00)    
	reboot   system boot  3.10.0-123.el7.x Wed Sep  7 04:54 - 09:03 (1+04:08)   
	
	wtmp begins Wed Sep  7 04:54:57 2016

lastlog				各用户最后一次登录时间

	[root@localhost daocoder]# lastlog
	用户名           端口     来自             最后登陆时间
	root             pts/0    192.168.1.111    三 10月 19 19:14:30 +0800 2016
	gdm              :0                        三 10月 12 12:33:03 +0800 2016
	daocoder         pts/2                     日 10月  9 14:59:20 +0800 2016
	godao            :0                        三 10月 12 12:34:10 +0800 2016
	mudai                                      **从未登录过**
	dos                                        **从未登录过**

三种日志：

tail /var/log/messages			系统日志

tail /var/log/maillog			邮件日志

tail /var/log/secure			安全日志

可直接查找关键字：

grep ‘Failed passwd’ /var/log/secure

wall			系统广播

	[root@localhost daocoder]# 
	Broadcast message from root@localhost.localdomain (pts/0) (Wed Oct 19 20:25:57 2016):
	
	test

write			指定用户及终端发送命令		（聊天专用）

	[root@localhost daocoder]# w
	 20:27:03 up 1 day,  8:22,  3 users,  load average: 0.00, 0.01, 0.05
	USER     TTY        LOGIN@   IDLE   JCPU   PCPU WHAT
	root     tty2      1210月16  2days  0.15s  0.15s -bash
	root     pts/0     19:14    7.00s  0.75s  0.02s w
	root     tty1      一17    1:12m  0.29s  0.29s -bash
	[root@localhost daocoder]# tty
	/dev/pts/0
	[root@localhost daocoder]# write root /dev/tty2 
	hi this is a test

	[root@localhost ~]# echo 'ni hao ' > /dev/pts/0			在另一终端界面输出

alias			别名		可自行设置

	[root@localhost ~]# alias
	alias cp='cp -i'
	alias egrep='egrep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias grep='grep --color=auto'
	alias l.='ls -d .* --color=auto'
	alias ll='ls -l --color=auto'
	alias ls='ls --color=auto'
	alias mv='mv -i'
	alias perlll='eval `perl -Mlocal::lib`'
	alias rm='rm -i'
	alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'

	[root@localhost /]# alias network='cd /etc/sysconfig/network-scripts/'
	[root@localhost /]# network
	[root@localhost network-scripts]# cd /

	[root@localhost /]# unalias network 
	[root@localhost /]# network
	bash: network: 未找到命令...

type 			查看命令		别名>内置>外部命令

	[root@localhost /]# type cd
	cd 是 shell 内嵌
	[root@localhost /]# type ls
	ls 是 `ls --color=auto' 的别名
	[root@localhost /]# type vim
	vim 是 /usr/bin/vim

	[root@localhost /]# alias cd='ls -l'
	[root@localhost /]# cd
	总用量 104
	lrwxrwxrwx.   1 root root     7 9月   7 04:33 bin -> usr/bin
	dr-xr-xr-x.   5 root root  4096 9月   8 09:04 boot
	drwxr-xr-x.   6 root root  4096 10月 19 11:30 daocoder
	drwxr-xr-x.  21 root root  3460 10月 19 19:13 dev
	drwxr-xr-x. 147 root root  8192 10月 17 17:19 etc
	drwxr-xr-x.   6 root root    55 9月   8 09:50 home
	lrwxrwxrwx.   1 root root     7 9月   7 04:33 lib -> usr/lib
	lrwxrwxrwx.   1 root root     9 9月   7 04:33 lib64 -> usr/lib64
	drwxr-xr-x.   2 root root     6 6月  10 2014 media
	drwxr-xr-x.   3 root root    20 10月  9 20:15 mnt
	drwxr-xr-x.   3 root root    52 10月 17 17:05 opt
	-rw-r--r--.   1 root root 57189 9月   7 04:37 parser.out
	-rw-r--r--.   1 root root 10617 9月   7 04:37 parsetab.py
	dr-xr-xr-x. 403 root root     0 10月 12 12:32 proc
	dr-xr-x---.   6 root root  4096 10月 17 17:19 root
	drwxr-xr-x.  40 root root  1260 10月 17 11:36 run
	lrwxrwxrwx.   1 root root     8 9月   7 04:33 sbin -> usr/sbin
	drwxr-xr-x.   2 root root     6 6月  10 2014 srv
	dr-xr-xr-x.  13 root root     0 10月 12 12:32 sys
	drwxrwxrwt.  22 root root  4096 10月 19 21:04 tmp
	drwxr-xr-x.  13 root root  4096 9月   7 04:33 usr
	drwxr-xr-x.  23 root root  4096 10月 12 12:32 var
	[root@localhost /]# unalias cd 
	[root@localhost /]# cd 
	[root@localhost ~]# 

history				查看历史命令

	[root@localhost ~]# history 
	 1019  vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 
	 1020  history 
	[root@localhost ~]# !1019
	vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 

按下[ctrl+r]:输入最近的命令，自动补全。

	[root@localhost ~]# vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 
	(reverse-i-search)`vim': vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 

！vim 		取你上次最后执行的命令

	[root@localhost ~]# !vim			
	vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 

!$			取你上次最后执行的命令的最后一段

	[root@localhost ~]# vim /etc/sysconfig/network-scripts/ifcfg-eno16777736 
	[root@localhost ~]# cat !$
	cat /etc/sysconfig/network-scripts/ifcfg-eno16777736
	HWADDR=00:0C:29:74:16:BD
	TYPE=Ethernet
	BOOTPROTO=dhcp
	DEFROUTE=yes
	PEERDNS=yes
	PEERROUTES=yes
	IPV4_FAILURE_FATAL=no
	IPV6INIT=yes
	IPV6_AUTOCONF=yes
	IPV6_DEFROUTE=yes
	IPV6_PEERDNS=yes
	IPV6_PEERROUTES=yes
	IPV6_FAILURE_FATAL=no
	NAME=eno16777736
	UUID=1b7d1529-d9af-4cee-acea-9560241b3e74
	ONBOOT=no

按下[ctrl+a]:可将光标移动到命令最前面。

按下[ctrl+e]:可将光标移动到命令最尾部。

按下[ctrl+u]:删除命令全部的内容。

按下[ctrl+k]:删除光标之后全部的内容。

按下[ctrl+l]:删除屏幕全部内容。

echo $?				查看上个命令是否成功		0真，其它为假

	[root@localhost ~]# cd /daocoder/
	[root@localhost daocoder]# echo $?
	0
	[root@localhost daocoder]# e
	bash: e: 未找到命令...
	[root@localhost daocoder]# echo $?
	127


# 2、系统变量相关

	[root@localhost daocoder]# echo $PATH			查看环境变量
	/usr/lib64/qt-3.3/bin:/root/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
	[root@localhost daocoder]# echo $PWD			当前路径		
	/daocoder
	[root@localhost daocoder]# pwd
	/daocoder
	[root@localhost daocoder]# echo $LANG			使用语言
	zh_CN.UTF-8
	[root@localhost daocoder]# echo $lang			区分大小写
	
	[root@localhost daocoder]# export LANG=en-US.UTF-8		修改语言
	[root@localhost daocoder]# echo $LANG
	en-US.UTF-8
	[root@localhost daocoder]# echo $HOME			家目录
	/root

	[root@localhost ~]# echo $PS1
	[\u@\h \W]\$

	[root@localhost ~]# export PS1='[\u@\h \t \W]\$'		注意这里前面没有‘$’
	[root@localhost 21:43:05 ~]#

以上全部都是在当前内存中生效，不是永久保存。

修改自己的环境变量。

[root@localhost ~]#vim /root/.bashrc 
[root@localhost ~]#cat !$
cat /root/.bashrc
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
export PS1='[\u@\h \W \t ]\$'
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi






































