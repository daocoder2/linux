<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# Linux各发行版本及其软件包管理方法 

## 1、Linux各发行版本

Linux发行版本有很多，按照使用领域分为桌面系统领域和服务器领域。下面简要介绍如下：

- Red Hat和Fedora：redhat最早发行的个人版本的Linux，自从Red Hat 9.0版本发布后，RedHat 公司就不再开发桌面版的 Linux发行套件，Red Hat Linux停止了开发，而将全部力量集中在服务器版的开发上，也就是 Red Hat Enterprise Linux 版。2004年4月30日，Red Hat公司正式停止对Red Hat 9.0版本的支援，标志著Red Hat Linux的正式完结。原本的桌面版Red Hat Linux发行套件则与来自开源社区的 Fedora 计划合并，成为 Fedora Core 发行版本。目前Red Hat分为两个系列：由Red Hat公司提供收费技术支持和更新的Red Hat Enterprise Linux(RHEL)，以及由社区开发的免费的Fedora Core。

	特点：面向个人桌面应用系统，采用基于rpm/yum管理软件包。

- RHEL(Red Hat Enterprise Linux)和CentOS：RHEL是Red Hat企业版，提供商业支持。CentOS是对RHEL重新编译而成，免费而稳定。

	特点：面向企业服务器使用，安全稳定，采用基于rpm/yum管理软件包。

- Debian和Ubuntu：Debian是社区类Linux的典范，是迄今为止最遵循GNU规范。Ubuntu基于Debian发行版和GNOME桌面环境.它使用Bash作为基础Shell，所以在很多基础命令上，ubuntu与CentOS的差别不是很明显，而ubuntu在桌面界面上要做的更为出色。此外Ubuntu基于Debian发行版和GNOME桌面环境.它使用Bash作为基础Shell，所以在很多基础命令上，ubuntu与CentOS的差别不是很明显，而ubuntu在桌面界面上要做的更为出色，还有类似的Kunbuntu/Xubuntu等。

	特点：面向桌面应用，采用apt-get/dpkg包管理方式。


# 2、软件安装工具：


在GNU/Linux(以下简称Linux)操作系统中，RPM和DPKG为最常见的两类软件包管理工具，他们分别应用于基于RPM软件包的Linux发行版本和DEB软件包的Linux发行版本。软件包管理工具的作用是提供在操作系统中安装，升级，卸载需要的软件的方法，并提供对系统中所有软件状态信息的查询。

RPM全称为RedhatPackage Manager，最早由RedHat公司制定实施，随后被GNU开源操作系统接受并成为很多Linux系统(RHEL)的既定软件标准。DEB是基于Debian操作系统(UBUNTU)的DEB软件包管理工具－DPKG，全称为Debian Package。

## 2.1 RPM包的安装、升级、查询和卸载

一个RPM包包含了已压缩的软件文件集以及该软件的内容信息（在头文件中保存），通常表现为以.rpm扩展名结尾的文件，例如package.rpm。对其操作，需要使用rpm\yum命令。

### 2.1.1 RPM命令常用参数

	RPM的常规使用方法为rpm-? package.rpm，其中-?为操作参数：

    -q	在系统中查询软件或查询指定rpm包的内容信息

    -i	在系统中安装软件

    -U	在系统中升级软件

    -e	在系统中卸载软件

    -h	用#(hash)符显示rpm安装过程，进度条

    -v	详述安装过程

    -p	表明对RPM包进行查询，通常和其它参数同时使用，如：

    -ql	查询某个RPM包中的所有文件列表, 查看软件包将会在系统里安装哪些部分
	
    -qi	查询某个RPM包的内容信息,系统列出这个软件包的详细资料，即有多少个文件、各文件名称、文件大小、创建时间、编译日期等信息。

安装RPM包

	rpm   -ivh package.rpm

升级rpm包

	rpm  -Uvh package.rpm

卸载rpm包

	rpm   -ev package

查询已安装rpm包

	rpm  -qa｜grep package

下面这条命令行可以帮助我们快速判定某个文件属于哪个软件包：

	rpm -qf <文件名>

Linux将为你列出所有损坏的文件。

	rpm -Va


### 2.1.2 yum包管理软件

YUM基于RPM包管理工具，能够从指定的源空间（服务器，本地目录等）自动下载目标RPM包并且安装，可以**自动处理依赖性关系并进行下载、安装，无须繁琐地手动下载、安装每一个需要的依赖包。**此外，YUM的另一个功能是**进行系统中所有软件的升级。**

