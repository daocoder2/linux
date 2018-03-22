<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# python web服务器环境搭建

服务器为cnetos7，以下环境以此为基准。

# 1、安装python3并与python2共存

## 1.1 python检测

centos7默认安装了 python2.7.5 因为一些命令要用它比如yum，它使用的是python2.7.5。

使用 python -V 命令查看一下是否安装Python。

	[root@localhost bin]# python -V
	Python 2.7.5

然后使用命令 which python 查看一下Python可执行文件的位置。

	[root@localhost bin]# which python
	/usr/bin/python
	[root@localhost bin]# cd /usr/bin/
	[root@localhost bin]# ll py*
	lrwxrwxrwx. 1 root root    7 4月   8 2017 python -> python2
	lrwxrwxrwx. 1 root root    9 4月   8 2017 python2 -> python2.7
	-rwxr-xr-x. 1 root root 7136 6月  18 2014 python2.7

python 指向的是python2.7。因为我们要安装python3版本，所以python要指向python3才行。

先yum安装必要的包，用于下载编译python3。

	[root@localhost bin]# yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

安装后防止错误，先做备份：

	[root@localhost bin]# mv python python.bak
	[root@localhost bin]# ll pytho*
	lrwxrwxrwx. 1 root root    9 4月   8 2017 python2 -> python2.7
	-rwxr-xr-x. 1 root root 7136 6月  18 2014 python2.7
	lrwxrwxrwx. 1 root root    7 4月   8 2017 python.bak -> python2

## 1.2 安装python3

获取安装包。

	[root@localhost ~]# wget https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz

解压。

	[root@localhost ~]# tar -xvJf  Python-3.6.4.tar.xz

切进目录。

	[root@localhost ~]# cd Python-3.6.4/

编译，安装。

	[root@localhost Python-3.6.4]# ./configure prefix=/usr/local/python3
	[root@localhost Python-3.6.4]# make && make install

安装完毕，/usr/local/目录下就会有python3了。

	[root@localhost Python-3.6.4]# cd /usr/local/python3/
	[root@localhost python3]# ll
	总用量 4
	drwxr-xr-x 2 root root 4096 3月  21 18:37 bin
	drwxr-xr-x 3 root root   23 3月  21 18:37 include
	drwxr-xr-x 4 root root   60 3月  21 18:37 lib
	drwxr-xr-x 3 root root   16 3月  21 18:37 share

然后我们可以添加软链到执行目录下/usr/bin。

	[root@localhost Python-3.6.4]# ln -s /usr/local/python3/bin/python3 /usr/bin/python

同时pip也建立一个软连接。

	[root@localhost bin]# ln -s /usr/local/python3/bin/pip3 /usr/bin/pip

然后软连接创建完成，查看当前python版本。

	[root@localhost python3]# python -V
	Python 3.6.4
	[root@localhost python3]# python2 -V
	Python 2.7.5
	[root@localhost python3]# cd /usr/bin/
	[root@localhost bin]# ll python*
	lrwxrwxrwx  1 root root   30 3月  21 18:40 python -> /usr/local/python3/bin/python3
	lrwxrwxrwx. 1 root root    9 4月   8 2017 python2 -> python2.7
	-rwxr-xr-x. 1 root root 7136 6月  18 2014 python2.7

最后因为执行yum需要python2的版本，所以我们还要修改yum的配置。

	[root@localhost bin]# vim /usr/bin/yum
	把#!/usr/bin/python 修改为 #!/usr/bin/python2

同理。

	[root@localhost bin]# vim /usr/libexec/urlgrabber-ext-down

这样python3版本就安装完成，同时python2也存在。

# 2、uwigi安装

这个很坑，老司机弯都转不过来。

坑如下：

说是在基于Debian的发行版上要安装依赖，依赖么，我懂的。

	apt-get install build-essential python-dev

然后我去找centos版本的相关依赖。

然后下面这样，python-dev的包在centos的yum中不叫python-dev,而是python-devel.

	[root@localhost local]# yum install python-devel

然后build-essential对应的工具说是下面这样。

	[root@localhost local]# yum groupinstall "Development Tools" 

