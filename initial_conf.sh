# Modify .bashrc
rm ~/.bashrc
ln -s .bashrc ~/.bashrc

# Add apt repositories if there arent on "cat /etc/apt/sources.list"
## sudo tee -a /etc/apt/sources.list<<EOF
## deb http://http.kali.org/kali kali-rolling main non-free contrib
## deb-src http://http.kali.org/kali kali-rolling main non-free contrib
## EOF
# Update repositories
sudo apt-get update 

# Adding /home/kali/.local/bin to the PATH
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$PATH:$HOME/.local/bin"
fi

# Install net-tools
sudo apt-get install net-tools -y

# Install Python stuff
pip3 install virtualenv
echo "Virtualenv installed:"
which virtualenv
cd $HOME
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt

