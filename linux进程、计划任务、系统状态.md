<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>

# linux进程管理、计划性任务和系统状态查询

# 1、linux进程管理

## 1.1 linux系统状态

inux是一个多用户，多任务的系统，可以同时运行多个用户的多个程序，就必然会产生很多的进程，而每个进程会有不同的状态。

![linux系统状态图解](http://i.imgur.com/Pw0r45a.png)

- R/运行状态（TASK_RUNNING）：指正在被CPU运行或者就绪的状态。这样的进程被成为runnning进程。运行态的进程可以分为3种情况：内核运行态、用户运行态、就绪态。

- S/可中断睡眠状态（TASK_INTERRUPTIBLE SLEEPING）：处于等待状态中的进程，一旦被该进程等待的资源被释放，那么该进程就会进入运行状态。

- D/不可中断睡眠状态（TASK_UNINTERRUPTIBLE SLEEPING）：该状态的进程只能用wake_up()函数唤醒。

- T/暂停状态（TASK_STOPPED）：当进程收到信号SIGSTOP、SIGTSTP、SIGTTIN或SIGTTOU时就会进入暂停状态。可向其发送SIGCONT信号让进程转换到可运行状态。

- Z/僵死状态（TASK_ZOMBIE）：当进程已经终止运行，但是父进程还没有询问其状态的情况。

这里注意：只有当进程从“内核运行态”转移到“睡眠状态”时，内核才会进行进程切换操作。在内核态下运行的进程不能被其它进程抢占，而且一个进程不能改变另一个进程的状态。为了避免进程切换时造成内核数据错误，内核在执行临界区代码时会禁止一切中断。

## 1.2 进程静态查看命令 ps

Linux中的ps命令是Process Status的缩写。ps命令用来列出系统中当前运行的那些进程。

ps命令列出的是当前那些进程的快照，就是执行ps命令的那个时刻的那些进程，如果想要动态的显示进程信息，就可以使用top命令。

要对进程进行监测和控制，首先必须要了解当前进程的情况，也就是需要查看当前进程，而 ps 命令就是最基本同时也是非常强大的进程查看命令。使用该命令可以确定有哪些进程正在运行和运行的状态、进程是否结束、进程有没有僵死、哪些进程占用了过多的资源等等。总之大部分信息都是可以通过执行该命令得到的。

ps工具标识进程有几种状态码，在下文将对进程的 R、S、D、T、Z、X 六种状态做个说明。
 
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process.

       D    Uninterruptible sleep (usually IO)
       R    Running or runnable (on run queue)
       S    Interruptible sleep (waiting for an event to complete)
       T    Stopped, either by a job control signal or because it is being traced.
       X    dead (should never be seen)
       Z    Defunct ("zombie") process, terminated but not
            reaped by its parent.
 
       For BSD formats and when the stat keyword is used,additional characters may be displayed:
       <    high-priority (not nice to other users)							高优先级
       N    low-priority (nice to other users)								低优先级
       L    has pages locked into memory (for real-time and custom IO)		有页被锁在内存中
       s    is a session leader												后台进程组
       l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)	多线程
       +    is in the foreground process group								前台进程组

ps(选项)		一般都使用ps aux

a：显示现行终端机下的所有程序，包括其他用户的程序。
u：以用户为主的格式来显示程序状况
x：显示所有程序，不以终端机来区分。


	[root@localhost ~]# ps
	   PID TTY          TIME CMD
	 82502 pts/0    00:00:00 bash
	 82672 pts/0    00:00:00 ps

	[root@localhost ~]# ps aux					部分列出
	USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
	root          1  0.0  0.4 201296  7760 ?        Ss   10月18   0:14 /usr/lib/systemd/syst
	root          2  0.0  0.0      0     0 ?        S    10月18   0:00 [kthreadd]
	root          3  0.0  0.0      0     0 ?        S    10月18   0:47 [ksoftirqd/0]
	root          5  0.0  0.0      0     0 ?        S<   10月18   0:00 [kworker/0:0H]
	root          7  0.0  0.0      0     0 ?        S    10月18   0:10 [migration/0]
	root          8  0.0  0.0      0     0 ?        S    10月18   0:00 [rcu_bh]
	root          9  0.0  0.0      0     0 ?        S    10月18   0:00 [rcuob/0]
	root         10  0.0  0.0      0     0 ?        S    10月18   0:00 [rcuob/1]
	root         11  0.0  0.0      0     0 ?        S    10月18   0:00 [rcuob/2]


