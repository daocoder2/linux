<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# shell基础

# 1、shell简介

shell 是一个用C语言编写的程序，它是用户使用Linux的桥梁。shell既是一种命令语言，又是一种程序设计语言。作为命令语言，它交互式地解释和执行用户输入的命令；作为程序设计语言，它定义了各种变量和参数，并提供了许多在高级语言中才具有的控制结构，包括循环和分支。

shell有两种执行命令的方式：

- 交互式（Interactive）：解释执行用户的命令，用户输入一条命令，Shell就解释执行一条。
- 批处理（Batch）：用户事先写一个Shell脚本(Script)，其中有很多条命令，让Shell一次把这些命令执行完，而不必一条一条地敲命令。
shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。

Ken Thompson的sh是第一种Unix Shell，Windows Explorer是一个典型的图形界面Shell。

shell及系统跟计算机硬件交互时使用的中间介质，它只是系统的一个工具。实际上，在shell和计算机硬件之间还有一层东西那就是系统内核了。回到计算机上来，用户直接面对的不是计算机硬件而是shell，用户把指令告诉shell，然后shell再传输给系统内核，接着内核再去支配计算机硬件去执行各种操作。

我用的linux发布版本（Redhat/CentOS）系统默认安装的shell叫做bash，即Bourne Again Shell，它是sh（Bourne Shell）的增强版本。Bourn Shell 是最早行起来的一个shell，创始人叫Steven Bourne，为了纪念他所以叫做Bourn Shell，检称sh。下面介绍这个 bash 有哪些特点。

## 1.1 记录命令

linux是会有记录的，预设可以记录1000条历史命令。这些命令保存在用户的家目录中的.bash_history文件中。另外只有当用户正常退出当前shell时，在当前shell中运行的命令才会保存至.bash_history文件中。

	[root@localhost ~]# ls -al
	总用量 60
	dr-xr-x---.  6 root root  4096 10月 24 19:51 .
	drwxr-xr-x. 18 root root  4096 10月 12 12:32 ..
	-rw-------.  1 root root 13180 10月 24 21:22 .bash_history
	-rw-r--r--.  1 root root    18 12月 29 2013 .bash_logout
	-rw-r--r--.  1 root root   176 12月 29 2013 .bash_profile
	-rw-r--r--.  1 root root   175 10月 19 23:18 .bashrc
	drwx------.  4 root root    29 9月   6 20:58 .cache

	[root@localhost ~]# less .bash_history | wc -l		保存1000条
	1000

	[root@localhost ~]# history -c 						清空内存中的历史

	[root@localhost ~]# history
	    6  less .bash_history | wc -l
	    7  less .bash_history 
	    8  history
	[root@localhost ~]# !8								执行历史某条记录
	history
	    6  less .bash_history | wc -l
	    7  less .bash_history 
	    8  history
	[root@localhost ~]# !!								双“!!”执行上条命令
	history
	    6  less .bash_history | wc -l
	    7  less .bash_history 
	    8  history
## 1.2 指令和文件名的补全

按tab键，它可以帮您补全一个指令，也可以帮您补全一个路径或者一个文件名。连续按两次tab键，系统则会把所有的指令或者文件名都列出来。

## 1.3 别名

通过alias把一个常用的并且很长的指令别名一个简洁易记的指令。如果不想用了，还可以用unalias解除别名功能。直接敲alias会看到目前系统预设的alias。格式也如下。

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

## 1.4 通配符

在bash下，可以使用 * 来匹配零个或多个字符，而用 ? 匹配一个字符。

	[root@localhost daocoder]# ls
	passwd
	[root@localhost daocoder]# ls passw?
	passwd
	[root@localhost daocoder]# ls pass?
	ls: 无法访问pass?: 没有那个文件或目录

## 1.5 输入输出重定向 

输入重定向用于改变命令的输入，输出重定向用于改变命令的输出。输出重定向更为常用，它经常用于将命令的结果输入到文件中，而不是屏幕上。输入重定向的命令是<，输出重定向的命令是>，另外还有错误重定向2>，以及追加重定向>>。

## 1.6 管道符

管道符 “|”, 就是把前面的命令运行的结果丢给后面的命令。

## 1.7 作业控制

当运行一个进程时，您可以使它暂停（按Ctrl+z），然后使用fg命令恢复它，利用bg命令使他到后台运行，您也可以使它终止（按Ctrl+c）。计划任务里面说过。

# 2、变量

环境变量PATH，这个环境变量就是shell预设的一个变量，通常shell预设的变量都是大写的，用户自定义为小写。

	[root@localhost daocoder]# echo $PATH 
	/usr/lib64/qt-3.3/bin:/root/perl5/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
	[root@localhost daocoder]# echo $HOME 
	/root
	[root@localhost daocoder]# echo $PWD
	/daocoder
	[root@localhost daocoder]# echo $LOGNAME 
	root
	[root@localhost daocoder]# env						下面一大串省略
	XDG_SESSION_ID=581
	HOSTNAME=localhost.localdomain
	SELINUX_ROLE_REQUESTED=
	TERM=xterm

	[root@localhost daocoder]# export a=1				声明全局变量，“=”两边不要有空格
	[root@localhost daocoder]# env | less
	a=1
	PWD=/daocoder
	LANG=zh_CN.UTF-8
	[root@localhost daocoder]# echo $a
	1

	[root@localhost daocoder]# b=2						用户自定义变量，只在当前shell （bash）下生效
	[root@localhost daocoder]# echo $b
	2
	[root@localhost daocoder]# bash
	[root@localhost daocoder]# echo $b

	[root@localhost ~]# set								显示所有变量，太长省略


