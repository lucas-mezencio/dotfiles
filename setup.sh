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

install_tmux() {
    echo "setting up tmux"
    if ! command -v tmux &> /dev/null; then
        echo "tmux not found"
    else
        # git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
        TPM_DIR=$HOME/.tmux/plugins/tpm
        if [ ! -d "$TPM_DIR" ]; then
            # echo "installing tpm first"
            echo "install tpm first"
            echo "git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
            # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
        else
            echo "tpm already installed"
        fi
        echo "DONT FORGET TO INSTALL FZF VIA BREW # TODO: ZSH"
        echo "installing tmux config"
        ./scripts/install-tmux.sh $THISPATH
    fi
}

if [ "$#" -eq 0 ]; then
    install_nvim
    install_alacritty
    install_tmux
elif [ "$#" -eq 1 ]; then
    case "$1" in 
        "nvim")
        install_nvim
            ;; 
        "alacritty")
        install_alacritty
            ;;
        "tmux")
        install_tmux
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
