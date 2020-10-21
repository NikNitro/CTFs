#! /dev/null

# Save current directory (inside CTFs)
CURRENT_PATH=$(pwd)

# Modify .bashrc
rm ~/.bashrc
ln -s $CURRENT_PATH/.resources_init/.bashrc ~/.bashrc

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

# Install Chisel
cd /opt/
sudo git clone https://github.com/jpillora/chisel.git
cd chisel/
sudo go build
ln -s /opt/chisel/chisel $HOME/.local/bin/chisel

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
cd $HOME
git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
### Building repos
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install
### Running bspwm
mkdir -p ~/.config/{bspwm,sxhkd}
cp /usr/local/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/
cp /usr/local/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/
chmod u+x ~/.config/bspwm/bspwmrc
### Set init at each login
echo "sxhkd &" > ~/.xinitrc
echo "exec bspwm" >> ~/.xinitrc
### Add line in bspwmrc for avoid burpsuite java errors (S4vitar recommends it!)
#sed -i'.bak' '/sxhkd &$/awmname LG3D &' ~/.config/bspwm/bspwmrc
### Also, for using sxhkd, we need to define a 'super' key, for example, windows key (called 'mod1')
sed -i'.bak' '/sxhkd &$/awmname LG3D &\ncompton --config ~/.config/compton/compton.conf &\n\n\nbspc config pointer_modifier mod1' ~/.config/bspwm/bspwmrc
### Set Caja with a floating view
sed -i 's/Gimp/Caja/g' ~/.config/bspwm/bspwmrc
### Set our own gnome-terminal
sed -i'.bak' 's/urxvt/gnome-terminal/' ~/.config/sxhkd/sxhkdrc
### Set Program launcher as Windows + d
sed -i 's/^super + @space$/super + d/' ~/.config/sxhkd/sxhkdrc 
### Set our program launcher as rofi.
sed -i 's/dmenu_run$/rofi -show run/'  ~/.config/sxhkd/sxhkdrc
### Add a ctrl key for preselect the direction
sed -i 's/super + ctrl + {h,j,k,l}/super + ctrl + alt {Left,Down,Up,Right}/g' ~/.config/sxhkd/sxhkdrc
### Change all others 'hjkl' directions for arrow keys
sed -i 's/{h,j,k,l}/{Left,Down,Up,Right}/' ~/.config/sxhkd/sxhkdrc
### Comment a couple of options never used
sed -i 's/^super + alt + {Left,Down,Up,Right}/#&/g' ~/.config/sxhkd/sxhkdrc
sed -i 's/^super + alt + shift + {Left,Down,Up,Right}/#&/g' ~/.config/sxhkd/sxhkdrc
### Added a ctrl for moving a floating windows
sed -i 's/^super + {Left,Down,Up,Right}/super + ctrl + {Left,Down,Up,Right}/g' ~/.config/sxhkd/sxhkdrc
### Let's now customize the sxhkd
text="
# -------------------------------------------------------------
# CUSTOM
# -------------------------------------------------------------

# Custom move/resize
alt + ctrl + {Left,Down,Up,Right}
        ~/.config/bspwm/scripts/bspwm_resize {west,south,north,east}
"
echo "$text" >> ~/.config/sxhkd/sxhkdrc
### And let's create the script for "Custom move/resize"
mkdir ~/.config/bspwm/scripts/
cd $CURRENT_PATH
ln -s $CURRENT_PATH/.resources_init/bspwm_resize ~/.config/bspwm/scripts/bspwm_resize
chmod +x ~/.config/bspwm/scripts/bspwm_resize
### Now let's create the compton.conf file
mkdir ~/.config/compton
ln -s $CURRENT_PATH/.resources_init/compton.conf ~/.config/compton/compton.conf
echo "In 30 seconds, the session will logout. Please select the bspwm theme before login again."
sleep 30
#kill -9 -1

## Installing Polybar (https://github.com/polybar/polybar/wiki/Compiling)
### Install all dependencies
sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev -y
### Install all optionals dependencies 
sudo apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y
### Download repo v3.4.tar
cd /opt/
sudo wget https://github.com/jaagr/polybar/releases/download/3.4.0/polybar-3.4.0.tar
sudo tar -xf polybar-3.4.0.tar 
sudo rm polybar-3.4.0.tar 
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
sed -i '/wmname LG3D &$/a~/.config/polybar/launch.sh &' ~/.config/bspwm/bspwmrc

## Install Hack Nerd Fonts
sudo unzip $CURRENT_PATH/.resources_init/HackNerdFont.zip -d /usr/local/share/fonts/

## Install CrackMapExec
cd /opt
sudo git clone https://github.com/byt3bl33d3r/CrackMapExec.git

## Install zsh
sudo apt-get install zsh -y

### Install Powerlevel10k and configure it
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

ln -s $CURRENT_PATH/.resources_init/p10k_conf.zsh ~/.p10k.zsh
sudo ln -s $CURRENT_PATH/.resources_init/p10k_conf.zsh /root/.p10k.zsh

sudo usermod --shell /usr/bin/zsh kali
sudo usermod --shell /usr/bin/zsh root

sudo mv ~/.zshrc ~/.zshrc.bak
sudo ln -s $CURRENT_PATH/.resources_init/.zshrc ~/.zshrc
sudo mv /root/.zshrc /root/.zshrc.bak
sudo ln -s /home/kali/.zshrc /root/.zshrc

### Install zsh plugins
sudo apt-get install zsh-autosuggestions -y
sudo apt-get install zsh-syntax-highlighting -y
sudo chown kali:kali -R /usr/share/zsh-syntax-highlighting
sudo chown kali:kali -R /usr/share/zsh-autosuggestions


## Install LSD
### A better ls
cd /tmp
wget https://github.com/Peltoche/lsd/releases/download/0.14.0/lsd_0.14.0_amd64.deb
sudo dpkg -i lsd_0.14.0_amd64.deb

## Install bat
### A better cat
sudo apt install bat

## Install fzf
### A good finder for CLI (https://github.com/junegunn/fzf)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


## Install another tools
### scrub, for file deleting
sudo apt-get install scrub -y

### i3lock-fancy
### imagemagick
sudo apt-get install i3lock-fancy imagemagick -y


