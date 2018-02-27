# svn的使用与搭建

# 1、客户端的svn环境

客户端的下载与使用没啥可说的，使用小乌龟，一路到底就行了。

[小乌龟下载地址。](https://www.visualsvn.com/visualsvn/download/tortoisesvn/)

# 2、服务器端的svn环境

## 2.1 subversion的安装

下面以centos为例说明，最简单的yum来安装，然后站点假设以lnmp环境运行，站点目录放在 `/home/wwwroot`。

	yum -y install subversion

## 2.2 subversion的配置

### 2.2.1 建立版本库目录

	mkdir svndata 				# 目录名自己随意设置

### 2.2.2 建立版本库

	cd /home/svndata			# 切到版本库目录，此时目录为空
	svnadmin create newproject	# 创建一个名为 newproject 的版本库，目录发生变化

创建一个名为 newproject 的版本库之后，会生成`/home/svndata/newproject`目录，它的目录结构如下：
	
	cd newproject
	[root@localhost newproject]# ll
	总用量 16
	drwxr-xr-x 2 root root   51 10月 23 16:36 conf
	drwxr-sr-x 6 root root 4096 10月 23 16:39 db
	-r--r--r-- 1 root root    2 10月 23 15:55 format
	drwxr-xr-x 2 root root 4096 10月 23 16:39 hooks
	drwxr-xr-x 2 root root   39 10月 23 15:55 locks
	-rw-r--r-- 1 root root  229 10月 23 15:55 README.txt

### 2.2.3 版本库配置

	cd conf/

**1、修改`svnserve.conf`，nowproject版本库的配置，主要为找到如下，然后取消相应注释或修改相应名称。**

	anon-access = read			# 控制非认证用户访问版本库的权限
	auth-access = write			# 控制认证用户访问版本库的权限
	password-db = passwd		# 指定用户名密码文件
	authz-db = authz			# 指定权限认证配置文件
	realm = newproject			# 指定版本库的认证域，即在登录时提示的认证域名称

**2、修改`authz`，即指定权限认证配置文件。**

	# 这里把不同用户放到不同的组里面，用户组自己随意命名，下面在设置目录访问权限的时候，用目录来操作就可以了。
	[groups]
	allowed = zhangsan,async	# 全部权限
	master = lisi				# 主程人员权限
	assist = wangmazi,zhaowu	# 协助人员权限
	
	[newproject:/]				# 表示根目录（/home/svndata/newproject），newproject: 对应前面配置的realm = newproject
	@allowed = rw				# 可读写
	@master = r					# 只读
	@assist = r					# 只读
	* =
	
	[newproject:/project]		# 表示project目录（/var/svn/newproject/project）
	@allowed = rw				# 可读写
	@master = rw				# 可读写
	@assist = rw				# 可读写
	* =

**3、修改`passwd`，即指定用户名密码文件。**

	[users]
	async = async
	zhangsan = 123456
	lisi = 123456
	wangmazi = 123456
	zhaowu = 123456

## 2.3 svn启动

启动svn。

	svnserve -d -r /home/svndata/		# 这里接的是版本库目录，不是其下面对应的某个版本库
	# -d : 守护进程  -r : svn数据版本库目录

查看svn进程。

	ps -aux | grep svnserve 			# 默认端口为：3690

这里面注意下防火墙的设置，iptables 放开端口，[iptables如何删除指定的规则](https://jingyan.baidu.com/article/3c343ff71522880d377963bb.html)。

然后加入开机自启动，略过。

## 2.4 站点同步设置（svn钩子）

**1、站点目录同步svn。**

假设站点目录要放在/home/wwwroot/文件夹下，techweb是站点的目录文件夹，一般与svn的代码仓同名，执行：

	svn co svn://ip地址/techweb

然后根据要求先输入服务器密码，再输入用户名和密码，再yes。

**2、再配置svn的钩子。**

	cd /home/svndata/newproject/hooks
	cp post-commit.tmpl post-commit 
	chmod +x post-commit 

修改`post-commit`，即提交之后执行动作文件。

	export LANG=en_US.UTF-8									# utf-8 编码
	SVN=/usr/bin/svn										# svn命令路径
	WEB=/home/wwwroot/techweb								# 站点路径
	$SVN update $WEB --username async --password async		# 提交后执行的命令，这里使用钩子用户，在每次提交后会自动执行此条命令
	chown -R www:www $WEB									# 更改目录所属

**3、服务器里执行下钩子文件的命令，即：**

	SVN=/usr/bin/svn										
	WEB=/home/wwwroot/techweb								
	$SVN update $WEB --username async --password async

命令复制下，然后命令行执行，再yes。

**4、重启svn**

	[root@localhost home]# killall svnserve
	[root@localhost home]# svnserve -d -r svndata/

**5、测试上传**




