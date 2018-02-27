# python升级导致yum无法使用

之前软件包练习时，对python进行了源码安装，版本得到了升级，今天忽然发现yum不能使用了下面是我遇到问题的过程及解决办法。

首先是执行yum命令时候开始报错了。

	[root@localhost daocoder]# yum list
	There was a problem importing one of the Python modules
	required to run yum. The error leading to this problem was:
	
	   No module named yum
	
	Please install a package which provides this module, or
	verify that the module is installed correctly.
	
	It's possible that the above module doesn't match the				注意到了这条信息
	current version of Python, which is:
	2.7.12 (default, Oct 13 2016, 10:42:06) 
	[GCC 4.8.2 20140120 (Red Hat 4.8.2-16)]
	
	If you cannot solve this problem yourself, please go to 
	the yum faq at:
	  http://yum.baseurl.org/wiki/Faq

信息里面提示说yum模块与现有的python版本不兼容。因yum是基于python编写的。

	[root@localhost daocoder]# rpm -qi yum
	Name        : yum
	Version     : 3.4.3
	Release     : 118.el7.centos
	Architecture: noarch
	Install Date: 2016年09月07日 星期三 04时39分27秒
	Group       : System Environment/Base
	Size        : 5741877
	License     : GPLv2+
	Signature   : RSA/SHA256, 2014年07月04日 星期五 13时52分58秒, Key ID 24c6a8a7f4a80eb5
	Source RPM  : yum-3.4.3-118.el7.centos.src.rpm


	[root@localhost daocoder]# rpm -qi python
	Name        : python
	Version     : 2.7.5
	Release     : 16.el7
	Architecture: x86_64
	Install Date: 2016年09月07日 星期三 04时36分20秒
	Group       : Development/Languages
	Size        : 80835
	License     : Python
	Signature   : RSA/SHA256, 2014年07月04日 星期五 12时38分03秒, Key ID 24c6a8a7f4a80eb5
	Source RPM  : python-2.7.5-16.el7.src.rpm
	Build Date  : 2014年06月18日 星期三 02时43分58秒
	Build Host  : worker1.bsys.centos.org
	Relocations : (not relocatable)
	Packager    : CentOS BuildSystem <http://bugs.centos.org>
	Vendor      : CentOS
	URL         : http://www.python.org/
	Summary     : An interpreted, interactive, object-oriented programming language

	[root@localhost daocoder]# whereis python
	python: /usr/bin/python /usr/bin/python2.7 /usr/bin/python2.7-config 
	/usr/lib/python2.7 /usr/lib64/python2.7 /usr/include/python2.7 /usr/share/man/man1/python.1.gz

这里面可以可以看出python有2个版本，一个是系统默认的/usr/bin/python ,一个是我自己安装的/usr/bin/python2.7 。

当初学软件安装的煞笔事件就将在下面展现了。

	[root@localhost bin]# cd /usr/bin
	[root@localhost bin]# ls -l | grep 'python'
	-rwxr-xr-x.   1 root root       11216 6月  19 2014 abrt-action-analyze-python
	lrwxrwxrwx.   1 root root          32 10月 13 10:55 python -> /usr/local/src/python/bin/python
	lrwxrwxrwx.   1 root root           9 9月   7 04:36 python2 -> python2.7
	-rwxr-xr-x.   1 root root        7136 6月  18 2014 python2.7
	-rwxr-xr-x.   1 root root        1835 6月  18 2014 python2.7-config
	lrwxrwxrwx.   1 root root          16 9月   7 04:37 python2-config -> python2.7-config
	lrwxrwxrwx.   1 root root          14 9月   7 04:37 python-config -> python2-config

这里看到/usr/bin/python是指向/usr/local/src/python/bin/python这个命令的，我们下面再进去。

	[root@localhost bin]# cd /usr/local/src/python/
	[root@localhost python]# cd bin
	[root@localhost bin]# ls -l
	总用量 8044
	-rwxr-xr-x. 1 root root     112 10月 13 10:43 2to3
	-rwxr-xr-x. 1 root root     110 10月 13 10:43 idle
	-rwxr-xr-x. 1 root root      95 10月 13 10:43 pydoc
	lrwxrwxrwx. 1 root root       7 10月 13 10:44 python -> python2
	lrwxrwxrwx. 1 root root       9 10月 13 10:44 python2 -> python2.7
	-rwxr-xr-x. 1 root root 8198005 10月 13 10:43 python2.7
	-rwxr-xr-x. 1 root root    1698 10月 13 10:44 python2.7-config
	lrwxrwxrwx. 1 root root      16 10月 13 10:44 python2-config -> python2.7-config
	lrwxrwxrwx. 1 root root      14 10月 13 10:44 python-config -> python2-config
	-rwxr-xr-x. 1 root root   18558 10月 13 10:43 smtpd.py


我们又发现/usr/local/src/python/bin/python这个命令是指向python2的。

最终看出来执行/usr/bin/python执行的是这个命令usr/bin/python2，但是usr/bin/python2是指向usr/bin/python2.7的，别问我哪来这么多弯子，我也晕晕的。我当初的想法好像就是只讲将python命令指向新版本的python2.7。

我现在的python版本是2.7，yum现在也是默认指向这个版本导致不能使用了。

然后我编辑了下 /usr/bin/yum 文件,原本首行是这样的#!/usr/bin/python，然后我改成这样了#!/usr/bin/python2.7，再然后再运行yum好像自动更新了下，再就能使用了，what the fuck，are you kidding me？反正我是晕了。

其他解决办法还是建议去网上看吧。

这样[ python升级导致yum命令无法使用的解决办法](http://blog.csdn.net/ei__nino/article/details/8495295)。

这样[python升级安装之后yum的修复 ](http://blog.chinaunix.net/uid-26000296-id-4357691.html)。


我还是继续学习吧。





