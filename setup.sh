#!/usr/bin/env bash

THISPATH=$(dirname "$(readlink -f "$0")")

install_nvim() {
    if ! command -v nvim &> /dev/null; then 
        echo "nvim not found"
    else
        echo "installing nvim config"
        ./scripts/install-nvim.sh $THISPATH
    fi
}

install_alacritty() {
    if ! command -v alacritty &> /dev/null; then 
        echo "alacritty not found"
    else
        echo "installing alacritty config"
        ./scripts/install-alacritty.sh $THISPATH
    fi
}

if [ "$#" -eq 0 ]; then
    install_nvim
    install_alacritty
elif [ "$#" -eq 1 ]; then
    case "$1" in 
        "nvim")
        install_nvim
            ;; 
        "alacritty")
        install_alacritty
            ;;
        *)
        echo "invalid option"
        exit 1
            ;;
    esac
else
    echo "invalid options, only one argument accepted"
    exit 1
fi