如上所述，YUM的RPM包来源于源空间，在RHEL中由/etc/yum.repos.d/目录中的.repo文件配置指定。YUM的系统配置文件位于/etc/yum.conf。

列出所有可更新的软件包信息

	yum info updates

安装RPM包

	yum -y install package-name

升级rpm包

	yum update package-name

卸载rpm包

	yum remove package-name

列出已安装rpm包

	yum list

列出系统中可升级的所有软件

	yum  check-update

## 2.2 DEB包的安装/升级/查询/卸载

一个DEB包包含了已压缩的软件文件集以及该软件的内容信息（在头文件中保存），通常表现为以.deb扩展名结尾的文件，例如package.deb。对其操作，需要使用dpkg命令。下面介绍dpkg工具的参数和使用方法，并以IBM Lotus Notes在UBUNTU904安装为例做具体说明。

### 2.2.1 DPKG命令常用参数

	DPKG的常规使用方法为dpkg-? Package(.rpm),其中 -?为安装参数：

    -l在系统中查询软件内容信息

    --info在系统中查询软件或查询指定rpm包的内容信息

    -i在系统中安装/升级软件

    -r在系统中卸载软件,不删除配置文件

    -P在系统中卸载软件以及其配置文件

查询系统中已安装的软件

	dpkg-l package

安装DEB包

	sudo dpkg -i package.deb

卸载DEB包

	sudo dpkg -rpackage.deb #不卸载配置文件

    sudodpkg -P package.deb #卸载配置文件

### 2.2.2 apt包管理软件

APT的全称为AdvancedPackaging Tools。与 YUM对应，它最早被设计成DPKG的前端软件，现在通过apt-rpm也支持rpm管理。APT的主要包管理工具为APT-GET，通过此工具可满足和上述YUM相似的功能要求。

更新源索引

	sudo  apt-get update

安装

	sudo  apt-get install package-name

下载指定源文件

	sudo  apt-get source package-name

升级所有软件

	sudo  apt-get upgrade

卸载

	sudo  apt-get remove package-name不删除配置文件

	sudo  apt-get remove –purge package-name删除配置文件

## 2.3 Alien

Alien工具可以将RPM软件包转换成DEB软件包，或把DEB软件包转换成RPM软件包，以此适应兼容性的需要。注意首先请在系统中安装alien。

在UBUNTU中使用alien将deb转换为rpm并安装

	sudo  alien -d package.rpm

	sudo dpkg -i package.deb

在RHEL中使用alien将deb转换为rpm并安装

	alien -r package.deb

	rpm -ivh package.rpm

# 3、软件包管理实战（vmware10+centos7）

## 3.1 windows和linux之间文件的传输

利用软件Xftp5，官方下载，傻瓜式传输，传输完成后得下面文件。

	[root@localhost /]# cd /daocoder/
	[root@localhost daocoder]# ls
	CentOS-7.0-1406-x86_64-DVD.iso			就是这个镜像文件，虚拟机安装centos7也是用的它

下面是重点，利用镜像文件要先将它挂载。

	[root@localhost /]# cd /mnt				先进入/mnt目录
	[root@localhost mnt]# ls
	[root@localhost mnt]# mkdir centos7		新建一个目录/centos7

挂载centos7镜像文件到上述目录

	[root@localhost /]# mount -o loop -t iso9660 /daocoder/CentOS-7.0-1406-x86_64-DVD.iso /mnt/centos7/
	mount: /dev/loop0 写保护，将以只读方式挂载

	[root@localhost /]# cd /mnt/centos7/
	[root@localhost centos7]# ls			下列就是之前的镜像文件了
	CentOS_BuildTag  EULA  images    LiveOS    repodata              RPM-GPG-KEY-CentOS-Testing-7
	EFI              GPL   isolinux  Packages  RPM-GPG-KEY-CentOS-7  TRANS.TBL

这里Packages目录下就是所有安装centos时所安装的软件包。

## 3.2 rpm安装软件包实战

安装下Packages列表下最后一个包，其它的看第2节的命令。

	[root@localhost Packages]# rpm -ivh zziplib-0.13.62-5.el7.x86_64.rpm
	警告：zziplib-0.13.62-5.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:zziplib-0.13.62-5.el7            ################################# [100%]

