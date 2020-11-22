# Scripting room

## First task

Create an script for decoding 50 times a base64 code.

    import base64 as b

    f = open("b64.txt")
    text = f.read()

    for i in range(50):
        text = b.b64decode(text)

    print(text)

## Second task
You need to write a script that connects to this webserver on the correct port, do an operation on a number and then move onto the next port. Start your original number at 0.

The format is: operation, number, next port.

For example the website might display, add 900 3212 which would be: add 900 and move onto port 3212.

Then if it was minus 212 3499, you'd minus 212 (from the previous number which was 900) and move onto the next port 3499

Do this until you the page response is STOP (or you hit port 9765).

Each port is also only live for 4 seconds. After that it goes to the next port. You might have to wait until port 1337 becomes live again...

Go to: http://<machines_ip>:3010 to start...

General Approach(it's best to do this using the sockets library in Python):

* Create a socket in Python using the sockets library
* Connect to the port 
* Send an operation
* View response and continue

Here we have the script solution: 
    import socket
    import time
    
    # Testing with:
    # echo "add 500 80" | nc -nlvp 1337
    
    result = 0.0
    result = 180374.0
    IP='10.10.199.238'
    #IP='127.0.0.1'
    port=1337
    port = 6632
    response = ''
    
    def calculate(op, value, result):
        if op == 'add':
            return result + value
        if op == 'minus':
            return result - value
        if op == 'multiply':
            return result * value
        if op == 'divide':
            return result / value
    
    while 'STOP' not in response and port != 9765:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            print((IP, port))
            s.connect((IP, port))
            s.sendall(b'GET / HTTP/1.1\r\n\r\n')
            response = s.recv(4096).split(' ')
            # Example:
            # ('response: ', ['HTTP/1.0', '200', 'OK\r\nContent-Type:', 'text/html;', 'charset=utf-8\r\nContent-Length:', '13\r\nServer:', 'Werkzeug/0.14.1', 'Python/3.5.2\r\nDate:', 'Sun,', '22', 'Nov', '2020', '11:55:32', 'GMT\r\n\r\nadd', '900', '23456'])
            # print("response: ", response)
            op = response[13].split('\n')[2]
            value = float(response[14])
            port = int(response[15])
            print(op, value, port)
            result = calculate(op, value, result)
            print("new result: ", result)
        except:
            print("fallo")
            pass
        finally:
            s.close
        
        time.sleep(4)

Result:

    ('add', '900', 23456)
    ('minus', '2', 8888)
    ('multiply', '4', 9823)[]
    ('divide', '2', 9887)
    ('add', '456', 7823)
    ('minus', '43', 10456)
    ('divide', '0.5', 10457)
    ('add', '877', 40000)
    ('add', '9', 40200)
    ('multiply', '34', 8743)
    ('minus', '5', 63890)
    ('divide', '1', 38721)
    ('add', '43', 6632)
    ('minus', '22', 29932)
    ('add', 900.0, 23456)
    ('new result: ', 900.0)
    ('minus', 2.0, 8888)
    ('new result: ', 898.0)
    ('multiply', 4.0, 9823)
    ('new result: ', 3592.0)
    ('divide', 2.0, 9887)
    ('new result: ', 1796.0)
    ('add', 456.0, 7823)
    ('new result: ', 2252.0)
    ('minus', 43.0, 10456)
    ('new result: ', 2209.0)
    ('divide', 0.5, 10457)
    ('new result: ', 4418.0)
    ('add', 877.0, 40000)
    ('new result: ', 5295.0)
    ('add', 9.0, 40200)
    ('new result: ', 5304.0)
    ('multiply', 34.0, 8743)
    ('new result: ', 180336.0)
    ('minus', 5.0, 63890)
    ('new result: ', 180331.0)
    ('divide', 1.0, 38721)
    ('new result: ', 180331.0)
    ('add', 43.0, 6632)
    ('new result: ', 180374.0)
    ('minus', 22.0, 29932)
    ('new result: ', 180352.0)
    ('divide', 3.0, 29132)
    ('new result: ', 60117.333333333336)
    ('multiply', 9.0, 8773)
    ('new result: ', 541056.0)
    ('minus', 1200.0, 1338)
    ('new result: ', 539856.0)
    ('add', 12.0, 1876)
    ('new result: ', 539868.0)
    ('divide', 1.0, 34232)
    ('new result: ', 539868.0)
    ('multiply', 1.0, 6783)
    ('new result: ', 539868.0)
    ('add', -100.0, 4040)
    ('new result: ', 539768.0)
    ('multiply', -2.0, 5050)
    ('new result: ', -1079536.0)
    ('add', 300.0, 9898)
    ('new result: ', -1079236.0)
    ('divide', 10.0, 3232)
    ('new result: ', -107923.6)
    ('minus', 10.0, 10321)
    ('new result: ', -107933.6)
    ('add', 130.0, 7709)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('multiply', xxx, 9872)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('multiply', -12.0, 32424)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('divide', 3.0, 65513)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('minus', 1000.0, 3459)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('add', 23.0, 7832)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('divide', xxx, 1111)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('minus', xxx, 2222)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)
    ('add', xxx, 9765)
    ('new result: ', xxxxxxxxxxxxxxxxxxx)

