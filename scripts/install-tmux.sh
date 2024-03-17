#! /usr/bin/env bash

# rm -rf $HOME/.config/tmux
rm -rf $HOME/.tmux
rm -rf $HOME/.tmux.conf

# ln -sf $1/config/tmux $HOME/.config/tmux
ln -sf $1/config/tmux/tmux.conf $HOME/.tmux.conf
ln -sf $1/config/tmux/tmux.keymaps.conf $HOME/.tmux.keymaps.conf