查询一个软件包是否被安装，如下格式很重要，需要**包名称且不加版本号**。

	[root@localhost Packages]# rpm -q zziplib-0.13.62-5.el7.x86_64.rpm		失败	
	未安装软件包 zziplib-0.13.62-5.el7.x86_64.rpm 	
	[root@localhost Packages]# rpm -q zz*									失败
	未安装软件包 zziplib-0.13.62-5.el7.x86_64.rpm 
	[root@localhost Packages]# rpm -q zziplib				成功
	zziplib-0.13.62-5.el7.x86_64

或者用另种方法。

	[root@localhost Packages]# rpm -qa | grep zziplib		成功	
	zziplib-0.13.62-5.el7.x86_64	
	[root@localhost Packages]# rpm -qa | grep zzip			成功
	zziplib-0.13.62-5.el7.x86_64
	[root@localhost Packages]# rpm -qa | grep zzip*			失败

查看软件包详细信息

	[root@localhost Packages]# rpm -qi yum
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
	Build Date  : 2014年06月27日 星期五 19时07分06秒
	Build Host  : worker1.bsys.centos.org
	Relocations : (not relocatable)
	Packager    : CentOS BuildSystem <http://bugs.centos.org>
	Vendor      : CentOS
	URL         : http://yum.baseurl.org/
	Summary     : RPM package installer/updater/manager
	Description :
	Yum is a utility that can check for and automatically download and
	install updated RPM packages. Dependencies are obtained and downloaded
	automatically, prompting the user for permission as necessary.

查看软件包的安装生成目录，只列出了部分。

	[root@localhost Packages]# rpm -ql yum			
	/etc
	/etc/bash_completion.d
	/etc/bash_completion.d/yum
	/etc/bash_completion.d/yummain.py
	/etc/cron.daily
	/etc/cron.daily/0yum-daily.cron
	/etc/cron.hourly

查询某个命令由哪个安装包得来。

	[root@localhost sbin]# which yumdb					先which找到这个命令
	/usr/sbin/yumdb
	[root@localhost sbin]# rpm -qf /usr/sbin/yumdb		再反查软件包
	yum-utils-1.1.31-24.el7.noarch

删除包

	[root@localhost sbin]# rpm -e zziplib
	[root@localhost sbin]# rpm -q zziplib
	未安装软件包 zziplib 

解决依赖性或错误时，强制性删除与强制性安装。

	[root@localhost Packages]# rpm -q zziplib					查看下有这个包
	zziplib-0.13.62-5.el7.x86_64
	[root@localhost Packages]# rpm -e zziplib --nodeps			强制性删除 nodepends帮助记忆
	[root@localhost Packages]# rpm -q zziplib					查看下没了
	未安装软件包 zziplib 
	[root@localhost Packages]# rpm -ivh zziplib-0.13.62-5.el7.x86_64.rpm --force 		强制性安装包
	警告：zziplib-0.13.62-5.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:zziplib-0.13.62-5.el7            ################################# [100%]

依赖性包的安装

	[root@localhost Packages]# rpm -ivh php-mysql-5.4.16-21.el7.x86_64.rpm
	警告：php-mysql-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	错误：依赖检测失败：
		php-pdo(x86-64) = 5.4.16-21.el7 被 php-mysql-5.4.16-21.el7.x86_64 需要
	[root@localhost Packages]# rpm -ivh php-pdo-5.4.16-21.el7.x86_64.rpm 
	警告：php-pdo-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	错误：依赖检测失败：
		php-common(x86-64) = 5.4.16-21.el7 被 php-pdo-5.4.16-21.el7.x86_64 需要
	[root@localhost Packages]# rpm -ivh php-common-5.4.16-21.el7.x86_64.rpm 
	警告：php-common-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	错误：依赖检测失败：
		libzip.so.2()(64bit) 被 php-common-5.4.16-21.el7.x86_64 需要
	[root@localhost Packages]# rpm -ivh libz
	libzapojit-0.0.3-4.el7.x86_64.rpm  libzip-0.10.1-8.el7.x86_64.rpm

	[root@localhost Packages]# rpm -ivh libzip-0.10.1-8.el7.x86_64.rpm 
	警告：libzip-0.10.1-8.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:libzip-0.10.1-8.el7              ################################# [100%]
	[root@localhost Packages]# rpm -ivh php-common-5.4.16-21.el7.x86_64.rpm 
	警告：php-common-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:php-common-5.4.16-21.el7         ################################# [100%]
	[root@localhost Packages]# rpm -ivh php-pdo-5.4.16-21.el7.x86_64.rpm 
	警告：php-pdo-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:php-pdo-5.4.16-21.el7            ################################# [100%]
	[root@localhost Packages]# rpm -ivh php-mysql-5.4.16-21.el7.x86_64.rpm
	警告：php-mysql-5.4.16-21.el7.x86_64.rpm: 头V3 RSA/SHA256 Signature, 密钥 ID f4a80eb5: NOKEY
	准备中...                          ################################# [100%]
	正在升级/安装...
	   1:php-mysql-5.4.16-21.el7          ################################# [100%]

