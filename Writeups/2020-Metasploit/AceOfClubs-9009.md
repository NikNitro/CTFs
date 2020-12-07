# AceOfClubs - 9009 

First of all, we found a ssh service listening over our port:     
![images\2-1.png](images\2-1.png)     
So let's try it:     
![images\2-2.png](images\2-2.png)     
It seems that the username is “admin”. After some tries (or releasing our Hydra) we found our credentials: username:password 
Let's hack it!
![images\2-3.png](images\2-3.png)     
Now, we must find our flag. Was that easy?? 
(Note: My partners were working on another flags, so I couldn't revert the target. Let's ignore the “2” in the owner name.)     
![images\2-4.png](images\2-4.png)     
So, we cannot read the file. Let's try to escalate privileges:     
![images\2-5.png](images\2-5.png)     
That vpn_connect seems strange. We can run it:     
![images\2-6.png](images\2-6.png)     
Interesting... We can write files as root. Maybe we have a bof. Let's try:     
![images\2-7.png](images\2-7.png)     
Mmm, it doesn't work, but let's try again with a normal run:     
![images\2-8.png](images\2-8.png)     
Wow! The new run has broken the last one, giving us a complete line for us. The first line saved had 153 chars, meanwhile the last one had 104, so if we insert 49 chars and our payload we can do nice things :) 
Let's create first our payload:     

![images\2-9.png](images\2-9.png)     
So our payload will be: 
```
root3:uJg/PTb1FPtqo:0:0:root:/root:/bin/bash 
```
And voila:     
![images\2-10.png](images\2-10.png)     
Let's run it now over the /etc/passwd file :)     
![images\2-11.png](images\2-11.png)     
And now, we can privesc with our new password     
![images\2-12.png](images\2-12.png)        