- VIRT：virtual memory usage 虚拟内存
	- 进程“需要的”虚拟内存大小，包括进程使用的库、代码、数据等
	- 假如进程申请100m的内存，但实际只使用了10m，那么它会增长100m，而不是实际的使用量
- RES：resident memory usage 常驻内存
	- 进程当前使用的内存大小，但不包括swap out
	- 包含其他进程的共享
	- 如果申请100m的内存，实际使用10m，它只增长10m，与VIRT相反
	- 关于库占用内存的情况，它只统计加载的库文件所占内存大小
- SHR：shared memory 共享内存
	- 除了自身进程的共享内存，也包括其他进程的共享内存
	- 虽然进程只使用了几个共享库的函数，但它包含了整个共享库的大小
	- 计算某个进程所占的物理内存大小公式：RES – SHR
	- swap out后，它将会降下来
- DATA
	- 数据占用的内存。如果top没有显示，按f键可以显示出来。
	- 真正的该程序要求的数据空间，是真正在运行中要使用的。

查看进程树：pstree		可详细看出进程间的父子级间关系

	[root@localhost ~]# pstree
	systemd─┬─ModemManager───2*[{ModemManager}]
	        ├─NetworkManager───2*[{NetworkManager}]
	        ├─2*[abrt-watch-log]
	        ├─abrtd
	        ├─alsactl
	        ├─atd
	        ├─auditd─┬─audispd─┬─sedispatch
	        │        │         └─{audispd}
	        │        └─{auditd}
	        ├─avahi-daemon───avahi-daemon
	        ├─chronyd
	        ├─crond
	        ├─dbus-daemon───{dbus-daemon}
	        ├─dhclient
	        ├─dnsmasq
	        ├─firewalld───{firewalld}
	        ├─iprdump
	        ├─iprinit
	        ├─iprupdate
	        ├─ksmtuned───sleep
	        ├─libvirtd───10*[{libvirtd}]
	        ├─2*[login───bash]
	        ├─lsmd
	        ├─lvmetad
	        ├─master─┬─pickup
	        │        └─qmgr
	        ├─polkitd───5*[{polkitd}]
	        ├─rngd
	        ├─rpc.statd
	        ├─rpcbind
	        ├─rsyslogd───2*[{rsyslogd}]
	        ├─smartd
	        ├─sshd───sshd───bash───pstree
	        ├─systemd-journal
	        ├─systemd-logind
	        ├─systemd-udevd
	        ├─tuned───4*[{tuned}]
	        └─vmtoolsd───{vmtoolsd}

## 1.3 进程动态查看命令 top

	[root@localhost ~]# top
	top - 09:47:58 up 23:40,  3 users,  load average: 0.00, 0.01, 0.05
	Tasks: 387 total,   1 running, 386 sleeping,   0 stopped,   0 zombie
	%Cpu(s):  0.1 us,  0.2 sy,  0.0 ni, 99.8 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	KiB Mem:   1870784 total,  1250820 used,   619964 free,     4600 buffers
	KiB Swap:  2097148 total,      120 used,  2097028 free.   839512 cached Mem

Cpu(s):  0.0%us,  0.5%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st

I try to explain  these:
us: is meaning of "user CPU time"
sy: is meaning of "system CPU time"
ni: is meaning of" nice CPU time"
id: is meaning of "idle"
wa: is meaning of "iowait" 
hi：is meaning of "hardware irq"
si : is meaning of "software irq"
st : is meaning of "steal time"

中文翻译为：

us 用户空间占用CPU百分比
sy 内核空间占用CPU百分比
ni 用户进程空间内改变过优先级的进程占用CPU百分比
id 空闲CPU百分比
wa 等待输入输出的CPU时间百分比
hi 硬件中断
si 软件中断 
st: 实时
	
	   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND            
	 90077 root      20   0  123796   1880   1160 R   0.7  0.1   0:00.91 top                
	     1 root      20   0  201296   7760   2540 S   0.0  0.4   0:14.43 systemd            
	     2 root      20   0       0      0      0 S   0.0  0.0   0:00.22 kthreadd           
	     3 root      20   0       0      0      0 S   0.0  0.0   0:47.76 ksoftirqd/0        
	     5 root       0 -20       0      0      0 S   0.0  0.0   0:00.00 kworker/0:0H       
	     7 root      rt   0       0      0      0 S   0.0  0.0   0:10.22 migration/0        
	     8 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcu_bh             
	     9 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcuob/0            
	    10 root      20   0       0      0      0 S   0.0  0.0   0:00.00 rcuob/1  

