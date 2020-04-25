# Modify .bashrc
rm ~/.bashrc
ln -s .bashrc ~/.bashrc

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

