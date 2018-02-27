<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# shell编程

# 1、grep

## 1.1 grep简介

grep （global search regular expression(RE) and print out the line,全面搜索正则表达式并把行打印出来）是一种强大的文本搜索工具，它能使用正则表达式搜索文本，并把匹配的行打印出来。Unix的grep家族包 括grep、egrep和fgrep。egrep和fgrep的命令只跟grep有很小不同。egrep是grep的扩展，支持更多的re元字符， fgrep就是fixed grep或fast grep，它们把所有的字母都看作单词，也就是说，正则表达式中的元字符表示回其自身的字面意义，不再特殊。linux使用GNU版本的grep。它功能 更强，可以通过-G、-E、-F命令行选项来使用egrep和fgrep的功能。

grep的工作方式是这样的，它在一个或多个文件中搜索字符串模板。如果模板包括空格，则必须被引用，模板后的所有字符串被看作文件名。搜索的结果被送到屏幕，不影响原文件内容。

grep可用于shell脚本，因为grep通过返回一个状态值来说明搜索的状态，如果模板搜索成功，则返回0，如果搜索不成功，则返回1，如果搜索的文件不存在，则返回2。我们利用这些返回值就可进行一些自动化的文本处理工作。
 

功能说明：查找文件里符合条件的字符串。
 
语　　法：grep [-abcEFGhHilLnqrsvVwxy][-A<显示列数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]

补充说明：grep 指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设grep指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为“-”，则grep指令会从标准输入设备读取数据。
 

参　　数：

  -a或--text   不要忽略二进制的数据。
  -A<显示列数>或--after-context=<显示列数>   除了显示符合范本样式的那一列之外，并显示该列之后的内容。
  -b或--byte-offset   在显示符合范本样式的那一列之前，标示出该列第一个字符的位编号。

  -B<显示列数>或--before-context=<显示列数>   除了显示符合范本样式的那一列之外，并显示该列之前的内容。

  -c或--count   计算符合范本样式的列数。

  -C<显示列数>或--context=<显示列数>或-<显示列数>   除了显示符合范本样式的那一列之外，并显示该列之前后的内容。

  -d<进行动作>或--directories=<进行动作>   当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。

  -e<范本样式>或--regexp=<范本样式>   指定字符串做为查找文件内容的范本样式。

  -E或--extended-regexp   将范本样式为延伸的普通表示法来使用。

  -f<范本文件>或--file=<范本文件>   指定范本文件，其内容含有一个或多个范本样式，让grep查找符合范本条件的文件内容，格式为每列一个范本样式。

  -F或--fixed-regexp   将范本样式视为固定字符串的列表。

  -G或--basic-regexp   将范本样式视为普通的表示法来使用。

  -h或--no-filename   在显示符合范本样式的那一列之前，不标示该列所属的文件名称。

  -H或--with-filename   在显示符合范本样式的那一列之前，表示该列所属的文件名称。

  -i或--ignore-case   忽略字符大小写的差别。

  -l或--file-with-matches   列出文件内容符合指定的范本样式的文件名称。

  -L或--files-without-match   列出文件内容不符合指定的范本样式的文件名称。

  -n或--line-number   在显示符合范本样式的那一列之前，标示出该列的列数编号。

  -q或--quiet或--silent   不显示任何信息。

  -r或--recursive   此参数的效果和指定“-d recurse”参数相同。

  -s或--no-messages   不显示错误信息。

  -v或--revert-match   反转查找。

  -V或--version   显示版本信息。

  -w或--word-regexp   只显示全字符合的列。

  -x或--line-regexp   只显示全列符合的列。

  -y   此参数的效果和指定“-i”参数相同。

  --help   在线帮助。

