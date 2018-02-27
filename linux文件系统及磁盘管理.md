<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# linux文件系统及磁盘管理

# 1、文件系统简介

## 1.1 什么是文件系统
文件系统至今没有准确的定义，姑且找几个看起来通俗易懂又比较切合的来看下。

- 文件系统是文件的数据结构或组织方法。

- 文件系统是基于被划分的存储设备上的逻辑上单位上的一种定义文件的命名、存储、组织及取出的方法；

- 文件系统是包括在一个磁盘（包括光盘、软盘、闪盘及其它存储设备）或分区的目录结构；一个可应用的磁盘设备可以包含一个或多个文件系统；如果您想进入一个文件系统，首先您要做的是挂载（ mount）文件系统；为了挂载（ mount）文件系统，您必须指定一个挂载点。

从上面可以看出，一个文件系统大体可以从下面几方面来理解，同时它们又是顺序列出：

- 存储介质：硬盘、光盘、软盘、 Flash 盘、磁带、网络存储设备等；

- 硬盘的分割， Linux 有 fdisk、 cfdisk 和 parted 等，常用的还是 fdisk 工具， Windows 和 dos 常用的也有fdisk ，但和 Linux 中的使用方法不一样。硬盘的分割工具还有第三方程序，比如 PQ。

- 格式化（文件系统的创建）：这个过程是存储设备建立文件系统的过程，通过一些初始化工具来进行。一般的情况下每个类型的操作系统都有这方面的工具，也有多功能的第三方工具，比如 PQ。如果您不太懂操作系统自带的工具，可以用第三方工具来切割硬盘，把硬盘分割成若干分区，然后再用操作系统自带的工作来初始化分区，也就是格式化分区。在Linux中有 mkfs 系列工具。

- 挂载（ mount）：文件系统只有挂载才能使用， Unix 类的操作系统如此， Windows 也是一样；在 Windows 更直观一些，具体内部机制我们不太了解。但 Unix类的操作系统是通过mount进行的，挂载文件系统时要有挂载点，比如我们在安装 Linux 的过程中，有时会提示我们分区，然后建立文件系统，接着是问你的挂载点是什么，我们
大多选择的是/ 。我们在 Linux 系统的使用过程中，也会挂载其它的硬盘分区，也要选中挂载点，挂载点通
常是一个空置的目录，最好是我们自建的空置目录。

- 文件系统可视的几何结构：文件系统的是用来组织和排列文件存取的，它又是可见的。linux通过ls查看，windows可视化不必说。

## 1.2 文件系统类型

文件系统类型有很多，但我们在 Linux 中常用的文件系统主要有 ext3、ext2 及 reiserfs； Windows 和 Dos 常用的文件系统是 fat 系列（包括 fat16 及 fat32等）和 ntfs 文件系统；光盘文件系统是 ISO-9660 文件系统；网络存储 NFS 服务器在客户端访问时，文件系统是 nfs，这个比较特殊一点；

### 1.2.1 ext*系统

ext2 文件系统应该说是 Linux 正宗的文件系统，早期的 Linux 都是用 ext2，但随着技术的发展，大多 Linux
的发行版本目前并不用这个文件系统了；比如 Redhat 和 Fedora 大多都建议用 ext3 ， ext3 文件系统是由 ext2
发展而来的。对于 Linux 新手，我们还是建议您不要用 ext2 文件系统； ext2 支持 undelete（反删除），如果
您误删除文件，有时是可以恢复的，但操作上比较麻烦； ext2 支持大文件。

ext3 is a Journalizing file system for Linux（ ext3 是一个用于 Linux 的日志文件系统）， ext3 支持大文件；但不支持反删除（ undelete）操作； Redhat 和 Fedora 都力挺 ext3。该文件系统从**2.4.15**版本的内核开始，合并到内核主线中。

ext4是第四代扩展文件系统（英语：Fourth extended filesystem，缩写为 ext4）是Linux系统下的日志文件系统，是ext3文件系统的后继版本。2008年12月25日，Linux Kernel **2.6.28**的正式版本发布。随着这一新内核的发布，ext4文件系统也结束实验期，成为稳定版。

### 1.2.2 其它文件系统简介

jsf 提供了基于日志的字节级文件系统，该文件系统是为面向事务的高性能系统而开发的。jsf（ Journaled File
System Technology for Linux）的开发者包括 AIX（ IBM 的 Unix）的 jsf 的主要开发者。

ReiserFS 。 ReiserFS 3.6.x（作为 Linux 2.4 一部分的版本）是由 Hans Reiser 和他的在 Namesys 的开发组
共同开发设计的。 Hans 和他的组员们相信最好的文件系统是那些能够有助于创建独立的共享环境或者命名空间的文件系统，应用程序可以在其中更直接、有效和有力地相互作用。

xfs 是一种非常优秀的日志文件系统，它是 SGI 公司设计的。 xfs 被称为业界最先进的、最具可升级性的文件
系统技术。它是一个全 64 位,快速、稳固的日志文件系统，多年用于 SGI 的 IRIX 操作系统。

iso9660： 标准 CDROM 文件系统，通用的 Rock Ridge 增强系统，允许长文件名。

Nfs： Sun 公司推出的网络文件系统，允许多台计算机之间共享同一文件系统，易于从所有这些计算机上存取文件。

NTFS：微软 Windows NT 内核的系列操作系统支持的、一个特别为网络和磁盘配额、文件加密等管理安全特
性设计的磁盘格式。

# 2、磁盘的简介及使用

学习 Linux 的磁盘档案系统，所以我们就需要先来了解一下硬盘的基础知识。

## 2.1 硬盘的物理组成

