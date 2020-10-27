#! /bin/bash

# Save current directory (inside CTFs)
CURRENT_PATH=$(pwd)


sudo ./.resources_init/initial_installation.sh

# Install Python stuff
pip3 install virtualenv
echo "Virtualenv installed:"
cd $HOME
virtualenv -p python3 venv
source venv/bin/activate
pip install -r requirements.txt

# Install Chisel
cd /opt/
sudo git clone https://github.com/jpillora/chisel.git
cd chisel/
sudo go build

# Install sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# Configure bash (Thanks S4vitar - https://www.youtube.com/watch?v=MF4qRSedmEs)
## Install rofi
sudo apt-get install rofi -y
## Install compton, for transparency and blur
sudo apt-get install compton -y
## Install feh for improve image viewing, and configure our wallpaper
sudo apt-get install feh -y
## Install bspwm - Docu: https://github.com/baskerville/bspwm/wiki
sudo apt-get install bspwm -y
### Install bspwm dependencies
sudo apt-get install caja -y
sudo apt-get install gnome-terminal -y
sudo apt-get install libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev -y
### Download repos
cd /opt/
sudo git clone https://github.com/baskerville/bspwm.git
sudo git clone https://github.com/baskerville/sxhkd.git

### Building repos
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install

### Running bspwm
mkdir -p ~/.config/{bspwm,sxhkd}
ln -s $CURRENT_PATH/.resources_init/bspwmrc ~/.config/bspwm/
ln -s $CURRENT_PATH/.resources_init/sxhkdrc ~/.config/sxhkd/

### Set init at each login
cd ~
echo "sxhkd &" > ~/.xinitrc
echo "exec bspwm" >> ~/.xinitrc

### And let's create the script for "Custom move/resize"
mkdir ~/.config/bspwm/scripts/
ln -s $CURRENT_PATH/.resources_init/bspwm_resize ~/.config/bspwm/scripts/bspwm_resize

### Now let's create the compton.conf file
mkdir ~/.config/compton
ln -s $CURRENT_PATH/.resources_init/compton.conf ~/.config/compton/compton.conf

## Installing Polybar (https://github.com/polybar/polybar/wiki/Compiling)
### Download repo v3.4.tar for 
cd /opt/
sudo wget https://github.com/jaagr/polybar/releases/download/3.4.0/polybar-3.4.0.tar
sudo tar -xf polybar-3.4.0.tar 
sudo rm polybar-3.4.0.tar 
cd polybar
sudo mkdir build
cd build
sudo cmake ..
sudo make -j$(nproc)
sudo make install
### Create the polybar config files
mkdir ~/.config/polybar
ln -s $CURRENT_PATH/.resources_init/polybar_launch.sh ~/.config/polybar/launch.sh
ln -s $CURRENT_PATH/.resources_init/polybar_config ~/.config/polybar/config
    ### Add launch.sh to the bspwmrc file
    #sed -i '/wmname LG3D &$/a~/.config/polybar/launch.sh &' ~/.config/bspwm/bspwmrc

## Install Hack Nerd Fonts
sudo unzip $CURRENT_PATH/.resources_init/HackNerdFont.zip -d /usr/local/share/fonts/

### Install Powerlevel10k and configure it
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
ln -s $CURRENT_PATH/.resources_init/p10k_conf.zsh ~/.p10k.zsh
sudo usermod --shell /usr/bin/zsh $USER
sudo mv ~/.zshrc ~/.zshrc.bak
sudo ln -s $CURRENT_PATH/.resources_init/.zshrc ~/.zshrc

# Also for root if there are more users
if [ $USER != 'root' ]; then

    sudo ln -s $CURRENT_PATH/.resources_init/p10k_conf.zsh /root/.p10k.zsh
    sudo usermod --shell /usr/bin/zsh root
    sudo mv /root/.zshrc /root/.zshrc.bak
    sudo ln -s ~/.zshrc /root/.zshrc
fi

### Install zsh plugins
sudo chown $USER:$USER -R /usr/share/zsh-syntax-highlighting
sudo chown $USER:$USER -R /usr/share/zsh-autosuggestions

## Install LSD
### A better ls
cd /tmp
wget https://github.com/Peltoche/lsd/releases/download/0.14.0/lsd_0.14.0_amd64.deb
sudo dpkg -i lsd_0.14.0_amd64.deb

## Install bat
### A better cat
### In debian and some other SO's, bat is not in the repo.
### sudo apt install bat
curl -s -L https://github.com/sharkdp/bat/releases/latest \
| grep "/sharkdp/.*/bat_[0-9\.]*_amd64.deb" \
| cut -d '"' -f 2 \
| sed 's/^/https:\/\/github.com/' \
| wget -P /tmp -qi -

sudo dpkg -i /tmp/bat*.deb

## Install fzf
### A good finder for CLI (https://github.com/junegunn/fzf)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install