参见[grep命令参数及用法](http://blog.csdn.net/dysh1985/article/details/7571273)。


## 1.2 grep实例

	[root@localhost daocoder]# alias grep							原本系统里面默认高亮显示
	alias grep='grep --color=auto'


	[root@localhost daocoder]# cat passwd 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep 'root' passwd					在passed中找到‘root’字符串 
	root:x:0:0:root:/root:/bin/bash

	[root@localhost daocoder]# grep -c 'root' passwd 				有‘root’字符串的行数
	1
	[root@localhost daocoder]# grep -n 'root' passwd 				有‘root’字符串的所在行行号
	1:root:x:0:0:root:/root:/bin/bash

	[root@localhost daocoder]# grep -n 'home' passwd 				有‘home’字符串所在行行号，这个看的明显点
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	7:dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -v 'root' passwd 				取反，不包含‘root’字符串
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -nA4 'root' passwd 				An取包含‘root’及其下n行
	1:root:x:0:0:root:/root:/bin/bash
	2-bin:x:1:1:bin:/bin:/sbin/nologin
	3-daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4-daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5-godao:x:1001:1001::/home/godao:/bin/bash

	[root@localhost daocoder]# grep -nB2 'home' passwd 				Bn取包含‘home’及其上n行
	2-bin:x:1:1:bin:/bin:/sbin/nologin
	3-daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	7:dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -nC1 'daocoder' passwd 			Bn取包含‘daocoder’及其上下n行
	3-daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5-godao:x:1001:1001::/home/godao:/bin/bash

	[root@localhost daocoder]# grep -n 'passwd' /etc/*				找出/etc/单层目录下包含‘passwd’字符串的文件
	/etc/login.defs:5:# passwd command) should therefore be configured elsewhere. Refer to
	grep: /etc/logrotate.d: 是一个目录
	grep: /etc/lvm: 是一个目录
	/etc/nsswitch.conf.bak:33:passwd:     files sss

	[root@localhost daocoder]# grep -rhn 'passwd' /etc/*				
	找出/etc/多层目录下包含‘passwd’字符串的文件,并没有文件名

	grep: /etc/request-key.d: 是一个目录
	13:yppasswdd	100009	yppasswd
	63:nispasswd	100303	rpc.nispasswdd
	
	[root@localhost daocoder]# grep '[2-5]' passwd 					找出passwd下包含数字2-5的行
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep '^d' passwd 					以d开头的行
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash
	[root@localhost daocoder]# grep -v '^d' passwd 					不是以d开头的行
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# grep -v '^#' passwd 					空行外的行

	[root@localhost daocoder]# grep 'h..e' passwd 					‘.’表示任意一个字符
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

- *	**匹配前面的子表达式零次或多次。**要匹配 * 字符，请使用 \*。
- +	**匹配前面的子表达式一次或多次。**要匹配 + 字符，请使用 \+。
- .	**匹配除换行符\n之外的任何单字符。**要匹配.，请使用\。
- ?	**匹配前面的子表达式零次或一次**，或指明一个非贪婪限定符。 要匹配?字符，请使用\?。

# 2、egrep(grep扩展形式)

下面这个例子可以看出grep与egrep最大的区别就是对需不需要对特殊字（.、+、？、{、}等多个）符用脱义。

	[root@localhost daocoder]# egrep 'o+' passwd 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep 'o+' passwd 
	[root@localhost daocoder]# grep 'o\+' passwd 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

再看一个例子。

	[root@localhost daocoder]# grep 'root|bash' passwd 						‘|’或者
	[root@localhost daocoder]# grep 'root\|bash' passwd 
	root:x:0:0:root:/root:/bin/bash
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash
	[root@localhost daocoder]# egrep 'root|bash' passwd 
	root:x:0:0:root:/root:/bin/bash
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# egrep 'r(o){2}' passwd 						匹配2次‘o’
	root:x:0:0:root:/root:/bin/bash

	[root@localhost daocoder]# egrep 'r(oo){2}' passwd 						匹配2次‘oo’
	root:x:0:0:roooot:/root:/bin/bash
	[root@localhost daocoder]# grep 'r\(oo\)\{2\}' passwd 
	root:x:0:0:roooot:/root:/bin/bash

	[root@localhost daocoder]# grep -E 'r(oo){2}' passwd 					grep -E 利用egrep
	root:x:0:0:roooot:/root:/bin/bash

# 3、sed(匹配、替换)

sed处于流式编辑器，按行处理。不能高亮，有点烦。匹配还是grep好点，sed适合删除和替换。

## 3.1 sed匹配

	[root@localhost daocoder]# sed '3p' passwd 								打印第三行
	root:x:0:0:roooot:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -n '.*' passwd|sed '3p'					‘.*’贪婪匹配
	1:root:x:0:0:roooot:/root:/bin/bash
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	7:dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# sed -n '3p' passwd 							只匹配指定行
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '3p'
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin

	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '1,3p'			只匹配1-3行	
	1:root:x:0:0:roooot:/root:/bin/bash
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '1,$p'			匹配全部行	
	1:root:x:0:0:roooot:/root:/bin/bash
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	7:dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '/ro/p'			‘ro’要匹配的字符串要在//里面
	1:root:x:0:0:roooot:/root:/bin/bash
	
	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '/r*/p'
	1:root:x:0:0:roooot:/root:/bin/bash
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash

## 3.2 sed删除和替换
	
删除和替换，不更改源文件。

	[root@localhost daocoder]# grep -n '.*' passwd|sed '7d'					删除第7行，但不更改源文件
	1:root:x:0:0:roooot:/root:/bin/bash
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	[root@localhost daocoder]# cat -n passwd 
	     1	root:x:0:0:roooot:/root:/bin/bash
	     2	bin:x:1:1:bin:/bin:/sbin/nologin
	     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	     4	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	     5	godao:x:1001:1001::/home/godao:/bin/bash
	     6	mudai:x:1002:1002::/home/mudai:/bin/bash
	     7	dos:x:1003:521::/home/dos:/bin/bash

	[root@localhost daocoder]# grep -n '.*' passwd|sed -n '/r./p'
	1:root:x:0:0:roooot:/root:/bin/bash
	4:daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	[root@localhost daocoder]# grep -n '.*' passwd|sed '/r./d'
	2:bin:x:1:1:bin:/bin:/sbin/nologin
	3:daemon:x:2:2:daemon:/sbin:/sbin/nologin
	5:godao:x:1001:1001::/home/godao:/bin/bash
	6:mudai:x:1002:1002::/home/mudai:/bin/bash
	7:dos:x:1003:521::/home/dos:/bin/bash
	[root@localhost daocoder]# cat -n passwd 
	     1	root:x:0:0:roooot:/root:/bin/bash
	     2	bin:x:1:1:bin:/bin:/sbin/nologin
	     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	     4	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	     5	godao:x:1001:1001::/home/godao:/bin/bash
	     6	mudai:x:1002:1002::/home/mudai:/bin/bash
	     7	dos:x:1003:521::/home/dos:/bin/bash

可加参数 -i直接更改源文件

	[root@localhost daocoder]# grep -n '.*' passwd|sed -i '7d'					不支持管道
	sed: 没有输入文件
	[root@localhost daocoder]# sed -i '7d' passwd 								删除第7行
	[root@localhost daocoder]# cat -n passwd 									查看下源文件
	     1	root:x:0:0:roooot:/root:/bin/bash	
	     2	bin:x:1:1:bin:/bin:/sbin/nologin
	     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	     4	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	     5	godao:x:1001:1001::/home/godao:/bin/bash
	     6	mudai:x:1002:1002::/home/mudai:/bin/bash

sed 's/需要替换字符串/替换后的字符串/g 文件名；g为全部替换。

	[root@localhost daocoder]# sed 's/roooot/root/g' passwd 					不对源文件生效 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	[root@localhost daocoder]# cat -n passwd 
	     1	root:x:0:0:roooot:/root:/bin/bash
	     2	bin:x:1:1:bin:/bin:/sbin/nologin
	     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	     4	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	     5	godao:x:1001:1001::/home/godao:/bin/bash
	     6	mudai:x:1002:1002::/home/mudai:/bin/bash
	[root@localhost daocoder]# sed -i 's/roooot/root/g' passwd					对源文件生效 
	[root@localhost daocoder]# cat -n passwd 
	     1	root:x:0:0:root:/root:/bin/bash
	     2	bin:x:1:1:bin:/bin:/sbin/nologin
	     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	     4	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	     5	godao:x:1001:1001::/home/godao:/bin/bash
	     6	mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# sed '5,10s/[0-9]//g' passwd 						删除5-10行所有的数字
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x::::/home/godao:/bin/bash
	mudai:x::::/home/mudai:/bin/bash

# 4、awk(匹配、替换、分段)

awk处于流式编辑器，按行处理。

## 4.1 分割指定段

	[root@localhost daocoder]# awk -F: '{print $1,$3}' passwd 					分割出第一、三段
	root 0
	bin 1
	daemon 2
	daocoder 1000
	godao 1001
	mudai 1002
	[root@localhost daocoder]# awk -F: '{print $N}' passwd 						打印全部段
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	[root@localhost daocoder]# awk '/root/' passwd 
	root:x:0:0:root:/root:/bin/bash

## 4.2 精确匹配（同sed）

	[root@localhost daocoder]# awk '$1~/root/' passwd 							第一行内匹配‘root’				
	root:x:0:0:root:/root:/bin/bash
	[root@localhost daocoder]# awk '$2~/root/' passwd 							第二行内匹配‘root’

	[root@localhost daocoder]# awk -F: '{print $1,$2};$1~/root/;$3~/\:/' passwd 多条语句
	注意这里单引号将全部语句扩起来
	root x
	root:x:0:0:root:/root:/bin/bash
	bin x
	daemon x
	daocoder x
	godao x
	mudai x
	[root@localhost daocoder]# awk -F: '{print $1,$2}' passwd 
	root x
	bin x
	daemon x
	daocoder x
	godao x
	mudai x
	[root@localhost daocoder]# awk -F: '$1~/root/' passwd 
	root:x:0:0:root:/root:/bin/bash
	[root@localhost daocoder]# awk -F: '$3~/\:/' passwd 

	[root@localhost daocoder]# awk '{print NR,$N}' passwd 					行加行号
	1 root:x:0:0:root:/root:/bin/bash
	2 bin:x:1:1:bin:/bin:/sbin/nologin
	3 daemon:x:2:2:daemon:/sbin:/sbin/nologin
	4 daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	5 godao:x:1001:1001::/home/godao:/bin/bash
	6 mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# awk -F: '$3>500' passwd 
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# awk -F: '$3==$4' passwd 						一个等号是赋值
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash

	[root@localhost daocoder]# awk -F: '$3==$4 && $7!="/bin/bash"' passwd 多条件语句，注意这个引号的位置
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin

	[root@localhost daocoder]# awk -F: '{print $NF}' passwd 				NF与NR的作用
	/bin/bash
	/sbin/nologin
	/sbin/nologin
	/bin/bash
	/bin/bash
	/bin/bash
	[root@localhost daocoder]# awk -F: '{print NF}' passwd 
	7
	7
	7
	7
	7
	7
	[root@localhost daocoder]# awk -F: '{print NR}' passwd 
	1
	2
	3
	4
	5
	6
	[root@localhost daocoder]# awk -F: '{print $NR}' passwd 				这个有意思：依次打印行列相同的位置
	root
	x
	2
	1001
	
	/home/mudai

	[root@localhost daocoder]# awk -F: '$5=$3+$4' passwd 				支持数组相加，字符串好像为零
	bin x 1 1 2 /bin /sbin/nologin
	daemon x 2 2 4 /sbin /sbin/nologin
	daocoder x 1000 1001 2001 /home/daocoder /bin/bash
	godao x 1001 1001 2002 /home/godao /bin/bash
	mudai x 1002 1002 2004 /home/mudai /bin/bash

	[root@localhost daocoder]# cat passwd 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash
	mudai:x:1002:1002::/home/mudai:/bin/bash
	[root@localhost daocoder]# awk 'NR==1' passwd 						输出指定行
	root:x:0:0:root:/root:/bin/bash
	[root@localhost daocoder]# awk 'NR>=1 && NR<=5' passwd 
	root:x:0:0:root:/root:/bin/bash
	bin:x:1:1:bin:/bin:/sbin/nologin
	daemon:x:2:2:daemon:/sbin:/sbin/nologin
	daocoder:x:1000:1001:demo:/home/daocoder:/bin/bash
	godao:x:1001:1001::/home/godao:/bin/bash

	[root@localhost daocoder]# awk -F: '{if ($1=="root") print $0}' passwd $0打印整行
	root:x:0:0:root:/root:/bin/bash



暂时这样，待补充。awk作编程语言使用可以。




































	


