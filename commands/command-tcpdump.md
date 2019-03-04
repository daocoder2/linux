<div class="BlogAnchor">
   <p>
   	<b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之tcpdump

# 1、tcpdump命令简介

tcpdump命令是基于unix系统的命令行的数据报嗅探工具，可以抓取流动在网卡上的数据包。它的原理大概如下：**linux抓包是通过注册一种虚拟的底层网络协议来完成对网络报文（准确的是网络设备）消息的处理权。**当网卡接收到一个网络报文之后，它会遍历系统中所有已经注册的网络协议，如以太网协议、x25协议处理模块来尝试进行报文的解析处理。当抓包模块把自己伪装成一个网络协议的时候，系统在收到报文的时候就会给这个伪协议一次机会，让它对网卡收到的保温进行一次处理，此时该模块就会趁机对报文进行窥探，也就是啊这个报文完完整整的复制一份，假装是自己接收的报文，汇报给抓包模块。

## 1.1 语法

查看本地网卡状态：

	[root@cnetos daocoder]# netstat -i
	Kernel Interface table
	Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
	docker0   1500    40409      0      0 0         20376      0      0      0 BMU
	ens5f0    1500 22999894941      0      0 0      25581016784      0      0      0 BMRU
	lo       65536 850291094      0      0 0      850291094      0      0      0 LRU

- Iface：存在的网卡。
- MTU：最大传输单元。
- RX-OK RX-ERR RX-DRP RX-OVR：正确接收数据报的数量以及发生错误、流式、碰撞的总数。
- TX-OK TX-ERR TX-DRP TX-OVR：正确发送数据报的数量以及发生错误、流式、碰撞的总数。

