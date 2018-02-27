<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# shell脚本

# 1、关于shell

Linux 中的 shell 有很多类型，其中最常用的几种是: Bourne shell (sh)、C shell (csh) 和 Korn shell (ksh), 各有优缺点。Bourne shell 是 UNIX 最初使用的 shell，并且在每种 UNIX 上都可以使用, 在 shell 编程方面相当优秀，但在处理与用户的交互方面做得不如其他几种shell。

这里可以参见下文[shell的简介及主流类型](https://zhidao.baidu.com/question/310105307.html)。

Linux 操作系统缺省的 shell 是 Bourne Again shell，它是 Bourne shell 的扩展，简称 Bash，与 Bourne shell 完全向后兼容，并且在Bourne shell 的基础上增加、增强了很多特性。Bash放在/bin/bash中，它有许多特色，可以提供如命令补全、命令编辑和命令历史表等功能，它还包含了很多 C shell 和 Korn shell 中的优点，有灵活和强大的编程接口，同时又有很友好的用户界面。

GNU/Linux 操作系统中的 /bin/sh 本是 bash (Bourne-Again Shell) 的符号链接，但鉴于 bash 过于复杂，有人把 ash 从 NetBSD 移植到 Linux 并更名为 dash (Debian Almquist Shell)，并建议将 /bin/sh 指向它，以获得更快的脚本执行速度。Dash Shell 比 Bash Shell 小的多，符合POSIX标准。

POSIX表示可移植操作系统接口（Portable Operating System Interface ，缩写为 POSIX ），POSIX标准定义了操作系统应该为应用程序提供的接口标准，是IEEE为要在各种UNIX操作系统上运行的软件而定义的一系列API标准的总称，其正式称呼为IEEE 1003，而国际标准名称为ISO/IEC 9945。

# 2、shell脚本的一些注意事项

## 2.1 shell脚本的一般习惯

- shell是批处理程序，类似windows的bat。
- 写shell脚本的时候，第一行我们一般以 #!/bin/bash 开头。即第一行一定要指明系统需要那种shell解释你的shell程序。
- shell脚本的文件名应该类似 *.sh ，帮助识别。
- 运行有几种方法：sh *.sh ；chmod +x *.sh ; ./*.sh 

## 2.2 shell开头第一行的几种方式及区别

- #!/bin/sh
- #!/bin/bash
- #!/usr/bin/perl
- #!/usr/bin/tcl
- #!/bin/sed -f
- #!/usr/awk -f

要注意,在每个脚本的开头都使用"#!",这意味着告诉你的系统这个文件的执行需要指定一个解释器。#!实际上是一个2 字节的魔法数字,这是指定一个文件类型的特殊标记, 换句话说, 在这种情况下,指的就是一个可执行的脚本(键入man magic 来获得关于这个迷人话题的更多详细信息)。在#!之后接着是一个路径名.这个路径名指定了一个解释脚本中命令的程序,这个程序可以是 shell,程序语言或者是任意一个通用程序。这个指定的程序从头开始解释并且执行脚本中的命令(从#!行下边的一行开始),忽略注释。
	
	#!/bin/bash 与 #!/bin/env bash 一个是指定shell解释器，一个是从环境变量中找到指定的解释器。

# 3、shell实例(这里是python)

	[root@localhost daocoder]# cat passwd 					查看下源文件	
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# vim file.py					编辑脚本	
		#!/bin/python
		
		f = file('passwd','r')
		for line in f.readlines():
		    line = line.strip('\n').split(':')[0]
		    print line
	
	[root@localhost daocoder]# ./file.py					执行脚本
	root
	bin
	daemon
	daocoder
	godao
	mudai
	[root@localhost daocoder]# python file.py 				执行脚本的另种方式
	root
	bin
	daemon
	daocoder
	godao
	mudai

## 3.1 shell实例（专门针对于date解释）

	[root@localhost daocoder]# touch date.sh			建立shell文件
	
	[root@localhost daocoder]# vim date.sh 				编辑shell文件
	
	#!/bin/env bash
	# there are demo about date command.
	
	date												#date基本命令#
	date +%F											#格式化日期#	
	date +%T											#格式化时间#
	date +%F" "%T										#格式化日期及时间并以空格连接#
	
	[root@localhost daocoder]# ./date.sh
	-bash: ./date.sh: 权限不够
	[root@localhost daocoder]# chmod +x date.sh
	
	[root@localhost daocoder]# chmod +x date.sh
	[root@localhost daocoder]# ./date.sh
	2016年 11月 03日 星期四 09:29:59 CST
	2016-11-03
	09:29:59
	2016-11-03 09:29:59

CST可以为如下4个不同的时区的缩写：

- 美国中部时间：Central Standard Time (USA) UT-6:00
- 澳大利亚中部时间：Central Standard Time (Australia) UT+9:30
- 中国标准时间：China Standard Time UT+8:00
- 古巴标准时间：Cuba Standard Time UT-4:00

	[root@localhost ~]# date +%y						年的后两位				
	16

	[root@localhost ~]# date +%Y						四位年
	2016

	[root@localhost ~]# date +%m						月份
	11

	[root@localhost ~]# date +%H						时
	09

	[root@localhost bin]# date -d "-2 hour" +%H
	07

	[root@localhost ~]# date +%M						分
	36

	[root@localhost ~]# date +%d						日
	03

	[root@localhost ~]# date +%S						秒
	18

	[root@localhost ~]# date +%s						时间戳
	1478136973
	
	[root@localhost ~]# date +%h						英文月
	11月

	[root@localhost bin]# date +%W
	44
	[root@localhost bin]# date +%w						周几，周日开始为0（今天是星期四）
	4

	[root@localhost bin]# date -d "-4 day" +%w			看下上星期日是几
	0

关于date -d " " 字符串里我测试了下，一般简写或全名都支持。例：sec、second、seconds等，同理其他。

	

时间的调整

	[root@localhost daocoder]# ntpdate time.windows.com			同步时间服务器
	 3 Nov 09:47:23 ntpdate[52918]: adjust time server 40.118.103.7 offset -0.027504 sec

这里你要先保证你已经安装了ntp这个包，即网络时间同步的包。

	[root@localhost bin]# yum list |grep ntp
	Repodata is over 2 weeks old. Install yum-cron? Or run: yum makecache fast
	fontpackages-filesystem.noarch          1.44-8.el7                     @anaconda
	ntp.x86_64                              4.2.6p5-18.el7.centos          @anaconda
	ntpdate.x86_64                          4.2.6p5-18.el7.centos          @anaconda
	fontpackages-devel.noarch               1.44-8.el7                     base     
	fontpackages-tools.noarch               1.44-8.el7                     base     
	ntp.x86_64                              4.2.6p5-22.el7.centos.2        updates  
	ntp-doc.noarch                          4.2.6p5-22.el7.centos.2        updates  
	ntp-perl.noarch                         4.2.6p5-22.el7.centos.2        updates  
	ntpdate.x86_64                          4.2.6p5-22.el7.centos.2        updates  
	python-ntplib.noarch                    0.3.2-1.el7                    base     
	sntp.x86_64                             4.2.6p5-22.el7.centos.2        updates  


	[root@localhost daocoder]# touch `date +%T`.log				这里注意``包含命令
	[root@localhost daocoder]# ls
	11:15:57.log  ip.txt       nmap-7.30          php-7.0.11.tar.gz  Python-2.7.12.tgz
	date.sh       list_pos.py  nmap-7.30.tar.bz2  prime.py           test
	file.py       lost+found   passwd             Python-2.7.12      write_file.txt
	[root@localhost daocoder]# rm -rf 11:15:57.log 

## 3.2 shell实例

### 3.2.1 if实例
 
	[root@localhost daocoder]# touch demo.sh					新建demo.sh文件
	[root@localhost daocoder]# vim demo.sh 						编辑demo.sh文件
	#!/bin/env bash
	
	a=0
	if [ $a -gt 1 ]
	then
	    echo "a > 1"
	else
	    echo "a<1"
	fi
	
	[root@localhost daocoder]# chmod +x demo.sh 				执行方法1
	[root@localhost daocoder]# ./demo.sh 
	a<1
	[root@localhost daocoder]# sh demo.sh 						执行方法2
	a<1
	[root@localhost daocoder]# bash demo.sh 					执行方法3
	a<1


if循环语句结构：
	if [ * ]
	then 
		*
	elif [ * ]
	then
		*
	else
		*
	fi

例子：

	#!/bin/env bash
	
	a=5
	if [ $a -gt 6 ]									这里[]左右需要空格
	then
	    echo "a > 6"
	elif [ $a -gt 2 ]								这种逻辑判断不可以，上面也可以
	then
	    echo "a>2"
	else
	    echo "a<2"
	fi

实例说明那种判断形式错误

	[root@localhost daocoder]# bash -x demo.sh 
	+ a=5
	+ '[' 5 -gt 6 ']'
	+ '[' 5 ']'
	+ echo 'a>2'
	a>2
	[root@localhost daocoder]# vim demo.sh 
	[root@localhost daocoder]# bash -x demo.sh 
	+ a=1
	+ '[' 1 -gt 6 ']'
	+ '[' 1 ']'
	+ echo 'a>2'
	a>2

修改下：

	#!/bin/env bash
	
		a=3
		if [ $a -gt 6 ]
		then
		    echo "a > 6"
		elif [ $a -gt 2 ]
		then
		    echo "a>2"
		else
		    echo "a<2"
		fi

	[root@localhost daocoder]# bash -x demo.sh 		-x执行可以看到过程
	+ a=3
	+ '[' 3 -gt 6 ']'
	+ '[' 3 -gt 2 ']'
	+ echo 'a>2'
	a>2


-gt >  	-ge >= 	-lt < 	-le <=		-eq = 		-ne !=  	-o ||	-a	&&


	[root@localhost daocoder]# a=4					内存中定义a
	
	[root@localhost daocoder]# if [ $a -gt 10 -o $a -lt 0 ];then echo "$a<0 $a>10";else echo "0<$a<10";fi									这里""内$a可以被释义
	0<4<10

	[root@localhost daocoder]# if [ $a -gt 10 ] || [ $a -lt 0 ];then echo "$a<0 $a>10";else echo "0<$a<10";fi									-o的另种表达形式，注意两者的区别
	0<5<10


-f 		检测是否是文件且存在

-d 		检测是否是目录且存在

-e 		检测是否存在

-rwx 	检测是否是文件且读写执行

-z		是否为空

	[root@localhost daocoder]# if [ -f demo.sh ];then echo "demo.sh存在";else echo "demo.sh不存在";fi
	demo.sh存在

	[root@localhost daocoder]# if [ -z $b ];then echo "$b null";else echo "$b not null";fi
	 null
	[root@localhost daocoder]# b=2
	[root@localhost daocoder]# if [ -z $b ];then echo "$b null";else echo "$b not null";fi
	2 not null

grep -q 返回执行结果，真假，没输出

	[root@localhost daocoder]# if grep -q 'daocoder' /etc/passwd 2>/dev/null;
	then echo "ok";else echo "not ok";fi
	ok
	[root@localhost daocoder]# if grep -q 'daocodermore' /etc/passwd;
	then echo "ok";else echo "not ok";fi
	not ok

	[root@localhost daocoder]# echo $?				查看命令是否正常运行成功
	1

### 3.2.2 case语句实例
	
	#!/bin/env bash 
	
	n=44
	a=$[$n%2]										这里$符号必须加
	case $a in										这里$符号必须加
	    1)											判断语句格式
	    echo "odd"
	    ;;											结束语句格式
	    0)
	    echo "even"
	    ;;
	    *)
	    echo "sha"
	esac											结束判断格式


	[root@localhost daocoder]# sh -x case.sh 
	+ n=44
	+ a=0
	+ case $a in
	+ echo even
	even


	[root@localhost daocoder]# a=1;b=2
	[root@localhost daocoder]# c=$[$a+$b];echo $c;
	3
	[root@localhost daocoder]# c=$[$a-$b];echo $c;
	-1
	[root@localhost daocoder]# c=$[$a*$b];echo $c;
	2
	[root@localhost daocoder]# c=$[$a/$b];echo $c;
	0
	[root@localhost daocoder]# c=$[$a%$b];echo $c;
	1
	[root@localhost daocoder]# bc					linux的计算器，ctrl+d 退出
	bc 1.06.95
	Copyright 1991-1994, 1997, 1998, 2000, 2004, 2006 Free Software Foundation, Inc.
	This is free software with ABSOLUTELY NO WARRANTY.
	For details type `warranty'. 
	1+2
	3
	100/5
	20
	0.2*4
	.8
	0.05*56
	2.80

	[root@localhost daocoder]# echo "2*3"|bc		另种方式利用
	6

### 3.2.3 for循环实例
	
	[root@localhost daocoder]# vim for.sh 
	
	#! /etc/env bash
	
	for i in `seq 1 10`
	do
	    echo "$i"
	done

	[root@localhost daocoder]# seq 2 2 7			首、步长、尾	
	2
	4
	6

sed的用法。

	[root@localhost daocoder]# man seq
	SEQ(1)                                    User Commands                                   SEQ(1)
	
	DESCRIPTION
	       Print numbers from FIRST to LAST, in steps of INCREMENT.
	
	       Mandatory arguments to long options are mandatory for short options too.
	
	       -f, --format=FORMAT
	              use printf style floating-point FORMAT
				指定打印的格式
				%后面指定数字的位数，默认是%g
				"%5g"数字位数不足部分是空格
	
	       -s, --separator=STRING
	              use STRING to separate numbers (default: \n)
	
	       -w, --equal-width
	              equalize width by padding with leading zeroes
				指定输出数字同宽，前面不足的用0补全，即与位数最多的数对齐


	[root@localhost daocoder]# seq -s . -w 1 2 10	-s 指定分隔符 -w 等宽
		01.03.05.07.09
	[root@localhost daocoder]# seq -f "%02g" 6 10			指定0补位
	06
	07
	08
	09
	10
	[root@localhost daocoder]# seq -f "%2g" 6 10			默认空格补位
	 6
	 7
	 8
	 9
	10

	[root@localhost daocoder]# seq -w 0 100| sed 's/^0//g'|sed 's/^0//g'	两次去零开头




	[root@localhost daocoder]# for f in `ls`;do echo $f;ls -dl $f; done
	case.sh
	-rw-r--r--. 1 root root 131 11月  3 16:53 case.sh
	date.sh
	-rwxr-xr-x. 1 root root 102 11月  3 09:43 date.sh
	demo.sh
	-rwxr-xr-x. 1 root root 120 11月  3 16:11 demo.sh
	file.py
	-rwxr-xr-x. 1 root root 117 11月  3 09:17 file.py
	for.sh
	-rw-r--r--. 1 root root 59 11月  3 17:05 for.sh
	ip.txt
	-rw-r--r--. 1 root root 130 9月  21 09:00 ip.txt
	list_pos.py
	-rw-r--r--. 1 root root 476 10月 20 16:31 list_pos.py
	lost+found
	drwx------. 2 root root 4096 10月  9 09:48 lost+found
	nmap-7.30
	drwxr-xr-x. 22 root root 12288 10月 10 11:10 nmap-7.30
	nmap-7.30.tar.bz2
	-rw-r--r--. 1 root root 9003761 9月  30 02:06 nmap-7.30.tar.bz2
	passwd
	-rw-r--r--. 1 root root 238 11月  1 10:56 passwd
	php-7.0.11.tar.gz
	-rw-r--r--. 1 root root 19031652 9月  14 03:10 php-7.0.11.tar.gz
	prime.py
	-rw-r--r--. 1 root root 442 10月 26 11:09 prime.py
	Python-2.7.12
	drwxrwxr-x. 18 daocoder daocoder 4096 10月 13 10:44 Python-2.7.12
	Python-2.7.12.tgz
	-rw-r--r--. 1 root root 16935960 6月  26 06:04 Python-2.7.12.tgz
	test
	drwxr-xr-x. 2 root root 4096 10月 13 17:16 test
	write_file.txt
	-rw-r--r--. 1 root root 6 10月 20 09:53 write_file.txt

	[root@localhost daocoder]# rm -rf *.bak ;for f in `ls`;do echo $f;if [ -f $f ];
	then cp $f $f.bak ;fi;done
	case.sh
	date.sh
	demo.sh
	file.py
	for.sh
	ip.txt
	list_pos.py
	lost+found
	nmap-7.30
	nmap-7.30.tar.bz2
	passwd
	php-7.0.11.tar.gz
	prime.py
	Python-2.7.12
	Python-2.7.12.tgz
	test
	write_file.txt
	[root@localhost daocoder]# ls
	case.sh      file.py      list_pos.py            passwd                 Python-2.7.12
	case.sh.bak  file.py.bak  list_pos.py.bak        passwd.bak             Python-2.7.12.tgz
	date.sh      for.sh       lost+found             php-7.0.11.tar.gz      Python-2.7.12.tgz.bak
	date.sh.bak  for.sh.bak   nmap-7.30              php-7.0.11.tar.gz.bak  test
	demo.sh      ip.txt       nmap-7.30.tar.bz2      prime.py               write_file.txt
	demo.sh.bak  ip.txt.bak   nmap-7.30.tar.bz2.bak  prime.py.bak           write_file.txt.bak


	[root@localhost daocoder]# vim for.sh			输出乘法口诀表
	
	#! /etc/env bash
	
	for i in `seq 1 9`
	do
	    for j in `seq 1 $i`
	    do
	        k=$[$i*$j]
	        echo -n "$j * $i = $k "
	        if [ $i -eq $j ]
	        then
	            echo -e ""
	        fi
	    done
	done

	[root@localhost daocoder]# sh for.sh
	1 * 1 = 1 
	1 * 2 = 2 2 * 2 = 4 
	1 * 3 = 3 2 * 3 = 6 3 * 3 = 9 
	1 * 4 = 4 2 * 4 = 8 3 * 4 = 12 4 * 4 = 16 
	1 * 5 = 5 2 * 5 = 10 3 * 5 = 15 4 * 5 = 20 5 * 5 = 25 
	1 * 6 = 6 2 * 6 = 12 3 * 6 = 18 4 * 6 = 24 5 * 6 = 30 6 * 6 = 36 
	1 * 7 = 7 2 * 7 = 14 3 * 7 = 21 4 * 7 = 28 5 * 7 = 35 6 * 7 = 42 7 * 7 = 49 
	1 * 8 = 8 2 * 8 = 16 3 * 8 = 24 4 * 8 = 32 5 * 8 = 40 6 * 8 = 48 7 * 8 = 56 8 * 8 = 64 
	1 * 9 = 9 2 * 9 = 18 3 * 9 = 27 4 * 9 = 36 5 * 9 = 45 6 * 9 = 54 7 * 9 = 63 8 * 9 = 72 9 * 9 = 81

echo的用法。

	[root@localhost daocoder]# man echo 				这里注意echo的用法	
	ECHO(1)                                                 User Commands                                                 ECHO(1)
	
	NAME
	       echo - display a line of text
	
	SYNOPSIS
	       echo [SHORT-OPTION]... [STRING]...
	       echo LONG-OPTION
	
	DESCRIPTION
	       Echo the STRING(s) to standard output.
	
	       -n     do not output the trailing newline	不输出在新的行，即不换行
	
	       -e     enable interpretation of backslash escapes	使反斜杠加字符可用
	
	       -E     disable interpretation of backslash escapes (default)	使反斜杠加字符不可用
	
	       --help display this help and exit
 


### 3.2.4 while循环实例

	[root@localhost daocoder]# vim while.sh
	
	#!/etc/env bash 
	
	i=1
	while [ $i -le 10 ]
	do
	    echo $i
	    i=$[$i+1]
	done

	[root@localhost daocoder]# sh while.sh
	1
	2
	3
	4
	5
	6
	7
	8
	9
	10

	[root@localhost daocoder]# while sleep 2;do echo 1;done			每2秒打印一次1 
	1
	1
	1
	1
	1



### 3.2.5 break实例

	[root@localhost daocoder]# vim break.sh
	
	#!/etc/env bash
	
	i=1
	for i in `seq 1 5`
	do echo $i
	    for j in `seq 1 $i`
	    do
	        echo $i $j
	        if [ $j -eq 3 ]
	        then
	            break									停止这次循环
	        fi
	    done
	    echo -------------
	done


	[root@localhost daocoder]# sh break.sh 
	1
	1 1
	-------------
	2
	2 1
	2 2
	-------------
	3
	3 1
	3 2
	3 3
	-------------
	4
	4 1
	4 2
	4 3
	-------------
	5
	5 1
	5 2
	5 3
	-------------

### 3.2.6 continue实例

	[root@localhost daocoder]# cat continue.sh 
	#!/bin/env bash
	
	for i in `seq 1 5`
	do 
	    echo $i
	    if [ $i -eq 3 ]
	    then 
	        echo $i $j
	    fi
	done
	echo $i
	[root@localhost daocoder]# sh continue.sh 
	1
	2
	3
	3
	4
	5
	5

### 3.2.7 functon实例

	[root@localhost daocoder]# cat function.sh 
	#!/bin/env bash
	
	function isnum() {
	    b=`echo "$1"|sed 's/[0-9]//g'`						这个 $1 指函数第一个参数
	    if [ -z $b ]
	    then
	        return 0
	    else
	        return 1
	    fi
	}
	read -p "please inout a num: " a
	if isnum $a
	then
	    echo ok
	else
	    echo not ok
	fi
	[root@localhost daocoder]# sh -x function.sh
	+ read -p 'please inout a num: ' a
	please inout a num: 2
	+ isnum 2
	++ echo 2
	++ sed 's/[0-9]//g'
	+ b=
	+ '[' -z ']'
	+ return 0
	+ echo ok
	ok


tips：

linux里面对条件的判断指执行语句是否成功，成功为0，不成功为假，所以上面这个例子里，输入一个数字后执行函数，b为空，然后if条件执行成功，即为0，return 0 说明执行成功，返回来输出ok。

下面这个例子可以大体看下，然后再附个链接去看看。

	[root@localhost daocoder]# echo "o"
	o
	[root@localhost daocoder]# echo $?
	0
	[root@localhost daocoder]# $?
	bash: 0: 未找到命令...
	[root@localhost daocoder]# echo $?
	127

[linux中“0真，非零为假？0为假，非0为真？”](http://linuxybird.blog.51cto.com/5689151/1411299)。
