然后centos警告错误啊。

	[root@localhost local]# yum groupinstall "Development Tools"
	已加载插件：fastestmirror, langpacks
	没有安装组信息文件
	Maybe run: yum groups mark convert (see man yum)
	Loading mirror speeds from cached hostfile
	 * base: mirrors.cn99.com
	 * extras: mirrors.163.com
	 * updates: mirrors.nju.edu.cn
	警告：分组 development 不包含任何可安装软件包。
	Maybe run: yum groups mark install (see man yum)
	指定组中没有可安装或升级的软件包

大家都是如是说：[警告：分组 development 不包含任何可安装软件包。](https://www.cnblogs.com/himismad/p/7953433.html)

尼玛，然后我就把这么说的全部包都安装了，两列，必要项和可选项。

	[root@localhost local]# yum install ElectricFence ant babel bzr chrpath cmake compat-gcc-44 compat-gcc-44-c++ cvs dejagnu expect gcc-gnat gcc-objc gcc-objc++ imake javapackages-tools ksc libstdc++-docs  mercurial mod_dav_svn nasm perltidy python-docs rpmdevtools rpmlint systemtap-sdt-devel systemtap-server
	
	[root@localhost local]# yum install autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build rpm-sign

安装后装uwsgi，用pip方式。

	[root@localhost local]# pip install uwsgi

fuck，装完没可执行命令啊。

	[root@localhost local]# uwsgi
	bash: uwsgi: 未找到命令...

然后下面一顿倒腾，甚至py3我都重装了，车毁人亡。

最后不得已还是求助官档吧。

[获取uwsgi](http://uwsgi-docs-zh.readthedocs.io/zh_CN/latest/WSGIquickstart.html)

正确方法就是这句，使用网络安装器：

	curl http://uwsgi.it/install | bash -s default /usr/local/uwsgi

卧槽了，吃枣药丸。继续前进！

# 3、nginx安装

以前直接用lnmp跑的站，然后有现成的，修修改改直接跑。

nignx配置文件：

	server
	{
	    listen 80 default_server;
	    server_name daocoder.ccom;
	    location /
	    {
	        include        uwsgi_params;
	        uwsgi_pass     127.0.0.1:8001;
	    }
	}

# 4、集成

## 4.1 nginx+uwsgi配置

之前nginx配置文件已有。

	server
	{
	    listen 80 default_server;
	    server_name daocoder.ccom;
	    location /
	    {
	        include        uwsgi_params;
	        uwsgi_pass     127.0.0.1:8001;
	    }
	}

下面uwsgi跑起来，编辑配置文件，那里创建都行，我是直接放在flask项目目录下创建uwsgi.ini内容如下：

	[uwsgi]
	# 启动程序时所使用的地址和端口，通常在本地运行flask项目，地址和端口是127.0.0.1:5000
	# 不过在服务器上是通过uwsgi设置端口，通过uwsgi来启动项目，也就是说启动了uwsgi，也就启动了项目
	socket = 127.0.0.1:8001
	# 项目目录
	# chdir = /home/wwwroot/flask/
	# flask程序的启动文件，通常在本地是通过运行 python manage.py runserver 来启动项目的
	wsgi-file = /home/wwwroot/flask/app.py
	# 程序内启用的application变量名
	callable = app
	# 处理器个数
	processes = 2
	# 线程个数
	threads = 2
	# 获取uwsgi统计信息的服务地址
	stats = 127.0.0.1:9191

## 4.2 flask项目

先下载flask。

	[root@localhost flask]# pip install flask

我的路径是：

	[root@localhost flask]# pwd
	/home/wwwroot/flask

此文件加创建文件如下：

	flask
		- templates/
			- index.html
		- app.py
		- uwsgi.ini
		
app.py文件内容：

	#! /usr/bin/python
	# -*- coding:utf-8 -*-
	
	from flask import Flask, render_template
	
	app = Flask(__name__)
	
	
	@app.route('/')
	def index():
	    return render_template('index.html')
	
	
	if __name__ == '__main__':
	    app.run()

templates/index.html的内容：

	<!DOCTYPE html>
	<html lang="en">
	<head>
	    <meta charset="UTF-8">
	    <title>flask</title>
	</head>
	<body>
	    <div>hello daocoder</div>
	</body>
	</html>

uwsgi.ini的内容在前面已有。

完了后，nginx重新启动，uwsgi跑起来。

	[root@localhost flask]# service nginx restart 
	[root@localhost flask]# uwsgi uwsgi.ini 

最后浏览器访问你的服务器，bingo。

再一个问题在于uwsgi于前台进行，无法后台跑，有说emperor参数，我没尝试，下面会使用supervisor来改变这方式。

# 5 安装配置supervisor

## 5.1 安装supervisor

尝试直接安装，成功后可直接到配置下一节。

	[root@localhost flask]# pip install supervisor

下面是我遇到的坑。

第一次失败。

	[root@localhost flask]# pip install supervisor
	Collecting supervisor
	  Downloading supervisor-3.3.4.tar.gz (419kB)
	    100% |████████████████████████████████| 419kB 5.1kB/s 
	    Complete output from command python setup.py egg_info:
	    Supervisor requires Python 2.4 or later but does not work on any version of Python 3.  You are using version 3.6.2 (default, Mar 22 2018, 07:59:08)
	    [GCC 4.8.5 20150623 (Red Hat 4.8.5-16)].  Please install using a supported version.
	    
	    ----------------------------------------
	Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-1n5dvn1g/supervisor/


好像不支持python3，那就yum安装。

	[root@localhost flask]# yum install supervisor
	已加载插件：fastestmirror, langpacks
	Loading mirror speeds from cached hostfile
	 * base: mirrors.cn99.com
	 * extras: mirrors.163.com
	 * updates: mirrors.nju.edu.cn
	没有可用软件包 supervisor。
	错误：无须任何处理
	[root@localhost flask]# yum info supervisor
	已加载插件：fastestmirror, langpacks
	Loading mirror speeds from cached hostfile
	 * base: mirrors.cn99.com
	 * extras: mirrors.163.com
	 * updates: mirrors.nju.edu.cn
	错误：没有匹配的软件包可以列出

无解，那就用python2指定pip安装。

	[root@localhost bin]# python2 -m pip install supervisor
	/usr/bin/python2: No module named pip

无力吐槽，原系统用的好像还是easy_install把管理工具这个，表示从来没用过。那就软连接先切回python2的版本再利用这个工具安装supervisor。

	[root@localhost bin]# easy_install supervisor
	Searching for supervisor
	Reading https://pypi.python.org/simple/supervisor/
	Best match: supervisor 3.3.4
	Downloading https://pypi.python.org/packages/44/60/698e54b4a4a9b956b2d709b4b7b676119c833d811d53ee2500f1b5e96dc3/supervisor-3.3.4.tar.gz#md5=f1814d71d820ddfa8c86d46a72314cec
	Processing supervisor-3.3.4.tar.gz
	Writing /tmp/easy_install-aL9rb7/supervisor-3.3.4/setup.cfg
	Running supervisor-3.3.4/setup.py -q bdist_egg --dist-dir /tmp/easy_install-aL9rb7/supervisor-3.3.4/egg-dist-tmp-_eRZYl
	warning: no previously-included files matching '*' found under directory 'docs/.build'
	Adding supervisor 3.3.4 to easy-install.pth file
	Installing echo_supervisord_conf script to /usr/bin
	Installing pidproxy script to /usr/bin
	Installing supervisorctl script to /usr/bin
	Installing supervisord script to /usr/bin
	
	Installed /usr/lib/python2.7/site-packages/supervisor-3.3.4-py2.7.egg
	Processing dependencies for supervisor
	Searching for meld3>=0.6.5
	Reading https://pypi.python.org/simple/meld3/
	Best match: meld3 1.0.2
	Downloading https://pypi.python.org/packages/45/a0/317c6422b26c12fe0161e936fc35f36552069ba8e6f7ecbd99bbffe32a5f/meld3-1.0.2.tar.gz#md5=3ccc78cd79cffd63a751ad7684c02c91
	Processing meld3-1.0.2.tar.gz
	Writing /tmp/easy_install-WgVnBv/meld3-1.0.2/setup.cfg
	Running meld3-1.0.2/setup.py -q bdist_egg --dist-dir /tmp/easy_install-WgVnBv/meld3-1.0.2/egg-dist-tmp-fZ0vyo
	zip_safe flag not set; analyzing archive contents...
	Adding meld3 1.0.2 to easy-install.pth file
	
	Installed /usr/lib/python2.7/site-packages/meld3-1.0.2-py2.7.egg
	Finished processing dependencies for supervisor

安装完了，然后当然是切回来python3的版本了，下面是py2切回py3的操作。

	[root@localhost bin]# ll pytho*
	lrwxrwxrwx. 1 root root    7 4月   8 2017 python -> python2
	lrwxrwxrwx  1 root root    9 3月  21 19:41 python2 -> python2.7
	-rwxr-xr-x  1 root root 7136 8月   4 2017 python2.7
	lrwxrwxrwx  1 root root   30 3月  22 08:04 python3.bak -> /usr/local/python3/bin/python3
	[root@localhost bin]# mv python python2.bak
	[root@localhost bin]# ll pytho*
	lrwxrwxrwx  1 root root    9 3月  21 19:41 python2 -> python2.7
	-rwxr-xr-x  1 root root 7136 8月   4 2017 python2.7
	lrwxrwxrwx. 1 root root    7 4月   8 2017 python2.bak -> python2
	lrwxrwxrwx  1 root root   30 3月  22 08:04 python3.bak -> /usr/local/python3/bin/python3
	[root@localhost bin]# mv python3.bak python
	[root@localhost bin]# ll pytho*
	lrwxrwxrwx  1 root root   30 3月  22 08:04 python -> /usr/local/python3/bin/python3
	lrwxrwxrwx  1 root root    9 3月  21 19:41 python2 -> python2.7
	-rwxr-xr-x  1 root root 7136 8月   4 2017 python2.7
	lrwxrwxrwx. 1 root root    7 4月   8 2017 python2.bak -> python2


**这里发现确实pip安装后可能生成不了可执行命令，未找到相应答案去提了个问题[pip安装模块后没有生成相应的可执行命令](https://github.com/pypa/pip/issues/5107)。当然这是臆断的，可能是我自己的服务器环境问题。以后估计还是要踩这个坑。**


## 5.2 配置supervisor

因为上面的包是安装在py2里面的，所以不能直接跑。

编辑下/usr/bin/supervisord。

	#!/usr/bin/python 改成 #!/usr/bin/python2

同理修改这几个命令文件：/usr/bin/echo_supervisord_conf、/usr/bin/supervisorctl。

[官档 supervisor](http://www.supervisord.org/running.html)

都改完了，先看写帮助。

	[root@localhost bin]# supervisord -h
	supervisord -- run a set of applications as daemons.
	
	Usage: /usr/bin/supervisord [options]
	
	Options:
	-c/--configuration FILENAME -- configuration file path (searches if not given)
	-n/--nodaemon -- run in the foreground (same as 'nodaemon=true' in config file)
	-h/--help -- print this usage message and exit
	-v/--version -- print supervisord version number and exit
	-u/--user USER -- run supervisord as this user (or numeric uid)
	-m/--umask UMASK -- use this umask for daemon subprocess (default is 022)
	-d/--directory DIRECTORY -- directory to chdir to when daemonized
	-l/--logfile FILENAME -- use FILENAME as logfile path
	-y/--logfile_maxbytes BYTES -- use BYTES to limit the max size of logfile
	-z/--logfile_backups NUM -- number of backups to keep when max bytes reached
	-e/--loglevel LEVEL -- use LEVEL as log level (debug,info,warn,error,critical)
	-j/--pidfile FILENAME -- write a pid file for the daemon process to FILENAME
	-i/--identifier STR -- identifier used for this instance of supervisord
	-q/--childlogdir DIRECTORY -- the log directory for child process logs
	-k/--nocleanup --  prevent the process from performing cleanup (removal of
	                   old automatic child log files) at startup.
	-a/--minfds NUM -- the minimum number of file descriptors for start success
	-t/--strip_ansi -- strip ansi escape codes from process output
	--minprocs NUM  -- the minimum number of processes available for start success
	--profile_options OPTIONS -- run supervisord under profiler and output
	                             results based on OPTIONS, which  is a comma-sep'd
	                             list of 'cumulative', 'calls', and/or 'callers',
	                             e.g. 'cumulative,callers')

然后这里说明下supervisor这个工具会在运行时，跑两个进程。一个是作为后台运行的服务`supervisord`，另一个是客户端`supervisorctl`用来交互`supervisord`。

至此大概说完，下面开始配置supervisord。

1、创建默认的配置文件。

	[root@localhost bin]# echo_supervisord_config > /etc/supervisord.conf

配置文件具体可参考[CentOS7下Supervisor安装与配置](https://www.linuxidc.com/Linux/2017-02/140417.htm)。

官档[Supervisor配置](http://www.supervisord.org/configuration.html)。

2、修改/etc/supervisord.conf文件

直接找到最下面的这个。

	[include]									# 这里的‘;’注释去掉
	;files = relative/directory/*.ini
	files = /etc/supervisor/conf.d/*.conf		# 这里加入自定义的配置文件文件路径

3、创建自定义文件配置文件夹

	[root@localhost etc]# mkdir -p supervisor/conf.d
	[root@localhost etc]# cd supervisor/conf.d
	[root@localhost conf.d]# vim uwsgi.cof
	; ================================
	;  uwsgi supervisor
	; ================================
	
	[program:uwsgi]
	command=/usr/bin/uwsgi --ini /home/wwwroot/flask/uwsgi.ini
	directory=/home/wwwroot/flask
	user=root
	stdout_logfile=/var/log/flask/uwsgi_out.log
	stderr_logfile=/var/log/flask/uwsgi_err.log
	autostart=true
	autorestart=true
	startsecs=10
	priority=997

结合自己的项目修修改改就好了。

都设置完了，下面跑起来吧。

	[root@localhost supervisor]# killall supervisord
	# -c指定配置文件路径，-n可前台运行，方便自己调试，具体自己去看官档
	[root@localhost supervisor]# /usr/bin/supervisord -c /etc/supervisord.conf
	
然后看看跑起来没。

	[root@localhost supervisor]# ps -aux | grep supervisord
	root     16454  0.0  0.1 217868 10952 ?        Ss   13:12   0:00 /usr/bin/python2 /usr/bin/supervisord -c /etc/supervisord.conf
	root     16633  0.0  0.0 112660   972 pts/1    S+   13:24   0:00 grep --color=auto supervisord

再看看uwsgi跑起来没。

	[root@localhost supervisor]# ps -aux | grep uwsgi
	root     16556  0.0  0.3 242740 22764 ?        S    13:15   0:00 /usr/bin/uwsgi --ini /home/wwwroot/flask/uwsgi.ini
	root     16558  0.0  0.3 316728 18860 ?        Sl   13:15   0:00 /usr/bin/uwsgi --ini /home/wwwroot/flask/uwsgi.ini
	root     16559  0.0  0.3 316728 18860 ?        Sl   13:15   0:00 /usr/bin/uwsgi --ini /home/wwwroot/flask/uwsgi.ini
	root     16647  0.0  0.0 112660   972 pts/1    S+   13:24   0:00 grep --color=auto uwsgi

然后客户端可以直接运行会出现命令行调试。

	[root@localhost supervisor]# supervisorctl 
	uwsgi                            RUNNING   pid 16556, uptime 0:26:03
	supervisor> help
	
	default commands (type help <topic>):
	=====================================
	add    exit      open  reload  restart   start   tail   
	avail  fg        pid   remove  shutdown  status  update 
	clear  maintail  quit  reread  signal    stop    version
	
	supervisor> 


有坑的话这个[supervisor 启动报错 error: , Errno 2 No such file or directory: file: /usr/lib/python2.7/](https://www.tuicool.com/articles/M3Aziu)，其它就保证服务已经启动就好了。

最后可以用虚拟环境完美解决，理论上这样，未尝试，因为前面pip安装模块后无法生成可执行命令的坑。附上参考地址[virtualenv - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/0014316089557264a6b348958f449949df42a6d3a2e542c000/001432712108300322c61f256c74803b43bfd65c6f8d0d0000)