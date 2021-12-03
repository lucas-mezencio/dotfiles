#! /bin/zsh

pwd=$(pwd)
script_folder=$pwd/scripts/
config_folder=$pwd/config/

#update system
sudo pacman -Syu

#install base
sudo pacman -S base

# enable scripts executable
sudo chmod +x $script_folder/*.sh

#configure git
./$script_folder/config-git.sh

#install fonts
sudo pacman -S ttf-fira-code
sudo pacman -S ttf-meslo-nerd-font-powerlevel10k


sudo pacman -S alacritty yay

echo criando pastas
# create local bin directory
mkdir -p ~/.local/bin
#create config files and folders
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/awesome

echo copiando arquivos de configuração
cp $config_folder/.zshrc ~
cp $config_folder/alacritty.yml ~/.config/config/alacritty

cp config/awesome/* ~/.config/awesome


# vim-plug
echo "Instalando vim_plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install jdk and ides
echo "Instalando JDK 11 e IDEs"
./$script_folder/config-ide.sh

echo "instalando softwares de uso diario"
yay -S spotify
sudo pacman -S vim
sudo snap install teams

#outros softwares

# dowload copycats theme

# update modified theme


todo # create scripts folder (to automate the copying of config files separadely)