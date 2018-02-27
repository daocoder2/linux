<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# ssh免密登录

ssh（secure shell）：使用加密通道来传输数据。其采用非对称加密技术，认证密匙包含两个部分：公匙和密匙。通过ssh-keygen命令创建密匙。要实现认证自动化，公匙必须放在服务器当中（将其加在~/.ssh/authorized_keys）,与公匙相对应的私匙应该放在客户机的~/.ssh文件夹中。

## 1、需求概要

ssh 无密码登录要使用公钥与私钥。

linux下可以用用ssh-keygen生成公钥/私钥对，下面以centos为例。

有机器A(192.168.8.234)，B(192.168.8.120)。现想A通过ssh免密码登录到B。

简单尝试，root操作。


## 2、实际操作

**1、首先登录到A机器**

	
	[root@localhost home]# cd
	# -P '' 就表示空密码，也可以不用-P参数，这样就要三次回车，用-P就一次回车。
	[root@localhost ~]#  $ ssh-keygen -t rsa -P ''

此时在家目录下面就生成了公钥/私钥对文件。

	[root@localhost ~]# cd .ssh/
	[root@localhost .ssh]# ll
	总用量 12
	-rw------- 1 root root 1679 1月  16 13:57 id_rsa
	-rw-r--r-- 1 root root  408 1月  16 13:57 id_rsa.pub

**2、再登录到B机器**

先切到相应的家目录下面的.ssh文件夹。

	[root@localhost .ssh]# cd 
	[root@localhost ~]# cd .ssh/
	
看下有没authorized_keys这个文件。

	[root@localhost .ssh]# ll
	总用量 16
	-rw-r--r-- 1 root root  408 1月  16 14:01 authorized_keys
	-rw------- 1 root root 1675 1月   8 09:09 id_rsa
	-rw-r--r-- 1 root root  408 1月   8 09:09 id_rsa.pub

有的话将**A机器下面的id_rsa.pub文件内容追加到这个文件的后面（注意换行）**。没有的话新建这个文件，然后把**A机器下面的id_rsa.pub文件内容写入到这个文件中**，退出保存。

**3、登录测试**

自己是什么用户名，就把root换了就好。

	[root@localhost ~]# ssh root@192.168.8.120
	Last login: Tue Jan 16 14:02:11 2018 from 192.168.8.234

## 3、奇淫技巧

**1、一个命令搞定远程写入公匙问题。**

A机器执行下面代码。

	[root@localhost .ssh]# ssh USER@REMOTE_HOST "cat >> ~/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
	Password:

上面输入B机器的密码就完了。

**2、ssh-copy-id**

多数Linux发布版中有一个叫做ssh-copy-id的工具，它可以自动将私钥加入远
程服务器的authorized_keys文件中。

	[root@localhost .ssh]# ssh-copy-id USER@REMOTE_HOST