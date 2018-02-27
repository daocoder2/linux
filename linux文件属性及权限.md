<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# 文件属性、权限详解 #

    [root@localhost /]# ls -al -i -h

![/根目录列表](http://i.imgur.com/LP2bFQM.png)

从前到后分别为是：inode、文件属性与权限、硬链接数、所属用户、所属组、文件大小、最后修改或访问时间、文件名。

# 1、inode #
inode译成中文就是索引节点。每个存储设备或存储设备的分区（存储设备是硬盘、软盘、U盘......）被格式化为文件系统后，应该有两部份，一部份是inode，另一部份是Block，Block是用来存储数据用的。而inode呢，就是用来存储这些数据的信息，这些信息包括文件大小、属主、归属的用户组、读写权限等。inode为每个文件进行信息索引，所以就有了inode的数值。操作系统根据指令，能通过inode值最快的找到相对应的文件。

做个比喻，比如一本书，存储设备或分区就相当于这本书，Block相当于书中的每一页，inode就相当于这本书前面的目录，一本书有很多的内容，如果想查找某部份的内容，我们可以先查目录，通过目录能最快的找到我们想要看的内容。虽然不太恰当，但还是比较形象。
当我们用ls查看某个目录或文件时，如果加上-i参数，就可以看到inode节点了；比如我们前面所说的例子。
    [root@localhost /]# ls -i
    128 dr-xr-xr-x.   5 root root 4.0K 9月   8 09:04 boot
boot目录的inode值是128。
## 1.1 inode相同的文件是硬链接文件 ##
在Linux文件系统中，inode值相同的文件是硬链接文件，也就是说，不同的文件名，inode可能是相同的，一个inode值可以对应多个文件。在Linux中，链接文件是通过ln工具来创建的。

## 	1.2 硬链接的创建及硬链接和源文件关系 ##
用ln创建文件硬链接的语法：**ln  源文件目标文件**
下面我们举一个例子，我们要为dao.txt创建其硬链接dao1.txt。然后看一下dao.txt和dao1.txt的属性的变化；

    [root@localhost daocoder]# ls -li dao.txt 先看下dao.txt的属性
    38903 -rw-r--r--. 1 root root 27 9月   8 10:57 dao.txt
    [root@localhost daocoder]# ln dao.txt dao1.txt		建立硬链接dao1.txt
    [root@localhost daocoder]# ls -li dao.txt dao1.txt 		再看下dao.txt及dao1.txt的属性
    38903 -rw-r--r--. 2 root root 27 9月   8 10:57 dao1.txt
    38903 -rw-r--r--. 2 root root 27 9月   8 10:57 dao.txt
    [root@localhost daocoder]# ln dao.txt dao2.txt 			建立硬链接dao2.txt
    [root@localhost daocoder]# ls -li dao.txt dao1.txt dao2.txt 	再看下它们的属性
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao1.txt
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao2.txt
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao.txt

我们可以看到dao.txt在没有创建硬链接文件dao1.txt的时候，其链接个数是1（也就是-rw-r--r--后的那个数值），创建了硬链接dao1.txt创建后，这个值变成了2，创建了硬链接dao2.txt创建后，这个值变成了3。也就是说，我们每次为dao.txt或它的硬链接文件（dao1.txt、dao2.txt）**创建一个新的硬链接文件后，其硬链接个数都会增加1**。

**inode值相同的文件，他们的关系是互为硬链接的关系。当我们修改其中一个文件的内容时，互为硬链接的文件的内容也会跟着变化。如果我们删除互为硬链接关系的某个文件时，其它的文件并不受影响。**比如我们把dao.txt删除后，我们还是一样能看到dao1.txt的内容，并且dao1.txt仍是存在的。

下面的例子，我们把dao.txt删除，然后我们看一下dao1.txt是不是能看到其内容。

    [root@localhost daocoder]# rm -f dao.txt
    [root@localhost daocoder]# cat dao1.txt 
    abcdefghijklmnopqrstuvwxyz

**注意：硬链接不能为目录创建，只有文件才能创建硬链接。**

## 	1.3 软链接的创建及软链接与源文件的关系 ##
创建软链接（也被称为符号链接）的语法：**ln -s 源文文件或目录目标文件或目录**
软链接也叫符号链接，他和硬链接有所不同，软链接文件只是其源文件的一个标记。当我们删除了源文件后，链接文件不能独立存在，虽然仍保留文件名，但我们却不能查看软链接文件的内容了。

    [root@localhost daocoder]# ls -il test.txt  先对一个文件查看它的属性
    38926 -rw-r--r--. 1 root root 35 9月   8 10:32 test.txt
    [root@localhost daocoder]# ln -s test.txt test-s.txt			建立它的软连接
    [root@localhost daocoder]# ls -il test.txt test-s.txt 			查看它们的属性
    38899 lrwxrwxrwx. 1 root root  8 9月   8 10:34 test-s.txt -> test.txt		
    38926 -rw-r--r--. 1 root root 35 9月   8 10:32 test.txt

我们来对比一下：

首先对比一下inode节点：两个文件的节点不同；

其次两个文件的属性不同：test.txt是-，也就是普通文件，而test-s.txt是l，它是一个链接文件；

第三两个文件的读写权限不同：test.txt是rw-r--r--，而test-s.txt的读写权限是rwxrwxrwx；

第三两个文件的硬链接个数相同：都是1。

第四两个文件的属主和所归属的用户组相同：root；

第五两个文件的大小不同：test.txt是35字节，而test-s.txt是8字节；

第六两个文件修改(或访问、创建）时间不同；同时test-s.txt -> test.txt，这表示test-s.txt 是test.txt 的软链接文件。

值得我们注意的是：**当我们修改链接文件的内容时，就意味着我们在修改源文件的内容。当然源文件的属性也会发生改变，链接文件的属性并不会发生变化。当我们把源文件删除后，链接文件只存在一个文件名，因为失去了源文件，所以软链接文件也就不存在了。这一点和硬链接是不同的。**

![](http://i.imgur.com/kh67oHJ.png)
![](http://i.imgur.com/U17INkd.png)

红色阴影部分还会是闪烁的状态。

![](http://i.imgur.com/4k3MKL5.png)

这是先前的：

![](http://i.imgur.com/YjkS4rs.png)

上面的例子告诉我们，如果一个链接文件失去了源，就意味着他已经不存在了；

软链接文件只是占用了inode来存储软链接文件属性等信息，但文件存储是指向源文件的。

软件链接，可以为文件或目录都适用。无论是软链接还是硬链接，都可以用rm来删除。rm工具是通用的。

# 2、文件类型及属性 #
	[root@localhost daocoder]# ls -li
    总用量 12
    10522 drwxr-xr-x. 4 root root   38 9月   7 09:52 aaa
    38903 -rw-r--r--. 2 root root   27 9月   8 10:57 dao1.txt
    38901 -rw-r--r--. 1 root root 2217 9月   7 09:37 passwd
前一字段inode在前面有详细介绍，再说第二字段：[d][rwx][r-x][r-x]，设对应为[1] [234] [567] [890]。  

[1]对应的在linux中文件的类型，在linux中所有东西都以文件表示,下面对这些文件类型进行说明。

- [-]普通文件（regular file）：就是一般我们存取的文件，由ls -al显示出来的属性中，第一个属性为 [-]，例如 [-rwxrwxrwx]。另外，依照文件的内容，又大致可以分为：

	- 纯文本文件（ASCII）：这是Unix系统中最多的一种文件类型，之所以称为纯文本文件，是因为内容为我们可以直接读到的数据，例如数字、字母等等。设 置文件几乎都属于这种文件类型。举例来说，使用命令“cat ~/.bashrc”就可以看到该文件的内容（cat是将文件内容读出来）。
	- 二进制文件（binary）：我们在GNU发展史中提过，系统其实仅认识且可以执行二进制文件（binary file）。Linux中的可执行文件（脚本，文本方式的批处理文件不算）就是这种格式的。举例来说，命令cat就是一个二进制文件。
	- 数据格式的文件（data）：有些程序在运行过程中，会读取某些特定格式的文件，那些特定格式的文件可以称为数据文件（data file）。举例来说，Linux在用户登入时，都会将登录数据记录在 /var/log/wtmp文件内，该文件是一个数据文件，它能通过last命令读出来。但使用cat时，会读出乱码。因为它是属于一种特殊格式的文件。

- [d]目录（directory）：就是目录，第一个属性为 [d]，例如 [drwxrwxrwx]。

- [l]连接文件（link）：类似Windows下面的快捷方式。第一个属性为 [l]，例如 [lrwxrwxrwx]。

	- 设备与设备文件（device）：与系统外设及存储等相关的一些文件，通常都集中在 /dev目录。通常又分为两种：

	- [l]块（block）设备文件：就是存储数据以供系统存取的接口设备，简单而言就是硬盘。例如一号硬盘的代码是 /dev/hda1等文件。第一个属性为 [b]。

	- [c]字符（character）设备文件：即串行端口的接口设备，例如键盘、鼠标等等。第一个属性为 [c]。

- [s]套接字（sockets）：这类文件通常用在网络数据连接。我们可以启动一个程序来监听客户端的要求，客户端就可以通过套接字来进行数据通信。第一个属性为 [s]，最常在 /var/run目录中看到这种文件类型。

- [p]管道（FIFO, pipe）：FIFO也是一种特殊的文件类型，它主要的目的是，解决多个程序同时存取一个文件所造成的错误。FIFO是first-in-first-out（先进先出）的缩写。第一个属性为 [p]。

那么如何对一个文件进行查看类型呢？上面ls -al已经可以看出文件类型，另外我们还可以通过下面这个例子来看文件类型。

	[root@localhost /]# file /bin/file
	/bin/file: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked 
	(uses shared libs), for GNU/Linux 2.6.32,BuildID[sha1]=*, stripped
	[root@localhost /]# file parser.out 
	parser.out: C source, ASCII text


## 2.1 Linux文件权限 ##

对应上面的[234] [567] [890]位来说说。每个文件或目录都有一组9个权限位，每三位被分为一组，他们分别是属主权限位（占三个位置）、用户组权限位（占三个位置）、其它用户权限位（占三个位置）。比如rwxr-xr-x，我们数一下就知道是不是9个位置了，正是这9个权限位来控制文件属主、用户组以及其它用户的权限。

### 2.1.1 权限位的解释 ###

Linux文件或目录的权限位是由9个权限位来控制，每三位为一组，它们分别是文件属主(owner)的读、写、执行，用户组(group)的读、写、执行以及(other)其它用户的读、写、执行。

文件属主：读r、写w、执行x

用户组：读r、写w、执行x

其它用户：读r、写w、执行x

同时 r对应数字4 w对应数字2 x对应数字1 

如果权限位不可读、不可写、不可执行，是用-来表示。
对于普通文件的读、写、执行权限可以这样理解：

**可读（read）** ：意味着我们可以查看阅读；

**可写（write）** ：意味着可以修改或删除（不过删除或修改的权限受父目录上的权限控制）；

**可执行（execute）**：意味着如果文件就可以运行，比如二进制文件（比如命令），或脚本（要用脚本语言解释器来解释运行）。

	[root@localhost test]# touch godao.sh
	[root@localhost test]# ls -al
	-rw-r--r--. 1 root root  0 9月   8 20:56 godao.sh

第一个字段- rw- r-- r-- 中的第一个字符是-，表示godao.sh是一个普通文件；

godao.sh的权限是rwxr-xr-x。表示godao.sh文件，文件的属主root，拥有rw-（可读、可写）权限，用户组root，拥有r--（可读)权限，其它用户拥有r--(可读）权限。这9个权限连在一起就是rw-r--r--，也就是说，godao.sh文件，文件属主root拥有可读、可写权限，用户组root下的所有用户拥有可读权限，其它用户拥有可读权限。

### 2.1.2 权限位的八进制表示说明 ###

    r = 4  w = 2  x = 1  - = 0
原来上面godao.sh文件的权限为：

    [root@localhost test]# ls -al
    -rw-r--r--. 1 root root  0 9月   8 20:56 godao.sh

属主的权限用数字表达：属主的那三个权限位的数字加起来的总和。比如上面的例子中属主的权限是rw-，也就是4+2+0，应该是6；
属组的权限用数字表达：属组的那个权限位数字的相加的总和。比如上面的例子中的r--，也就是4+0+0，应该是4；
其它用户的权限数字表达：其它用户权限位的数字相加的总和。比如上面例子中是r--，也就是4+0+0，应该是4；

下面利用chmod命令来改变godao.sh文件的权限，chmod命令等会在下面说明。

	[root@localhost test]# chmod 766 godao.sh 
	[root@localhost test]# ls -al
	-rwxrw-rw-. 1 root root  0 9月   8 20:56 godao.sh
此时属主权限位为rwx：7=4+2+1，组权限位为rw-：6=4+2+0，其它用户权限位为rw-：6=4+2+0。

八进制数字权限，每个三位的权限代码（分别是属主、属组、其它用户）组合，有8种可能：

	0---   1--x   2-w-   3-wx   4 r--   5 r-x   6 rw-   7 rwx   

注解：我们可以根据上面的数字列表来组合权限，如上面我的例子。

### 2.1.3 改变权限的命令chmod ###

chmod是用来改变文件或目录权限的命令，但只有文件的属主和超级权限用户root才有这种权限。通过chmod来改变文件或目录的权限有两种方法，一种是通过八进制的语法，另一种是通过助记语法。上面已经对八进制语法进行了说明、下面将是通过助记语法来说明。

### 2.1.4 权限位助记语法说明 ###

	[root@localhost test]# chmod u-x,go+x godao.sh 
	-rw-rwxrwx. 1 root root  0 9月   8 20:56 godao.sh

对比之前那个例子可以发现，属主减去了可执行命令，属组和其他用户都得到了可执行命令。

# 3、硬链接数 #

关于硬链接的在1.2节有详细的说明，下面再说点关于硬链接的一些问题。

**文件和目录的链接数由指向这个文件或目录的硬连接数决定。**

**目录的连接数是：1（此目录本身“.”）+1（上层目录“..”连接）+此下的子目录个数**

    [root@localhost daocoder]# mkdir test
    [root@localhost daocoder]# ls -al		daocoder目录链接数3 = . + .. +test
    drwxr-xr-x.  3 root root   30 9月   8 17:35 .
    drwxr-xr-x. 18 root root 4096 9月   8 17:03 ..
    drwxr-xr-x.  2 root root   20 9月   8 17:36 test
    [root@localhost test]# ls -al			test目录链接数4 = . + .. + aaa + bbb
    drwxr-xr-x. 4 root root 40 9月   8 17:48 .
    drwxr-xr-x. 3 root root 30 9月   8 17:35 ..
    drwxr-xr-x. 3 root root 14 9月   8 17:49 aaa
    drwxr-xr-x. 2 root root  6 9月   8 17:48 bbb
    [root@localhost test]# ls aaa -al		aaa目录链接数3 = . + .. + a
    drwxr-xr-x. 3 root root 14 9月   8 17:49 .
    drwxr-xr-x. 4 root root 40 9月   8 17:48 ..
    drwxr-xr-x. 2 root root  6 9月   8 17:49 a

**test虽然是空目录，但是里面至少有两个隐藏目录：.和..，分别表示当前目录和上层目录**

    [root@localhost test]# ls -al	        test目录链接数2 = . + .. 
    drwxr-xr-x. 2 root root  6 9月   8 17:30 .
    drwxr-xr-x. 3 root root 60 9月   8 17:30 ..

**文件的连接数就是指向此文件的硬连接数+1（此文件本身）**

    [root@localhost test]# ls -al		dao.txt文件本身 链接数1
   	 -rw-r--r--. 1 root root 27 9月   8 10:57 dao.txt
    [root@localhost test]# ln dao.txt dao1.txt 		给dao.txt做一个硬链接dao1.txt
    [root@localhost test]# ls -al					 链接数变2
    -rw-r--r--. 2 root root 27 9月   8 10:57 dao1.txt
    -rw-r--r--. 2 root root 27 9月   8 10:57 dao.txt
    [root@localhost test]# ln dao.txt dao2.txt 		给dao.txt再做一个硬链接dao2.txt
    [root@localhost test]# ls -ali					链接数变2、注意他们的硬连接数也一样
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao1.txt
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao2.txt
    38903 -rw-r--r--. 3 root root 27 9月   8 10:57 dao.txt
    

# 4&5、拥有者与拥有组 #

这个没啥解释的，主要看之后用户与组权限管理。

# 6、文件大小 #
即当前文件的大小、一般利用命令ls -h 来查看，下面来man一下看看说明。

![](http://i.imgur.com/398Gg0I.png)

# 7、最后访问或修改时间 #

介绍下linux中与文件相关的三个时间，文件的 access time也就是 ‘atime’ 是在读取文件或者执行文件时更改的。文件的 modified time也就是‘mtime’是在写入文件时随文件内容的更改而更改的。文件的 create time也就是‘ctime’是在写入文件、更改所有者、权限或链接设置时随inode的内容更改而更改的。 因此，更改文件的内容即会更改mtime和ctime，但是文件的ctime可能会在 mtime 未发生任何变化时更改，例如，更改了文件的权限，但是文件内容没有变化。如何获得一个文件的atime mtime 以及ctime 。

    [root@localhost test]# stat dao.txt 
    文件："dao.txt" 大小：27  块：8   IO 块：4096   普通文件
    设备：fd01h/64769d	Inode：38903   硬链接：1
    权限：(0644/-rw-r--r--)Uid：(0/root)Gid：(0/root)
    环境：unconfined_u:object_r:default_t:s0
    最近访问：2016-09-08 17:33:53.527665825 +0800
    最近更改：2016-09-08 10:57:32.382234291 +0800
    最近改动：2016-09-08 20:08:40.944977239 +0800
    创建时间：-
它和windows平台的文件相关的几个时间不同，windows是创建时间、修改时间和访问时间，如下图。

![](http://i.imgur.com/me8SFtJ.png)

# 8、文件名 #

## 8.1 Linux文件名的限制 ##

一般来说，在设置Linux下的文件名时，最好避免一些特殊字符。例如下面这些：

    * ? > < ; & ! [ ] | / ' " ` ( ) { }
因为这些符号在命令行界面下是有特殊意义的。另外，文件名的开头为小数点“.”时，表示这个文件为“隐藏文件”。同时，由于命令中常常会使用 -option之类的参数，所以最好也避免将文件名的开头以 - 或 来命名。

## 8.2 Linux文件扩展名 ##

基本上，Linux文件是没有“扩展名”的，我们知道，Linux文件能否执行，与它第一列的10个属性有关，与文件名一点关系也没有。这与Windows不 同。在Windows中，能执行的文件扩展名通常是 .com、.exe、.bat等等，而在Linux中，只要属性中有x，例如 [-rwx-r-xr-x] 即表示这个文件可以执行。

不过，可以执行与可执行成功是不一样的。举例来说，在root家目录下的 install.log是一个纯文本文件，如果修改权限成为 -rwxrwxrwx后，这个文件能执行吗？当然不行。因为它的内容根本就没有可执行的数据。所以说，x表示这个文件具有可执行的能力，但能不能执行成 功，当然就要看该文件的内容。

虽然扩展名没有什么实际的帮助，不过，由于我们仍然希望可以通过扩展名来了解该文件是什么，所以，通常还是会以适当的扩展名来表示该文件是什么类型。下面有数种常用的扩展名：

- *.sh：批处理文件（scripts，脚本），因为批处理文件使用shell写成，所以扩展名就编成 .sh。
- *Z, *.tar, *.tar.gz, *.zip, *.tgz：经过打包的压缩文件。这是因为压缩软件分别为gunzip、tar等等的，根据不同的压缩软件而取其相关的扩展名。
- *.html, *.php：网页相关文件，分别表示HTML语法与PHP语法的网页文件。.html的文件可使用网页浏览器来直接打开， .php的文件则可以通过客户端的浏览器来浏览服务器端，以得到运算后的网页结果。
- 另外.pl，还有程序语言如Perl的文件，其扩展名也可能取成 .pl。
 
基本上，Linux上面的文件名只是让你了解该文件可能的用途而已，真正的执行与否仍然需要属性的规范。例如，虽然有一个文件为可执行文件，如有 名的代理服务器软件squid，如果这个文件的属性被修改成无法执行，那么它就不能执行。在文件传送的过程中常发生这种问题。例如，你在网络上下载一个可 执行文件，但是，偏偏在你的Linux系统中就是无法执行。那就是可能文件的属性被改变了。从网络上传送到你的Linux系统中，文件的属性确实是会被改 变的。

另外，在Linux中，每一个文件或目录的文 件名最长可以到255个字符，加上完整路径时，最长可达4096个字符，是相当长的文件名。我们希望Linux的文件名可以一看就知道该文件的作用，所以文件名通常是很长，其实可以通过 [tab] 按键来确认文件名，这个以后说。

# 9、copyright #
   文件由**daocoder**原创+搜集、仅供交流学习使用、可自由转载、但希望注明出处。