---

	[root@centos daocoder]# tcpdump --help
	tcpdump version 4.9.0
	libpcap version 1.5.3
	OpenSSL 1.0.1e-fips 11 Feb 2013
	Usage: tcpdump [-aAbdDefhHIJKlLnNOpqStuUvxX#] [ -B size ] [ -c count ]
			[ -C file_size ] [ -E algo:secret ] [ -F file ] [ -G seconds ]
			[ -i interface ] [ -j tstamptype ] [ -M secret ] [ --number ]
			[ -Q|-P in|out|inout ]
			[ -r file ] [ -s snaplen ] [ --time-stamp-precision precision ]
			[ --immediate-mode ] [ -T type ] [ --version ] [ -V file ]
			[ -w file ] [ -W filecount ] [ -y datalinktype ] [ -z postrotate-command ]
			[ -Z user ] [ expression ]

这里面大概可以分成几类来看：

**1、类型的关键字**

- host：指明一台主机。如：host 10.1.110.110
- net：指明一个网络地址，如：net 10.1.0.0
- port：指明端口号：如：port 8090

**2、确定方向的关键字**

- src：ip包的源地址，如：src 10.1.110.110
- dst：ip包的目标地址。如：dst 10.1.110.110

**3、协议的关键字（缺省是所有协议的信息包）**

- fddi、ip、arp、rarp、tcp、udp。

**4、其它关键字**

- gateway、broadcast、less、greater。

**5、常用表达式**

- ! or not
- && or and 
- || or or

**6、参数详解**

- A：以ascii编码打印每个报文（不包括链路的头）。
- a：将网络地址和广播地址转变成名字。
- c：**抓取指定数目的包。**
- C：用于判断用 -w 选项将报文写入的文件的大小是否超过这个值，如果超过了就新建文件（文件名后缀是1、2、3依次增加）；
- d：将匹配信息包的代码以人们能够理解的汇编格式给出； 
- dd：将匹配信息包的代码以c语言程序段的格式给出； 
- ddd：将匹配信息包的代码以十进制的形式给出；
- D：列出当前主机的所有网卡编号和名称，可以用于选项 -i；
- e：在输出行打印出数据链路层的头部信息； 
- f：将外部的Internet地址以数字的形式打印出来； 
- F<表达文件>：从指定的文件中读取表达式,忽略其它的表达式； 
- i<网络界面>：**监听主机的该网卡上的数据流，如果没有指定，就会使用最小网卡编号的网卡（在选项-D可知道，但是不包括环路接口），linux 2.2 内核及之后的版本支持 any 网卡，用于指代任意网卡**； 
- l：如果没有使用 -w 选项，就可以将报文打印到 标准输出终端（此时这是默认）； 
- n：**显示ip，而不是主机名**； 
- nn：**显示port，而不是服务名**； 
- N：不列出域名； 
- O：不将数据包编码最佳化； 
- p：不让网络界面进入混杂模式； 
- q：快速输出，仅列出少数的传输协议信息； 
- r<数据包文件>：从指定的文件中读取包(这些包一般通过-w选项产生)； 
- s<数据包大小>：指定抓包显示一行的宽度，-s0表示可按包长显示完整的包，经常和-A一起用，默认截取长度为60个字节，但一般ethernet MTU都是1500字节。所以，要抓取大于60字节的包时，使用默认参数就会导致包数据丢失； 
- S：用绝对而非相对数值列出TCP关联数； 
- t：在输出的每一行不打印时间戳； 
- tt：在输出的每一行显示未经格式化的时间戳记； 
- T<数据包类型>：将监听到的包直接解释为指定的类型的报文，常见的类型有rpc （远程过程调用）和snmp（简单网络管理协议）； 
- v：**输出一个稍微详细的信息，例如在ip包中可以包括ttl和服务类型的信息**； 
- vv：**输出详细的报文信息**； 
- x/-xx/-X/-XX：以十六进制显示包内容，几个选项只有细微的差别，详见man手册； 
- w<数据包文件>：直接将包写入文件中，并不分析和打印出来；
- expression：用于筛选的逻辑表达式；

## 1.2 视图参数含义

	[root@centos dcocoder]# tcpdump host 10.1.110.110 -i ens5f0 -c 10 -l -n
	tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
	listening on ens5f0, link-type EN10MB (Ethernet), capture size 262144 bytes
	10:59:51.071567 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1715331653:1715331865, ack 2259278754, win 65535, length 212
	10:59:51.071699 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 212:408, ack 1, win 65535, length 196
	10:59:51.071794 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 408:572, ack 1, win 65535, length 164
	10:59:51.071861 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 572:736, ack 1, win 65535, length 164
	10:59:51.071910 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 736:900, ack 1, win 65535, length 164
	10:59:51.071958 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 900:1064, ack 1, win 65535, length 164
	10:59:51.072006 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1064:1228, ack 1, win 65535, length 164
	10:59:51.072053 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1228:1392, ack 1, win 65535, length 164
	10:59:51.072141 IP 10.1.85.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1392:1556, ack 1, win 65535, length 164
	10:59:51.077438 IP 10.1.110.110.7608 > 10.1.87.25.ssh: Flags [.], ack 212, win 63360, length 0
	10 packets captured
	13 packets received by filter
	0 packets dropped by kernel

1、第一行：`tcpdump: verbose output suppressed, use -v or -vv for full protocol decode`

使用选项`v`和`vv`，可以看出更全的详细内容。

2、第二行：`listening on ens5f0, link-type EN10MB (Ethernet), capture size 262144 bytes`，说明监听的是`ens5f0`这个NIC设备的网络包，且它的链路层是基于以太网的，要抓的包大小限制`262144`，装包大小限制可以用利用`-s`来控制。

3、第三行：`10:59:51.071567 IP 10.1.87.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1715331653:1715331865, ack 2259278754, win 65535, length 212`。

- `10:59:51.071567`：抓包时间为时、分、秒、微妙。
- `IP 10.1.87.21.ssh > 10.1.110.110.7608: Flags [P.], seq 1715331653:1715331865, ack 2259278754, win 65535, length 212`，这里用`man dump`这个命令引用说明：

> **src > dst: flags data-seqno ack window urgent options**
	Src and dst are the source and destination IP addresses and ports.  
	Flags are some combination of S (SYN), F (FIN), P (PUSH), R (RST), U (URG), W (ECN CWR), E  (ECN-Echo)  or  '.' (ACK),  or  'none'  if no flags are set.  
	Data-seqno describes the portion of sequence space covered by the data in this packet (see example below).  Ack is sequence number of the next data expected the other direction on this connection.  
	Window is the number of bytes of receive buffer space available the other direction on this connection.  
	Urg  indicates there is `urgent' data in the packet.  
	Options are tcp options enclosed in angle brackets (e.g., <mss 1024>).

上面视图简单的解释就是该包`10.1.87.21`传到`10.1.110.110`，通过的端口是`22`（ssh的端口）向`7608`，前几个是使用的是`PUSH`的标识，最后一个是返回的`ACK`标识。

## 1.3 常用场景

1、获取`10.1.85.21`和`10.1.85.19`之间的通信，使用命令注意转义符号。

	[root@centos daocoder]# tcpdump host 10.1.85.21 and \( 10.1.85.19\) -i ens5f0 -nn -c 10

2、获取从`10.1.85.21`发来的包。

	[root@centos daocoder]# tcpdump src host 10.1.85.21 -c 10 -i ens5f1

3、监听tcp（udp）端口。

	[root@centos daocoder]# tcpdump tcp port 22 -c 10

4、获取主机`10.1.85.21`和除`10.1.85.19`之外所有主机的通信。

	[root@centos daocoder]# tcpdump ip host 10.1.85.21 and ! 10.1.85.19 -c 10 -i any


5、获取从`10.1.85.19`且端口主机到`10.1.85.21`主机的通信。

	[root@centos daocoder]# tcpdump src host 10.1.85.19 and src port 48565 and dst host 10.1.85.21 and dst port 5090 -i any -c 10 -nn

# 2、感谢

[聊聊tcpdump与Wireshark抓包分析](https://www.jianshu.com/p/a62ed1bb5b20)
