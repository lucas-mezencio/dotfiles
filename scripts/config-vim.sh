#! /bin/bash

cp ../config/vim/.vimrc ~/.vimrc
cp ../config/vim/init.vim ~/.config/nvim/init.vim

echo 'stty -ixon' >> ~/.zshrc 
>>>>>>> feature-scripts
