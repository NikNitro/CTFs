# Information Gatering

## dirsearch

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