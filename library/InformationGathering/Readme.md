# Information Gatering
## nmap

### normal use
> nmap -p21,22,80,111,139,445,2049 -sC -T5 -sV -O -oN nmap.out 10.10.179.78
```
# Nmap 7.60 scan initiated Mon Oct 26 20:54:44 2020 as: nmap -p21,22,80,111,139,445,2049 -sC -T5 -sV -O -oN nmap.out 10.10.179.78
Nmap scan report for ip-10-10-179-78.eu-west-1.compute.internal (10.10.179.78)
Host is up (0.00036s latency).

PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         ProFTPD 1.3.5
22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b3:ad:83:41:49:e9:5d:16:8d:3b:0f:05:7b:e2:c0:ae (RSA)
|   256 f8:27:7d:64:29:97:e6:f8:65:54:65:22:f7:c8:1d:8a (ECDSA)
|_  256 5a:06:ed:eb:b6:56:7e:4c:01:dd:ea:bc:ba:fa:33:79 (EdDSA)
80/tcp   open  http        Apache httpd 2.4.18 ((Ubuntu))
| http-robots.txt: 1 disallowed entry 
|_/admin.html
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doest have a title (text/html).
111/tcp  open  rpcbind     2-4 (RPC #100000)
| rpcinfo: 
|   program version   port/proto  service
|   100000  2,3,4        111/tcp  rpcbind
|   100000  2,3,4        111/udp  rpcbind
|   100003  2,3,4       2049/tcp  nfs
|   100003  2,3,4       2049/udp  nfs
|   100005  1,2,3      33399/tcp  mountd
|   100005  1,2,3      40921/udp  mountd
|   100021  1,3,4      41139/tcp  nlockmgr
|   100021  1,3,4      47381/udp  nlockmgr
|   100227  2,3         2049/tcp  nfs_acl
|_  100227  2,3         2049/udp  nfs_acl
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp  open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
2049/tcp open  nfs_acl     2-3 (RPC #100227)
MAC Address: 02:7A:2C:4A:87:E3 (Unknown)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose|WAP|phone|media device
Running (JUST GUESSING): Linux 3.X|4.X (99%), Asus embedded (94%), Google Android 5.X|6.X|7.X (92%)
OS CPE: cpe:/o:linux:linux_kernel:3.13 cpe:/h:asus:rt-n56u cpe:/o:linux:linux_kernel:3.4 cpe:/o:google:android:5 cpe:/o:google:android:6 cpe:/o:linux:linux_kernel:3.18 cpe:/o:linux:linux_kernel:4 cpe:/o:linux:linux_kernel:3.x
Aggressive OS guesses: Linux 3.13 (99%), ASUS RT-N56U WAP (Linux 3.4) (94%), Linux 3.16 (94%), Linux 3.1 (93%), Linux 3.2 (93%), Linux 3.8 (92%), Android 5.0 - 5.1 (92%), Android 6.0-7.1.2 (Linux 3.18-4.4.1) (92%), Linux 3.10 (92%), Linux 3.12 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: Host: KENOBI; OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Host script results:
|_nbstat: NetBIOS name: KENOBI, NetBIOS user: <unknown>, NetBIOS MAC: <unknown> (unknown)
| smb-os-discovery: 
|   OS: Windows 6.1 (Samba 4.3.11-Ubuntu)
|   Computer name: kenobi
|   NetBIOS computer name: KENOBI\x00
|   Domain name: \x00
|   FQDN: kenobi
|_  System time: 2020-10-26T15:55:01-05:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2020-10-26 20:55:01
|_  start_date: 1600-12-31 23:58:45

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
# Nmap done at Mon Oct 26 20:55:06 2020 -- 1 IP address (1 host up) scanned in 22.21 seconds
```

### Scripts

####  smb
> nmap -p445 --script=smb-enum-shares.nse,smb-enum-users.nse -oN smb.txt 10.10.179.78
```
# Nmap 7.60 scan initiated Mon Oct 26 21:20:50 2020 as: nmap -p445 --script=smb-enum-shares.nse,smb-enum-users.nse -oN smb.txt 10.10.179.78
Nmap scan report for ip-10-10-179-78.eu-west-1.compute.internal (10.10.179.78)
Host is up (0.00027s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds
MAC Address: 02:7A:2C:4A:87:E3 (Unknown)

Host script results:
| smb-enum-shares: 
|   account_used: guest
|   \\10.10.179.78\IPC$: 
|     Type: STYPE_IPC_HIDDEN
|     Comment: IPC Service (kenobi server (Samba, Ubuntu))
|     Users: 2
|     Max Users: <unlimited>
|     Path: C:\tmp
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.179.78\anonymous: 
|     Type: STYPE_DISKTREE
|     Comment: 
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\home\kenobi\share
|     Anonymous access: READ/WRITE
|     Current user access: READ/WRITE
|   \\10.10.179.78\print$: 
|     Type: STYPE_DISKTREE
|     Comment: Printer Drivers
|     Users: 0
|     Max Users: <unlimited>
|     Path: C:\var\lib\samba\printers
|     Anonymous access: <none>
|_    Current user access: <none>

# Nmap done at Mon Oct 26 21:20:51 2020 -- 1 IP address (1 host up) scanned in 1.02 seconds
```

