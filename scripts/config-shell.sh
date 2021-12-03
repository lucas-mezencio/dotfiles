#! /bin/bash

#oh-my-zsh
echo "Instalando oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

#Zplug
echo "Instalando Zplug"
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#copiandos arquivos
pwd=$(pwd)
config=$(dirname $pwd)/config/shell
cp $config/.zshrc $HOME
cp $config/.aliases $HOME/.config/.aliases

zplug install --verbose
zplug load --verbose