从上面可以看出，层层安装这样是可以安装成功软件包的，但是设想若层层依赖到最后变成循环依赖时，这就无解了，这就要求我们使用yum来安装软件包，它可以完美的解决依赖性关系。

## 3.3 yum安装软件包实战

软件的安装与卸载同样存在依赖性的关系，如上述要想用 rpm 直接卸载 libzip 这个软件包会这样。

	[root@localhost ~]# rpm -e libzip
	错误：依赖检测失败：
		libzip.so.2()(64bit) 被 (已安裝) php-common-5.4.16-21.el7.x86_64 需要

那么利用 yum 来卸载这个 libzip 安装包会这样。

	[root@localhost ~]# yum remove libzip
	已加载插件：fastestmirror, langpacks
	正在解决依赖关系
	--> 正在检查事务
	---> 软件包 libzip.x86_64.0.0.10.1-8.el7 将被 删除
	--> 正在处理依赖关系 libzip.so.2()(64bit)，它被软件包 php-common-5.4.16-21.el7.x86_64 需要
	--> 正在检查事务
	---> 软件包 php-common.x86_64.0.5.4.16-21.el7 将被 删除
	--> 正在处理依赖关系 php-common(x86-64) = 5.4.16-21.el7，它被软件包 php-pdo-5.4.16-21.el7.x86_64 需要
	--> 正在检查事务
	---> 软件包 php-pdo.x86_64.0.5.4.16-21.el7 将被 删除
	--> 正在处理依赖关系 php-pdo(x86-64) = 5.4.16-21.el7，它被软件包 php-mysql-5.4.16-21.el7.x86_64 需要
	--> 正在检查事务
	---> 软件包 php-mysql.x86_64.0.5.4.16-21.el7 将被 删除
	--> 解决依赖关系完成
	base/7/x86_64                                                                 | 3.6 kB  00:00:00     
	centos7-iso                                                                   | 3.6 kB  00:00:00     
	extras/7/x86_64                                                               | 3.4 kB  00:00:00     
	updates/7/x86_64                                                              | 3.4 kB  00:00:00     
	
	依赖关系解决
	
	=====================================================================================================
	 Package                 架构                版本                       源                      大小
	=====================================================================================================
	正在删除:
	 libzip                  x86_64              0.10.1-8.el7               installed              104 k
	为依赖而移除:
	 php-common              x86_64              5.4.16-21.el7              installed              3.8 M
	 php-mysql               x86_64              5.4.16-21.el7              installed              232 k
	 php-pdo                 x86_64              5.4.16-21.el7              installed              192 k
	
	事务概要
	=====================================================================================================
	移除  1 软件包 (+3 依赖软件包)
	
	安装大小：4.3 M
	是否继续？[y/N]：y
	Downloading packages:
	Running transaction check
	Running transaction test
	Transaction test succeeded
	Running transaction
	警告：RPM 数据库已被非 yum 程序修改。
	  正在删除    : php-mysql-5.4.16-21.el7.x86_64                                                   1/4 
	  正在删除    : php-pdo-5.4.16-21.el7.x86_64                                                     2/4 
	  正在删除    : php-common-5.4.16-21.el7.x86_64                                                  3/4 
	  正在删除    : libzip-0.10.1-8.el7.x86_64                                                       4/4 
	  验证中      : php-common-5.4.16-21.el7.x86_64                                                  1/4 
	  验证中      : php-mysql-5.4.16-21.el7.x86_64                                                   2/4 
	  验证中      : libzip-0.10.1-8.el7.x86_64                                                       3/4 
	  验证中      : php-pdo-5.4.16-21.el7.x86_64                                                     4/4 
	
	删除:
	  libzip.x86_64 0:0.10.1-8.el7                                                                       
	
	作为依赖被删除:
	  php-common.x86_64 0:5.4.16-21.el7 php-mysql.x86_64 0:5.4.16-21.el7 php-pdo.x86_64 0:5.4.16-21.el7
	
	完毕！

