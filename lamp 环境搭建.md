<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# LAMP 环境源码编译安装

# 1、相关软件包的下载

[apache 下载](http://httpd.apache.org/download.cgi)

[apr、apr_util源码包下载地址](http://apr.apache.org/download.cgi)

[pcre 下载地址](https://sourceforge.net/projects/pcre/files/)

[PHP 下载地址](http://www.php.net/downloads.php)

[mysql源码包下载地址，进去下拉 source code ](http://dev.mysql.com/downloads/mysql/)


已下载的安装包。

	[root@localhost src]# ls -al
	总用量 164516
	drwxr-xr-x.  4 root root      4096 11月 14 11:11 .
	drwxr-xr-x. 12 root root      4096 9月   7 04:33 ..
	-rw-r--r--.  1 root root   1031613 4月  29 2015 apr-1.5.2.tar.gz
	-rw-r--r--.  1 root root    874044 9月  20 2014 apr-util-1.5.4.tar.gz
	-rw-r--r--.  1 root root   8406575 7月   5 03:50 httpd-2.4.23.tar.gz
	-rw-r--r--.  1 root root 141638761 9月  29 22:58 mysql-community-5.7.16-1.el6.src.rpm
	drwxr-xr-x.  5 root root        38 10月 10 11:10 nmap
	-rw-r--r--.  1 root root   1257162 11月 14 10:51 pcre-8.31.tar.bz2
	-rw-r--r--.  1 root root  15239442 11月 14 11:11 php-7.0.13.tar.bz2
	drwxr-xr-x.  6 root root        52 10月 13 10:44 python

相关软件卸载

	[root@localhost src]# yum -y remove httpd
	
	[root@localhost src]# yum -y remove mysql
	
	[root@localhost src]# yum -y remove mysql-server
	
	[root@localhost src]# yum -y remove php
	
	[root@localhost src]# yum -y remove php-mysql

selinux暂时禁用

	[root@localhost src]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# 2、apache 软件的安装

先附参考网页，感谢。[ apache 的安装](http://www.jb51.net/article/59474.htm)，[apache 的安装详解](http://www.linuxidc.com/Linux/2016-10/136156.htm)。

## 2.1 安装 apr

	[root@localhost ~]# cd /usr/local/src/
	[root@localhost src]# tar xf apr-1.5.2.tar.gz
	[root@localhost src]# cd apr-1.5.2
	[root@localhost apr-1.5.2]# ./configure --prefix=/usr/local/apr
	[root@localhost apr-1.5.2]# make && make install

## 2.2 安装 apr-util

	[root@localhost ~]# cd /usr/local/src/
	[root@localhost src]# tar xf apr-util-1.5.4.tar.gz
	[root@localhost src]# cd apr-util-1.5.4
	[root@localhost apr-util-1.5.4]# ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
	[root@localhost apr-util-1.5.4]# make && make install

## 2.3 安装 pcre

	[root@localhost apr-util-1.5.4]# cd /usr/local/src/
	[root@localhost src]# tar xf pcre-8.31.tar.bz2 
	[root@localhost src]# cd pcre-8.31
	[root@localhost pcre-8.37]# ./configure --prefix=/usr/local/pcre
	[root@localhost pcre-8.37]# make && make install

## 2.4 安装 Apache2.4.23

	[root@localhost src]# tar xf httpd-2.4.23.tar.bz2 
	[root@localhost src]# cd httpd-2.4.23
	[root@localhost httpd-2.4.23]# ./configure --prefix=/usr/local/apache24 --sysconfdir=/etc/httpd --enable-so --enable-rewrite --enable-ssl --with-pcre=/usr/local/pcre --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util
	[root@localhost httpd-2.4.23]# make && make install

## 2.5 apache的初始化

	[root@localhost httpd-2.4.16]# /bin/cp /usr/local/apache2/bin/apachectl /etc/init.d/httpd
	[root@localhost httpd-2.4.16]# groupadd apache 												添加apache用户组及用户
	[root@localhost httpd-2.4.16]# useradd -g apache -s /usr/sbin/nologin apache
	[root@localhost httpd-2.4.16]# chown -R apache:apache /usr/local/apache24
	[root@localhost httpd-2.4.16]# chmod +x /etc/init.d/apache24

## 2.6 apache 加入系统服务

为了使 apache 开机启动，我们可以把 apachectl 启动脚本加入 rc.local 文件中，如下：

	[root@localhost init.d]# echo "/usr/local/apache24/bin/apachectl start" >> /etc/rc.local 
	[root@localhost init.d]# cat /etc/rc.local 
	#!/bin/bash
	# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
	#
	# It is highly advisable to create own systemd services or udev rules
	# to run scripts during boot instead of using this file.
	#
	# In constrast to previous versions due to parallel execution during boot 
	# this script will NOT be run after all other services.
	#  
	# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
	# that this script will be executed during boot.
	
	touch /var/lock/subsys/local
	/usr/local/apache24/bin/apachectl start

我们也可以通过把apache加入系统服务，来启动apache。把apache添加为系统服务有两种方法，第一种是通过chkconfig进行添加，第二种是直接添加系统的各个启动级别。

我们先来介绍第一种方法，修改启动httpd脚本加入如下两行命令，如下：

	[root@localhost init.d]# vim httpd 
	
	#!/bin/sh
	#
	# chkconfig: 2345 70 60
	# description:apache start script

tips：
上面不是注释，chkconfig: 2345 70 60中的2345是指脚本的运行级别，即在2345这4种模式下都可以运行，234都是文本界面，5是图形界面X。
70是指脚本将来的启动顺序号，如果别的程序的启动顺序号比70小（比如44、45），则脚本需要等这些程序都启动以后才启动。60是指系统关闭时，脚本的停止顺序号。默认network的是：2345 10 90。

	Linux系统有7个运行级别(runlevel)
	运行级别0：系统停机状态，系统默认运行级别不能设为0，否则不能正常启动
	运行级别1：单用户工作状态，root权限，用于系统维护，禁止远程登陆
	运行级别2：多用户状态(没有NFS)
	运行级别3：完全的多用户状态(有NFS)，登陆后进入控制台命令行模式
	运行级别4：系统未使用，保留
	运行级别5：X11控制台，登陆后进入图形GUI模式
	运行级别6：系统正常关闭并重启，默认运行级别不能设为6，否则不能正常启动

使用chkconfig进行添加，如下：

	[root@localhost init.d]# chkconfig --add httpd			 							增加执行权限
	[root@localhost init.d]# chkconfig --level 2345 httpd on  							设置开机启动
	[root@localhost init.d]# chkconfig --list httpd   									查看是否设置成功
	httpd          	0:关	1:关	2:开	3:开	4:开	5:开	6:关


## 2.7 测试

	[root@localhost httpd]# wget http://192.168.0.31									这个ip是我的虚拟机动态获得ip地址
	--2016-11-15 08:53:49--  http://192.168.0.31/
	正在连接 192.168.0.31:80... 已连接。
	已发出 HTTP 请求，正在等待回应... 200 OK
	长度：45 [text/html]
	正在保存至: “index.html”
	
	100%[====================================================>] 45          --.-K/s 用时
	
	2016-11-15 08:53:49 (5.44 MB/s) - 已保存 “index.html” [45/45])

然后客户端浏览器地址栏输入：192.168.0.31。

![apache 测试图](http://i.imgur.com/J9z1nTs.png)

# 3、PHP 软件的安装

## 3.1 安装PHP依赖包

PHP的安装安装依赖的包libxml2，libxml2-devel。如果没有安装的话，在安装php过程中会出现如下的错误：configure: error: xml2-config not found. Please check your libxml2 installation。

所以先用yum安装好依赖的包：

yum install libxml2
yum install libxml2-devel

	[root@localhost system]# yum list | grep 'libxml*'
	file:///mnt/centos7/repodata/repomd.xml: [Errno 14] curl#37 - "Couldn't open file /mnt/centos7/repodata/repomd.xml"
	正在尝试其它镜像。
	libxml2.x86_64                          2.9.1-5.el7                    @anaconda
	libxml2-devel.x86_64                    2.9.1-5.el7                    @anaconda
	libxml2-python.x86_64                   2.9.1-5.el7                    @anaconda
	perl-libxml-perl.noarch                 0.08-19.el7                    @anaconda
	libxml2.i686                            2.9.1-6.el7_2.3                updates  
	libxml2.x86_64                          2.9.1-6.el7_2.3                updates  
	libxml2-devel.i686                      2.9.1-6.el7_2.3                updates  
	libxml2-devel.x86_64                    2.9.1-6.el7_2.3                updates  
	libxml2-python.x86_64                   2.9.1-6.el7_2.3                updates  
	libxml2-static.i686                     2.9.1-6.el7_2.3                updates  
	libxml2-static.x86_64                   2.9.1-6.el7_2.3                updates  
	pentaho-libxml.noarch                   1.1.3-10.el7                   base     
	pentaho-libxml-javadoc.noarch           1.1.3-10.el7                   base  

	[root@localhost system]# yum install libxml2.x86_64 
	...	
	更新完毕:
	  libxml2.x86_64 0:2.9.1-6.el7_2.3                                                
	作为依赖被升级:
	  libxml2-devel.x86_64 0:2.9.1-6.el7_2.3  libxml2-python.x86_64 0:2.9.1-6.el7_2.3 
	完毕！
	[root@localhost system]# yum install libxml2-devel.x86_64 
	软件包 libxml2-devel-2.9.1-6.el7_2.3.x86_64 已安装并且是最新版本


## 3.2 安装PHP

	[root@localhost src]# tar -xvf php-7.0.13.tar.bz2 						解压php安装包

	[root@localhost php-7.0.13]# ./configure --prefix=/usr/local/php7 --with-apxs2=/usr/local/apache24/bin/apxs
	--prefix=/usr/local/php									指定安装目录
	--with-asp2=/usr/local/apache24/bin/asp					使apache能解析php页面，不加只能解析php页面,加了会生成libphp7.so
	[root@localhost php-7.0.13]# make
	[root@localhost php-7.0.13]# make test
	[root@localhost php-7.0.13]# make install

	[root@localhost php]# cp /usr/local/src/php-7.0.13/php.ini-development  /usr/local/php/lib/php.ini


# 4、apache 与 php 的测试

	[root@localhost bin]# /usr/local/php7/bin/php -v
	PHP 7.0.13 (cli) (built: Nov 15 2016 10:47:54) ( NTS )
	Copyright (c) 1997-2016 The PHP Group
	Zend Engine v3.0.0, Copyright (c) 1998-2016 Zend Technologies

## 4.1 修改apache的配置文件

	[root@localhost httpd]# vim httpd.conf 										apache的配置文件，一般在指定安装目录/httpd/httpd.conf
	
	<IfModule mod_php7.c>														加入这些代码
	    AddType application/x-httpd-php .php									解析php文件
	    AddType application/x-httpd-php .php3 .inc phtml						解析这些后缀的文件
	    AddType application/x-httpd-php-source .phps							直接展示源码
	</IfModule>

	<IfModule dir_module>														这里加入index.php，原先没有的
	    DirectoryIndex index.html index.php
	</IfModule>

改完之后，重启apache。

	[root@localhost apache24]# /etc/init.d/httpd -k restart							这是我自己的安装目录

## 4.1 测试

apache指定安装目录下，切换文件加到htdocs目录，然后新建index.php文件测试。

	[root@localhost htdocs]# vim index.php 
	
	<?php
	    phpinfo();

![php+apache测试](http://i.imgur.com/TqjueuL.png)

# 5、redis的安装

[redis下载安装地址](https://redis.io/)。

我装的时候没注意留图、参见下面链接吧。

[linux详细redis安装和php中redis扩展](https://www.cnblogs.com/sss-justdDoIt/p/5632004.html)。

然后在php对redis扩展的问题时遇到点问题。

	致命错误：ext/standard/php_smart_str.h：没有那个文件或目录					就是这个东西

[先看下相关的问题，它没解决我的问题，不过确实PHP7对相关的文件命名更改了](http://www.bubuko.com/infodetail-1270231.html)。

然后再找PHP7对redis扩展模块加载的相关网页。

[这个详细点](http://www.cnblogs.com/GaZeon/p/5422078.html)。这里面不知道autoconfig

[这个简单点、不过他写的里面配置redis时路径错误、注意下](http://blog.csdn.net/sinat_20415509/article/details/52295395)。

然后安装phpredis安装完成继续参见[linux详细redis安装和php中redis扩展](https://www.cnblogs.com/sss-justdDoIt/p/5632004.html)。

这中间还会涉及到这个问题、即如何让对已安装好的PHP进行动态扩展添加。就是这么个问题：编译php时忘记添加某扩展，后来想添加扩展，比如redis，然后php提供了这么个功能。

	/usr/local/php/bin/phpize				这是一个可执行文件。

phpize的作用可以这样理解：侦测环境(phpize工具是在php安装目录下,基于这点phpize对应了当时的php环境，所以是要根据该php的配置情况生成对应的configure文件)，建立一个configure文件。必须在一个目录下去运行phpize。那么phpize就知道你的的环境是哪个目录，并且configure文件建立在该目录下。

所以我们在安装phpredis时，有这么一步，切到他的目录下执行：/usr/local/php/bin/phpize ，这中间需要依赖于一个叫autoconf的安装包，一样是安装下就好，省略。

再说下，make install会自动将生成的.so扩展复制到php的扩展目录下去，之后修改配置文件就好。

再下面我就安装成功了。

![phpredis截图](http://i.imgur.com/mPzE9Pp.png)











	









