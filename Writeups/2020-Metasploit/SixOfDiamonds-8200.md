# SixOfDiamonds - 8200

At first, we can see an apache server running, so let's see what is serving.  

![images\3-1.png](images\3-1.png) 

It seems a site for uploading photos.  

![images\3-2.png](images\3-2.png) 
Let's upload a photo:  

![images\3-3.png](images\3-3.png) 

It's okay, and we can see it on  
[http://127.0.0.1:8200/images/moose.jpg](http://127.0.0.1:8200/images/moose.jpg)  

Let's try to upload a php file:  


![images\3-4.png](images\3-4.png)

Not allowed php files. Let's change its name:  

![images\3-5.png](images\3-5.png)

Mmm. Let's now to copy this php file below the head of the image, but first of all, we must to put our IP into it  


![images\3-6.png](images\3-6.png)
And  

![images\3-7.png](images\3-7.png)
 
Now it worked:  

![images\3-8.png](images\3-8.png)  

Now, opening a listener in our machine and opening the  
[http://127.0.0.1:8200/images/moose.jpg.php](http://127.0.0.1:8200/images/moose.jpg.php) file should works  

And here we are.  

!![images\3-9.png](images\3-9.png)
!  

And, doing a 
```
find / -name "*.png" 2>/dev/null
```
we find our flag:  

![images\3-10.png](images\3-10.png)