## Third task
The VM you have to connect to has a UDP server running on port 4000. Once connected to this UDP server, send a UDP message with the payload "hello" to receive more information. You will find some sort of encryption(using the AES-GCM cipher). Using the information from the server, write a script to retrieve the flag. Here are some useful thingsto keep in mind:

    sending and receiving data over a network is done in bytes
    the PyCA encryption library and functions takes its inputs as bytes
    AES GCM sends both encrypted plaintext and tag, and the server sends these values sequentially in the form of the encrypted plaintext followed by the tag

This machine may take up to 5 minutes to configure once deployed. Please be patient. 

Use this general approach(use Python3 here as well):

    Use the Python sockets library to create a UDP socket and send the aforementioned packets to the server
    use the PyCA encyption library and follow the instructions from the server

So, the code is:

    import socket
    
    IP = '10.10.41.22'
    PORT = 4000
    
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    finded = False
    
    while not finded:
        msg = b"hello"
        s.sendto(msg, (IP, PORT))
        instructions = s.recvfrom(4000)
        print(instructions)
        # You've connected to the super secret server, send a packet with the payload ready to receive more information
        
        msg = b"ready"
        s.sendto(msg, (IP, PORT))
        cipher_params = s.recvfrom(4000)
        print(cipher_params)
        # "key:thisisaverysecretkeyl337 iv:secureivl337 to decrypt and find the flag that has a SHA256 checksum of ]w\xf0\x18\xd2\xbfwx`T\x86U\xd8Ms\x82\xdc'\xd6\xce\x81n\xdeh\xf6]rb\x14c\xd9\xda send final in the next payload to receive all the encrypted flags
        ## key:thisisaverysecretkeyl337
        ## iv:secureivl337
        ## to decrypt and find the flag that has a SHA256 checksum of
        ## ]w\xf0\x18\xd2\xbfwx`T\x86U\xd8Ms\x82\xdc'\xd6\xce\x81n\xdeh\xf6]rb\x14c\xd9\xda
        ## send final in the next payload to receive all the encrypted flags
        
        msg = b"final"
        s.sendto(msg, (IP, PORT))
        encodedmessage = s.recv(2048)
        print(encodedmessage)
        # h\t:\xe9\xb0\x81\xba\xaaf+,\xcc\x1d
        
        s.sendto(msg, (IP, PORT))
        flags = s.recv(2048)
        print(flags)
        # b'\xc0\x99\x8a\xa8\x8b.\x87\xcdB\n\x8b\x0bq]7\xc3'
        
        
        ###### Now, we go to the second part of the exercise:
        from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
        from cryptography.hazmat.backends import default_backend
        import hashlib
        
        key = b'thisisaverysecretkeyl337'
        iv  = b'secureivl337'
        checksum = b"]w\xf0\x18\xd2\xbfwx`T\x86U\xd8Ms\x82\xdc'\xd6\xce\x81n\xdeh\xf6]rb\x14c\xd9\xda"
        backend = default_backend()
        
        cipher = Cipher(algorithms.AES(key), modes.GCM(iv, flags), backend)
        decryptor = cipher.decryptor()
        decoded = decryptor.update(encodedmessage) + decryptor.finalize()
        print(decoded)
        # THM{AME7IKSG}
        
        flag_hash = hashlib.sha256(decoded).digest()
        if flag_hash == checksum:
            print("FLAG IS: {}".format(decoded))
            finded = True
