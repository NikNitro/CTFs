# -*- coding: utf-8 -*-
"""
This script is for a CTF in HTB named "Emdee five for life",
in which we must to read a string, and send its md5 quickly.
"""
from urllib import request, parse
import hashlib
from bs4 import BeautifulSoup

TARGET = "http://docker.hackthebox.eu:31983/"

req = request.Request(TARGET)
resp = request.urlopen(req)
soup = BeautifulSoup(resp.read(), 'html.parser')
plaintext = soup.h3.contents[0]
cookie = resp.getheader('Set-Cookie')

md5text = hashlib.md5(plaintext.encode('utf-8')).hexdigest()

data = parse.urlencode({'hash': md5text}).encode()
headers = {'Cookie': cookie}
req = request.Request(TARGET, data=data, headers=headers)
resp = request.urlopen(req)
soup = BeautifulSoup(resp.read(), 'html.parser')



print("Respuesta:")
print("plaintext", plaintext)
print("md5sum text", md5text)
print(soup)


