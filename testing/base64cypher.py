#!/usr/bin/python3
import sys

"""
This code encode using base64 each one of the lines in a file.
"""
def file_encoding(filein, fileout):
  from base64 import b64encode

  f_out = open(fileout, 'w')

  with open(filein, 'r') as f_in:
    content = f_in.readlines()
  
  for line in content:
    newline = line.replace('\n', '').replace(' ', ':')
    newline = str(b64encode(str.encode(newline)))[2:-1] + "\n" # For removing the b'xxxxx' chars
    f_out.write(newline)


if __name__ == '__main__':

    if len(sys.argv) < 3:
        print('Usage: python3 base64cypher.py filename.in filename.out')
        print('Example: python3 base64cypher.py mirai_user_pass.txt mirai_encoded.txt')

    else:
        file_encoding(sys.argv[1], sys.argv[2])