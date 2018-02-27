<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# rsync+inotify实现数据实时同步（局域网）

## 1、简介

### 1.1 rsync简介及基本命令

rsync是linux系统下的数据镜像备份工具。使用快速增量备份工具Remote Sync可以远程同步，支持本地复制，或者与其他SSH、rsync主机同步。它可通过LAN/WAN快速同步多台主机间的文件。rsync使用所谓的“rsync算法”来使本地和远程两个主机之间的文件达到同步，这个算法只传送两个文件的不同部分，而不是每次都整份传送，因此速度相当快。

- 可以镜像保存整个目录树和文件系统。
- 可以很容易做到保持原来文件的权限、时间、软硬链接等等。
- 无须特殊权限即可安装。
- 快速：第一次同步时 rsync 会复制全部内容，但在下一次只传输修改过的文件（）增量备份。rsync 在传输数据的过程中可以实行压缩及解压缩操作，因此可以使用更少的带宽。
- 安全：可以使用scp、ssh等方式来传输文件，当然也可以通过直接的socket连接。
- 支持匿名传输，以方便进行网站镜象。

**1、基本语法**

	rsync [OPTION]... SRC DEST
	rsync [OPTION]... SRC [USER@]host:DEST
	rsync [OPTION]... [USER@]HOST:SRC DEST
	rsync [OPTION]... [USER@]HOST::SRC DEST
	rsync [OPTION]... SRC [USER@]HOST::DEST
	rsync [OPTION]... rsync://[USER@]HOST[:PORT]/SRC [DEST]

对应于以上六种命令格式，rsync有六种不同的工作模式：

- 拷贝本地文件。当SRC和DES路径信息都不包含有单个冒号":"分隔符时就启动这种工作模式。如：rsync -a /data /backup
- 使用一个远程shell程序(如rsh、ssh)来实现将本地机器的内容拷贝到远程机器。当DST路径地址包含单个冒号":"分隔符时启动该模式。如：rsync -avz *.c foo:src
- 使用一个远程shell程序(如rsh、ssh)来实现将远程机器的内容拷贝到本地机器。当SRC地址路径包含单个冒号":"分隔符时启动该模式。如：rsync -avz foo:src/bar /data
- 从远程rsync服务器中拷贝文件到本地机。当SRC路径信息包含"::"分隔符时启动该模式。如：rsync -av root@192.168.78.192::www /databack
- 从本地机器拷贝文件到远程rsync服务器中。当DST路径信息包含"::"分隔符时启动该模式。如：rsync -av /databack root@192.168.78.192::www
- 列远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。如：rsync -v rsync://192.168.78.192/www