硬盘是电脑主要的存储媒介之一，由一个或者多个铝制或者玻璃制的碟片组成。碟片外覆盖有铁磁性材料。

硬盘有固态硬盘（Solid State Drives）（SSD 盘，新式硬盘）、机械硬盘（Hard Disk Drive）（HDD 传统硬盘）、混合硬盘Hybrid Hard Disk（HHD 一块基于传统机械硬盘诞生出来的新硬盘）。SSD采用闪存颗粒来存储，HDD采用磁性碟片来存储，混合硬盘是把磁性硬盘和闪存集成到一起的一种硬盘。绝大多数硬盘都是固定硬盘，被永久性地密封固定在硬盘驱动器中。

### 2.1.1 硬盘的基础知识

- 基本参数：
	- 容量：作为计算机系统的数据存储器，容量是硬盘最主要的参数。

	- 转速：Rotational Speed 或Spindle speed，是硬盘内电机主轴的旋转速度，也就是硬盘盘片在一分钟内所能完成的最大转数。硬盘的转速越快，硬盘寻找文件的速度也就越快，相对的硬盘的传输速度也就得到了提高。硬盘转速以每分钟多少转来表示，单位表示为RPM，RPM是Revolutions Per minute的缩写，是转/每分钟。	
	家用的普通硬盘的转速一般有5400rpm、7200rpm几种高转速硬盘也是台式机用户的首选；而对于笔记本用户则是4200rpm、5400rpm为主，虽然已经有公司发布了10000rpm的笔记本硬盘，但在市场中还较为少见；服务器用户对硬盘性能要求最高，服务器中使用的SCSI硬盘转速基本都采用10000rpm，甚至还有15000rpm的，性能要超出家用产品很多。
	
	- 平均访问时间：verage Access Time是指磁头从起始位置到到达目标磁道位置，并且从目标磁道上找到要读写的数据扇区所需的时间。平均访问时间体现了硬盘的读写速度，它包括了硬盘的寻道时间和等待时间，即：平均访问时间=平均寻道时间+平均等待时间。
	
		- 硬盘的平均寻道时间（Average Seek Time）是指硬盘的磁头移动到盘面指定磁道所需的时间。这个时间当然越小越好，硬盘的平均寻道时间通常在8ms到12ms之间，而SCSI硬盘则应小于或等于8ms。
		- 硬盘的等待时间，又叫潜伏期（Latency），是指磁头已处于要访问的磁道，等待所要访问的扇区旋转至磁头下方的时间。平均等待时间为盘片旋转一周所需的时间的一半，一般应在4ms以下。

	- 传输速率：Data Transfer Rate，硬盘的数据传输率是指硬盘读写数据的速度，单位为兆字节每秒（MB/s）。硬盘数据传输率又包括了内部数据传输率和外部数据传输率。
		- 内部传输率（Internal Transfer Rate) 也称为持续传输率（Sustained Transfer Rate），它反映了硬盘缓冲区未用时的性能。内部传输率主要依赖于硬盘的旋转速度。
		- 外部传输率（External Transfer Rate）也称为突发数据传输率（Burst Data Transfer Rate）或接口传输率，它标称的是系统总线与硬盘缓冲区之间的数据传输率，外部数据传输率与硬盘接口类型和硬盘缓存的大小有关。

	- 缓存：Cache memory，是硬盘控制器上的一块内存芯片，具有极快的存取速度，它是硬盘内部存储和外界接口之间的缓冲器。由于硬盘的内部数据传输速度和外界介面传输速度不同，缓存在其中起到一个缓冲的作用。

- 厂商：希捷（Seagate）美、西部数据（Western Digital）美、日立（HITACHI）日、东芝（TOSHIBA）日、三星（Samsung）韩。

