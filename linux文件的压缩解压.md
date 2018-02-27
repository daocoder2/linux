<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# linux文件的压缩解压

# 1、linux文件的打包与压缩

对于压缩文件，在Windows下最常见的压缩文件就只有两种，一是 * .zip，另一个是* .rar。可是 Linux 就不同了，它有 .gz、.tar.gz、tgz、bz2、.Z、.tar等众多的压缩文件名，此外windows下的.zip和.rar也可以在Linux下使用，不过在Linux使用.zip和.rar的人就太少了。本文就来对这些常见的压缩文件进行一番小结。

在具体总结各类压缩文件之前，首先要弄清两个概念：打包和压缩。

打包是指将一大堆文件或目录等变成一个总的文件；压缩则是将一个大的文件通过一些压缩算法变成一个小文件。为什么要区分这两个概念呢？其实这源于 Linux中的很多压缩程序只能针对一个文件进行压缩，这样当你想要压缩一大堆文件时，你就得先借助另它的工具将这一大堆文件先打成一个包，然后再就原来的压缩程序进行压缩。

Linux下最常用的打包程序就是tar了，使用tar程序打出来的包我们常称为tar包，tar包文件的命令通常都是以.tar结尾的。tar 由 'Tape archiver（磁带归档器）' 衍生而来，最初被用来在磁带上归档和存储文件。tar 是一个 GNU 软件，它可以压缩一组文件（归档），或提取它们以及对已有的归档文件进行相关操作。在存储、备份以及传输文件方面，它是很有用的。在创建归档文件时，Tar 可以保持原有文件和目录结构不变。通过 Tar 归档的文件的后缀名为 ‘.tar’。

Linux常用的压缩程序比较多。

- Gzip 即 GNU zip，它是一个被广泛用于 Linux 操作系统中的压缩应用，被其压缩的文件的后缀名为'*.gz' 。

- Bzip2 也是一个压缩工具，与其他传统的工具相比，它可以将文件压缩到更小，但其缺点为：运行速度比 gzip 慢。

- 7-zip 是另一个开源压缩软件。它使用 7z 这种新的压缩格式，并支持高压缩比。因此，它被认为是比先前提及的压缩工具更好的软件。在 Linux 下，可以通过 p7zip 软件包得到，该软件包里包含 3 个二进制文件： 7z, 7za 和 7zr。归档文件以 '.7z' 为后缀名。

		*.Z       compress 程序压缩的档案； 
			
		*.bz2     bzip2 程序压缩的档案； 
			
		*.gz      gzip 程序压缩的档案； 
			
		*.zip     zip 程序压缩文件			windows及linux上互传文件最好用这个格式。
		
		*.rar     rar 程序压缩文件
		
		*.tar     tar 程序打包的数据，并没有压缩过； 
			
		*.tar.gz  tar 程序打包的档案，其中并且经过gzip 的压缩！

# 2、linux文件解压缩实战

## 2.1 tar命令解析

	[root@localhost bin]# tar --help
	用法: tar [主选项+辅选项] [FILE]...
	 GNU ‘tar’：将许多文件一起保存至一个单独的磁带或磁盘归档，并能从归档中单独还原所需文件。
	
	 主选项:
	
	  -A, --catenate, --concatenate   追加 tar 文件至归档
	  -c, --create               建立压缩档案
	  -d, --diff, --compare      找出归档和文件系统的差异
	      --delete               从归档(非磁带！)中删除
	  -r, --append               向压缩归档文件末尾追加文件
	  -t, --list                 查看归档内容
	      --test-label           测试归档卷标并退出
	  -u, --update               更新原压缩包中的文件
	  -x, --extract, --get       解压归档文件

**这五个是独立的命令，压缩解压都要用到其中一个，可以和别的命令连用但只能用其中一个。**

**下面的参数是根据需要在压缩或解压档案时可选的。**

	辅选项:

	  -v, --verbose              详细地列出处理的文件

	
	  
      --force-local
                             即使归档文件存在副本还是把它认为是本地归档
	  -j, --bzip2                通过 bzip2 过滤归档
	  -J, --xz                   通过 xz 过滤归档
	      --lzip                 通过 lzip 过滤归档
	      --lzma                 通过 lzma 过滤归档
	      --lzop
	      --no-auto-compress     不使用归档后缀名来决定压缩程序
	  -z, --gzip, --gunzip, --ungzip   通过 gzip 过滤归档
	  -Z, --compress, --uncompress   通过 compress 过滤归档

	　下面的参数-f是必须的
	
	　-f, --file=ARCHIVE         使用归档文件，这个参数是最后一个参数，后面只能接档案名。

下面带几个例子解析：

	tar -cf all.tar *.jpg 这条命令是将所有.jpg的文件打成一个名为all.tar的包。-c是表示产生新的包，-f指定包的文件名。
	tar -rf all.tar *.gif 这条命令是将所有.gif的文件增加到all.tar的包里面去。-r是表示增加文件的意思。 
	tar -uf all.tar logo.gif 这条命令是更新原来tar包all.tar中logo.gif文件，-u是表示更新文件的意思。 
	tar -tf all.tar 这条命令是列出all.tar包中所有文件，-t是列出文件的意思 
	tar -xf all.tar 这条命令是解出all.tar包中所有文件，-x是解开的意思

