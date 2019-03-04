<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之brctl

# 1、brctl命令简介

网桥是一种在链路层实现中继，对帧进行转发的技术，根据MAC分区块，可隔离碰撞，将网络的多个网段在数据链路层连接起来的网络设备。

和磁盘设备类似，Linux 用户想要使用网络功能，不能通过直接操作硬件完成，而需要直接或间接的操作一个 Linux 为我们抽象出来的设备，既通用的 Linux 网络设备来完成。一个常见的情况是，系统里装有一个硬件网卡，Linux 会在系统里为其生成一个网络设备实例，如 eth0，用户需要对 eth0 发出命令以配置或使用它了。更多的硬件会带来更多的设备实例，虚拟的硬件也会带来更多的设备实例。

首先安装网桥管理工具包：bridge-utile。

Linux内核通过一个虚拟的网桥设备来实现桥接的，这个设备可以绑定若干个以太网接口设备，从而将它们桥接起来。

网桥设备br0绑定了eth0和eth1。对于网络协议栈的上层来说，只看得到br0，因为桥接是在数据链路层实现的，上层不需要关心桥接的细节。于是协议栈上层需要发送的报文被送到br0，网桥设备的处理代码再来判断报文该被转发到eth0或是eth1，或者两者皆是；反过来，从eth0或从eth1接收到的报文被提交给网桥的处理代码，在这里会判断报文该转发、丢弃、或提交到协议栈上层。而有时候eth0、eth1也可能会作为报文的源地址或目的地址，直接参与报文的发送与接收（从而绕过网桥）。

强烈推荐下面两篇博文：

[划重点：Linux 上的基础网络设备详解](https://www.ibm.com/developerworks/cn/linux/1310_xiawc_networkdevice/)

[Linux 网络设备](https://segmentfault.com/blog/wuyangchun?page=1)

再解释一下：linux内核有网络设备管理层，处于网络驱动和网络协议栈间，负责它们之间的数据交互。例一个网卡eth0，它的一端内核协议栈（利用内核网络设备管理模块间接实现通信），另一段是外面的物理网络。从外面的物理网络接收的数据，会转发给内核协议栈，而应用程序也从内核协议栈发出数据。

## 1.1 语法

	[root@localhost ~]# brctl
	Usage: brctl [commands]
	commands:
		addbr     	<bridge>		add bridge									# 添加网桥
		delbr     	<bridge>		delete bridge								# 删除网桥
		addif     	<bridge> <device>	add interface to bridge					# 添加一个设备接口到网桥
		delif     	<bridge> <device>	delete interface from bridge			# 删除一个设备接口到网桥
		hairpin   	<bridge> <port> {on|off}	turn hairpin on/off
		setageing 	<bridge> <time>		set ageing time
		setbridgeprio	<bridge> <prio>		set bridge priority
		setfd     	<bridge> <time>		set bridge forward delay
		sethello  	<bridge> <time>		set hello time
		setmaxage 	<bridge> <time>		set max message age
		setpathcost	<bridge> <port> <cost>	set path cost
		setportprio	<bridge> <port> <prio>	set port priority
		show      	[ <bridge> ]		show a list of bridges					# 列出当前所有网桥
		showmacs  	<bridge>		show a list of mac addrs
		showstp   	<bridge>		show bridge stp info
		stp       	<bridge> {on|off}	turn stp on/off