- **接口种类**

	- ATA：Advanced Technology Attachment，是用传统的40-pin 并口数据线连接主板与硬盘的，外部接口速度最大为133MB/s，因为并口线的抗干扰性太差，且排线占空间，不利计算机散热，将逐渐被SATA 所取代。
	
	- IDE：Integrated Drive Electronics，即“电子集成驱动器”，俗称PATA并口。
	
	- SATA：几大厂商组成的Serial ATA委员会，确立Serial ATA 2.0规范。Serial ATA采用串行连接方式，串行ATA总线使用嵌入式时钟信号，具备了更强的纠错能力，与以往相比其最大的区别在于能对传输指令（不仅仅是数据）进行检查如果发现错误会自动矫正。
	
	- SATA Ⅱ：SATA Ⅱ是芯片巨头Intel英特尔与硬盘巨头Seagate希捷在SATA的基础上发展起来的，其主要特征是外部传输率从SATA的150MB/s进一步提高到了300MB/s，此外还包括NCQ(Native Command Queuing，原生命令队列）、端口多路器(Port Multiplier）、交错启动（Staggered Spin-up）等一系列的技术特征。但是并非所有的SATA硬盘都可以使用NCQ技术，除了硬盘本身要支持NCQ之外，也要求主板芯片组的SATA控制器支持NCQ。

	- SATA Ⅲ：“SATARevision3.0”，是串行ATA国际组织（SATA-IO）新版规范，主要是传输速度翻番达到6Gbps，同时向下兼容旧版规范“SATARevision2.6”（也就是现在俗称的SATA3Gbps），接口、数据线都没有变动。

	- SCSI：Small Computer System Interface（小型计算机系统接口），是同IDE（ATA）完全不同的接口，IDE接口是普通PC的标准接口，而SCSI并不是专门为硬盘设计的接口，是一种广泛应用于小型机上的高速数据传输技术。

	- SAS：Serial Attached SCSI，即串行连接SCSI，现在流行的Serial ATA(SATA)硬盘相同，都是采用串行技术以获得更高的传输速度。并通过缩短连结线改善内部空间等。SAS是并行SCSI接口之后开发出的全新接口。此接口的设计是为了改善存储系统的效能、可用性和扩充性，并且提供与SATA硬盘的兼容性。

### 2.1.2 硬盘的物理结构

硬盘其实是由许许多多的圆形硬盘盘所组成的， 依据硬盘盘能够容纳的数据量，而有所谓的单碟 (一块硬盘里面只有一个硬盘盘) 或者是多碟 (一块硬盘里面含有多个硬盘盘)的硬盘。在这里我们以单一个硬盘盘来说明，硬盘盘可由底下的图形来示意：

![daocoder](http://i.imgur.com/HonT2j8.png)

硬盘里面一定会有所谓的磁头 ( Head ) 在进行该硬盘盘上面的读写动作，而磁头是固定在机械手臂上面的，机械手臂上有多个磁头可以进行读取的动作。 而当磁头固定不动 (假设机械手臂不动) ，硬盘盘转一圈所画出来的圆就是所谓的磁道( Track )；而如同我们前面刚刚提到的，一块硬盘里面可能具有多个硬盘盘，所有硬盘盘上面相同半径的那一个磁道就组成了所谓的磁柱( Cylinder )。这个磁柱也是磁盘分割( partition )时的最小单位了；另外，由圆心向外划直线，则可将磁道再细分为一个一个的扇区( Sector )，这个扇区就是硬盘盘上面的最小储存物理量了！ 通常一个 sector 的大小约为 512 Bytes 。以上就是整个硬盘的基本组件。

在计算整个硬盘的储存量时，简单的计算公式就是：Cylinder x Head x Sector x 512 Bytes。

硬盘在读取时，主要是“硬盘盘会转动，利用机械手臂将磁头移动到正确的数据位置(单方向的前后移动)，
然后将数据依序读出。” 在这个操作的过程当中，由于机械手臂上的磁头与硬盘盘的接触是很细微的空间，
如果有抖动或者是脏污在磁头与硬盘盘之间时，就会造成数据的损毁或者是实体硬盘整个损毁。因此，正确的使用计算机的方式，应该是在计算机通电之后，就绝对不要移动主机，并免抖动到硬盘，而导致整个硬盘数据发生问题啊！**另外，也不要随便将插头拔掉就以为是顺利关机，因为机械手臂必须要归回原位，所以使用操作系统的正常关机方式，才能够有比较好的硬盘保养啊，因为它会让硬盘的机械手臂归回原位。**

## 2.2 磁盘的分区

在了解了硬盘的物理组件之后，再接着下来介绍的就是硬盘的分割( Partition )。为什么要进行硬盘分割啊？因为我们必须要告诉操作系统：这块硬盘可以存取的区域是由 A 磁柱到 B 磁柱，如此一来，操作系统才能够控制硬盘磁头去 A-B 范围内的磁柱存取数据；如果没有告诉操作系统这个信息， 那么操作系统就无法利用我们的硬盘来进行数据的存取了，因为操作系统将无法知道他要去哪里读取数据啊，这就是磁盘分割( Partition )的重点了： 也就是记录每一个分割区( Partition )的起始与结束磁柱！

## 2.3 格式化

硬盘和软盘都必须格式化后才能使用，这是因为各种操作系统都必须按照一定的方式来管理磁盘，比如windows对无法对ext4文件系统进行操作管理，而只有格式化才能使磁盘的结构能被操作系统认识。

磁盘的格式化分为物理格式化和逻辑格式化。

	- 物理格式化又称低级格式化，是对磁盘的物理表面进行处理，在磁盘上建立标准的磁盘记录格式，划分磁道（track）和扇区（sector）。
	
	- 逻辑格式化又称高级格式化，是在磁盘上建立一个系统存储区域，包括引导记录区、文件目录区FCT、文件分配表FAT。

## 2.4 挂载

文件系统由三部分组成：文件系统的接口，对对象操纵和管理的软件集合，对象及属性。这里的接口就是挂载点，及让操作系统识别这块硬盘里的文件系统的一个点。

# 3、对linux ext2文件系统的认识

## 3.1 linux逻辑上数据存储的最小单位

硬盘是用来储存数据的，那么数据就必须读写进硬盘。刚刚我们提到硬盘的最小储存单位是 sector ，不过数据所储存的最小单位并不是 sector，因为用 sector 来储存太没有效率了。因为一个 sector 只有 512 Bytes ，而磁头是一个一个 sector 的读取，也就是说，如果我的档案有 10 MBytes ，那么为了读这个档案， 我的磁头必须要
进行读取 (I/O) 20480 次。

这种情况下，linux中逻辑区块( Block )就产生了，逻辑区块是在 partition 进行filesystem 的格式化时， 所指定的“最小储存单位”，这个最小储存单位当然是架构在 sector 的大小上面( 因为 sector 为硬盘的最小物理储存单位啊！ )，所以Block 的大小为 sector 的 2 的次方倍数。此时，磁头一次可以读取一个 block ，如果假设我们在格式化的时候，指定 Block 为 4 KBytes ( 亦即由连续的八个 sector 所构成一个 block )，那么同样一个 10 MBytes 的档案， 磁头要读取的次数则大幅降为 2560 次，这个时候可就大大的增加档案的读取效能。

同时注意Block 单位的规划并不是越大越好。因为一个 Block 最多仅能容纳一个档案 (这里指Linux 的 ext2 档案系统)。这产生一个问题，假如您的 Block 规划为 4 KBytes ，而您有一个档案大小为 0.1 KBytes ，这个小档案将占用掉一个 Block 的空间，这会造成硬盘空间的极大浪费。

**ext2 允许的 block size 为 1024, 2048 及 4096 bytes三种，这里对“最小存储单位”的选择就要考虑实际应用中档案读取的性能和硬盘空间的使用率。**

Superblock：当我们在进行磁盘分割( partition )时，每个磁盘分割槽( partition )就是一个档案系统( filesystem )， 而每个档案系统开始的位置的那个 block 就称为 superblock ，superblock 的作用是储存像是档案系统的大小、空的和填满的区块，以及他各自的总数和其它诸如此类的信息等等， 这也就是说，当您要使用这一个磁盘分割槽( 或者说是档案系统 )来进行数据存取的时候，第一个要经过的就是 superblock 这个区块了，所以 superblock 坏了，您的这个磁盘槽大概也就坏了。

## 3.2 linux 的磁盘分区要点
 
开机扇区( Master Boot Recorder, MBR )，就是记录在一块硬盘的第零轨上面，也是计算机开机之后要去利用该硬盘时， 必须要读取的第一个区域。这个区域内记录的就是硬盘里面的所有分割信息，以及开机的时候可以进行开机管理程序的写入的空间。

那么 MBR 有什么限制呢？它最大的限制来自于他的大小不够大到储存所有分割与开机管理程序的信息，因此，MBR 仅提供最多四个 partition 的记忆，这就是所谓的 Primary (P)与 Extended (E) 的 partition最多只能有四个的原因了。如果你预计分割超过 4 个 partition 的话，那么势必需要使用 3P +1E ，并且将所有的剩余空间都拨给 Extended 才行( Extended 最多只能有一个 )，否则只要 3P+ E 之后还有剩下的空间， 那么那些容量将成为废物而浪费了，所以如果您要分割硬盘时，并且已经预计规划使用掉 MBR 所提供的 4 个 partition ( 3P + E 或 4P )那么磁盘的全部容量需要使用光，否则剩下的容量也不能再被使用。不过，如果您仅是分割出 1P + 1E 的话，那么剩下的空间就还能再分割两个 primary partition 。

## 3.3 ext2 = inode + block

Linux档案属性与目录配置中有介绍，每个档案不止有档案的内容数据，还包括档案的种种属性，例如：所属群组、 所属使用者、能否执行、档案建立时间、档案特殊属性等等。由于 Linux操作系统是一个多人多任务的环境，为了要保护每个使用者所拥有数据的隐密性， 所以具有多样化的档案属性是必须的。**在标准的 ext2 档案系统当中，我们将每个档案的内容分为两个部分来储存，一个是档案的属性，另一个则是档案的内容。**

ext2 规划出 inode 与 Block 来分别储存档案的属性( inode )与档案的内容( Block area )。当我们要将一个 partition 格式化( format )为 ext2时，就必须要指定 inode 与 Block 的大小才行，也就是说，当 partition 被格式化为 ext2 的档案系统时，他一定会有 inode table 与 block area 这两个区域。

Block 已经在前面说过了，他是数据储存的最小单位。简单的说， Block 是记录“档案内容数据”的区域，至于inode 则是记录“该档案的相关属性，以及档案内容放置在哪一个 Block
之内”的信息。即 inode 除了记录档案的属性外，同时还必须要具有指向( pointer )的功能，亦即指向档案内容放置的区块之中，它可以让操作系统正确地去取得档案的内容。 下面几个是 inode 记录的部分信息：

- 该档案的拥有者与群组(owner/group)；
- 该档案的存取模式(read/write/excute)；
- 该档案的类型(type)；
- 该档案建立或状态改变的时间(ctime)、最近一次的读取时间(atime)、最近修改的时间(mtime)；
- 该档案的容量；
- 定义档案特性的旗标(flag)，如 SetUID...；
- 该档案真正内容的指向 (pointer)；

那么我的 Linux 系统到底是如何读取一个档案的内容呢？下面我们分别针对目录与档案来说明：

- 目录：当我们在 Linux 下的 ext2 档案系统建立一个目录时， ext2 会分配一个 inode 与至少一块Block 给该目录。其中，inode 记录该目录的相关属性，并指向分配到的那块 Block ；而 Block则是记录在这个目录下的相关连的档案(或目录)的关连性。

- 档案：当我们在 Linux 下的 ext2 建立一个一般档案时， ext2 会分配至少一个 inode 与相对于该档
案大小的 Block 数量给该档案。例如：假设我的一个 Block 为 4 Kbytes ，而我要建立一个 100
KBytes 的档案，那么 linux 将分配一个 inode 与 25 个 Block 来储存该档案！要注意的是，**inode 本身并不纪录文件名，而是记录档案的相关属性，至于文件名则是记录在目录所属的block 区域！** 

那么档案与目录的关系又是如何呢？就如同上面的目录提到的，档案的相关连结会记录在目录的 block 数据区域， 所以当我们要读取一个档案的内容时，我们的 Linux 会先由根目录 / 取得该档案的上层目录所在 inode ， 再由该目录所记录的档案关连性 (在该目录所属的 block 区域) 取得该档案的 inode ， 最后在经由 inode 内提供的 block 指向，而取得最终的档案内容。

> 当系统读取/etc/crontab 的流程为：

>1、操作系统根据根目录( / )的相关资料可取得 /etc 这个目录所在的 inode ，并前往读取 /etc 这
个目录的所有相关属性；

>2、根据 /etc 的 inode 的资料，可以取得 /etc 这个目录底下所有档案的关连数据是放置在哪一个
Block 当中，并前往该 block 读取档案的关连性内容；

>3、由上个步骤的 Block 当中，可以知道 crontab 这个档案的 inode 所在地，并前往该 inode ；

>4、由上个步骤的 inode 当中，可以取得 crontab 这个档案的所有属性，并且可前往由 inode 所指
向的 Block 区域，顺利的取得 crontab 的档案内容。

简单的归纳一下， ext2 有几个特点：

- Blocks 与 inodes 在一开始格式化时 (format) 就已经固定了；
- 一个 partition 能够容纳的档案数与 inode 有关；
- 一般来说，每 4Kbytes 的硬盘空间分配一个 inode ；
- 一个 inode 的大小为 128 bytes；
- Block 为固定大小，目前支持 1024/2048/4096 bytes 等；
- Block 越大，则损耗的硬盘空间也越多。
-  关于单一档案：若 block size=1024，最大容量为 16GB，若 block size=4096，容量最大为 2TB；
- 关于整个 partition ：若 block size=1024，则容量达 2TB，若 block size=4096，则容量达 32TB。
- 文件名最长达 255 字符，完整文件名长达 4096 字符。

## 3.4 ext2档案的存取和日志式档案系统的功能

当一个 ext2 的 filesystem 被建立时， 他拥有 superblock / group description / block bitmap / inode bitmap / inode table / data blocks 等等区域。要注意的是，每个 ext2 filesystem 在被建立的时候，会依据 partition 的大小， 给予数个 block group ，而每个block group 就有上述的这些部分。整个 filesystem 的架构可以下图展现：

![daocoder](http://i.imgur.com/mIkYNut.png)

我们将整个 filesystem 简单化， 假设仅有一个 block group ，那么上面的各个部分分别代表什么呢？

- SuperBlock：如前所述， Superblock 是记录整个 filesystem 相关信息的地方， 没有Superblock ，就没有这个 filesystem 了。他记录的信息主要有：
	- block 与 inode 的总量；
	- 未使用与已使用的 inode / block 数量；
	- 一个 block 与一个 inode 的大小；
	- filesystem 的挂载时间、最近一次写入数据的时间、最近一次检验磁盘 (fsck) 的时间等档案系统的相关信息；
	- 一个 valid bit 数值，若此档案系统已被挂载，则 valid bit 为 0 ，若未被挂载，则valid bit 为 1 。
- Group Description：纪录此 block 由由何处开始记录；
- Block bitmap：此处记录那个 block 有没有被使用；
- Inode bitmap：此处记录那个 inode 有没有被使用；
- Inode table：为每个 inode 数据存放区；
- Data Blocks：为每个 block 数据存放区。

# 3、磁盘的分区、格式化、校验与挂载

## 3.1 虚拟机上的硬盘添加

这里比较简单，百度了下有图文说明的，下面是链接，这步相当于将一块新的硬盘添加到了物理主机中。

[虚拟中如何添加新的硬盘](http://jingyan.baidu.com/article/c843ea0b77267f77921e4a4b.html)

下面再是我虚拟主机上添加虚拟硬盘前后的状态、。

添加之前只有sda一块硬盘、。

	[root@localhost daocoder]# fdisk -l
	
	磁盘 /dev/sda：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x000b87f7
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sda1   *        2048     1026047      512000   83  Linux
	/dev/sda2         1026048    41943039    20458496   8e  Linux LVM
	
	磁盘 /dev/mapper/centos-swap：2147 MB, 2147483648 字节，4194304 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	
	
	磁盘 /dev/mapper/centos-root：18.8 GB, 18798870528 字节，36716544 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节

添加之后有两块、。

	[root@localhost ~]# fdisk -l
	
	磁盘 /dev/sda：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x000b87f7
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sda1   *        2048     1026047      512000   83  Linux
	/dev/sda2         1026048    41943039    20458496   8e  Linux LVM		这里可以看出扇区已经被分配完。
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区	然后这里看出sdb尚未被使用，称为“裸盘”。
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	
	
	磁盘 /dev/mapper/centos-swap：2147 MB, 2147483648 字节，4194304 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	
	
	磁盘 /dev/mapper/centos-root：18.8 GB, 18798870528 字节，36716544 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节


然后看上面sda与sdb之间的差别，sda已经分为2个区，sdb尚未被使用。

这里再说明一下，linux里面对每块都可以进行分区，且可以是3P+1E或其他的模式。**分区主要分为基本分区（primary partion）和扩充分区(extension partion)两种，基本分区和扩充分区的数目之和不能大于四个。且基本分区可以马上被使用但不能再分区。扩充分区必须再进行分区后才能使用，也就是说它必须还要进行二次分区。那么由扩充分区再分下去的是什么呢？它就是逻辑分区（logical partion），况且逻辑分区没有数量上限制。**

下面我们对sdb开始操作加深理解下这些东西。

## 3.2 硬盘的分区

	[root@localhost ~]# fdisk /dev/sdb
	欢迎使用 fdisk (util-linux 2.23.2)。
	
	更改将停留在内存中，直到您决定将更改写入磁盘。
	使用写入命令前请三思。
	
	Device does not contain a recognized partition table
	使用磁盘标识符 0x1e4ff6b6 创建新的 DOS 磁盘标签。
	
<b color="red">

	命令(输入 m 获取帮助)：m						这里会有帮助列表。
	命令操作
	   a   toggle a bootable flag
	   b   edit bsd disklabel
	   c   toggle the dos compatibility flag
	   d   delete a partition
	   g   create a new empty GPT partition table
	   G   create an IRIX (SGI) partition table
	   l   list known partition types
	   m   print this menu
	   n   add a new partition
	   o   create a new empty DOS partition table
	   p   print the partition table
	   q   quit without saving changes
	   s   create a new empty Sun disklabel
	   t   change a partition's system id
	   u   change display/entry units
	   v   verify the partition table
	   w   write table to disk and exit
	   x   extra functionality (experts only)

</b>
	
	命令(输入 m 获取帮助)：n					这里开始新建分区		
	Partition type:
	   p   primary (0 primary, 0 extended, 4 free)
	   e   extended
	Select (default p): p						选择一个主分区
	分区号 (1-4，默认 1)：1
	起始 扇区 (2048-41943039，默认为 2048)：
	将使用默认值 2048
	Last 扇区, +扇区 or +size{K,M,G} (2048-41943039，默认为 41943039)：+5G		5G的空间，单纯练习分区。
	分区 1 已设置为 Linux 类型，大小设为 5 GiB				这里默认就是linux的文件系统  id=83
	
	
	命令(输入 m 获取帮助)：l
	
	 0  空              24  NEC DOS         81  Minix / 旧 Linu bf  Solaris        
	 1  FAT12           27  隐藏的 NTFS Win 82  Linux 交换 / So c1  DRDOS/sec (FAT-
	 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
	 3  XENIX usr       3c  PartitionMagic  84  OS/2 隐藏的 C:  c6  DRDOS/sec (FAT-
	 4  FAT16 <32M      40  Venix 80286     85  Linux 扩展      c7  Syrinx         
	 5  扩展            41  PPC PReP Boot   86  NTFS 卷集       da  非文件系统数据 
	 6  FAT16           42  SFS             87  NTFS 卷集       db  CP/M / CTOS / .
	 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux 纯文本    de  Dell 工具      
	 8  AIX             4e  QNX4.x 第2部分  8e  Linux LVM       df  BootIt         
	 9  AIX 可启动      4f  QNX4.x 第3部分  93  Amoeba          e1  DOS 访问       
	 a  OS/2 启动管理器 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
	 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
	 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad 休 eb  BeOS fs        
	 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         ee  GPT            
	 f  W95 扩展 (LBA)  54  OnTrackDM6      a6  OpenBSD         ef  EFI (FAT-12/16/
	10  OPUS            55  EZ-Drive        a7  NeXTSTEP        f0  Linux/PA-RISC  
	11  隐藏的 FAT12    56  Golden Bow      a8  Darwin UFS      f1  SpeedStor      
	12  Compaq 诊断     5c  Priam Edisk     a9  NetBSD          f4  SpeedStor      
	14  隐藏的 FAT16 <3 61  SpeedStor       ab  Darwin 启动     f2  DOS 次要       
	16  隐藏的 FAT16    63  GNU HURD or Sys af  HFS / HFS+      fb  VMware VMFS    
	17  隐藏的 HPFS/NTF 64  Novell Netware  b7  BSDI fs         fc  VMware VMKCORE 
	18  AST 智能睡眠    65  Novell Netware  b8  BSDI swap       fd  Linux raid 自动
	1b  隐藏的 W95 FAT3 70  DiskSecure 多启 bb  Boot Wizard 隐  fe  LANstep        
	1c  隐藏的 W95 FAT3 75  PC/IX           be  Solaris 启动    ff  BBT            
	1e  隐藏的 W95 FAT1 80  旧 Minix       
	
	命令(输入 m 获取帮助)：p						打印下sdb磁盘列表看看，已经有了一个主分区。
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x1e4ff6b6
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	
	命令(输入 m 获取帮助)：n						继续分区。
	Partition type:
	   p   primary (1 primary, 0 extended, 3 free)
	   e   extended
	Select (default p): e							分个扩展分区出来
	分区号 (2-4，默认 2)：3
	起始 扇区 (10487808-41943039，默认为 10487808)：	这里其实扇区接sdb1分区的结束去开始。
	将使用默认值 10487808
	Last 扇区, +扇区 or +size{K,M,G} (10487808-41943039，默认为 41943039)：+10G		这里是结束扇区。
	分区 3 已设置为 Extended 类型，大小设为 10 GiB
	
	命令(输入 m 获取帮助)：p							再打印看下列表。
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x1e4ff6b6
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	/dev/sdb3        10487808    31459327    10485760    5  Extended
	
	命令(输入 m 获取帮助)：n							再继续分区。
	Partition type:
	   p   primary (1 primary, 1 extended, 2 free)
	   l   logical (numbered from 5)
	Select (default p): p								一个主分区。
	分区号 (2,4，默认 2)：
	起始 扇区 (31459328-41943039，默认为 31459328)：
	将使用默认值 31459328
	Last 扇区, +扇区 or +size{K,M,G} (31459328-41943039，默认为 41943039)：
	将使用默认值 41943039
	分区 2 已设置为 Linux 类型，大小设为 5 GiB
	
	命令(输入 m 获取帮助)：p				再打印看下列表。
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x1e4ff6b6
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	/dev/sdb2        31459328    41943039     5241856   83  Linux
	/dev/sdb3        10487808    31459327    10485760    5  Extended
	
	Partition table entries are not in disk order
	
	命令(输入 m 获取帮助)：n
	Partition type:				
	   p   primary (2 primary, 1 extended, 1 free)
	   l   logical (numbered from 5)
	Select (default p): l				这里扩展分区已经建立之后就变成了罗逻辑分区，建个逻辑分区
	添加逻辑分区 5
	起始 扇区 (10489856-31459327，默认为 10489856)：
	将使用默认值 10489856
	Last 扇区, +扇区 or +size{K,M,G} (10489856-31459327，默认为 31459327)：+5G
	分区 5 已设置为 Linux 类型，大小设为 5 GiB
	
	命令(输入 m 获取帮助)：p			建立主分区
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x1e4ff6b6
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	/dev/sdb2        31459328    41943039     5241856   83  Linux
	/dev/sdb3        10487808    31459327    10485760    5  Extended
	/dev/sdb5        10489856    20975615     5242880   83  Linux
	
	Partition table entries are not in disk order
	
	命令(输入 m 获取帮助)：w			保存
	The partition table has been altered!
	
	Calling ioctl() to re-read partition table.				然后这里出现这里问题，可忽略我觉得。
	正在同步磁盘。
	您在 /var/spool/mail/root 中有邮件

然后在这里有这个说明，[解决Partition table entries are not in disk order 的问题。](http://www.linuxidc.com/Linux/2011-08/41000.htm)

	[root@localhost ~]# fdisk -l
	
	磁盘 /dev/sda：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x000b87f7
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sda1   *        2048     1026047      512000   83  Linux
	/dev/sda2         1026048    41943039    20458496   8e  Linux LVM
	
	磁盘 /dev/sdb：21.5 GB, 21474836480 字节，41943040 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	磁盘标签类型：dos
	磁盘标识符：0x1e4ff6b6
	
	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	/dev/sdb2        31459328    41943039     5241856   83  Linux
	/dev/sdb3        10487808    31459327    10485760    5  Extended
	/dev/sdb5        10489856    20975615     5242880   83  Linux
	
	Partition table entries are not in disk order
	
	磁盘 /dev/mapper/centos-swap：2147 MB, 2147483648 字节，4194304 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节
	
	
	磁盘 /dev/mapper/centos-root：18.8 GB, 18798870528 字节，36716544 个扇区
	Units = 扇区 of 1 * 512 = 512 bytes
	扇区大小(逻辑/物理)：512 字节 / 512 字节
	I/O 大小(最小/最佳)：512 字节 / 512 字节

最后我又在扩展分区进行新的分割，结果如下：

	   设备 Boot      Start         End      Blocks   Id  System
	/dev/sdb1            2048    10487807     5242880   83  Linux
	/dev/sdb2        10487808    31459327    10485760    5  Extended
	/dev/sdb3        31459328    41943039     5241856   83  Linux
	/dev/sdb5        10489856    20975615     5242880   83  Linux
	/dev/sdb6        20977664    31459327     5240832   83  Linux

总结几点：

- 分区时，设备标识符。在 Linux 中，每一个硬件设备都映射到一个系统的文件，对于硬盘、光驱等、IDE、或 SCSI 设备也不例外。Linux 把各种 IDE 设备分配了一个由 hd 前缀组成的文件；而对于各种 SCSI 设备，则分配了一个由 sd 前缀组成的文件。 对于ide硬盘，驱动器标识符为“hdx~”,其中“hd”表明分区所在设备的类型，这里是指ide硬盘了。“x”为盘号（a为基本盘，b为基本从属盘，c为辅助主盘，d为辅助从属盘）,“~”代表分区，前四个分区用数字1到4表示，它们是主分区或扩展分区，从5开始就是逻辑分区。例，hda3表示为第一个ide硬盘上的第三个主分区或扩展分区,hdb2表示为第二个ide硬盘上的第二个主分区或扩展分区。对于scsi硬盘则标识为“sdx~”，scsi硬盘是用“sd”来表示分区所在设备的类型的，其余则和ide硬盘的表示方法一样，不在多说。 例如，第一个 IDE 设备，Linux 就定义为 hda；第二个 IDE 设备就定义为 hdb；下面以此类推。而 SCSI 设备就应该是 sda、sdb、sdc 等。

- 分区数量：要进行分区就必须针对每一个硬件设备进行操作，这就有可能是一块IDE硬盘或是一块SCSI硬盘。对于每一个硬盘（IDE 或 SCSI）设备，Linux 分配了一个 1 到 16 的序列号码，这就代表了这块硬盘上面的分区号码。（这里应该对于ide和scsi不同）。

- 各分区的作用：在 Linux 中规定，每一个硬盘设备最多能有 4个主分区（其中包含扩展分区）构成，任何一个扩展分区都要占用一个主分区号码，也就是在一个硬盘中，主分区和扩展分区一共最多是 4 个。

	- 对于早期的 DOS 和 Windows（Windows 2000 以前的版本），系统只承认一个主分区，可以通过在扩展分区上增加逻辑盘符（逻辑分区）的方法，进一步地细化分区。主分区的作用就是计算机用来进行启动操作系统的，因此每一个操作系统的启动，或者称作是引导程序，都应该存放在主分区上。这就是主分区和扩展分区及逻辑分区的最大区别。我们在指定安装引导 Linux 的 bootloader 的时候，都要指定在主分区上，就是最好的例证。Linux 规定了主分区（或者扩展分区）占用 1 至 16 号码中的前 4 个号码。以第一个 IDE 硬盘为例说明，主分区（或者扩展分区）占用了 hda1、hda2、hda3、hda4，而逻辑分区占用了 hda5 到 hda16 等 12 个号码。因此，Linux 下面每一个硬盘总共最多有 16 个分区。对于逻辑分区，Linux 规定它们必须建立在扩展分区上（在 DOS 和 Windows 系统上也是如此规定），而不是主分区上。因此，我们可以看到扩展分区能够提供更加灵活的分区模式，但不能用来作为 操作系统 的引导。 除去上面这些各种分区的差别，我们就可以简单地把它们一视同仁了。

- 分区指标：对于每一个 Linux 分区来讲，分区的大小和分区的类型是最主要的指标。容量的大小读者很容易理解，但是分区的类型就不是那么容易接受了。分区的类型规定了这个分区上面的文件系统的格式。Linux 支持多种的文件系统格式，其中包含了我们熟悉的FAT32、FAT16、NTFS、HP-UX，以及各种 Linux 特有的 Linux Native和 Linux Swap分区类型。在 Linux 系统中，可以通过分区类型号码来区别这些不同类型的分区。各种类型号码在介绍Fdisk的使用方式的时候将会介绍。

## 3.3 硬盘的格式化与挂载

对新添加的硬盘分区成功后，必须对其格式化才能被挂载使用。

未格式化之前执行挂载命令出现下述错误情况。网上有相关的其他解答，不过没提及格式化这块。

[mount：文件系统类型错误、选项错误……](https://www.cnblogs.com/wangkongming/p/4338456.html)

	[root@localhost /]# mount -t ext4 /dev/sdb1 /daocoder
	mount: 文件系统类型错误、选项错误、/dev/sdb1 上有坏超级块、
	       缺少代码页或助手程序，或其他错误
	
	       有些情况下在 syslog 中可以找到一些有用信息- 请尝试
	       dmesg | tail  这样的命令看看。

那么我们现对他格式化一下。

	[root@localhost log]# mkfs.ext4 /dev/sdb1			格式化为ext4的文件系统：打出mkfs.e后按tab键可查看支持文件系统类型
	mke2fs 1.42.9 (28-Dec-2013)
	文件系统标签=
	OS type: Linux
	块大小=4096 (log=2)
	分块大小=4096 (log=2)
	Stride=0 blocks, Stripe width=0 blocks
	327680 inodes, 1310720 blocks
	65536 blocks (5.00%) reserved for the super user
	第一个数据块=0
	Maximum filesystem blocks=1342177280
	40 block groups
	32768 blocks per group, 32768 fragments per group
	8192 inodes per group
	Superblock backups stored on blocks: 
		32768, 98304, 163840, 229376, 294912, 819200, 884736
	
	Allocating group tables: 完成                            
	正在写入inode表: 完成                            
	Creating journal (32768 blocks): 完成
	Writing superblocks and filesystem accounting information: 完成 
	
	[root@localhost log]# mount -t ext4 /dev/sdb1 /daocoder			此时挂载成功
	[root@localhost log]# mount										mount查看验证下，部分截取
	/dev/sdb1 on /daocoder type ext4 (rw,relatime,seclabel,data=ordered)

对新硬盘的添加正确方法是现将新盘分区挂载到一个新的目录下，或直接根目录下/mut，将分区挂载在上面，然后将你之前想要挂载的目录下（我的比如是/daocoder这个目录）的文件复制或移动到/mut，同时删除原/daocoder中的文件，否则它还是会占用根磁盘空间。然后再将这个分区挂载到/daocoder这个目录下就好了。步骤如下：

	[root@localhost dev]# cd /daocoder/					先到/daocoder下看下目录下的文件
	[root@localhost daocoder]# ls
	ip.txt  passwd  test  www

	[root@localhost /]# mkdir /temp						新建个文件夹作为备份文件的目录						
	[root@localhost /]# mv /mnt/* /temp/				将原/daocoder下的文件全部移动到/temp目录下

	[root@localhost /]# ls -l /daocoder/				查看下/daocoder，没东西了
	总用量 0
	
	[root@localhost /]# mount /dev/sdb1 /daocoder/		将新区挂载到/daocoder目录下

	[root@localhost /]# mv /tamp/* /daocoder/			再将备份文件拷贝回来
	[root@localhost /]# ls /daocoder/
	ip.txt  lost+found  passwd  test  www
	[root@localhost /]# rm -rf /temp/					删除那个新建目录

				
	
	再到/daocoder下看下目录下的文件，此时多了一个/lost+found，这个是硬盘分区下特有的文件夹，说明它是一个独立的分区
	[root@localhost mnt]# cd /daocoder/
	[root@localhost daocoder]# ls 
	ip.txt  lost+found  passwd  test  www

再附上一个网页做参考，可能人家说的更好点。[求救：linux下的目录挂载问题，数据丢了！](http://bbs.csdn.net/topics/330109035)

注意此时的挂载是临时的，即写入内存中的，若想长久保存挂载盘，需要将挂载信息写入文件。

第一种方法：

	[root@localhost daocoder]# cat /etc/rc.local 
	#!/bin/bash
	# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES
	#
	# It is highly advisable to create own systemd services or udev rules
	# to run scripts during boot instead of using this file.
	#
	# In constrast to previous versions due to parallel execution during boot 
	# this script will NOT be run after all other services.
	#  
	# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure
	# that this script will be executed during boot.

	touch /var/lock/subsys/local
	mount /dev/sdb1 /daocoder				这行就是新添加的挂载分区信息了，其他的是系统已有的。

第二种方法：

	[root@localhost daocoder]# cat /etc/fstab 
	
	#
	# /etc/fstab
	# Created by anaconda on Tue Sep  6 20:33:08 2016
	#
	# Accessible filesystems, by reference, are maintained under '/dev/disk'
	# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
	#
	/dev/mapper/centos-root /                       xfs     defaults        1 1
	UUID=9ff617e1-346d-447c-804e-6f3cac28b82a /boot                   xfs     defaults        1 2
	/dev/mapper/centos-swap swap                    swap    defaults        0 0
	/dev/sdb1 /daocoder ext4 defaults 0 0			这行就是新添加的挂载分区信息了，其他的是系统已有的。













