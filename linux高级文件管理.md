<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# 高级文件管理

# 1、标准输入、输出

	[root@localhost ~]# ls -l /dev/stdin
	lrwxrwxrwx. 1 root root 15 9月  19 08:00 /dev/stdin -> /proc/self/fd/0
	[root@localhost ~]# ls -l /dev/stdout
	lrwxrwxrwx. 1 root root 15 9月  19 08:00 /dev/stdout -> /proc/self/fd/1
	[root@localhost ~]# ls -l /dev/stderr 
	lrwxrwxrwx. 1 root root 15 9月  19 08:00 /dev/stderr -> /proc/self/fd/2

![daocoder](http://i.imgur.com/cI4dO8l.png)

## 1.1 标准输入输出的几种方式

	[root@localhost daocoder]# ls
	passwd  test  www													这里test是个目录
	[root@localhost daocoder]# ls -al la -l test 1>1.log 2>2.log		正确输出到1.log，错误输出到2.log
	[root@localhost daocoder]# ls										上面产生了2个日志文件
	1.log  2.log  passwd  test  www
	[root@localhost daocoder]# cat 1.log								看下1.log的内容，正确的内容输出 
	test:
	总用量 4
	drwxr-xr-x. 4 root root 55 9月   8 20:56 .
	drwxrwsr-x. 3 root root 82 9月  19 17:06 ..
	drwxr-xr-x. 3 root root 14 9月   8 17:49 aaa
	drwxr-xr-x. 2 root root  6 9月   8 17:48 bbb
	-rw-r--r--. 1 root root 27 9月   8 10:57 dao.txt
	-rw-rwxrwx. 1 root root  0 9月   8 20:56 godao.sh
	[root@localhost daocoder]# cat 2.log 							看下1.log的内容，错误的内容输出
	ls: 无法访问la: 没有那个文件或目录

先删除过渡下，再看另种方法输出。

	[root@localhost daocoder]# rm -f *.log
	[root@localhost daocoder]# ls
	passwd  test  www

这种方法比较常用。

	[root@localhost daocoder]# ls -al la -l test >1.log 2>&1		正确输出到1.log，错误也输出到1.log
	[root@localhost daocoder]# ls
	1.log  passwd  test  www
	[root@localhost daocoder]# cat 1.log 							看下1.log文件
	ls: 无法访问la: 没有那个文件或目录
	test:
	总用量 4
	drwxr-xr-x. 4 root root 55 9月   8 20:56 .
	drwxrwsr-x. 3 root root 70 9月  19 17:13 ..
	drwxr-xr-x. 3 root root 14 9月   8 17:49 aaa
	drwxr-xr-x. 2 root root  6 9月   8 17:48 bbb
	-rw-r--r--. 1 root root 27 9月   8 10:57 dao.txt
	-rw-rwxrwx. 1 root root  0 9月   8 20:56 godao.sh

再删除下，看下第三种方法输出。

	[root@localhost daocoder]# ls -al la -l test &>1.log		这里注意下&和>要连结在一起，分开有错误
	[root@localhost daocoder]# cat 1.log 
	ls: 无法访问la: 没有那个文件或目录
	test:
	总用量 4
	drwxr-xr-x. 4 root root 55 9月   8 20:56 .
	drwxrwsr-x. 3 root root 70 9月  19 17:22 ..
	drwxr-xr-x. 3 root root 14 9月   8 17:49 aaa
	drwxr-xr-x. 2 root root  6 9月   8 17:48 bbb
	-rw-r--r--. 1 root root 27 9月   8 10:57 dao.txt
	-rw-rwxrwx. 1 root root  0 9月   8 20:56 godao.sh

## 1.2 输出重定向及追加

	[root@localhost daocoder]# echo "hello world" > a.log			输出重定向到a.log
	[root@localhost daocoder]# cat a.log 							查看下a.log
	hello world
	[root@localhost daocoder]# echo "this is a test" > a.log		输出重定向到a.log
	[root@localhost daocoder]# cat a.log 							查看下a.log，这里之前内容会被覆盖
	this is a test

	[root@localhost daocoder]# echo "this is another test" >> a.log	这里是追加，不会覆盖之前内容，双大于号
	[root@localhost daocoder]# cat a.log 							查看下，两条语句
	this is a test
	this is another test

## 1.3 系统黑洞

	[root@localhost daocoder]# ls -lsh /dev/null 				这里面 1， 3不知道啥意思
	0 crw-rw-rw-. 1 root root 1, 3 9月  19 08:00 /dev/null

	[root@localhost daocoder]# du -sh /dev/null 
	0	/dev/null

这个东西类似windows的回收站。

## 1.4 零发射器（待补充，磁盘管理）
dd 的主要选项：

if=file：输入文件名，缺省为标准输入。

of=file：输出文件名，缺省为标准输出。

ibs=bytes：一次读入 bytes 个字节(即一个块大小为 bytes 个字节)。

obs=bytes：一次写 bytes 个字节(即一个块大小为 bytes 个字节)。

bs=bytes：同时设置读写块的大小为 bytes ，可代替 ibs 和 obs 。

count=blocks：仅拷贝 blocks 个块，块大小等于 ibs 指定的字节数。

	[root@localhost daocoder]# dd if=/dev/zero of=test.txt bs=1M count=1
	记录了1+0 的读入
	记录了1+0 的写出
	1048576字节(1.0 MB)已复制，0.0100743 秒，104 MB/秒

	[root@localhost daocoder]# ls -lh test.txt 
	-rw-r--r--. 1 root root 1.0M 9月  19 21:34 test.txt

# 2、文件的基本处理

## 2.1 wc命令：统计

	[root@localhost daocoder]# wc passwd 
	  42   81 2217 passwd
	[root@localhost daocoder]# wc -l passwd 			line：行数
	42 passwd
	[root@localhost daocoder]# wc -w passwd 			word：单词数
	81 passwd
	[root@localhost daocoder]# wc -c passwd 			char：字符数
	2217 passwd

## 2.2 grep：过滤器

	[root@localhost daocoder]# grep 'root' passwd 		直接包含root关键字的过滤
	root:x:0:0:root:\root:\bin\bash
	operator:x:11:0:operator:\root:\sbin\nologin

![daocoder](http://i.imgur.com/x8KomwF.png)

	[root@localhost daocoder]# vim passwd 

![daocoder](http://i.imgur.com/IcUTeGB.png)
	
	[root@localhost daocoder]# grep '^root' passwd 		加“^”以root开头的行过滤
	root:x:0:0:root:\root:\bin\bash

 grep -n 显示过滤结果的行号

	[root@localhost daocoder]# grep -n 'nologin$' passwd 	加“$”以nologin结尾的行过滤，-n并显示行号
	2:bin:x:1:1:bin:\bin:\sbin\nologin
	3:daemon:x:2:2:daemon:\sbin:\sbin\nologin
	4:adm:x:3:4:adm:\var\adm:\sbin\nologin
	5:lp:x:4:7:lp:\var\spool\lpd:\sbin\nologin
	9:mail:x:8:12:mail:\var\spool\mail:\sbin\nologin
	10:operator:x:11:0:operator:\root:\sbin\nologin
	11:games:x:12:100:games:\usr\games:\sbin\nologin

grep -c 统计过滤结果的行数

	[root@localhost daocoder]# grep -c 'nologin$' passwd	-c，统计过滤结果
	37

grep -v 对过滤结果取反

	[root@localhost daocoder]# grep -vn 'nologin$' passwd 	-vn，对过滤结果取反并统计行号
	1:root:x:0:0:root:\root:\bin\bash
	6:sync:x:5:0:sync:\sbin:\bin\sync
	7:shutdown:x:6:0:shutdown:\sbin:\sbin\shutdown
	8:halt:x:7:0:halt:\sbin:\sbin\halt
	42:daocoder:x:1000:1000:daocoder:\home\daocoder:\bin\bash

grep -i 不区分大小写进行过滤		case-insensitive

	[root@localhost daocoder]# grep '^root' passwd 
	root:x:0:0:root:\root:\bin\bash
	[root@localhost daocoder]# grep -i '^root' passwd 
	root:x:0:0:root:\root:\bin\bash
	ROOT:x:3:4:adm:\var\adm:\sbin\nologin

## 2.3 tr：替换

	[root@localhost daocoder]# tr 'a-z' 'A-Z' passwd 
	tr: 额外的操作数 "passwd"


	[root@localhost daocoder]# tr 'a-z' 'A-Z' <passwd 	“<”输入重定向，将passed文件交给tr命令替换
	ROOT:X:0:0:ROOT:\ROOT:\BIN\BASH
	BIN:X:1:1:BIN:\BIN:\SBIN\NOLOGIN
	DAEMON:X:2:2:DAEMON:\SBIN:\SBIN\NOLOGIN
	ROOT:X:3:4:ADM:\VAR\ADM:\SBIN\NOLOGIN
	LP:X:4:7:LP:\VAR\SPOOL\LPD:\SBIN\NOLOGIN
	SYNC:X:5:0:SYNC:\SBIN:\BIN\SYNC
	SHUTDOWN:X:6:0:SHUTDOWN:\SBIN:\SBIN\SHUTDOWN
	HALT:X:7:0:HALT:\SBIN:\SBIN\HALT

## 2.4 sort：排序

passed文件大致按上面的图或代码排序，下面利用sort对passed进行排序，默认按首字母排序。

	[root@localhost daocoder]# sort passwd 				先是首字母a-z排序，首字母共同就再下个字母排序、类推（下面未列完全）
	abrt:x:173:173::\etc\abrt:\sbin\nologin
	apache:x:48:48:Apache:\usr\share\httpd:\sbin\nologin
	avahi-autoipd:x:170:170:Avahi IPv4LL Stack:\var\lib\avahi-autoipd:\sbin\nologin
	avahi:x:70:70:Avahi mDNS\DNS-SD Stack:\var\run\avahi-daemon:\sbin\nologin
	bin:x:1:1:bin:\bin:\sbin\nologin
	chrony:x:996:995::\var\lib\chrony:\sbin\nologin
	colord:x:994:993:User for colord:\var\lib\colord:\sbin\nologin
	daemon:x:2:2:daemon:\sbin:\sbin\nologin
	daocoder:x:1000:1000:daocoder:\home\daocoder:\bin\bash
	dbus:x:81:81:System message bus:\:\sbin\nologin
	ftp:x:14:50:FTP User:\var\ftp:\sbin\nologin
	games:x:12:100:games:\usr\games:\sbin\nologin

sort -t : -k 3 这里面“-t”是指定分隔符为“:”，“-k”是指出按第几列排序 

感觉这个是很鸡肋的功能，上面这样是默认根据每个数字的先后进行排序，类似之前首字母排序那样，不是按照大小排序。

	[root@localhost daocoder]# sort -t: -k 3 passwd
	root:x:0:0:root:\root:\bin\bash
	daocoder:x:1000:1000:daocoder:\home\daocoder:\bin\bash
	qemu:x:107:107:qemu user:\:\sbin\nologin
	operator:x:11:0:operator:\root:\sbin\nologin
	usbmuxd:x:113:113:usbmuxd user:\:\sbin\nologin
	bin:x:1:1:bin:\bin:\sbin\nologin
	games:x:12:100:games:\usr\games:\sbin\nologin
	ftp:x:14:50:FTP User:\var\ftp:\sbin\nologin
	oprofile:x:16:16:Special user account to be used by OProfile:\var\lib\oprofile:\sbin\nologin
	avahi-autoipd:x:170:170:Avahi IPv4LL Stack:\var\lib\avahi-autoipd:\sbin\nologin
	pulse:x:171:171:PulseAudio System Daemon:\var\run\pulse:\sbin\nologin
	rtkit:x:172:172:RealtimeKit:\proc:\sbin\nologin
	abrt:x:173:173::\etc\abrt:\sbin\nologin
	daemon:x:2:2:daemon:\sbin:\sbin\nologin
	rpcuser:x:29:29:RPC Service User:\var\lib\nfs:\sbin\nologin
	rpc:x:32:32:Rpcbind Daemon:\var\lib\rpcbind:\sbin\nologin

sort -t: -k 3 -r 		“-r”是指将第3列逆序排序，不过也是类似首字母排序那样，不是按照大小排序，鸡肋 

	[root@localhost daocoder]# sort -t: -k 3 -r passwd|more		只列出部分
	nobody:x:99:99:Nobody:\:\sbin\nologin
	polkitd:x:999:999:User for polkitd:\:\sbin\nologin
	saslauth:x:998:76:"Saslauthd user":\run\saslauthd:\sbin\nologin
	libstoragemgmt:x:997:996:daemon account for libstoragemgmt:\var\run\lsm:\sbin\nologin
	chrony:x:996:995::\var\lib\chrony:\sbin\nologin
	unbound:x:995:994:Unbound DNS resolver:\etc\unbound:\sbin\nologin
	colord:x:994:993:User for colord:\var\lib\colord:\sbin\nologin
	gnome-initial-setup:x:993:991::\run\gnome-initial-setup\:\sbin\nologin
	pcp:x:992:990:Performance Co-Pilot:\var\lib\pcp:\sbin\nologin		注意这里
	postfix:x:89:89::\var\spool\postfix:\sbin\nologin
	dbus:x:81:81:System message bus:\:\sbin\nologin

sort -t: -k 3 -h 		“-h”是指十进制数字大小排序 

	[root@localhost daocoder]# sort -t: -k 3 -h passwd 
	root:x:0:0:root:\root:\bin\bash
	bin:x:1:1:bin:\bin:\sbin\nologin
	daemon:x:2:2:daemon:\sbin:\sbin\nologin
	ROOT:x:3:4:adm:\var\adm:\sbin\nologin
	lp:x:4:7:lp:\var\spool\lpd:\sbin\nologin
	sync:x:5:0:sync:\sbin:\bin\sync
	shutdown:x:6:0:shutdown:\sbin:\sbin\shutdown
	halt:x:7:0:halt:\sbin:\sbin\halt
	mail:x:8:12:mail:\var\spool\mail:\sbin\nologin
	operator:x:11:0:operator:\root:\sbin\nologin
	games:x:12:100:games:\usr\games:\sbin\nologin
	ftp:x:14:50:FTP User:\var\ftp:\sbin\nologin
	oprofile:x:16:16:Special user account to be used by OProfile:\var\lib\oprofile:\sbin\nologin
	rpcuser:x:29:29:RPC Service User:\var\lib\nfs:\sbin\nologin
	rpc:x:32:32:Rpcbind Daemon:\var\lib\rpcbind:\sbin\nologin
	ntp:x:38:38::\etc\ntp:\sbin\nologin
	gdm:x:42:42::\var\lib\gdm:\sbin\nologin
	apache:x:48:48:Apache:\usr\share\httpd:\sbin\nologin
	pegasus:x:66:65:tog-pegasus OpenPegasus WBEM\CIM services:\var\lib\Pegasus:\sbin\nologin
	avahi:x:70:70:Avahi mDNS\DNS-SD Stack:\var\run\avahi-daemon:\sbin\nologin
	tcpdump:x:72:72::\:\sbin\nologin
	sshd:x:74:74:Privilege-separated SSH:\var\empty\sshd:\sbin\nologin
	radvd:x:75:75:radvd user:\:\sbin\nologin
	dbus:x:81:81:System message bus:\:\sbin\nologin
	postfix:x:89:89::\var\spool\postfix:\sbin\nologin
	nobody:x:99:99:Nobody:\:\sbin\nologin

看下postfix这个用户信息，它是关于虚拟用户及域的邮件系统，uid位的“x”是表虚拟用户？这个没看懂。然后这个“x”在十进制大小排序中是怎么计算大小的？ascii码为120。bug啊

## 2.5 cut：分割信息

cut -d: -f 1,3,5		“-d”是指定分隔符，“-f”是指定显示列	 

	[root@localhost daocoder]# cut -d: -f 1,3,5 passwd| head -5
	root:0:root
	bin:1:bin
	daemon:2:daemon
	ROOT:3:adm
	lp:4:lp
	[root@localhost daocoder]# cut -d: -f 1-5 passwd| head -5
	root:x:0:0:root
	bin:x:1:1:bin
	daemon:x:2:2:daemon
	ROOT:x:3:4:adm
	lp:x:4:7:lp


## 2.6 uniq：去重

uniq [-cdu][-f<栏位>][-s<字符位置>][-w<字符位置>][--help][--version][输入文件][输出文件]

补充说明：uniq可检查文本文件中重复出现的行列。

参数：
  -c: 在每列旁边显示该行重复出现的次数。

  -d: 仅显示重复出现的行列。

  -f: 忽略比较指定的栏位。

  -s: 忽略比较指定的字符。

  -u: 仅显示出一次的行列。

  -w: 指定要比较的字符。

  -n：前n个字段和每个字段前的空白一起被忽略

  +n：前n个字符被忽略

	[root@localhost daocoder]# cat ip.txt 				查看下ip.txt的内容
	112.65.44.44
	112.65.44.44
	112.65.43.44
	112.65.44.44
	112.65.44.44
	113.65.24.44
	113.65.24.44
	114.65.24.44
	115.65.74.84
	113.65.24.44
	[root@localhost daocoder]# uniq ip.txt 				默认情况下uniq查看ip.txt的内容：对于那些连续重复的行只显示一次！注意这里是连续重复的行。
	112.65.44.44
	112.65.43.44
	112.65.44.44
	113.65.24.44
	114.65.24.44
	115.65.74.84
	113.65.24.44
	[root@localhost daocoder]# uniq -c ip.txt 			参数显示文件中每行[连续]出现的次数
	      2 112.65.44.44
	      1 112.65.43.44
	      2 112.65.44.44
	      2 113.65.24.44
	      1 114.65.24.44
	      1 115.65.74.84
	      1 113.65.24.44

这里可以看出来单独这个命令满足不了生活正常需求，我们需要的是把重复的行列在一起统计或其他。

那我们设想先将它按一定规则进行排序，然后再对它们进行去重显示。

	[root@localhost daocoder]# sort -t. -k 1 ip.txt 			以“.”分隔按第一列进行排序
	112.65.43.44
	112.65.44.44
	112.65.44.44
	112.65.44.44
	112.65.44.44
	113.65.24.44
	113.65.24.44
	113.65.24.44
	114.65.24.44
	115.65.74.84

uniq -c		在每列旁边显示某条记录重复的次数

	[root@localhost daocoder]# sort -t. -k 1 ip.txt |uniq -c	排完序后去重显示
	      1 112.65.43.44
	      4 112.65.44.44
	      3 113.65.24.44
	      1 114.65.24.44
	      1 115.65.74.84

uniq -d		显示有重复的记录一次

	[root@localhost daocoder]# sort -t. -k 1 ip.txt |uniq -d
	112.65.44.44
	113.65.24.44

uniq -u		显示没有重复的记录一次

	[root@localhost daocoder]# sort -t. -k 1 ip.txt |uniq -u
	112.65.43.44
	114.65.24.44
	115.65.74.84




## 2.7 命令组合运用

先“grep”筛选“passed”文件中以“nologin”结尾的行，再用“head”取前10行，再“cut”取1，3，6，7列得到结果。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 	
	bin:1:bin:\sbin\nologin
	daemon:2:daemon:\sbin\nologin
	ROOT:3:adm:\sbin\nologin
	lp:4:lp:\sbin\nologin
	mail:8:mail:\sbin\nologin
	operator:11:operator:\sbin\nologin
	games:12:games:\sbin\nologin
	ftp:14:FTP User:\sbin\nologin
	nobody:99:Nobody:\sbin\nologin
	dbus:81:System message bus:\sbin\nologin

对上述结果，再“sort”按第1列进行排序，即默认的首字母排序。
这里注意几点：同字母时排序是按照ascii码进行大小，故大写字母在小写字母之前。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -11|cut -d: -f 1,3,5,7 |sort -t: -k 1
	bin:1:bin:\sbin\nologin
	daemon:2:daemon:\sbin\nologin
	dbus:81:System message bus:\sbin\nologin
	ftp:14:FTP User:\sbin\nologin
	games:12:games:\sbin\nologin
	lp:4:lp:\sbin\nologin
	mail:8:mail:\sbin\nologin
	nobody:99:Nobody:\sbin\nologin
	operator:11:operator:\sbin\nologin
	ROOT:3:adm:\sbin\nologin
	rpc:32:Rpcbind Daemon:\sbin\nologin

对上述结果，再“sort”按第2列进行排序，即默认的首阿拉伯数排序。
这里注意几点：排序不是按照十进制数字大小；11比1排序在前，以此类推；sort是对管道之前产生的结果进行按列选择排序。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 |sort -t: -k 2
	operator:11:operator:\sbin\nologin
	games:12:games:\sbin\nologin
	ftp:14:FTP User:\sbin\nologin
	bin:1:bin:\sbin\nologin
	daemon:2:daemon:\sbin\nologin
	ROOT:3:adm:\sbin\nologin
	lp:4:lp:\sbin\nologin
	dbus:81:System message bus:\sbin\nologin
	mail:8:mail:\sbin\nologin
	nobody:99:Nobody:\sbin\nologin

对上述结果，再“sort”按第2列以阿拉伯数字大小进行排序。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 |sort -t: -k 2 -h
	bin:1:bin:\sbin\nologin
	daemon:2:daemon:\sbin\nologin
	ROOT:3:adm:\sbin\nologin
	lp:4:lp:\sbin\nologin
	mail:8:mail:\sbin\nologin
	operator:11:operator:\sbin\nologin
	games:12:games:\sbin\nologin
	ftp:14:FTP User:\sbin\nologin
	dbus:81:System message bus:\sbin\nologin
	nobody:99:Nobody:\sbin\nologin

对上述结果，再“sort”按第3列进行排序，即默认的首阿拉伯数排序。
这里注意几点：不同字母时排序是按照不分区大小写进行字母排序，即FTP在deamon和games之中；同字母时按照ascii码的大小进行排序，故大写字母在小写字母之前。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 |sort -t: -k 3
	ROOT:3:adm:\sbin\nologin
	bin:1:bin:\sbin\nologin
	daemon:2:daemon:\sbin\nologin
	ftp:14:FTP User:\sbin\nologin
	games:12:games:\sbin\nologin
	lp:4:lp:\sbin\nologin
	mail:8:mail:\sbin\nologin
	nobody:99:Nobody:\sbin\nologin
	operator:11:operator:\sbin\nologin
	dbus:81:System message bus:\sbin\nologin

对上述结果，再进行替换tr。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 |sort -t: -k 2 -h|tr 'a-f' 'A-F'
	Bin:1:Bin:\sBin\nologin
	DAEmon:2:DAEmon:\sBin\nologin
	ROOT:3:ADm:\sBin\nologin
	lp:4:lp:\sBin\nologin
	mAil:8:mAil:\sBin\nologin
	opErAtor:11:opErAtor:\sBin\nologin
	gAmEs:12:gAmEs:\sBin\nologin
	Ftp:14:FTP UsEr:\sBin\nologin
	DBus:81:SystEm mEssAgE Bus:\sBin\nologin
	noBoDy:99:NoBoDy:\sBin\nologin

再统计字符wc。

	[root@localhost daocoder]# grep 'nologin$' passwd|head -10|cut -d: -f 1,3,5,7 |sort -t: -k 2 -h|tr 'a-f' 'A-F'|wc 
	10      13     293

## 2.8 args

之所以能用到这个命令，是由于很多命令不支持“|”管道来传递参数，而日常工作中有有这个必要，所以就有了xargs命令。
	
	[root@localhost daocoder]# grep '^root' passwd|head -1|xargs mkdir
	[root@localhost daocoder]# ls
	passwd  root:x:0:0:root:root:binbash  test  test.txt  www
	[root@localhost daocoder]# grep '^root' passwd|head -1|cut -d: -f1 |xargs mkdir
	[root@localhost daocoder]# ls
	passwd  root  root:x:0:0:root:root:binbash  test  test.txt  www

	[root@localhost daocoder]# rm -rf roo*
	[root@localhost daocoder]# ls
	passwd  test  test.txt  www

## 2.9 split

	[root@localhost daocoder]# ls -lh passwd 					看下大小：274bytes
	-rw-r--r--. 1 root root 274 10月 19 23:45 passwd
	[root@localhost daocoder]# du -s passwd 					看下大小：4KB
	4	passwd
	[root@localhost daocoder]# du -sh *							看下大小：4KB
	4.0K	file.py
	4.0K	ip.txt
	4.0K	list_pos.py
	4.0K	lost+found
	113M	nmap-7.30
	8.6M	nmap-7.30.tar.bz2
	4.0K	passwd
	19M	php-7.0.11.tar.gz
	4.0K	prime.py
	139M	Python-2.7.12
	17M	Python-2.7.12.tgz
	16K	test
	4.0K	write_file.txt
	[root@localhost daocoder]# split -b 100 passwd 				分割文件，每个100bytes
	[root@localhost daocoder]# ls
	passwd xac xaa xab
	[root@localhost daocoder]# rm -f x*
	[root@localhost daocoder]# ls
	passwd
	[root@localhost daocoder]# split -b 100 passwd pass_		分割文件后，指定pass_文件头
	[root@localhost daocoder]# ls
	passwd pass_ac pass_aa  pass_ab  

	[root@localhost daocoder]# cat passwd | wc -l				看下行数
	7
	[root@localhost daocoder]# split -l 2 passwd l_				以2行分割文件，产生4个文件
	[root@localhost daocoder]# ls
	passwd l_ac  l_ad 	l_aa   l_ab   
	[root@localhost daocoder]# cat l_aa | wc -l
	2


# 3、文件的查找

## 3.1 命令的查找

Linux命令有内置命令和外部命令之分，内置命令和外部命令功能基本相同，但也有些细微差别。

内部命令实际上是shell程序的一部分，其中包含的是一些比较简单的linux系统命令，这些命令由shell程序识别并在shell程序内部完成运行，通常在linux系统加载运行时shell就被加载并驻留在系统内存中。内置命令是写在bash源码里面的，其执行速度比外部命令快，因为解析内部命令shell不需要创建子进程。比如：exit，history，cd，echo等。

外部命令是linux系统中的实用程序部分，因为实用程序的功能通常都比较强大，所以其包含的程序量也会很大，在系统加载时并不随系统一起被加载到内存中，而是在需要时才将其调用内存。通常外部命令的实体并不包含在shell中，但是其命令执行过程是由shell程序控制的。shell程序管理外部命令执行的路径查找、加载存放，并控制命令的执行。外部命令是在bash之外额外安装的，通常放在/bin，/usr/bin，/sbin，/usr/sbin......等等。可通过“echo $PATH”命令查看外部命令的存储路径，比如：ls、vi等。

简单来说就是bash内置命令是一些基本的命令，外部命令是你添加到linux环境变量中的软件实现的命令。

用type命令可以分辨内部命令与外部命令。

	[root@localhost daocoder]# type cd
	cd 是 shell 内嵌
	[root@localhost daocoder]# type ls
	ls 是 `ls --color=auto' 的别名

再看点区别。

	[root@localhost daocoder]# type pwd
	pwd 是 shell 内嵌
	[root@localhost daocoder]# man pwd
	[root@localhost daocoder]# pwd --help
	-bash: pwd: --: 无效选项
	pwd: 用法:pwd [-LP]
	[root@localhost daocoder]# /bin/pwd --help
	用法：/bin/pwd [选项]...
	输出当前工作目录的完整名称。
	
	  -L, --logical		使用环境变量中的PWD，即使其中包含符号链接
	  -P, --physical	避免所有符号链接
	      --help		显示此帮助信息并退出
	      --version		显示版本信息并退出
	
	注意：您的shell 内含自己的pwd 程序版本，它会覆盖这里所提及的相应
	版本。请查阅您的shell 文档获知它所支持的选项。
	


查看bash内置命令。

[root@localhost daocoder]# man builtin

![daocoder](http://i.imgur.com/5IbbM9R.png)

这篇文章里面有介绍：http://os.51cto.com/art/201006/207329.htm

命令查找：which。

	[root@localhost daocoder]# which cd				bash内置命令
	/usr/bin/cd

	[root@localhost daocoder]# which ls				linux外部命令
	alias ls='ls --color=a

也可以是whereis，搜索出这个命令所依赖的环境目录，没which直观。

	[root@localhost daocoder]# whereis cd
	cd: /usr/bin/cd /usr/share/man/man1/cd.1.gz /usr/share/man/man1p/cd.1p.gz /usr/share/man/mann/cd.n.gz
	[root@localhost daocoder]# whereis ls
	ls: /usr/bin/ls /usr/share/man/man1/ls.1.gz /usr/share/man/man1p/ls.1p.gz


这些命令搜索所依赖的库是什么呢?就是下面文件所在路径搜索。

	[root@localhost daocoder]# echo $PATH			linux环境变量
	/usr/lib64/qt-3.3/bin:/root/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

## 3.1 文件的查找

### 3.1.1 查找文件命令：locate。

	[root@localhost daocoder]# locate passwd |more  
	/daocoder/passwd
	/etc/passwd
	/etc/passwd-
	/etc/pam.d/passwd
	/etc/security/opasswd
	/usr/bin/gpasswd
	/usr/bin/grub2-mkpasswd-pbkdf2
	/usr/bin/htpasswd
	/usr/bin/kdepasswd
	/usr/bin/kpasswd
	/usr/bin/lppasswd
	/usr/bin/passwd
	/usr/bin/smbpasswd
	/usr/bin/vncpasswd
	/usr/include/kde4/kleo/changepasswdjob.h
	/usr/include/rpcsvc/yppasswd.h
	/usr/include/rpcsvc/yppasswd.x
	--MORE--

同理，文件查找也有所依赖的库文件，命令是updatedb，这个是定期更新，也可以手动更新，若你查找新建文件查找不到，执行下这个命令，然后在查找就ok了，下面是例子。

	[root@localhost daocoder]# ls				先看下这个文件列表
	passwd  test  test.txt  www
	[root@localhost daocoder]# touch mudai		建立一个名为“mudai”的文件
	[root@localhost daocoder]# ls
	mudai  passwd  test  test.txt  www
	[root@localhost daocoder]# locate mudai		查找下“mudai”这个文件：失败
	/home/mudai
	/home/mudai/.bash_logout
	/home/mudai/.bash_profile
	/home/mudai/.bashrc
	/home/mudai/.mozilla
	/home/mudai/.mozilla/extensions
	/home/mudai/.mozilla/plugins
	/var/spool/mail/mudai
	[root@localhost daocoder]# updatedb			更新下文件库
	[root@localhost daocoder]# locate mudai		再查找名为“mudai”的文件：成功
	/daocoder/mudai
	/home/mudai
	/home/mudai/.bash_logout
	/home/mudai/.bash_profile
	/home/mudai/.bashrc
	/home/mudai/.mozilla
	/home/mudai/.mozilla/extensions
	/home/mudai/.mozilla/plugins
	/var/spool/mail/mudai

### 3.1.2 查找文件命令：find

另外一个命令：find，是对根文件系统进行查找，默认是/root文件下。

find -name "文件名"							根据文件名查找
	
	[root@localhost daocoder]# find -name 'mudai'
	./mudai
	[root@localhost daocoder]# find / -name 'mudai'
	/var/spool/mail/mudai
	/home/mudai
	/daocoder/mudai

find -type f									根据文件类型查找

	[root@localhost daocoder]# find /daocoder -type f
	/daocoder/test/dao.txt
	/daocoder/test/godao.sh
	/daocoder/www
	/daocoder/test.txt
	/daocoder/passwd
	/daocoder/mudai

find -size 1M（+1M或-1M）

	[root@localhost daocoder]# find /daocoder -size -1M		根据文件大小查找
	/daocoder/test/godao.sh
	/daocoder/www
	/daocoder/mudai

find -group "组名"

	[root@localhost daocoder]# find /daocoder -group 'root'		根据文件所属组查找
	/daocoder
	/daocoder/test
	/daocoder/test/dao.txt
	/daocoder/test/aaa
	/daocoder/test/aaa/a
	/daocoder/test/bbb
	/daocoder/test/godao.sh
	/daocoder/www
	/daocoder/test.txt
	/daocoder/passwd
	/daocoder/mudai


find -user "用户名"

	[root@localhost daocoder]# find /daocoder -user 'daocoder'		根据文件拥有者查找
	[root@localhost daocoder]# find /daocoder -user 'root'
	/daocoder
	/daocoder/test
	/daocoder/test/dao.txt
	/daocoder/test/aaa
	/daocoder/test/aaa/a
	/daocoder/test/bbb
	/daocoder/test/godao.sh
	/daocoder/test.txt
	/daocoder/passwd
	/daocoder/mudai

来man下find命令。
	[root@localhost daocoder]# man find

![daocoder](http://i.imgur.com/OZGfPEF.png)

find查找文件后再处理。

find /daocoder -name "mudai" -exec ls -lh {} \;

	[root@localhost daocoder]# find /daocoder -name "mudai" -exec ls -lh {} \;
	-rw-r--r--. 1 root root 0 9月  20 11:01 /daocoder/mudai

	[root@localhost daocoder]# find /daocoder -name "mudai"|rm -f		找到“muda”文件并删除：失败
	[root@localhost daocoder]# ls
	mudai  passwd  test  test.txt  www
	[root@localhost daocoder]# find /daocoder -name "mudai"|xargs rm -f	找到“muda”文件并删除：成功
	[root@localhost daocoder]# ls
	passwd  test  test.txt  www

再举例。

	[root@localhost daocoder]# touch mudai
	[root@localhost daocoder]# ls
	mudai  passwd  test  test.txt  www
	[root@localhost daocoder]# ls
	mudai  passwd  test  test.txt  www
	[root@localhost daocoder]# find /daocoder -name "mudai" -exec rm -f {} \;	找到“muda”文件并删除：成功
	[root@localhost daocoder]# ls
	passwd  test  test.txt  www

再举例。这次删除有询问。

	[root@localhost daocoder]# touch mudai
	[root@localhost daocoder]# ls
	mudai  passwd  test  test.txt  www
	[root@localhost daocoder]# find /daocoder -name "mudai" -ok rm -f {} \;	找到“muda”文件并删除：成功
	< rm ... /daocoder/mudai > ? y
	[root@localhost daocoder]# ls
	passwd  test  test.txt  www













