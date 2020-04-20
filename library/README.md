# My own CTF library

## WebApplicationAnalysis
### Wapiti

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
## Crypto

### PadBuster
For Padding Oracle Attack.

Use:
```
perl padBuster.pl http://url?post=base64 base64 blocklenght 
```

## SQLi

### blind-sqli.py

Python script created on my own, for blind SQLi attacks.

Use:
Set in-code the URL, the payload and the keyword for stopping.
TODO: Improve the script for getting the params in a usual way.
```
python3 blind-sqli
```

## PasswordCracking
### Hydra
Used for password cracking using dictionarys. It works in a lot of different enviroments.

Use:
```
kali@kali:/usr/share/wordlists$ hydra -L rockyou.txt -p password 3X.XXX.XXX.XX7 http-post-form "/51xxxxxf3/login:username=^USER^&password=^PASS^:Invalid username"
```

## Forensic

### Exiftool
For getting the metadata of a file

Use:
```
exiftool file.jpg
```
### Foremost
For getting hiding files into one given.

Use:
```
foremost file.jpg
```