#### nfs
> nmap -p111 --script=nfs-ls,nfs-statfs,nfs-showmount -oN nfs 10.10.179.78
```
Nmap 7.60 scan initiated Mon Oct 26 21:26:58 2020 as: nmap -p111 --script=nfs-ls,nfs-statfs,nfs-showmount -oN nfs 10.10.179.78
Nmap scan report for ip-10-10-179-78.eu-west-1.compute.internal (10.10.179.78)
Host is up (0.00020s latency).

PORT    STATE SERVICE
111/tcp open  rpcbind
| nfs-ls: Volume /var
|   access: Read Lookup NoModify NoExtend NoDelete NoExecute
| PERMISSION  UID  GID  SIZE  TIME                 FILENAME
| rwxr-xr-x   0    0    4096  2019-09-04T08:53:24  .
| rwxr-xr-x   0    0    4096  2019-09-04T12:27:33  ..
| rwxr-xr-x   0    0    4096  2019-09-04T12:09:49  backups
| rwxr-xr-x   0    0    4096  2019-09-04T10:37:44  cache
| rwxrwxrwt   0    0    4096  2019-09-04T08:43:56  crash
| rwxrwsr-x   0    50   4096  2016-04-12T20:14:23  local
| rwxrwxrwx   0    0    9     2019-09-04T08:41:33  lock
| rwxrwxr-x   0    108  4096  2019-09-04T10:37:44  log
| rwxr-xr-x   0    0    4096  2019-01-29T23:27:41  snap
| rwxr-xr-x   0    0    4096  2019-09-04T08:53:24  www
|_
| nfs-showmount: 
|_  /var *
| nfs-statfs: 
|   Filesystem  1K-blocks  Used       Available  Use%  Maxfilesize  Maxlink
|_  /var        9204224.0  1838532.0  6875096.0  22%   16.0T        32000
MAC Address: 02:7A:2C:4A:87:E3 (Unknown)

# Nmap done at Mon Oct 26 21:26:59 2020 -- 1 IP address (1 host up) scanned in 0.76 seconds
```

## Fuzzers
### dirsearch

dirsearch is another tool for dict attacs in urls. We can see it's GitHub here:
https://github.com/maurosoria/dirsearch

Let's see an example:
```
kali@kali:/usr/share$ dirsearch.py -u http://URL -e * -w wordlists/dirbuster/directory-list-lowercase-2.3-medium.txt 

  _|. _ _  _  _  _ _|_    v0.3.9                                                                                                                           
 (_||| _) (/_(_|| (_| )                                                                                                                                    
                                                                                                                                                           
Extensions: accountsservice | HTTP method: GET | Threads: 20 | Wordlist size: 622885

Error Log: /home/kali/CTFs/library/InformationGathering/dirsearch/logs/errors-20-09-18_15-14-47.log

Target: http://URL                                                                                                                                
                                                                                                                                                           
Output File: /home/kali/CTFs/library/InformationGathering/dirsearch/reports/10.10.10.191/_20-09-18_15-14-47.txt

[15:14:47] Starting: 
[15:14:49] 200 -    3KB - /about                 
[15:14:50] 403 -  277B  - /icons/                 
[15:14:51] 200 -    7KB - /0                      
[15:14:55] 301 -    0B  - /admin  ->  http://URL/admin/
[15:14:55] 200 -    2KB - /admin/            
```

-u is for the address
-e is for the file extension
-w is the wordlist to use

### Gobuster
Scan a website (-u http://192.168.0.155/) for directories using a wordlist (-w /usr/share/wordlists/dirb/common.txt) and print the full URLs of discovered paths (-e):
```
gobuster -e -u http://192.168.0.155/ -w /usr/share/wordlists/dirb/common.txt
```

    -w (wordlist)
    -t (50 threads)
    -x (Look for these extensions in the bruteforce)


```
gobuster -u http://docker.hackthebox.eu:42566/ -w /usr/share/dirbuster/directory-list-2.3-medium.txt -t 50 -x php,txt,html,htm
```

### Wfuzz
Wordlist attack for any url part, checking by http code, char, lines or words returned, etc.

-c for colour
-z for wordlist (needs the file preposition)
-hh for hiding if returns (in this case) 24 char
and finally, the URL with FUZZ in the site to testing.

```
kali@kali:/usr/share/wordlists/dirb$ wfuzz -c -z file,big.txt --hh 24 http://docker.hackthebox.eu:32328/api/action.php?FUZZ=test

Warning: Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.

********************************************************
* Wfuzz 2.4 - The Web Fuzzer                           *
********************************************************

Target: http://docker.hackthebox.eu:32328/api/action.php?FUZZ=test
Total requests: 20469

===================================================================
ID           Response   Lines    Word     Chars       Payload                                                                                                                                                                                                                                                   
===================================================================

000015356:   200        0 L      5 W      27 Ch       "reset"                                                                                                                                                                                                                                                   

Total time: 69.76943
Processed Requests: 20469
Filtered Requests: 20468
Requests/sec.: 293.3806

```