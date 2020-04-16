# Hacker101 CTF Writeup

## Encrypted Pastebin

Flag0 -- Found

    What are these encrypted links?
    Encodings like base64 often need to be modified for URLs. Thanks, HTTP
    What is stopping you from modifying the data? Not having the key is no excuse

Flag1 -- Found

    We talk about this in detail in the Hacker101 Crypto Attacks video
    Don't think about this in terms of an attack against encryption; all you care about is XOR

Flag2 -- Not Found

    Remember: XOR
    Sometimes all it takes is toggling a few bits in the right place

Flag3 -- Not Found

    You are on your own for this one. Good luck and have fun!


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


Flag0 -- Found

    Something looks out of place with checkout
    It's always nice to get free stuff

Flag1 -- Found

    There must be a way to administer the app
    Tools may help you find the entrypoint
    Tools are also great for finding credentials

Flag2 -- Found

    Always test every input
    Bugs don't always appear in a place where the data is entered


### Flag 0
This first flag can be found editing the POST request in /checkout for getting free the articles, setting their price as 0.
### Flag 1
After a little research, as we have the /cart page, we've tryed with the /login page succesfully.
Using Hydra, we've attacked first the user, and then the password, gaining access to the Admin panel, and also to our second flag.
Those are not easy credentials for handy work, but we can find them in some usual dictionaries ;)

### Flag2
Trying to XSS all the fields, we can see the flag when trying to purchase all:)

## Postbook

Flag0 -- Found

    The person with username "user" has a very easy password...

Flag1 -- Found

    Try viewing your own post and then see if you can change the ID


Flag2 -- Found

    You should definitely use "Inspect Element" on the form when creating a new post

Flag3 -- Found

    189 * 5

Flag4 -- Found

    You can edit your own posts, what about someone else's?

Flag5 -- Found

    The cookie allows you to stay signed in. Can you figure out how they work so you can sign in to user with ID 1?

Flag6 -- Found

    Deleting a post seems to take an ID that is not a number. Can you figure out what it is?

### Flag 2
Log in as a current user, and write something into "What's on your mind?" form. One of the "hidden variables" is the userid, which we can change :)

### Flag 4
When editing a post, you can also change the id post in the form.
### Flag 5
After a little research, I noticed that there are a 32-char id for each user, and it doesn't depend on the username nor the password. Trying to reload the cookie doesn't renew the id either. So the id must be calculated from the user_id, and we have two diferent options for each user:
When we post a message into the book, one of the HTTP params (as we saw in Flag 2) is a numeric id, but when we enter into "My profile", the last GET parameter is a character id. We can now create the next table:

| ID Number | ID Char  | User    | Session ID                        |
| :-------: |:--------:| :-------| :--------------------------------:|
| 1         | b        | admin   |      This_is_what_we_want         |
| 2         | c        | user    | c81e728d9d4c2f636f067f89cc14862c  |
| 3         | d        | myuser  | eccbc87e4b5ce2fe28308fd9f2a7baf3  |
| 4         | e        | user2   | a87ff679a2f3e71d9181a67b7542122c  |

After a short research, we get that all session IDs have the same lenght, so it should be a hash function. MD5 is a common function that fits with the lenght, and... Voi lá
```
kali@kali:/tmp$ echo -n 2 | md5sum 
c81e728d9d4c2f636f067f89cc14862c  -
kali@kali:/tmp$ echo -n 3 | md5sum 
eccbc87e4b5ce2fe28308fd9f2a7baf3  -
kali@kali:/tmp$ echo -n 1 | md5sum 
c4ca4238a0b923820dcc509a6f75849b  -
```

### Flag 6

The last flag is very similar to the one right before, but deleting posts instead hijacking sessions.