# BlackJocker - 8123

First of all we can see a website of salt haters. Inside it we found 3 websites:  
	→ /hint  
	→ /admin  
	→ /sign-up  

In /admin, we have a basic http auth. Hydra cannot fight with it. Don't try it  

In sign-up we can find the password policy (in the source code, inside a js):  
```
	let submit_btn = document.getElementById('signUpSubmit');  
	let pwd = document.getElementById('passwordInput');  
	let div = document.getElementById('resultDiv');  

	var valid_pwd_regex = /^[a-z0-9]+$/;  

	submit_btn.addEventListener('click', function(){  
	if (pwd.value.match(valid_pwd_regex) && pwd.value.length <= 14 && pwd.value.length >= 9) {  
	div.innerHTML = "That password is valid!\nWe're not taking new members at the moment, but we'll get back to you.";  
	} else {  
	div.innerHTML = "Invalid password!";  
	}  
	});  
```
So, our passwords must comply "a-z0-9" characters, and a length between 9 and 14\. INTERESTING.  

In our main page, we have a possible valid mail: admin@example.com.  

Let's go to the /hint page.  

Here, if we give a valid email, it return us a password hint.  
Let's try with our admin email:  
![images\4-1.png](images\4-1.png)

ihatesalt. 9 chars. No, it doesn't work, but we are close.  

Opening burp for seeing this request, we can see the next in our response:  

![images\4-2.png](images\4-2.png)

So, we have now two ways:  
- Trying to send the id in order to find more users, and a weaker password.  
- Crack the hash.  

The first way fails, so let's crack the hash:  

Crackstation, hashcrack and others websites fails, but they don't have the first 9 characters.  
With crunch, I've created a password dictionary with all posibilities of the password policy, begining with our “ihatesalt”. You can use your own script or crunch:  
![images\4-3.png](images\4-3.png) 

We have a dict of more than 62 millions words. It's insane for hydra, but perfect for hashcat.  
Saving the hash in a file called “8123.hash”, we run hydra and:  
![images\4-4.png](images\4-4.png) 

It's all. Now go to the /admin page with your credentials to get the flag :)  

![images\4-5.png](images\4-5.png)