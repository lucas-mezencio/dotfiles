#!/usr/bin/env bash

wallpaper_folder=$HOME/Pictures/Wallpapers
if [ ! -d $wallpaper_folder ]; then
    mkdir $HOME/Pictures/Wallpapers
fi

for wallpaper in $(ls wallpapers); do
    echo copying wallpaper $wallpaper $(pwd
    cp wallpaper/$wallpaper $wallpaper_folder -v
done
