#! /bin/zsh

pwd=$(pwd)
script_folder=$pwd/scripts/
config_folder=$pwd/config/

#update system
sudo pacman -Syu

#install base
sudo pacman -S base

echo "Creating folders"
# create local bin directory
mkdir -p $HOME/.local/bin
#create config files and folders
mkdir -p $HOME/.config/alacritty
mkdir -p $HOME/.config/awesome

# enable scripts executable
echo "Enabling scripts"
sudo chmod +x $script_folder/*.sh

#configure git
echo "Configuring git"
./$script_folder/config-git.sh

#install fonts
echo "Intalling fonts"
sudo pacman -S ttf-fira-code ttf-meslo-nerd-font-powerlevel10k

echo "Intalling alacritty terminal and Yay helper"
sudo pacman -S alacritty yay

echo "configurando shell"
./$script_folder/config-shell.sh

# install jdk and ides
echo "Instalando JDK 11 e IDEs"
./$script_folder/config-ide.sh

echo "instalando softwares de uso diario"
sudo pacman -S neovim
sudo snap install teams
