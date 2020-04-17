# My own CTF library

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