安装软件包同理。记住命令即可，或利用yum --help。

## 3.4 源码包的安装

如果你需要的软件包在rpm包里没有或是你需要较新版本的软件包，这就需要你自己去下载源码包，编译并安装。这些源码包一般以.tar.gz或直接.gz结尾。

下面我们以下载并安装 nmap 这个软件包来练习。

1、获取源码包

到[namp官网下载页面](https://nmap.org/download.html)移动到S**ource Code Distribution (in case you wish to compile Nmap yourself)**这栏，windows平台选择[nmap-7.30.tar.bz2](https://nmap.org/dist/nmap-7.30.tar.bz2)直接点击下载，后利用Xftp传到linux上面或选择它右键复制下载链接，在linux里敲命令

	[root@localhost daocoder]# wget https://nmap.org/dist/nmap-7.30.tar.bz2

2、解压文件 

	[root@localhost daocoder]#tar -jxvf nmap-7.30.tar.bz2		解压后会生成nmap-7.30这个目录

3、检查包安装环境./configure 
	
	[root@localhost daocoder]#cd nmap-7.30						进入namp-7.30的目录
	[root@localhost nmap-7.30]# ./configure --prefix=/usr/local/src/		检查环境并指定安装目录

4、编译
	
	[root@localhost nmap-7.30]# make

5、安装

	[root@localhost nmap-7.30]# make install

6、删除

直接cd到安装目录rm -rf 即可删除。

nmap的用法，以后练习。
	[root@localhost bin]# ./nmap 192.168.0.31				这个是嗅探主机开启的端口
	
	Starting Nmap 7.30 ( https://nmap.org ) at 2016-10-10 11:23 CST
	Nmap scan report for 192.168.0.31
	Host is up (0.000012s latency).
	Not shown: 998 closed ports
	PORT    STATE SERVICE
	22/tcp  open  ssh
	111/tcp open  rpcbind
	
	Nmap done: 1 IP address (1 host up) scanned in 1.59 seconds
	
	[root@localhost bin]# ./nmap -sP 192.168.0.0/24			这个是查看子网已占用的ip地址
	
	Starting Nmap 7.30 ( https://nmap.org ) at 2016-10-10 11:16 CST
	Nmap scan report for 192.168.0.1
	Host is up (0.00097s latency).
	MAC Address: A4:56:02:AC:73:DF (fenglian Technology)
	Nmap scan report for 192.168.0.18
	Host is up (0.044s latency).
	MAC Address: D4:97:0B:74:5F:DB (Xiaomi Communications)
	Nmap scan report for 192.168.0.21
	Host is up (0.00038s latency).
	MAC Address: 28:D2:44:AF:7A:B4 (Lcfc(hefei) Electronics Technology)
	Nmap scan report for 192.168.0.24
	Host is up (0.059s latency).
	MAC Address: 0C:84:DC:3F:74:05 (Hon Hai Precision Ind.)
	Nmap scan report for 192.168.0.25
	Host is up (0.00010s latency).
	MAC Address: 20:47:47:78:AE:F7 (Dell)
	Nmap scan report for 192.168.0.27
	Host is up (0.0012s latency).
	MAC Address: 3C:97:0E:AF:6F:20 (Wistron InfoComm(Kunshan)Co.)
	Nmap scan report for 192.168.0.37
	Host is up (0.030s latency).
	MAC Address: 58:44:98:16:E2:26 (Xiaomi Communications)
	Nmap scan report for 192.168.0.38
	Host is up (0.38s latency).
	MAC Address: AC:5F:3E:4E:9E:48 (Unknown)
	Nmap scan report for 192.168.0.40
	Host is up (0.047s latency).
	MAC Address: 54:27:1E:6E:5C:5E (AzureWave Technology)
	Nmap scan report for 192.168.0.59
	Host is up (0.14s latency).
	MAC Address: 30:10:B3:E8:6E:52 (Liteon Technology)
	Nmap scan report for 192.168.0.102
	Host is up (0.13s latency).
	MAC Address: 68:3E:34:00:B1:C4 (Meizu Technology)
	Nmap scan report for 192.168.0.109
	Host is up (0.095s latency).
	MAC Address: 18:CF:5E:99:41:06 (Liteon Technology)
	Nmap scan report for 192.168.0.31
	Host is up.
	Nmap done: 256 IP addresses (13 hosts up) scanned in 7.62 seconds

























		



  