默认情况下仅显示比较重要的 PID、USER、PR、NI、VIRT、RES、SHR、S、%CPU、%MEM、TIME+、COMMAND 列。可以通过下面的快捷键来更改显示内容。
通过 f 键可以选择显示的内容。按 f 键之后会显示列的列表，按 a-z 即可显示或隐藏对应的列，最后按回车键确定。
按 o 键可以改变列的显示顺序。按小写的 a-z 可以将相应的列向右移动，而大写的 A-Z 可以将相应的列向左移动。最后按回车键确定。
按大写的 F 或 O 键，然后按 a-z 可以将进程按照相应的列进行排序。而大写的 R 键可以将当前的排序倒转。

各列含义如下：
序号 列名 含义
a PID 进程id
b PPID 父进程id
c RUSER Real user name
d UID 进程所有者的用户id
e USER 进程所有者的用户名
f GROUP 进程所有者的组名
g TTY 启动进程的终端名。不是从终端启动的进程则显示为 ?
h PR 优先级
i NI nice值。负值表示高优先级，正值表示低优先级
j P 最后使用的CPU，仅在多CPU环境下有意义
k %CPU 上次更新到现在的CPU时间占用百分比
l TIME 进程使用的CPU时间总计，单位秒
m TIME+ 进程使用的CPU时间总计，单位1/100秒
n %MEM 进程使用的物理内存百分比
o VIRT 进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
p SWAP 进程使用的虚拟内存中，被换出的大小，单位kb。
q RES 进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
r CODE 可执行代码占用的物理内存大小，单位kb
s DATA 可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
t SHR 共享内存大小，单位kb
u nFLT 页面错误次数
v nDRT 最后一次写入到现在，被修改过的页面数。
w S 进程状态。（D=不可中断的睡眠状态，R=运行，S=睡眠，T=跟踪/停止，Z=僵尸进程）
x COMMAND 命令名/命令行
y WCHAN 若该进程在睡眠，则显示睡眠中的系统函数名
z Flags 任务标志，参考 sched.h

	[root@localhost daocoder]# top		按下1可查看各cpu状态
	top - 20:01:37 up 1 day,  7:57,  3 users,  load average: 0.00, 0.01, 0.05
	Tasks: 389 total,   2 running, 387 sleeping,   0 stopped,   0 zombie
	%Cpu0  :  0.0 us,  0.0 sy,  0.0 ni, 99.7 id,  0.3 wa,  0.0 hi,  0.0 si,  0.0 st
	%Cpu1  :  0.3 us,  0.3 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	%Cpu2  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	%Cpu3  :  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
	KiB Mem:   1870784 total,  1270960 used,   599824 free,     5664 buffers
	KiB Swap:  2097148 total,       88 used,  2097060 free.   845052 cached Mem


## 1.4 进程控制命令 kill

	[root@localhost ~]# kill -l				查看进程信号量
	 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
	 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
	11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
	16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
	21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
	26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
	31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
	38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
	43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
	48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
	53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
	58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
	63) SIGRTMAX-1	64) SIGRTMAX	

需掌握：1、sigup：对进程重运行；9、sigkill：强制停止进程；15、sigterm：不管进程、任其发展。

两种方法进行 kill 发射信号量：1、kill pid 2、killall pro_name

	[root@localhost ~]# ps aux | grep sleep
	root      91512  0.0  0.0 107892   620 pts/0    S+   10:24   0:00 sleep 500
	root      91520  0.0  0.0 107892   620 ?        S    10:24   0:00 sleep 60
	root      91936  0.0  0.0 112656   988 pts/1    S+   10:25   0:00 grep --color=auto slee
	
	[root@localhost ~]# kill 91512
	
	[root@localhost ~]# ps aux | grep sleep
	root      91944  0.0  0.0 107892   620 ?        S    10:25   0:00 sleep 60
	root      91947  0.0  0.0 112656   992 pts/1    S+   10:26   0:00 grep --color=auto slee
	
	[root@localhost ~]# sleep 500
	已终止


