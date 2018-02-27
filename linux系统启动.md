<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# linux开机启动相关

[源地址：linux启动流程](http://chrinux.blog.51cto.com/6466723/1192004)

# １、系统的启动流程

POST加电自检-->BIOS(Boot Sequence)-->加载对应引导上的MBR(bootloader)-->主引导设置加载其BootLoader-->Kernel初始化-->initrd—>/etc/init进程加载/etc/inittab，其进程流程图如下：

![启动流程](http://i.imgur.com/bqTrURA.png)

# 2、对启动流程的解析

## 2.1 post加电自检（硬件检测）

**POST加电自检**：电脑主机在打开电源的时候，随后会听到滴的一声，说明系统启动了开机加电自检（post-power on self test），这个过程主要是检测计算机的硬件设备比如：CPU、内存、主板、显卡、CMOS等设备是否有故障。

CMOS常指保存计算机基本启动信息（如日期、时间、启动设置等）的芯片。有时人们会把CMOS和BIOS混称，其实CMOS是主板上的一块可读写的并行或串行FLASH芯片，是用来保存BIOS的硬件配置和用户对某些参数的设定。

若设备有故障时，按两种情况处理：对于严重故障（致命性故障）则停机，此时由于各种初始化尚未完成，不能给出任何的提示或信号；对于非严重故障则给出提示或警告给用户进行处理。这个过程若没有故障，post自己完成接力任务，将尾部的工作交给BIOS处理。

## 2.2 BIOS(寻找启动磁盘+主引导记录)

**BIOS**：计算机加电自检完成后第一个读取的地方就是就是BIOS（Basic Input Output System，基础输入输出系统），BIOS里面记录了主机板的芯片集与相关设置，如CPU与接口设备的通信频率、启动设备的搜索顺序、硬盘的大小与类型、系统时间、外部总线、各种接口设备的I/O地址、已经与CPU通信的IRQ中断信息，所以，启动如果要顺利启动，首先要读取BIOS设置。

按照BIOS所设定的系统启动流程，如果检测通过，则根据引导次序(Boot Sequence)开始寻找第一设备上支持启动程序，我们的启动设备主要包括硬盘、USB、SD等。我们一般用的是硬盘，然后进行读取第一个设备就是硬盘，第一个
要读去的就是该硬盘的主引导记录MBR（Master Boot Record），然后系统可以根据启动区安装的引导加载程序（Boot Loader）开始执行核心识别的工作，然后查找相关配置和定义。

## 2.3 MBR

MBR（Master Boot Record），即硬盘的主引导记录。为了便于理解，一般将MBR分为广义和狭义两种：广义的MBR包含整个扇区（引导程序、分区表及分隔标识），也就是上面所说的主引导记录；而狭义的MBR仅指引导程序而言。

[dd命令详解](http://blog.itpub.net/26686207/viewspace-717558/)

	[root@localhost daocoder]# dd if=/dev/sda of=/daocoder/mbr bs=512 count=1
	记录了1+0 的读入
	记录了1+0 的写出
	512字节(512 B)已复制，0.000332915 秒，1.5 MB/秒
	[root@localhost daocoder]# ls
	mbr
	[root@localhost daocoder]# ls -l mbr 
	-rw-r--r--. 1 root root 512 10月 17 10:01 mbr

这里mbr文件不能用cat直接输出或vim编辑，会乱码，只能按照下面方式输出。

[hexdump 十六进制查看器](http://codingstandards.iteye.com/blog/805778)

hexdump -C mbr -C参数，显示结果分为三列（文件偏移量、字节的十六进制、ASCII字符）

	[root@localhost daocoder]# hexdump -C mbr 
	00000000  eb 63 90 10 8e d0 bc 00  b0 b8 00 00 8e d8 8e c0  |.c..............|
	00000010  fb be 00 7c bf 00 06 b9  00 02 f3 a4 ea 21 06 00  |...|.........!..|
	00000020  00 be be 07 38 04 75 0b  83 c6 10 81 fe fe 07 75  |....8.u........u|
	00000030  f3 eb 16 b4 02 b0 01 bb  00 7c b2 80 8a 74 01 8b  |.........|...t..|
	00000040  4c 02 cd 13 ea 00 7c 00  00 eb fe 00 00 00 00 00  |L.....|.........|
	00000050  00 00 00 00 00 00 00 00  00 00 00 80 01 00 00 00  |................|
	00000060  00 00 00 00 ff fa 90 90  f6 c2 80 74 05 f6 c2 70  |...........t...p|
	00000070  74 02 b2 80 ea 79 7c 00  00 31 c0 8e d8 8e d0 bc  |t....y|..1......|
	00000080  00 20 fb a0 64 7c 3c ff  74 02 88 c2 52 be 05 7c  |. ..d|<.t...R..||
	00000090  b4 41 bb aa 55 cd 13 5a  52 72 3d 81 fb 55 aa 75  |.A..U..ZRr=..U.u|
	000000a0  37 83 e1 01 74 32 31 c0  89 44 04 40 88 44 ff 89  |7...t21..D.@.D..|
	000000b0  44 02 c7 04 10 00 66 8b  1e 5c 7c 66 89 5c 08 66  |D.....f..\|f.\.f|
	000000c0  8b 1e 60 7c 66 89 5c 0c  c7 44 06 00 70 b4 42 cd  |..`|f.\..D..p.B.|
	000000d0  13 72 05 bb 00 70 eb 76  b4 08 cd 13 73 0d 5a 84  |.r...p.v....s.Z.|
	000000e0  d2 0f 83 de 00 be 85 7d  e9 82 00 66 0f b6 c6 88  |.......}...f....|
	000000f0  64 ff 40 66 89 44 04 0f  b6 d1 c1 e2 02 88 e8 88  |d.@f.D..........|
	00000100  f4 40 89 44 08 0f b6 c2  c0 e8 02 66 89 04 66 a1  |.@.D.......f..f.|
	00000110  60 7c 66 09 c0 75 4e 66  a1 5c 7c 66 31 d2 66 f7  |`|f..uNf.\|f1.f.|
	00000120  34 88 d1 31 d2 66 f7 74  04 3b 44 08 7d 37 fe c1  |4..1.f.t.;D.}7..|
	00000130  88 c5 30 c0 c1 e8 02 08  c1 88 d0 5a 88 c6 bb 00  |..0........Z....|
	00000140  70 8e c3 31 db b8 01 02  cd 13 72 1e 8c c3 60 1e  |p..1......r...`.|
	00000150  b9 00 01 8e db 31 f6 bf  00 80 8e c6 fc f3 a5 1f  |.....1..........|
	00000160  61 ff 26 5a 7c be 80 7d  eb 03 be 8f 7d e8 34 00  |a.&Z|..}....}.4.|
	00000170  be 94 7d e8 2e 00 cd 18  eb fe 47 52 55 42 20 00  |..}.......GRUB .|
	00000180  47 65 6f 6d 00 48 61 72  64 20 44 69 73 6b 00 52  |Geom.Hard Disk.R|
	00000190  65 61 64 00 20 45 72 72  6f 72 0d 0a 00 bb 01 00  |ead. Error......|
	000001a0  b4 0e cd 10 ac 3c 00 75  f4 c3 00 00 00 00 00 00  |.....<.u........|
	000001b0  00 00 00 00 00 00 00 00  f7 87 0b 00 00 00 80 20  |............... |
	000001c0  21 00 83 dd 1e 3f 00 08  00 00 00 a0 0f 00 00 dd  |!....?..........|
	000001d0  1f 3f 8e fe ff ff 00 a8  0f 00 00 58 70 02 00 00  |.?.........Xp...|
	000001e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
	000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
	00000200

16列*32行=512Bytes，硬盘的0柱面、0磁头、1扇区称为主引导扇区（也叫主引导记录MBR）。它由三个部分组成，主引导程序、硬盘分区表DPT（Disk Partition table）和分区有效标志。在总共512字节的主引导扇区里主引导程序（boot loader）占446个字节，第二部分是Partition table区（分区表），即DPT，占64个字节，硬盘中分区有多少以及每一分区的大小都记在其中。第三部分是magic number（检验码），占2个字节，固定为0xAA55或0x55AA，这取决于处理器类型，如果是小端模式处理器（如Intel系列），则该值为0xAA55；如果是大端模式处理器（如Motorola6800），则该值为0x55AA。

> 每个分区占16字节，即分区表64字节最大可分4个分区。

## 2.4 Boot Loader 加载Grub（grand unified bootloader 统一引导程序）程序

因引导程序只有466Bytes，放不下内核，就写一个小程序bootloader去引导kernel。这个小程序有两种：lilo和greb。lilo重启后生效，greb修改后生效。lilo已被grub取代。

Boot Loader 是在操作系统内核运行之前运行的一段小程序。通过这段小程序，我们可以初始化硬件设备、建立内存空间的映射图，从而将系统的软硬件环境带到一个合适的状态，以便为最终调用操作系统内核准备好正确的环境。

kernl主要靠Grub的引导开始的，Grub存在于/boot/grub ，分为两个阶段：

- stage1：主要是Boot loader ，系统启动时，装载stage2。它无法直接连接greb2，中间借助stage1.5。

- stage 1.5:过渡 ，文件系统之类。

- stage2:主要是/boot/grub，greb的核心

/boot/grub下有很多文件，大体分为下面几个：stage1、文件系统类型-stage1.5、stage2、grub.conf或grub.cfg。

grub.conf里面存放的是grub配置文件，即改即生效，这也是区别于lilo的最大部分。

这个grub.conf里面的文件说明可参数最上面的那个链接文件。

## 2.5  kernel

根据Grub内的定义，grub读取完毕后就把下面的工作交个内核了。kernel主要是完成系统硬件探测及硬件驱动的初始
化，并且以读写的方式挂载根文件系统（根切换），那么这里就出现了一个“先有鸡还是先有蛋的文件了”，具体是什么呐？
 
要想访问真正的根文件系统（rootfs）的话，就必须加载根文件系统中的设备，这时根文件系统又没有挂载，要挂载根文件系统又得加载根文件系统中的驱动程序，哪怎么办呢？为了解决这个问题，这是就用到了initrd文件了。
 
再来说下kernel初始化所要工作的内容做下简单总结：**探测硬件->加载驱动（initrd)->挂载根文件系统->rootfs(/sbin/init)。**

到此止内核空间的相关工作已经完成，内核空间的任务开始向用户空间转移，内核空间通过一个间接的initrd(微型
linux)向用户空间的/sbin/init过度，所以gurb开始引导内核转向initrd。 

## 2.6 initrd（初始化跟文件系统所需驱动+挂载根文件系统）

initrd：一个虚拟的文件系统，里面有lib、bin、sbin、usr、proc、sys、var、dev、boot等一些目录，其实你会发现里面的目录有点像真的/,对吧，所以我们称之为虚拟的根文件系统，作用就是将kernel和真的根文件系统建立关联关系，让kernel去initrd中加载根文件系统所需要的驱动程序，并以读写的方式挂载根文件系统，并让执行用户当中第一个进程init。 

## 2.7 init

init执行完毕以后会启动系统内的/etc/inittab文件，来完成系统系统的初始化工作。下面我们来介绍一下inittab这个配置文件内的详细内容。

![init](http://i.imgur.com/CZfEjPM.png)

各个级别的定义：
默认运行级别      

	0：halt                     				关机  
	1: single user mode   						单用户维护模式)  
	2：multi user mode, without NFS  			不支持NFS功能  
	3: multi user mode, text mode     			字符界面  
	4：reserved   								系统保留  
	5: multi user mode, graphic mode   			图形化界面  
	6: reboot   								重启 
	
	/etc/inittab格式及语法(:)    
	[选项]:[runlevel]:[行为]:[命令] 
	行为：  
	                   initdefault：代表默认运行级别  
	                   sysinit：代表系统初始化操作选项  
	                   ctrlaltdel：代表重启的相关设置  
	                   wait：代表上一个命令执行结束后方可执行下面的操作  
	                   respawn：代表后面字段可以无限制再生(reboot) 
	命令选项  
	               一些命令，不过通常都是脚本 

inittab这个配置文件会指定初始化脚本：rc.sysint。

这个文件在/etc/rc.d的目录下，这个目录内容如下（这是虚拟机，不全）。

	[root@localhost etc]# ls rc*
	rc.local
	
	rc0.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  K80iprinit    K90network
	K05pmie  K05pmmgr     K05pmwebd   K79iprdump     K80iprupdate
	
	rc1.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  K80iprinit    K90network
	K05pmie  K05pmmgr     K05pmwebd   K79iprdump     K80iprupdate
	
	rc2.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  S20iprinit    S21iprdump
	K05pmie  K05pmmgr     K05pmwebd   S10network     S20iprupdate
	
	rc3.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  S20iprinit    S21iprdump
	K05pmie  K05pmmgr     K05pmwebd   S10network     S20iprupdate
	
	rc4.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  S20iprinit    S21iprdump
	K05pmie  K05pmmgr     K05pmwebd   S10network     S20iprupdate
	
	rc5.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  S20iprinit    S21iprdump
	K05pmie  K05pmmgr     K05pmwebd   S10network     S20iprupdate
	
	rc6.d:
	K05pmcd  K05pmlogger  K05pmproxy  K50netconsole  K80iprinit    K90network
	K05pmie  K05pmmgr     K05pmwebd   K79iprdump     K80iprupdate
	
	rc.d:
	init.d  rc0.d  rc1.d  rc2.d  rc3.d  rc4.d  rc5.d  rc6.d  rc.local

rc.sysinit脚本内定义了一些与系统初始化的定义：
设定主机名；检测并挂载/etc/fstab中其他文件系统；启动swap分区；/etc/sysctl.conf设定内核参数；装载键映射-->键盘上每个键的功能；然后根据系统运行级别运行相关的服务脚本：/etc/rc.d/init.d/脚本和/etc/rc.d/rc*.d。 

	rc0-rc6目录下脚本： 
	K*     ##只要是以K开头的文件均执行stop工作  
	S*     ##只要是以S开头的文件均执行start工作  
	0-99  (执行次序，数字越小越先被执行) 
	用户自定义开机启动程序(/etc/rc.d/rc.local)  
	可以根据自己的需求将一些执行命令或是脚本写到/etc/rc.d/rc.local里，当开机时，就可以加载啦。

## 2.8 加载用户文件

四个文件：2个全局（/etc/bashrc、/etc/profile）和两个用户（/home/daocoder/.bashrc、/home/daocoder/.bashrc_profile）。

他们是加载系统及自己的环境变量。

# 3、查看系统级别

[root@localhost etc]# runlevel 				N指上次启动级别，5当前启动级别
N 5
[root@localhost etc]# init 3				切换启动级别
[root@localhost etc]# runlevel 				上次级别5，这次级别3
5 3

# 4、系统初始化总结

	硬件的初始化，图像界面启动的初始化（如果设置了默认启动基本）  
	主机RAID的设置初始化，device mapper 及相关的初始化，  
	检测根文件系统，以只读方式挂载  
	激活udev和selinux  
	设置内核参数 /etc/sysctl.conf  
	设置系统时钟  
	启用交换分区，设置主机名  
	加载键盘映射  
	激活RAID和LVM逻辑卷  
	挂载额外的文件系统 /etc/fstab  
	最后根据mingetty程序调用login让用户登录->用户登录（完成系统启动）
	在系统启动过程中主要的脚本和目录有:
	boot
	/grub
	/boot/grub/grub.conf
	/boot/initrd+内核版本
	/initrd文件中的/proc/  /sys/    /dev/ 目录的挂载 及根的切换
	/etc/inittab  脚本
	/etc/rc.d/rc.sysinit  脚本 等








