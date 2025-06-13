#!/bin/env bash

MENU=wofi
if output=$(pgrep wofi); then
    echo "there is a wofi instance running"
fi


TERMINAL="alacritty"
if output=$(pgrep $TERMINAL); then
    echo "there is a alacritty instance running"
fi