## 2.2 gzip命令解析（gzip为例，bzip2类似）

	[root@localhost bin]# gzip --help
	Usage: gzip [OPTION]... [FILE]...
	Compress or uncompress FILEs (by default, compress FILES in-place).
	
	Mandatory arguments to long options are mandatory for short options too.
	
	  -c, --stdout      write on standard output, keep original files unchanged
	  -d, --decompress  decompress
	  -f, --force       force overwrite of output file and compress links
	  -h, --help        give this help
	  -l, --list        list compressed file contents
	  -n, --no-name     do not save or restore the original name and time stamp
	  -N, --name        save or restore the original name and time stamp
	  -q, --quiet       suppress all warnings
	  -r, --recursive   operate recursively on directories
	  -S, --suffix=SUF  use suffix SUF on compressed files
	  -t, --test        test compressed file integrity
	  -v, --verbose     verbose mode

gzip压缩：

	[root@localhost daocoder]# ls
	passwd
	[root@localhost daocoder]# gzip passwd 
	[root@localhost daocoder]# ls
	passwd.gz
	[root@localhost daocoder]# gunzip passwd.gz 
	[root@localhost daocoder]# ls
	passwd

bzip2压缩：

	[root@localhost daocoder]# bzip2 passwd 
	[root@localhost daocoder]# ls
	passwd.bz2
	[root@localhost daocoder]# bunzip2 passwd.bz2
	[root@localhost daocoder]# ls
	passwd

zip压缩：

	[root@localhost daocoder]# zip passwd.zip passwd		需要指定文件名
	  adding: passwd (deflated 61%)
	[root@localhost daocoder]# ls
	passwd.zip		passwd
	[root@localhost daocoder]# unzip passwd.zip 
	Archive:  passwd.zip
	replace passwd? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
	  inflating: passwd                  
	[root@localhost daocoder]# ls
	passwd.zip   passwd     

这里我们可以看出 gzip、bzip2 两个与 zip 压缩文件的第一个区别。zip对文件的压缩或解压会保留源文件生成新的文件，且压缩或解压时需要指定文件名。然后还要注意一个问题就是**对 zip 压缩文件时指定压缩目标文件的命名最好以‘.zip’结尾**，linux会高亮显示，其他后缀名也可以正常解压，但不建议。

	[root@localhost daocoder]# ls -al
	drwxr-xr-x.  4 root  root       4096 9月   8 20:56 test

	[root@localhost daocoder]# gzip test				gzip不能对目录压缩
	gzip: test is a directory -- ignored
	[root@localhost daocoder]# bzip2 test				bzip2不能对目录压缩
	bzip2: Input file test is a directory.
	[root@localhost daocoder]# zip test.zip test		zip可以对目录压缩
	  adding: test/ (stored 0%)							但是这里是压缩0%，有问题！
	[root@localhost daocoder]# ls
	test.zip		test
	[root@localhost daocoder]# zip -r test.zip test		这里注意对目录的压缩带上 -r 参数
	  adding: test/ (stored 0%)
	  adding: test/passwd (deflated 61%)
	  adding: test/godao.sh (stored 0%)


这里我们可以看出 gzip、bzip2 两个与 zip 压缩文件的第二个区别，即 zip 可以对目录压缩。

总结：1、zip压缩不对源文件有影响。2、zip可以对目录压缩。




## 2.3 文件打包解压缩例子

这里即时tar和bzip等连用进行直接解包和解压的过程。

查看

	tar -tf aaa.tar.gz   在不解压的情况下查看压缩包的内容
	
压缩

	[root@localhost daocoder]# tar -cf txt.tar *.txt	将目录里所有.txt文件打包成txt.tar
	[root@localhost daocoder]# ls
	txt.tar

	[root@localhost daocoder]# tar -czf txt.tar.gz *.txt	
	将目录里所有txt文件打包成txt.tar后，并且将其用gzip压缩，生成一个gzip压缩过的包，命名txt.tar.gz
	[root@localhost daocoder]# ls
	txt.tar.gz

	[root@localhost daocoder]# tar -cjf txt.tar.bz2 *.txt
	将目录里所有txt文件打包成txt.tar后，并且将其用bzip2压缩，生成一个bzip2压缩过的包，命名txt.tar.bz2
	[root@localhost daocoder]# ls
	txt.tar.bz2

解压（源包文件不会消失）

	tar –xvf file.tar 			解压 tar包
	
	tar -xzvf file.tar.gz 		解压tar.gz
	
	tar -xjvf file.tar.bz2   	解压 tar.bz2

	tar –xZvf file.tar.Z 		解压tar.Z
	

# 3、总结

- *.tar 用 tar –xvf 解压

- *.gz 用 gzip -d或者gunzip 解压

- *.tar.gz和*.tgz 用 tar –xzf 解压

- *.bz2 用 bzip2 -d或者用bunzip2 解压

- *.tar.bz2用tar –xjf 解压

- *.Z 用 uncompress 解压

- *.tar.Z 用tar –xZf 解压






