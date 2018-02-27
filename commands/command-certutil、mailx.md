<div class="BlogAnchor">
   <p>
   <b id="AnchorContentToggle" title="收起" style="cursor:pointer;">目录[+]</b>
   </p>
   
  <div class="AnchorContent" id="AnchorContent"> </div>
</div>


# linux命令之certutil

## 1、certutil命令简介

certutil 是 Mozzila 基金会  发布用于管理  Netscape Communicator  与  格式的安全数据库文件的命令行工具，用于列出，生成，修改和删除  证书和更改证书密码，生成新的公共和私有密钥对。显示密钥证书内容，或删除 里的密钥对。参见[《使用安全模型数据库工具》（英文）](http://www.mozilla.org/projects/security/pki/nss/tools/modutil.html)，以获得更多关于安全模型数据库的信息，这里主要简单的介绍一下Certutil 工具的使用方法。

## 1.1 语法

	所有命令可参见系统自带帮助，通俗易懂。

	certutil(选项)(参数)

	[root@localhost lftshell]# certutil -H
	-A              Add a certificate to the database        (create if needed)
	   All options under -E apply
	-B              Run a series of certutil commands from a batch file
	   -i batch-file     Specify the batch file
	-E              Add an Email certificate to the database (create if needed)
	   -n cert-name      Specify the nickname of the certificate to add
	   -t trustargs      Set the certificate trust attributes:
	                          trustargs is of the form x,y,z where x is for SSL, y is for S/MIME,
	                          and z is for code signing. Use ,, for no explicit trust.
	                          p 	 prohibited (explicitly distrusted)
	                          P 	 trusted peer
	                          c 	 valid CA
	                          T 	 trusted CA to issue client certs (implies c)
	                          C 	 trusted CA to issue server certs (implies c)
	                          u 	 user cert
	                          w 	 send warning
	                          g 	 make step-up cert
	   -f pwfile         Specify the password file
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -a                The input certificate is encoded in ASCII (RFC1113)
	   -i input          Specify the certificate file (default is stdin)
	
	-C              Create a new binary certificate from a BINARY cert request
	   -c issuer-name    The nickname of the issuer cert
	   -i cert-request   The BINARY certificate request file
	   -o output-cert    Output binary cert to this file (default is stdout)
	   -x                Self sign
	   -m serial-number  Cert serial number
	   -w warp-months    Time Warp
	   -v months-valid   Months valid (default is 3)
	   -f pwfile         Specify the password file
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -1 | --keyUsage keyword,keyword,... 
	                     Create key usage extension. Possible keywords:
	                     "digitalSignature", "nonRepudiation", "keyEncipherment",
	                     "dataEncipherment", "keyAgreement", "certSigning",
	                     "crlSigning", "critical"
	   -2                Create basic constraint extension
	   -3                Create authority key ID extension
	   -4                Create crl distribution point extension
	   -5 | --nsCertType keyword,keyword,...  
	                     Create netscape cert type extension. Possible keywords:
	                     "sslClient", "sslServer", "smime", "objectSigning",
	                     "sslCA", "smimeCA", "objectSigningCA", "critical".
	   -6 | --extKeyUsage keyword,keyword,... 
	                     Create extended key usage extension. Possible keywords:
	                     "serverAuth", "clientAuth","codeSigning",
	                     "emailProtection", "timeStamp","ocspResponder",
	                     "stepUp", "msTrustListSign", "critical"
	   -7 emailAddrs     Create an email subject alt name extension
	   -8 dnsNames       Create an dns subject alt name extension
	   -a                The input certificate request is encoded in ASCII (RFC1113)
	
	-G              Generate a new key pair
	   -h token-name     Name of token in which to generate key (default is internal)
	   -k key-type       Type of key pair to generate ("dsa", "ec", "rsa" (default))
	   -g key-size       Key size in bits, (min 512, max 8192, default 1024) (not for ec)
	   -y exp            Set the public exponent value (3, 17, 65537) (rsa only)
	   -f password-file  Specify the password file
	   -z noisefile      Specify the noise file to be used
	   -q pqgfile        read PQG value from pqgfile (dsa only)
	   -q curve-name     Elliptic curve name (ec only)
	                     One of nistp256, nistp384, nistp521
	                     sect163k1, nistk163, sect163r1, sect163r2,
	                     nistb163, sect193r1, sect193r2, sect233k1, nistk233,
	                     sect233r1, nistb233, sect239k1, sect283k1, nistk283,
	                     sect283r1, nistb283, sect409k1, nistk409, sect409r1,
	                     nistb409, sect571k1, nistk571, sect571r1, nistb571,
	                     secp160k1, secp160r1, secp160r2, secp192k1, secp192r1,
	                     nistp192, secp224k1, secp224r1, nistp224, secp256k1,
	                     secp256r1, secp384r1, secp521r1,
	                     prime192v1, prime192v2, prime192v3, 
	                     prime239v1, prime239v2, prime239v3, c2pnb163v1, 
	                     c2pnb163v2, c2pnb163v3, c2pnb176v1, c2tnb191v1, 
	                     c2tnb191v2, c2tnb191v3,  
	                     c2pnb208w1, c2tnb239v1, c2tnb239v2, c2tnb239v3, 
	                     c2pnb272w1, c2pnb304w1, 
	                     c2tnb359w1, c2pnb368w1, c2tnb431r1, secp112r1, 
	                     secp112r2, secp128r1, secp128r2, sect113r1, sect113r2
	                     sect131r1, sect131r2
	   -d keydir         Key database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   --keyAttrFlags attrflags
	                     PKCS #11 key Attributes.
	                     Comma separated list of key attribute attribute flags,
	                     selected from the following list of choices:
	                     {token | session} {public | private} {sensitive | insensitive}
	                     {modifiable | unmodifiable} {extractable | unextractable}
	   --keyOpFlagsOn opflags
	   --keyOpFlagsOff opflags
	                     PKCS #11 key Operation Flags.
	                     Comma separated list of one or more of the following:
	                     encrypt, decrypt, sign, sign_recover, verify,
	                     verify_recover, wrap, unwrap, derive
	
	-D              Delete a certificate from the database
	   -n cert-name      The nickname of the cert to delete
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	
	-F              Delete a key from the database
	   -n cert-name      The nickname of the key to delete
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	
	-U              List all modules
	   -d moddir         Module database directory (default is '~/.netscape')
	   -P dbprefix       Cert & Key database prefix
	   -X                force the database to open R/W
	
	-K              List all private keys
	   -h token-name     Name of token to search ("all" for all tokens)
	   -k key-type       Key type ("all" (default), "dsa", "ec", "rsa")
	   -n name           The nickname of the key or associated certificate
	   -f password-file  Specify the password file
	   -d keydir         Key database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -X                force the database to open R/W
	
	-L              List all certs, or print out a single named cert (or a subset)
	   -n cert-name      Pretty print named cert (list all if unspecified)
	   --email email-address 
	                     Pretty print cert with email address (list all if unspecified)
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -X                force the database to open R/W
	   -r                For single cert, print binary DER encoding
	   -a                For single cert, print ASCII encoding (RFC1113)
	   --dump-ext-val OID 
	                     For single cert, print binary DER encoding of extension OID
	
	-M              Modify trust attributes of certificate
	   -n cert-name      The nickname of the cert to modify
	   -t trustargs      Set the certificate trust attributes (see -A above)
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	
	-N              Create a new certificate database
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   --empty-password  use empty password when creating a new database
	
	-T              Reset the Key database or token
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -h token-name     Token to reset (default is internal)
	   -0 SSO-password   Set token's Site Security Officer password
	
	-O              Print the chain of a certificate
	   -n cert-name      The nickname of the cert to modify
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -a                Input the certificate in ASCII (RFC1113); default is binary
	   -P dbprefix       Cert & Key database prefix
	   -X                force the database to open R/W
	
	-R              Generate a certificate request (stdout)
	   -s subject        Specify the subject name (using RFC1485)
	   -o output-req     Output the cert request to this file
	   -k key-type-or-id Type of key pair to generate ("dsa", "ec", "rsa" (default))
	                     or nickname of the cert key to use 
	   -h token-name     Name of token in which to generate key (default is internal)
	   -g key-size       Key size in bits, RSA keys only (min 512, max 8192, default 1024)
	   -q pqgfile        Name of file containing PQG parameters (dsa only)
	   -q curve-name     Elliptic curve name (ec only)
	                     See the "-G" option for a full list of supported names.
	   -f pwfile         Specify the password file
	   -d keydir         Key database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -p phone          Specify the contact phone number ("123-456-7890")
	   -a                Output the cert request in ASCII (RFC1113); default is binary
	   See -S for available extension options 
	   See -G for available key flag options 
	
	-V              Validate a certificate
	   -n cert-name      The nickname of the cert to Validate
	   -b time           validity time ("YYMMDDHHMMSS[+HHMM|-HHMM|Z]")
	   -e                Check certificate signature 
	   -u certusage      Specify certificate usage:
	                          C 	 SSL Client
	                          V 	 SSL Server
	                          L 	 SSL CA
	                          A 	 Any CA
	                          Y 	 Verify CA
	                          S 	 Email signer
	                          R 	 Email Recipient
	                          O 	 OCSP status responder
	                          J 	 Object signer
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -a                Input the certificate in ASCII (RFC1113); default is binary
	   -P dbprefix       Cert & Key database prefix
	   -X                force the database to open R/W
	
	-W              Change the key database password
	   -d certdir        cert and key database directory
	   -f pwfile         Specify a file with the current password
	   -@ newpwfile      Specify a file with the new password in two lines
	
	--upgrade-merge Upgrade an old database and merge it into a new one
	   -d certdir        Cert database directory to merge into (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix of the target database
	   -f pwfile         Specify the password file for the target database
	   --source-dir certdir 
	                     Cert database directory to upgrade from
	   --source-prefix dbprefix 
	                     Cert & Key database prefix of the upgrade database
	   --upgrade-id uniqueID 
	                     Unique identifier for the upgrade database
	   --upgrade-token-name name 
	                     Name of the token while it is in upgrade state
	   -@ pwfile         Specify the password file for the upgrade database
	
	--merge         Merge source database into the target database
	   -d certdir        Cert database directory of target (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix of the target database
	   -f pwfile         Specify the password file for the target database
	   --source-dir certdir 
	                     Cert database directory of the source database
	   --source-prefix dbprefix 
	                     Cert & Key database prefix of the source database
	   -@ pwfile         Specify the password file for the source database
	
	-S              Make a certificate and add to database
	   -n key-name       Specify the nickname of the cert
	   -s subject        Specify the subject name (using RFC1485)
	   -c issuer-name    The nickname of the issuer cert
	   -t trustargs      Set the certificate trust attributes (see -A above)
	   -k key-type-or-id Type of key pair to generate ("dsa", "ec", "rsa" (default))
	   -h token-name     Name of token in which to generate key (default is internal)
	   -g key-size       Key size in bits, RSA keys only (min 512, max 8192, default 1024)
	   -q pqgfile        Name of file containing PQG parameters (dsa only)
	   -q curve-name     Elliptic curve name (ec only)
	                     See the "-G" option for a full list of supported names.
	   -x                Self sign
	   -m serial-number  Cert serial number
	   -w warp-months    Time Warp
	   -v months-valid   Months valid (default is 3)
	   -f pwfile         Specify the password file
	   -d certdir        Cert database directory (default is ~/.netscape)
	   -P dbprefix       Cert & Key database prefix
	   -p phone          Specify the contact phone number ("123-456-7890")
	   -1                Create key usage extension
	   -2                Create basic constraint extension
	   -3                Create authority key ID extension
	   -4                Create crl distribution point extension
	   -5                Create netscape cert type extension
	   -6                Create extended key usage extension
	   -7 emailAddrs     Create an email subject alt name extension
	   -8 DNS-names      Create a DNS subject alt name extension
	   --extAIA          Create an Authority Information Access extension
	   --extSIA          Create a Subject Information Access extension
	   --extCP           Create a Certificate Policies extension
	   --extPM           Create a Policy Mappings extension
	   --extPC           Create a Policy Constraints extension
	   --extIA           Create an Inhibit Any Policy extension
	   --extSKID         Create a subject key ID extension
	   See -G for available key flag options 
	   --extNC           Create a name constraints extension
	   --extSAN type:name[,type:name]... 
	                     Create a Subject Alt Name extension with one or multiple names
	                     - type: directory, dn, dns, edi, ediparty, email, ip, ipaddr,
	                             other, registerid, rfc822, uri, x400, x400addr
	   --extGeneric OID:critical-flag:filename[,OID:critical-flag:filename]... 
	                     Add one or multiple extensions that certutil cannot encode yet,
	                     by loading their encodings from external files.
	                     - OID (example): 1.2.3.4
	                     - critical-flag: critical or not-critical
	                     - filename: full path to a file containing an encoded extension


## 1.2 部分使用

### 1.2.1 生成新的安全数据库

在指定的目录certdir里生成新的安全数据库文件，如果要生成 key3.db 文件，你需要用到“密钥数据工具”或其他指定的工具：

	certutil -N -d certdir

### 1.2.2 列出安全数据库中的证书

列出指定的目录certdir>中 cert8.db 文件里的所有证书：

	certutil -L -d certdir

### 1.2.3 创建证书

一个有效的证书必须是受信任的根CA颁发的，如果一个CA密钥对无效，你可以用参数 -x 创建一个自签名证书（目的是为了颁发）。本例在指定的目录 certdir 中创建一个名为 myissuer 的自签名证书：

	certutil -S -s "CN=My Issuer" -n myissuer -x -t "C,C,C" -1 -2 -5 -m 1234 -f password-file -d certdir

### 1.2.4 添加证书到数据库中

添加一个证书到证书数据库中：

	certutil -A -n jsmith@netscape.com -t "p,p,p" -i mycert.crt -d certdir


## 1.3 配置mailx的实例使用

1、编辑mail的配置文件

	[root@localhost ~]# vim /etc/mail.rc
	set from=spendemail@qq.com										# 发送邮件后显示的邮件发送方
	set smtp=smtp.qq.com											# qq smtp邮件服务器
	set smtp-auth-user=youremail@qq.com								# 你的qq邮箱
	set smtp-auth-password=yourpass									# 你的qq邮箱密码（设置页面加密后的授权码）
	set smtp-auth=login												# 动作、登录
	set smtp-use-starttls											# 安全连接传输
	set ssl-verify=ignore											# 忽略ssl验证
	set nss-config-dir=/root/.certs									# 证书路径

2、添加邮箱证书到本地

	# 创建证书目录
	[root@localhost ~]# mkdir -p /root/.certs/
	# 获取证书内容（可分开执行查看过程）						
	[root@localhost ~]# echo -n | openssl s_client -connect smtp.qq.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/qq.crt
	# 添加证书到数据库
	[root@localhost ~]# certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
	[root@localhost ~]# certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
	# 列出指定目录下的证书
	[root@localhost ~]# certutil -L -d /root/.certs
	# 指明受新人证书、防报错
	[root@localhost ~]# certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ~/.certs -i ~/.certs/qq.crt