# Hacker101 CTF Writeup

## Encrypted Pastebin

### Flag 1
This flag appears above any error (see below). 
### Flag 2
Studying the URL errors when editing the parameter (usually removing some characters) we get 3 different errors:
```
Traceback (most recent call last):
  File "./main.py", line 69, in index
    post = json.loads(decryptLink(postCt).decode('utf8'))
  File "./common.py", line 46, in decryptLink
    data = b64d(data)
  File "./common.py", line 11, in <lambda>
    b64d = lambda x: base64.decodestring(x.replace('~', '=').replace('!', '/').replace('-', '+'))
  File "/usr/local/lib/python2.7/base64.py", line 328, in decodestring
    return binascii.a2b_base64(s)
Error: Incorrect padding
```
```
Traceback (most recent call last):
  File "./main.py", line 69, in index
    post = json.loads(decryptLink(postCt).decode('utf8'))
  File "./common.py", line 48, in decryptLink
    cipher = AES.new(staticKey, AES.MODE_CBC, iv)
  File "/usr/local/lib/python2.7/site-packages/Crypto/Cipher/AES.py", line 95, in new
    return AESCipher(key, *args, **kwargs)
  File "/usr/local/lib/python2.7/site-packages/Crypto/Cipher/AES.py", line 59, in __init__
    blockalgo.BlockAlgo.__init__(self, _AES, key, *args, **kwargs)
  File "/usr/local/lib/python2.7/site-packages/Crypto/Cipher/blockalgo.py", line 141, in __init__
    self._cipher = factory.new(key, *args, **kwargs)
ValueError: IV must be 16 bytes long
```
```
Traceback (most recent call last):
  File "./main.py", line 69, in index
    post = json.loads(decryptLink(postCt).decode('utf8'))
  File "./common.py", line 49, in decryptLink
    return unpad(cipher.decrypt(data))
  File "/usr/local/lib/python2.7/site-packages/Crypto/Cipher/blockalgo.py", line 295, in decrypt
    return self._cipher.decrypt(ciphertext)
ValueError: Input strings must be a multiple of 16 in length
```

From this, we can suposse that the URL parameter is a base64 code with some replaces, so we can get the original and test that it also works as a parameter.

Now, we have any plain and ciphertext as we want, but no key nor IV (from the second error we can see it's a AES CBC) so we could try with a Padding Oracle attack.
I'll test with this script:
https://github.com/AonCyberLabs/PadBuster

## Petshop Pro


Hints for "Petshop Pro"
Flag0 -- Found

    Something looks out of place with checkout
    It's always nice to get free stuff

Flag1 -- Found

    There must be a way to administer the app
    Tools may help you find the entrypoint
    Tools are also great for finding credentials

Flag2 -- Not Found
You don't have any hints for this flag yet. 

###Flag 0
This first flag can be found editing the POST request in /checkout for getting free the articles, setting their price as 0.
###Flag 1
After a little research, as we have the /cart page, we've tryed with the /login page succesfully.
Using Hydra, we've attacked first the user, and then the password, gaining access to the Admin panel, and also to our second flag.
Those are not easy credentials for handy work, but we can find them in some usual dictionaries ;)

###Flag2

###Other things

We can find some XSS bugs into the name and description fields, easily edited from the HTTP parameters or the admin panel.