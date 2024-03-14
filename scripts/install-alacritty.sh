#!/usr/bin/env bash

rm -rf $HOME/.config/alacritty
ln -sf $1/config/alacritty $HOME/.config/alacritty
