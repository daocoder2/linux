<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之iptables

# 1、iptables命令简介

ip 是个命令， ip 命令的功能很多！基本上它整合了 ifconfig 与 route 这两个命令，不过 ip 的功能更强大。

## 1.1 语法

	[root@localhost ~]# ip
	Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }
	       ip [ -force ] -batch filename
	where  OBJECT := { link | addr | addrlabel | route | rule | neigh | ntable |
	                   tunnel | tuntap | maddr | mroute | mrule | monitor | xfrm |
	                   netns | l2tp | tcp_metrics | token }
	       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |
	                    -f[amily] { inet | inet6 | ipx | dnet | bridge | link } |
	                    -4 | -6 | -I | -D | -B | -0 |
	                    -l[oops] { maximum-addr-flush-attempts } |
	                    -o[neline] | -t[imestamp] | -b[atch] [filename] |
	                    -rc[vbuf] [size]}

## 1.2 选项

OPTIONS：选项。

- -s：显示出该设备的统计数据(statistics)，例如总接受封包数等；

OBJECT：动作对象，就是是可以针对哪些网络设备对象进行动作。

-  link：关于设备 (device) 的相关设定，包括 MTU，MAC 地址等。
-   addr/address：关于额外的 IP 设定，例如多 IP 的实现等。
-   route ：与路由有关的相关设定。

## 1.3 命令解释

### 1.3.1 ip link 相关

ip link 可以设定与设备(device)有关的相关设定，包括MTU以及该网络设备的MAC等，当然也可以启动(up)或关闭(down)某个网络设备。


**1、查看当前主机设备**

	[root@hserver1 ~]# ip link
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff

	[root@hserver1 ~]# ip link show
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff

	[root@hserver1 ~]# ip -s link show
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    RX: bytes  packets  errors  dropped overrun mcast   
	    2484149802179 18084541920 0       0       0       0      
	    TX: bytes  packets  errors  dropped carrier collsns 
	    2484149802179 18084541920 0       0       0       0      
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff
	    RX: bytes  packets  errors  dropped overrun mcast   
	    543869729815 1042387048 0       0       0       0      
	    TX: bytes  packets  errors  dropped carrier collsns 
	    145245658628 953348255 0       0       0       0 

使用`ip link show`可以显示出整个设备的硬件相关信息，如上所示，包括MAC地址、MTU等。lo是主机内部自行设定的，如果加上`-s`的参数后，则这个网卡的相关统计信息就会被列出来，包括接收(RX)及传送(TX)的封包数量等，详细的内容与`ifconfig`所输出的结果相同。

**2、启动、关闭与设定设备的相关信息**

	# 关闭ens32这个设备
	[root@localhost ~]# ip link set ens32 down

	# 启动ens32这个设备
	[root@localhost ~]# ip link set ens32 up

	# 更改MTU为1000 bytes，单位就是bytes，再改回来。
	[root@localhost ~]# ip link set ens32 mtu 1000
	[root@hserver1 ~]# ip link show
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1000 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff
	[root@localhost ~]# ip link set ens32 mtu 1500

要更改网卡代号、MAC地址的信息的话，设定前需要先关闭该网卡，否则会不成功。

	[root@localhost ~]# ip link set ens32 name daocoder
	RTNETLINK answers: Device or resource busy

	# 关闭ens32这个设备
	[root@localhost ~]# ip link set ens32 down
	# 改网卡名
	[root@localhost ~]# ip link set ens32 name daocoder
	2 daocoder: <BROADCAST,MULTICAST> mtu 1000 qdisc noqueue state DOWN mode DEFAULT 
    link/ether 02:42:41:f5:6b:fb brd ff:ff:ff:ff:ff:ff
	# 改回来
	[root@localhost ~]# ip link set daocoder name ens32
	# 如果你的网卡支持MAC更改，测试完之后要立刻改回来
	[root@localhost ~]# ip link set ens32 address aa:aa:aa:aa:aa:aa

在这个设备的硬件相关信息设定，上面包括 MTU, MAC 以及传输的模式等等，都可以在这里设定。

### 1.3.2 ip address 相关

如果说`ip link`是与OSI七层模型的第二层数据链路层有关的话，那么`ip address (ip addr)`就是与第三层网络层有关的了。主要是在设定与 IP 有关的各项参数，包括 netmask, broadcast 等。

**1、查看IP参数**

	[root@hserver1 ~]# ip addr
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff
	    inet 192.168.8.120/24 brd 192.168.8.255 scope global dynamic ens32
	       valid_lft 66532sec preferred_lft 66532sec
	    inet6 fe80::20c:29ff:fea8:9dcf/64 scope link 
	       valid_lft forever preferred_lft forever
	[root@hserver1 ~]# ip addr show
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff
	    inet 192.168.8.120/24 brd 192.168.8.255 scope global dynamic ens32
	       valid_lft 66526sec preferred_lft 66526sec
	    inet6 fe80::20c:29ff:fea8:9dcf/64 scope link 
	       valid_lft forever preferred_lft forever
	[root@hserver1 ~]# ip -s addr show
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever
	2: ens32: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
	    link/ether 00:0c:29:a8:9d:cf brd ff:ff:ff:ff:ff:ff
	    inet 192.168.8.120/24 brd 192.168.8.255 scope global dynamic ens32
	       valid_lft 66522sec preferred_lft 66522sec
	    inet6 fe80::20c:29ff:fea8:9dcf/64 scope link 
	       valid_lft forever preferred_lft forever

