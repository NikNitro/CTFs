#! /bin/bash

sudo apt-get update

# http://steghide.sourceforge.net/
sudo apt-get install steghide -y
# https://github.com/Paradoxis/StegCracker
pip3 install stegcracker
# Exiftool
sudo apt-get install exiftool -y
# john
# http://www.reydes.com/d/?q=Romper_la_Contrasena_de_un_Archivo_ZIP_utilizando_John_The_Ripper
cd /tmp
git clone https://github.com/openwall/john.git
sudo apt-get update
sudo apt-get install libssl-dev libssl
cd /tmp/john/src
./configure && sudo make -s clean && sudo make -sj4
## ./zip2john ~/Descargas/bitup/ciud_ejemp/me.zip > /tmp/secret.hash
## ./john --wordlist=/home/niknitro/Descargas/rockyou.txt /tmp/secret.hash

# sonic-visualiser (spectrograms)
sudo apt-get install sonic-visualiser -y

# binwalk
sudo apt-get install binwalk -y

# WavSteg https://github.com/ragibson/Steganography#WavSteg
pip3 install stego-lsb

# stegpy
pip3 install stegpy