# 2、进程的前后端切换

	[root@localhost ~]# sleep 500				创建一个前台进程，它会抢占你的前台控制权
	按下[ctrl+c]终止进程

	[root@localhost ~]# sleep 500 &				创建一个后台进程
	[1] 92562

	[root@localhost ~]# jobs					查看后台进程
	[1]+  运行中               sleep 500 &

	[root@localhost ~]# sleep 800
	按下[ctrl+z]暂停前台进程并将它放在后台去
	[2]+  已停止               sleep 800

	[root@localhost ~]# jobs					再查看后台进程
	[1]-  运行中               sleep 500 &
	[2]+  已停止               sleep 800

	[root@localhost ~]# fg %1					后台变前台进程
	sleep 500
	按下[ctrl+z]暂停前台进程并将它放在后台去
	[1]+  已停止               sleep 500

	[root@localhost ~]# bg %1 %2				将后台进程启动
	[1]+ sleep 500 &
	[2]+ sleep 800 &

	[root@localhost ~]# kill %1 				终止一个后台进程
	[1]-  已终止               sleep 500

	[root@localhost ~]# ps aux | grep sleep		查看下sleep的pid
	root      92580  0.0  0.0 107892   624 pts/0    S    10:31   0:00 sleep 800
	root      92645  0.0  0.0 107892   624 ?        S    10:35   0:00 sleep 60
	root      92647  0.0  0.0 112656   992 pts/0    S+   10:35   0:00 grep --color=auto slee

	[root@localhost ~]# kill 92580				终止一个进程
	[2]+  已终止               sleep 800

# 3、计划任务

计划性任务若想使用，要保证他们的进程在运行。

命令端执行查看一次性计划任务状态命令：

	/etc/init.d/atd status

命令端执行查看重复性计划任务状态命令：

	/etc/init.d/crond status

## 3.1 一次性计划任务

	[root@localhost daocoder]# ls			看下目标文件夹下的文件
	ad.txt  log         nmap-7.30          php-7.0.11.tar.gz  Python-2.7.12.tgz
	ip.txt  lost+found  nmap-7.30.tar.bz2  Python-2.7.12      test
	
	[root@localhost daocoder]# at 11:30		一次性任务：建个文件
	at> touch test.txt
	at> <EOT>								按下[ctrl+d]结束	
	job 4 at Wed Oct 19 11:30:00 2016
	
	[root@localhost daocoder]# at -l		看下一次性任务列表
	4	Wed Oct 19 11:30:00 2016 a root
	
	[root@localhost daocoder]# at -c 4		看下它的详细内容	
	这里有很多环境变量被我删除了。
	touch test.txt

	[root@localhost daocoder]# at -c 4		看下它的详细内容

	[root@localhost daocoder]# ls			有了这个文件
	test.txt

	[root@localhost daocoder]# at 11:40		再新建个一次性计划任务
	at> touch test
	at> <EOT>
	job 5 at Wed Oct 19 11:40:00 2016
	[root@localhost daocoder]# at -l		看下列表
	5	Wed Oct 19 11:40:00 2016 a root
	[root@localhost daocoder]# at -d 5		删除上面那个任务
	[root@localhost daocoder]# at -l		再看下列表，没了

## 3.2 重复性计划任务

	The time and date fields are:

              field          allowed values
              -----          --------------
              minute         0-59
              hour           0-23
              day of month   1-31
              month          1-12 (or names, see below)
              day of week    0-7 (0 or 7 is Sunday, or use names)

	A field may contain an asterisk (*), which always stands for "first-last".

命令：[root@localhost daocoder]# crontab -e

	* * * * * 分别指 分 时 日 月 周 。
	# run five minutes after midnight, every day
	5 0 * * *       $HOME/bin/daily.job >> $HOME/tmp/out 2>&1		
	# run at 2:15pm on the first of every month -- output mailed to paul
	15 14 1 * *     $HOME/bin/monthly
	# run at 10 pm on weekdays, annoy Joe
	0 22 * * 1-5    mail -s "It's 10pm" joe%Joe,%%Where are your kids?%
	23 0-23/2 * * * echo "run 23 minutes after midn, 2am, 4am ..., everyday"

例子（不执行了）：

	00 03 * * * + 命令　　　　　	//每天凌晨3点去干啥。
	00 9,12,22 * * * + 命令		 //每天9、12、22、点去干啥。
	00 9-12 * * * + 命令			 //每天9-12点去干哈。
	*/5 * * * *					   //每5分钟干啥

其他脚本式计划性任务待补充。



	
	



