ip address [add|del] [IP参数] [dev 设备名] [相关参数]

	[root@hserver1 ~]# ip addr 
	add      change   del      flush    help     replace  show

[add|del]：

- add|del：进行相关参数的增加(add)或删除(del)设定。
- show：显示详细信息。

IP 参数 ：主要就是网域的设定，例如 192.168.100.100/24 之类的设定。

[dev 设备名]：IP 参数所要设定的设备，例如eth0, eth1等。

[相关参数]：

- broadcast：设定广播位址，如果设定值是 + 表示让系统自动计算；
- label：该设备的别名，例如eth0:0；
- scope：这个设备的领域，默认global，通常是以下几个大类：
	- global：允许来自所有来源的连线；
	- site：仅支持IPv6 ，仅允许本主机的连接；
	- link：仅允许本设备自我连接；
	- host：仅允许本主机内部的连接；

	[root@localhost ~]# ip addr show lo
	1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN 
	    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
	    inet 127.0.0.1/8 scope host lo
	       valid_lft forever preferred_lft forever
	    inet6 ::1/128 scope host 
	       valid_lft forever preferred_lft forever

	[root@localhost ~]# ip address add 192.168.12.23/24 broadcast + dev ens160 label ens160:test

如果远程连接，下面的操作要自己的主机和远程机器在统一网段再操作。

一个网卡只能绑定一个IP地址（即IP与MAC绑定），但可以设置多个IP地址，作用就是可以连接多个网段（就是可以访问多个网段），但前提是这些网段物理层是连接在一起。

	# 给ens160这块网卡再设置一个虚拟ip。
	[root@localhost ~]# ip addr show ens160
	2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000
	    link/ether 00:0c:29:22:c5:7c brd ff:ff:ff:ff:ff:ff
	    inet 192.168.8.216/24 brd 192.168.8.255 scope global ens160
	       valid_lft forever preferred_lft forever
	    inet 192.168.12.23/24 brd 192.168.12.255 scope global ens160:test
	       valid_lft forever preferred_lft forever
	    inet6 fe80::20c:29ff:fe22:c57c/64 scope link 
	       valid_lft forever preferred_lft forever

	# 然后再删除这个ip
	[root@localhost ~]# ip address del 192.168.12.23/24 dev ens160

### 1.3.3 ip route 相关

**tips：此节不要随便尝试。**

路由的查看与设定。事实上ip route 的功能几乎与 route 这个命令一样，但是，它还可以进行额外的参数设置，例如MTU的规划等。

	[root@localhost ~]# ip route
	default via 192.168.8.254 dev ens160  proto static  metric 100 
	172.18.0.0/16 dev br-b16b81326e94  proto kernel  scope link  src 172.18.0.1 
	192.168.8.0/24 dev ens160  proto kernel  scope link  src 192.168.8.216  metric 100 
	[root@localhost ~]# ip route show
	default via 192.168.8.254 dev ens160  proto static  metric 100 
	172.18.0.0/16 dev br-b16b81326e94  proto kernel  scope link  src 172.18.0.1 
	192.168.8.0/24 dev ens160  proto kernel  scope link  src 192.168.8.216  metric 100

必须注意的几点： 

- proto：此路由的路由协定，主要有redirect,kernel,boot,static,ra等，其中kernel是直接由核心判断自动设定。 
- scope：路由的范围，主要是link，是与本设备有关的直接连接。

ip route [add|del] [IP或网域] [via gateway] [dev 设备]

	[root@localhost ~]# ip route 
	add      append   change   del      flush    get      help     list     monitor  replace

[add|del]：

- add|del：增加(add)或删除(del)路由。
- show：显示详细信息。

[IP或网域]：可使用192.168.50.0/24之类的网域或者是单纯的 IP 。

[via gateway]：从哪个gateway出去，不一定需要。

[dev 设备名]：所要设定的设备，例如eth0, eth1等。

**1、显示当前路由**

	[root@localhost ~]# ip route
	default via 192.168.8.254 dev ens160  proto static  metric 100 
	172.18.0.0/16 dev br-b16b81326e94  proto kernel  scope link  src 172.18.0.1 
	192.168.8.0/24 dev ens160  proto kernel  scope link  src 192.168.8.216  metric 100 
	[root@localhost ~]# ip route show
	default via 192.168.8.254 dev ens160  proto static  metric 100 
	172.18.0.0/16 dev br-b16b81326e94  proto kernel  scope link  src 172.18.0.1 
	192.168.8.0/24 dev ens160  proto kernel  scope link  src 192.168.8.216  metric 100

**2、增加路由**

主要是本机直接可沟通的网域。

	[root@localhost ~]# ip route add 192.168.12.0/24 dev ens160

**3、增加通往外部路由**

	[root@localhost ~]# ip route add 192.168.10.0/24 via 192.168.12.1 dev eth0

**4、删除路由**

	[root@localhost ~]# ip route del 192.168.10.0/24