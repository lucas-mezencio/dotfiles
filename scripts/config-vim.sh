#! /bin/bash

pwd=$(pwd)
parent_folder=$(dirname $pwd)

mkdir -p $HOME/.config/nvim
cp -r $parent_folder/config/nvim $HOME/.config/

# INSTALL VIM PLUG (PLUGIN MANAGER)

echo $(sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
