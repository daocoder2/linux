<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux用户及组管理
本篇文章nag主要介绍linux中用户、组的基本概念，对应的配置文件，用户及组的管理包括添加、修改、删除。

# 1、Linux用户、组概念及相关文件介绍

## 1.1 用户的概念和相关文件说明
linux用户分为普通用户和超级用户，每新建一个普通用户默认情况都会在/etc/home这个目录下建立一个家目录，同时在etc/passwd和/etx/shadow下会分别存放这些用户的基本信息和密码，这些就是用户信息基本了解的开始，我们就从这些用户相关文件的信息开始学习。

	[root@localhost godao]# vim /etc/passwd

![daocoder](http://i.imgur.com/B4puo0D.png)

从图中可以看到每一条用户信息都分为了7段，即用户名：密码控位键:uid:gid:用户描述：用户家目录：用户环境。

1、用户名：自己设置的名称，每个用户匹配自己的uid，如root就是预设的系统管理员的账号名称，它的uid一般为0。另外注意uid可以重复。

2、密码控位键：在早期的unix中，密码即在这个文档的这个位置，但是这个文件基本对所有用户都可见，出于对用户的隐私性及文件的安全性考虑，这里以“x”代替加密的密码，真正的密码被放在/etc/passwd中这个文件中去了，这个下面也会说明。密码控位键的作用是让系统读取用户的密码，如果把密码控位键“x”给删了，那切换到这个账户就不用密码。

3、uid：每个新建的用户都有相应的uid由计算机识别，用户登录进系统后，系统通过该值，而不是用户名来识别用户，同时它还有相应的范围表不同的特性。

- uid = 0时，代表这个账号是系统管理员，当你要作另一个系统管理员账号时，你可以将账号的uid改成0。
- uid = 1-499时，保留给系统使用的id。其实，预设 500以下给系统作为保留账号只是一个习惯。一般来说，1-99 会保留给系统预设的账号，另外100-499则保留给一些服务来使用。 
- uid = 500-65535时，给一般用户使用，事实上，目前的linux 核心(2.6.x+版)已经可以支持到4294967295 (2^32-1) 这么大的uid号了。

4、gid：每个用户创建的同时都会默认创建它同名的用户组，这个用户组同样会有自己的gid，与它相关的文件在/etc/group中，其实/etc/group的观念与/etc/passwd差不多，它是用来规范group的。

5、用户描述信息：没啥用处，可以理解为帮助你理解这个帐号是用途或来源。

6、家目录：每新建一个用户会默认建立自己的家目录，用于存放用户自己的信息。

7、shell环境：指每个用户登录时默认的shell环境，这个shell就是用户输出指令与硬件之间交互的界面。

	[root@localhost godao]# vim /etc/shadow

![daocoder](http://i.imgur.com/XO6fE1O.png)

从图中可以看到每一条用户信息都分为了9段。

1、帐号名称：定义与这个 shadow 条目相关联的特殊用户帐户。 

2、密码：包含一个加密的密码，可解密的。**注意带“！”符号标识该帐号不能用来登录。** 

3、上次修改密码的日期：19700101日起，密码被修改的天数。

4、密码将被允许修改之前的天数：0表示可在任何时间修改。

5、系统将强制用户修改为新密码之前的天数：99999表示不需要修改，1表示永远都不能修改。

6、密码变更前提前几天警告：-1表示没有警告。

7、帐号失效日期 ：即密码过期之后，系统自动禁用帐户的天数，-1 表示永远不会禁用。

8、帐号取消日期 ：即帐户被禁用的天数，-1表示该帐户被启用。

9、保留条目，目前没用 

上述这些条目信息我们可以man一下来获取帮助。

	[root@localhost godao]# man 1 ls 		对命令的帮助  即默认的man ls
![daocoder](http://i.imgur.com/LpD5Y5Q.png)

	[root@localhost godao]# man 5 passwd   对文件的帮助  注意与上面的区别
![daocoder](http://i.imgur.com/qu6eyBy.png)

我们还可以看下man man这个文件说明。

	[root@localhost godao]# man 1 man         注意man自己也是一个命令
![daocoder](http://i.imgur.com/zP9J9LN.png)

这里再强调一个东西，对系统而言呢，设计者对它考虑也比较人性化了，对于**系统中某些比较重要的文件，如shadow、passwd，它们还会有自己的备份文件，这要求我们自己知道这个啊。**

	[root@localhost daocoder]# ls /etc/pass*
	/etc/passwd  /etc/passwd-              后面这个就是备份文件了
	[root@localhost daocoder]# ls /etc/sha*
	/etc/shadow  /etc/shadow-

## 1.2 用户组的概念和相关文件说明

具有某种共同特征的用户集合起来就是用户组（Group）。用户组（Group）配置文件主要有 /etc/group和/etc/gshadow，其中 /etc/gshadow是/etc/group的加密信息文件。linux /etc/group文件是有关于系统管理员对用户和用户组管理的文件,linux用户组的所有信息都存放在/etc/group文件中。
将用户分组是Linux系统中对用户进行管理及控制访问权限的一种手段。每个用户都属于某个用户组；一个组中可以有多个用户，一个用户也可以属于不 同的组。当一个用户同时是多个组中的成员时，在/etc/passwd文件中记录的是用户所属的**主组**，也就是登录时所属的默认组，而其他组称为**附加组**。

	[root@localhost ~]# vim /etc/group

![daocoder](http://i.imgur.com/Mgq73rJ.png)

字段从前之后依次为：组名、口令（密码控位键）、组标识号:组内用户列表。

1、组名：组名是用户组的名称，由字母或数字构成。与/etc/passwd中的用户名一样，组名不应重复。

2、密码控位键：口令字段存放的是用户组加密后的口令字。一般Linux系统的用户组都没有口令，即这个字段一般为空，或者是*。

3、gid（组标识号）：组标识号与用户标识号类似，也是一个整数，被系统内部用来标识组。别称GID。

4、组内用户列表：是属于这个组的所有用户的列表，不同用户之间用逗号(,)分隔。这个用户组可能是用户的主组，也可能是附加组。

	[root@localhost ~]# vim /etc/gshadow

![daocoder](http://i.imgur.com/nsuh9pf.png)

字段从左至右依次为：组名、组密码、组管理员、组成员。

# 2、用户及组的查询、添加、删除等管理

## 2.1 用户的查询、添加、删除

###添加用户

	[root@localhost daocoder]# useradd godao			添加用户
	[root@localhost daocoder]# passwd godao				设置密码
	更改用户 godao 的密码 。
	新的 密码：
	重新输入新的 密码：
	passwd：所有的身份验证令牌已经成功更新。
	[root@localhost daocoder]# cd /home/godao/			查看并切换到刚建立的家目录
	[root@localhost godao]# vim /etc/passwd

![daocoder](http://i.imgur.com/dDoEbaD.png)

	[root@localhost ~]# su godao						可以正常登录
	[godao@localhost root]$ cd /						注意这里管理和普通用户的符号变化

###禁止用户登录

	[root@localhost ~]# vim /etc/passwd					设置shell环境为nologin

![daocoder](http://i.imgur.com/ZnmOjhV.png)

	[root@localhost ~]# su godao						切换到godao用户试下查看登录结果：失败
	This account is currently not available.

###切换用户的方法 

su是部分切换，账户切换了，个人信息没有切换。su - 是完全切换。同时root切换普通目录不需要输入密码，但反之要输入密码，同等用户间切换也是要输入密码。

###用户信息的修改

	[root@localhost ~]# man usermod						man下看下usermod命令说明，部分截图
![daocoder](http://i.imgur.com/phjEy0D.png)

![daocoder](http://i.imgur.com/PJY4iUF.png)

	[godao@localhost ~]$ vim /etc/passwd				先看下用户信息列表，注意daocoder这个用户

![daocoder](http://i.imgur.com/l1kYDQb.png)

它的用户名daocoder，uid：1000，gid：1000，描述信息：daocoder，家目录/home/daocoder，shell环境：/bin/bash。

	[godao@localhost ~]$ vim /etc/group

![daocoder](http://i.imgur.com/NhjdS9F.png)

它的主组为daocoder，附加组mudai。

用下面这个命令看起来直观点：
	[godao@localhost ~]$ id daocoder
	uid=1000(daocoder) gid=1000(daocoder) 组=1000(daocoder),1002(mudai)
	
好了，下面进行修改内容。

	[root@localhost ~]#  usermod daocoder -g 1001 -G godao -c demo

![daocoder](http://i.imgur.com/Pk2B2vj.png)

	[godao@localhost ~]$ id daocoder
	uid=1000(daocoder) gid=1001(godao) 组=1001(godao)

它现在用户名daocoder，uid：1000，gid：1001，描述信息：demo，家目录/home/daocoder，shell环境：/bin/bash。它的主组为godao，附加组godao。

###usermod命令语法：修改用户帐号群组，登录目录等。

语法：usermod [-LU][-c <备注>][-d <登入目录>][-e <有效期限>][- f <缓冲天数>][-g <群组>][-G <群组>][-l <帐号名称>][-s][-u][用户帐号]

补充说明：usermod可用来修改用户帐号的各项设定。

参　　数：

-c<备注>:修改用户帐号的备注文字。

-d登入目录>:修改用户登入时的目录。

-e<有效期限>:修改帐号的有效期限。

-f<缓冲天数>:修改在密码过期后多少天即关闭该帐号。

-g<群组>:修改用户所属的群组。

-G<群组>:修改用户所属的附加群组。

-l<帐号名称>:修改用户帐号名称。

-L:锁定用户密码，使密码无效。

-s:修改用户登入后所使用的shell。

-u:修改用户ID。

-U:解除密码锁定。

###用户的删除

	[root@localhost ~]# userdel godao						删除用户，没有参数，不包含家目录
	[root@localhost ~]# ls /home
	daocoder  godao
	[root@localhost ~]# userdel -r godao				删除用户包含家目录 加参数 -r
	[root@localhost ~]# ls /home
	daocoder

## 2.2 组的查询、添加、删除

###组的添加
	[root@localhost /]# groupadd go -g 521     增加组并指定gid
	[root@localhost /]# vim /etc/group			如下图

![daocoder](http://i.imgur.com/jXkA57C.png)

###主组与附加组
每个用户创建时若没有指定用户组，创建用户的时候系统会默认同时创建一个和这个用户名同名的组，这个组就是主组，不可以把用户从基本组中删除。超级组：0 ；系统组：1-499；普通组：500+。
在使用useradd命令创建用户的时侯可以用-g 和-G 指定用户所属组和附属组。
在使用usermod命令改变用户的时侯可以用-g 和-G 指定用户所属组和附属组。

	[root@localhost /]# useradd dos  -g go		添加用户并制定主组go

![daocoder](http://i.imgur.com/wx1TSia.png)

注意它的gid为521、就是上面创建的go的gid

	[root@localhost /]# usermod -G mudai daocoder  指定daocoder的附加组为mudai

![daocoder](http://i.imgur.com/qeBa1Aw.png)

这么说，创建daocoder时默认主组就是daocoder，上面又是将daocoder加入mudai这个组中，mudai就相当于daocoder的附加组。

![daocoder](http://i.imgur.com/JaOorXg.png)

	[root@localhost /]# groupdel go				删除组：成功、不演示了

### 组信息的修改


groupmod(group modify)

功能说明：更改群组识别码或名称。

语　　法：groupmod [-g <群组识别码> <-o>][-n <新群组名称>][群组名称]

补充说明：需要更改群组的识别码或名称时，可用groupmod指令来完成这项工作。

选项:
  -g, --gid GID                 将组 ID 改为 GID
  -h, --help                    显示此帮助信息并推出
  -n, --new-name NEW_GROUP      改名为 NEW_GROUP
  -o, --non-unique              允许使用重复的 GID
  -p, --password PASSWORD		将密码更改为(加密过的) PASSWORD
  -R, --root CHROOT_DIR         chroot 到的目录
	
	[root@localhost ~]# groupadd test				添加一个组、名为test
	[root@localhost ~]# tail -1 /etc/group			查看下
	test:x:1003:

	[root@localhost ~]# groupmod -g 1111 test		指定test的gid为1111
	[root@localhost ~]# tail -1 /etc/group			再看看
	test:x:1111:

	[root@localhost ~]# groupmod -n tested test		test组换个名tested
	[root@localhost ~]# tail -1 /etc/group			再看看
	tested:x:1111:

# 3、文件管理与用户、组权限的联系

root模式下查看下/daocoder目录的详细信息，发现该目录对root目录有读写执行的权限，对用户组及其他人只有读与执行的权限，下面来验证下。

## 3.1 文件的读写执行权限与用户、组的联系

### 改变目录其它人的权限以在其下建立文件
	[root@localhost daocoder]# ls -l -d ../daocoder      root查看daocoder目录的信息
	drwxr-xr-x. 3 root root 30 9月   9 08:55 ../daocoder 

	[root@localhost ~]# su - godao							切换下其他用户
	上一次登录：三 9月  7 11:19:21 CST 2016pts/0 上

	[godao@localhost /]$ cd daocoder/			
	[godao@localhost daocoder]$ touch test					尝试建立文件：失败
	touch: 正在设置"test" 的时间: 权限不够

	[root@localhost daocoder]# chmod o+w ./				root修改daocoder目录的权限
	[godao@localhost daocoder]$ ls -dl ./					看下看下daocoder的权限
	drwxr-xrwx. 3 root root 30 9月   9 08:55 ./			
	[godao@localhost daocoder]$ touch www					再次尝试建立文件：成功

###	改变目录所属组的权限，将用户添加到所属组以在其下建立文件

	[root@localhost daocoder]# chmod 775 ./				利用八进制法改变文件权限使所属组用户都有读写可执行权限

	[root@localhost daocoder]# usermod -G root godao	    将godao用户加入到root组	
	[root@localhost daocoder]# ls -l -d ./					现在看下daocoder目录的权限
	drwxrwxr-x. 3 root root 40 9月   9 09:10 ./

	[root@localhost ~]# su - godao							切换下用户到godao
	[godao@localhost daocoder]$ ls -al						看下daocoder目录下的文件列表
	drwxrwsr-x.  3 root  root   40 9月   9 14:09 .
	drwxr-xr-x. 18 root  root 4096 9月   8 17:03 ..
	-rw-r--r--.  1 root  root 2217 9月   9 08:52 passwd
	drwxr-xr-x.  4 root  root   55 9月   8 20:56 test
	touch: 正在设置"test" 的时间: 权限不够

	[godao@localhost daocoder]$ touch www					建立www文件：成功


这里有个bug，还没搞明白怎么解决。

	[godao@localhost daocoder]$ touch test			
	建立touch文件时变成了修改touch目录的时间 ，显示权限不够。那么如何在test目录下建立一个test文件呢？

