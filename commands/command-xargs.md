<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之xargs

## 1、xargs命令简介

xargs命令是给其他命令传递参数的一个过滤器，也是组合多个命令的一个工具。**它擅长将标准输入数据转换成命令行参数，xargs能够处理管道或者stdin并将其转换成特定命令的命令参数。**xargs也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行。**xargs的默认命令是echo，空格是默认定界符。这意味着通过管道传递给xargs的输入将会包含换行和空白，不过通过xargs的处理，换行和空白将被空格取代。**xargs是构建单行命令的重要组件之一。

### 1.1 语法

	xargs(选项)

### 1.2 参数

先看一个文件，如下。

	[root@localhost sysshell]# cat 12-web-http-log.txt 
	2017-12-24 02:03  can access, but the httpcode is 502 
	2017-12-25 02:03  can access, but the httpcode is 502 
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502

1、-a file：从文件中读入作为sdtin。

	[root@localhost sysshell]# xargs -a 12-web-http-log.txt echo
	2017-12-24 02:03 can access, but the httpcode is 502 2017-12-25 02:03 can access, but the httpcode is 502 2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502

2、-0：当sdtin含有特殊字元时候（换行），将其当成一般字符，像/'空格等。

	[root@localhost sysshell]# xargs -0 -a 12-web-http-log.txt echo
	2017-12-24 02:03  can access, but the httpcode is 502 
	2017-12-25 02:03  can access, but the httpcode is 502 
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502 

3、-n num：后面加次数，表示命令在执行的时候一次用的argument的个数，默认是用所有的。通常用来指定命令限定参数的地方。

	[root@localhost sysshell]# cat 12-web-http-log.txt | xargs echo
	2017-12-24 02:03 can access, but the httpcode is 502 2017-12-25 02:03 can access, but the httpcode is 502 2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502

	[root@localhost sysshell]# cat 12-web-http-log.txt | xargs -n 6 echo
	2017-12-24 02:03 can access, but the
	httpcode is 502 2017-12-25 02:03 can
	access, but the httpcode is 502
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501
	340200） can access, but the httpcode
	is 502

这里可以看出两个东西：

- xargs默认以空格作为分界符，文件中的空格和换行都被认作分界符。
- 指定调用个数。

4、-i或是-I：linux支持类型不同，将xargs的每项名称，一般是一行一行赋值给{}，可以用{}代替。选项告诉 xargs 可以使用{}代替传递过来的参数。主要作用是当xargs command 后有多个参数时，调整参数位置。

	[root@localhost sysshell]# cat 12-web-http-log.txt | xargs -i echo {}
	2017-12-24 02:03  can access, but the httpcode is 502 
	2017-12-25 02:03  can access, but the httpcode is 502 
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502

	[root@localhost sysshell]# cat 12-web-http-log.txt | xargs -I @ echo @
	2017-12-24 02:03  can access, but the httpcode is 502 
	2017-12-25 02:03  can access, but the httpcode is 502 
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502

这里可以看出两个东西：

- -i：默认替换字符为{}、-I：指定替换字符，一般为{}、可替换成$ @等符号、一般是{}。
- 建议使用-I，其符合POSIX标准。

5、启用命令行输出模式：其先打印要运行的命令，然后执行命令，打印出命令结果，跟踪与调试xargs的利器，也是研究xargs运行原理的好办法。

	[root@localhost sysshell]# cat 12-web-http-log.txt | xargs -t -I @ echo @
	echo 2017-12-24 02:03  can access, but the httpcode is 502  
	2017-12-24 02:03  can access, but the httpcode is 502 
	echo 2017-12-25 02:03  can access, but the httpcode is 502  
	2017-12-25 02:03  can access, but the httpcode is 502 
	echo 2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502  
	2017-12-26 02:03 192.168.8.12 （芜湖 213 8501 340200） can access, but the httpcode is 502 