[rsync使用详细参阅](http://man.linuxde.net/rsync)

### 1.2 inotify简介及基本命令

inotify一种强大的、细粒度的、异步文件系统监控机制，它满足各种各样的文件监控需要，可以监控文件系统的访问属性、读写属性、权限属性、删除创建、移动等操作，也就是可以监控文件发生的一切变化。

inotify-tools是用c编写的，除了要求内核支持inotify外，不依赖于其他。inotify-tools提供两种工具，一是 inotifywait，它是用来监控文件或目录的变化，二是inotifywatch，它是用来统计文件系统访问的次数。

[inotify使用详细参阅](http://man.linuxde.net/inotifywait)

## 2、安装

### 2.1 基本需求及目标

操作系统：CentOS 7.X
源服务器：192.168.8.234 （服务器端）
目标服务器：192.168.8.120，192.168.8.121 （客户端）
目的：把源服务器上/home/test目录实时同步到目标服务器的/home/www下。

### 2.2 rsync客户端安装

**1、服务器端安装rsync（120、接收备份文件的服务器）**

	# 安装rsync服务
	[root@localhost sysshell]# yum install rsync
	# 网上说xinetd这个是启动rsync的、好像没啥用、可以考虑忽略
	[root@localhost sysshell]# yum install xinetd
	[root@localhost sysshell]# cd  /etc/xinetd.d/
	[root@localhost xinetd.d]# vim rsync
	disable = no
	[root@localhost xinetd.d]# service xinetd start

**2、rsync配置文件编辑**

	[root@localhost www]# vim /etc/rsyncd.conf
	# 通用配置文件
	# 日志文件位置，启动rsync后自动产生这个文件，无需提前创建
	log file = /var/log/rsyncd.log
	# pid文件的存放位置
	pidfile = /var/run/rsyncd.pid
	# 支持max connections参数的锁文件
	lock file = /var/run/rsync.lock
	# 用户认证配置文件，里面保存用户名称和密码，后面会创建这个文件
	secrets file = /etc/rsync.pass
	# rsync启动时欢迎信息页面文件位置（文件内容自定义）
	motd file = /etc/rsyncd.Motd
	
	# 模块配置
	# 自定义模块名称 shengguo
	[shengguo]
	# rsync服务端数据目录路径
	path = /home/www
	# 模块名称注释说明
	comment = shengguo_rsync
	# 设置rsync运行权限为root
	uid = root
	# 设置rsync运行组权限为root
	gid = root
	# 默认端口
	port=873
	# 默认为true，修改为no，增加对目录文件软连接的备份
	use chroot = no
	# 设置rsync服务端文件为读写权限
	read only = no
	# 不显示rsync服务端资源列表
	list = no
	# 最大连接数
	max connections = 200
	# 设置超时时间
	timeout = 600
	# 执行数据同步的用户名，可以设置多个，用英文状态下逗号隔开
	auth users = root,rsync,test
	# 允许进行数据同步的服务器端IP地址，可以设置多个，用英文状态下逗号隔开（可以用网段）
	hosts allow = 192.168.8.234,192.168.8.107
	# 禁止数据同步的客户端IP地址，可以设置多个，用英文状态下逗号隔开（可以用网段、可用*）
	hosts deny = 192.168.21.25

**3、创建用户认证文件**

	# 文件路径见上面的配置文件
	[root@localhost www]# vim /etc/rsync.pass
	# 格式，用户名:密码，可以设置多个，每行一个用户名:密码
	rsync:123456

**4、设置文件权限**

	# 设置文件所有者读取、写入权限
	chmod 600 /etc/rsyncd.conf
	# 设置文件所有者读取、写入权限（这个好像重要点、没进坑）
	chmod 600 /etc/rsync.pass

**5、启动rsync**

	# 我是这种方式启动
	rsync --daemon --config=/etc/rsyncd.conf
	# xinetd方式启动
	/etc/init.d/xinetd start    # 启动
	service xinetd stop         # 停止
	service xinetd restart      # 重新启动

### 2.3 rsync服务器端安装

**1、安装rsync（234、备份文件所在的服务器）**
	
	安装rsync服务，同上面。
	
**2、创建认证密码文件**

	[root@localhost www]# vim /etc/rsync.pass
	# 密码
	123456
	
	# 设置文件权限，只设置文件所有者具有读取、写入权限即可
	[root@localhost www]# chmod 600 /etc/rsync.pass

### 2.4 rsync同步文件简单测试

**1、同步指定文件（需要手动输入密码）**

	[root@localhost home]# rsync -avH --port=873 --progress /home/rsync.txt  root@192.168.8.120:/home/www

**2、同步指定文件或文件夹**

	[root@localhost home]# rsync -avH --port=873 --progress --password-file=/home/wwwroot/rsync-pass.txt /home/rsync.txt  root@192.168.8.120/home/www

### 2.5 服务器端安装inotify

最新文件参阅地址及下载地址从下面去找。

[inotify github地址](https://github.com/rvoicilas/inotify-tools/wiki)

[本版本inotify下载地址](http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz)

**1、下载及安装**

	[root@localhost local]# wget http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
	[root@localhost local]# tar -zxvf inotify-tools-3.14.tar.gz
	[root@localhost local]# cd inotify-tools-3.14/
	[root@localhost local]# ./configure --prefix=/usr/local/inotify
	[root@localhost local]# make && make install

**2、脚本编辑测试**

	[root@localhost local]# vim inotyfy.sh

	#!/bin/bash
	host=192.168.1.120
	src=/home/www
	des=web
	user=rsync
	/usr/local/inotify/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w %e %f' -e modify,delete,create,attrib \
	${src} | while read files
	do
	#    /usr/bin/rsync -vzrtopg --delete --progress --password-file=/usr/local/rsync/rsync.passwd ${src} ${user}@${host}::${des}
	#    echo "${files} was rsynced" >>/tmp/rsync.log 2>&1
	    echo ${files}
	done

脚本作用：尝试inotify的基本用法和验证脚本的某些功能，便于自定义改变脚本内容。

输出如是：

	[root@localhost www]# ./test.sh
	18-01-16 10:34 /home/www/ CREATE daocoder.txt
	18-01-16 10:34 /home/www/ ATTRIB daocoder.txt
	18-01-16 10:34 /home/www/ CREATE .daocoder.txt.swp
	18-01-16 10:34 /home/www/ CREATE .daocoder.txt.swx
	18-01-16 10:34 /home/www/ DELETE .daocoder.txt.swx
	18-01-16 10:34 /home/www/ DELETE .daocoder.txt.swp
	18-01-16 10:34 /home/www/ CREATE .daocoder.txt.swp
	18-01-16 10:34 /home/www/ MODIFY .daocoder.txt.swp
	18-01-16 10:34 /home/www/ ATTRIB .daocoder.txt.swp
	18-01-16 10:34 /home/www/ MODIFY .daocoder.txt.swp

**3、服务器端脚本编写**

	[root@localhost www]# vim inotyfy.sh

	#!/bin/bash
	
	# 待同步目录
	srcdir=/home/www/test/
	# 目标服务器rsync同步目录模块名称
	dstdir=shengguo
	# 不需要同步的目录，如果有多个，每一行写一个目录，使用相对于同步模块的路径；
	# 例如：不需要同步/home/www/test/目录下的a目录和b目录下面的b1目录，exclude.list文件可以这样写
	# a/
	# b/b1/
	excludedir=/usr/local/inotify/exclude.list
	# 目标服务器rsync同步用户名
	rsyncuser=rsync
	# 密码存放路径
	rsyncpassdir=/home/wwwroot/rsync-pass.txt
	# 目标服务器ip地址
	dstip="192.168.8.120"
	
	/usr/local/inotify/bin/inotifywait -mrq --timefmt '%y-%m-%d %H:%M' --format '%T %w %e %f' -e modify,delete,create,attrib ${srcdir} | while read file
	do
	    for ip in ${dstip}
	        do
	#            rsync -avH --port=873 --progress --delete --password-file=${rsyncpassdir} --exclude-from=${excludedir}  ${srcdir} ${rsyncuser}@${ip}::${dstdir}
	            rsync -avH --port=873 --progress --password-file=${rsyncpassdir}  ${srcdir} ${rsyncuser}@${ip}::${dstdir}
	            echo "${dstip} ${file} was rsynced" >> ./rsync.log 2>&1
	        done
	done


**4、inotify服务加入后台守护进程并开机自启动**

	# 编辑，在最后添加一行
	vi /etc/rc.d/rc.local
	# 设置开机自动在后台运行脚本
	sh /usr/local/inotify/inotyfy.sh &



## 3、爬坑概要

**1、rsync服务未启动**

	rsync: failed to connect to 192.168.1.144 (192.168.1.144): Connection refused (111)。

可能是rsync服务没启动，解决办法如下：

a、telnet 192.168.xxx.xxx 873  检测端口。

b、ps -aux | grep rsync 找找进程服务是否存在。

c、netstat -lunpt   查看服务的端口列表。

上面查看后没有rsync服务的话，手动启动rsync服务。

	[root@localhost local]# rsync --daemon --config=/etc/rsyncd.conf

**2、用户认证错误**

	Password:
	  @ERROR: auth failed on module shengguo
	  rsync error: error starting client-server protocol (code 5) at main.c(1516) [sender=3.0.9]

配置文件错误，两方面：一检查服务器端与客户端的密码文件配置，客户端是用户名:密码的形式，服务器端是直接密码；二检查配置文件注释不要与配置同行（我是这个坑）。


## 4、参考目录

[首推荐全局文件：rsync+inotify实现数据实时同步](http://www.osyunwei.com/archives/7435.html)