## 2.1 变量命名规则

在linux下设置自定义变量有哪些规则呢？

- 设定变量的格式为 “a=b”, 其中a为变量名，b为变量的内容，等号两边不能有空格； 
- 变量名只能由英、数字以及下划线组成，而且不能以数字开头； 
- 当变量内容带有特殊字符（如空格）时，需要加上单引号；
- 如果变量内容中需要用到其他命令运行结果则可以使用反引号; 
	[root@localhost ~]# myname=`pwd`
	[root@localhost ~]# echo $myname
	/root
 
- 变量内容可以累加其他变量的内容，需要加双引号; 

	[root@localhost ~]# myname="$HOME"`pwd`
	[root@localhost ~]# echo $myname
	/root/root


# 3、系统环境变量与个人环境变量的配置文件

/etc/profile ：这个文件预设了几个重要的变量，例如PATH, USER, LOGNAME, MAIL, INPUTRC, HOSTNAME, HISTSIZE, umask等等。

/etc/bashrc ：这个文件主要预设umask以及PS1。

	[root@localhost ~]# echo $PS1
	[\u@\h \W]\$
	\u 就是用户， \h 主机名， \W 则是当前目录，\$ 就是那个 ‘#’ 了，如果是普通用户则显示为 ‘$’。

除了两个系统级别的配置文件外，每个用户的主目录下还有几个这样的隐藏文件：

.bash_profile ：定义了用户的个人化路径与环境变量的文件名称。每个用户都可使用该文件输入专用于自己使用的shell信息,当用户登录时,该文件仅仅执行一次。

.bashrc ：该文件包含专用于您的shell的bash信息,当登录时以及每次打开新的shell时,该该文件被读取。例如您可以将用户自定义的alias或者自定义变量写到这个文件中。

.bash_history ：记录命令历史用的。

.bash_logout ：当退出shell时，会执行该文件。可以把一些清理的工作放到这个文件中。

## 3.1要想系统内所有用户登录后都能使用该变量

需要在 “/etc/profile” 文件最末行加入 export myname=daocoder 然后运行 source /etc/profile 就可以生效了。此时再运行bash命令或者直接 su - test 账户可以看到效果。

## 3.2 只想让当前用户使用该变量

需要在用户主目录下的 .bashrc 文件最后一行加入 export myname=daocoder 然后运行 source .bashrc 就可以生效了。这时候再登录test账户，myname变量则不会生效了。上面用的source命令的作用是，将目前设定的配置刷新，即不用注销再登录也能生效。

# 4、linux shell中的特殊符号

1、* 代表零个或多个任意字符。 

2、? 只代表一个任意的字符 

3、# 这个符号在linux中表示注释说明的意思，即 # 后面的内容linux忽略掉。 

4、\ 脱意字符，将后面的特殊符号（例如”*” ）还原为普通字符。 

5、| 管道符，前面多次出现过，它的作用在于将符号前面命令的结果丢给符号后面的命令。

# 5、命令

命令 : cut

用来截取某一个字段

语法： cut -d '分隔字符' [-cf] n 这里的n是数字

-d ：后面跟分隔字符，分隔字符要用单引号括起来

-c ：后面接的是第几个字符

-f ：后面接的是第几个区块

	[root@localhost ~]# cat /etc/passwd |cut -d ':' -f 1 |head -n5
	root
	bin
	daemon
	adm
	lp

命令 : sort

sort 用做排序

语法： sort [-t 分隔符] [-kn1,n2] [-nru] 这里的n1 < n2

-t 分隔符 ：作用跟cut的-d一个意思

-n ：使用纯数字排序

-r ：反向排序

-u ：去重复

-kn1,n2 ：由n1区间排序到n2区间，可以只写-kn1，即对n1字段排序

	[root@localhost ~]# head -n5 /etc/passwd |sort
	adm:x:3:4:adm:/var/adm:/sbin/nologin
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
	root:x:0:0:root:/root:/bin/bash

命令 : wc

用于统计文档的行数、字符数、词数，常用的选项为：

-l ：统计行数

-m ：统计字符数

-w ：统计词数

	[root@localhost ~]# wc /etc/passwd
	  27   37 1220 /etc/passwd
	[root@localhost ~]# wc -l /etc/passwd
	27 /etc/passwd
	[root@localhost ~]# wc -m /etc/passwd
	1220 /etc/passwd
	[root@localhost ~]# wc -w /etc/passwd
	37 /etc/passwd

	命令 : uniq
	
	去重复的行，阿铭最常用的选项只有一个：
	
	-c ：统计重复的行数，并把行数写在前面

命令 : tee

后跟文件名，类似与重定向 “>”, 但是比重定向多了一个功能，在把文件写入后面所跟的文件中的同时，还显示在屏幕上。

命令 : tr

替换字符，常用来处理文档中出现的特殊符号，如DOS文档中出现的^M符号。常用的选项有两个：

-d ：删除某个字符，-d 后面跟要删除的字符

-s ：把重复的字符去掉

最常用的就是把小写变大写: tr ‘[a-z]’ ‘[A-Z]’

命令 : split

切割文档，常用选项：

-b ：依据大小来分割文档，单位为byte



















 








 





