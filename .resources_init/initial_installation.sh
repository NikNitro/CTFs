#!/bin/bash

# Update repositories
sudo apt-get update 

# Install basic packages and dependencies
## Install net-tools
sudo apt-get install net-tools -y
 
## Install build-essentials
sudo apt-get install build-essential

## Polybar dependencies
sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python3-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev -y
sudo apt install libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y
# If python3-xcbgen fails, install python-xcbgen

# SO customization
## Install zsh with plugins
sudo apt-get install zsh zsh-autosuggestions zsh-syntax-highlighting -y

# Sec applications

sudo apt-get install binwalk -y


## Install another tools
### scrub, for file deleting
sudo apt-get install scrub -y

### i3lock-fancy
sudo apt-get install i3lock-fancy -y