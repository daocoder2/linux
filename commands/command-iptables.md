<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之iptables

## 1、iptables命令简介

iptables命令是Linux上常用的防火墙软件，是netfilter项目的一部分。可以直接配置，也可以通过许多前端和图形界面配置。它可以用来过滤、阻塞不需要的流量，允许正常的网络流浪通行。

### 1.1 语法

	iptables(选项)(参数)

### 1.2 选项

- -t<表>：指定要操纵的表；
- -A：向规则链中添加条目；
- -D：从规则链中删除条目；
- -i：向规则链中插入条目；
- -R：替换规则链中的条目；
- -L：显示规则链中已有的条目；
- -F：清楚规则链中已有的条目；
- -Z：清空规则链中的数据包计算器和字节计数器；
- -N：创建新的用户自定义规则链；
- -P：定义规则链中的默认目标；
- -h：显示帮助信息；
- -p：指定要匹配的数据包协议类型；
- -s：指定要匹配的数据包源ip地址；
- -j<目标>：指定要跳转的目标；
- -i<网络接口>：指定数据包进入本机的网络接口；
- -o<网络接口>：指定数据包要离开本机所使用的网络接口。

### 1.3 命令顺序

	iptables -t 表名 <-A/I/D/R> 规则链名 [规则号] <-i/o 网卡名> -p 协议名 <-s 源IP/源子网> --sport 源端口 <-d 目标IP/目标子网> --dport 目标端口 -j 动作

### 1.4 命令解释

**1、表名**

- raw：高级功能，如：网址过滤。
- mangle：数据包修改（QOS），用于实现服务质量。
- net：地址转换，用于网关路由器。
- filter：包过滤，用于防火墙规则。

**2、规则链名**

- INPUT链：处理输入数据包。
- OUTPUT链：处理输出数据包。
- PORWARD链：处理转发数据包。
- PREROUTING链：用于目标地址转换（DNAT）。
- POSTOUTING链：用于源地址转换（SNAT）。

**3、动作**

- accept：接收数据包。
- drop：丢弃数据包。
- redirct：重定向、映射、透明代理。
- snat：源地址转换。
- dnat：目标地址转换。
- masquerade：IP伪装（NAT），用于ADSL。
- log：日志记录。

## 2、常用命令

**1、开放指定的端口**

	iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT               #允许本地回环接口(即运行本机访问本机)
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT    #允许已建立的或相关连的通行
	iptables -A OUTPUT -j ACCEPT         #允许所有本机向外的访问
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT    #允许访问22端口
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT    #允许访问80端口
	iptables -A INPUT -p tcp --dport 21 -j ACCEPT    #允许ftp服务的21端口
	iptables -A INPUT -p tcp --dport 20 -j ACCEPT    #允许FTP服务的20端口
	iptables -A INPUT -j reject       #禁止其他未允许的规则访问
	iptables -A FORWARD -j REJECT     #禁止其他未允许的规则访问

**2、屏蔽IP**

	iptables -I INPUT -s 123.45.6.7 -j DROP       #屏蔽单个IP的命令
	iptables -I INPUT -s 123.0.0.0/8 -j DROP      #封整个段即从123.0.0.1到123.255.255.254的命令
	iptables -I INPUT -s 124.45.0.0/16 -j DROP    #封IP段即从123.45.0.1到123.45.255.254的命令
	iptables -I INPUT -s 123.45.6.0/24 -j DROP    #封IP段即从123.45.6.1到123.45.6.254的命令是

**3、查看已添加的iptables规则**

iptables -L -n -v

	Chain INPUT (policy DROP 48106 packets, 2690K bytes)
	 pkts bytes target     prot opt in     out     source               destination         
	 5075  589K ACCEPT     all  --  lo     *       0.0.0.0/0            0.0.0.0/0           
	 191K   90M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:22
	1499K  133M ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp dpt:80
	4364K 6351M ACCEPT     all  --  *      *       0.0.0.0/0            0.0.0.0/0           state RELATED,ESTABLISHED
	 6256  327K ACCEPT     icmp --  *      *       0.0.0.0/0            0.0.0.0/0           

	Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
	 pkts bytes target     prot opt in     out     source               destination         
	
	Chain OUTPUT (policy ACCEPT 3382K packets, 1819M bytes)
	 pkts bytes target     prot opt in     out     source               destination         
	 5075  589K ACCEPT     all  --  *      lo      0.0.0.0/0            0.0.0.0/0  

**4、删除已添加的iptables规则**

将所有iptables以序号标记显示，执行：

	iptables -L -n --line-numbers

比如要删除INPUT里序号为8的规则，执行：

	iptables -D INPUT 8