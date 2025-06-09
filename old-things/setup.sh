#!/usr/bin/env bash

THISPATH=$(dirname "$(readlink -f "$0")")

install_ansible () {
    if command -v ansible &> /dev/null; then
        echo "ansible already installed"
    else
        sudo -v
        sudo apt install -y ansible
    fi
}

main () {
    install_ansible
    ansible-playbook setup/dotfiles.yaml -K
}
main

# if [ "$#" -eq 0 ]; then
#     install_nvim
#     install_alacritty
#     install_tmux
# elif [ "$#" -eq 1 ]; then
#     case "$1" in 
#         "nvim")
#         install_nvim
#             ;; 
#         "alacritty")
#         install_alacritty
#             ;;
#         "tmux")
#         install_tmux
#             ;;
#         *)
#         echo "invalid option"
#         exit 1
#             ;;
#     esac
# else
#     echo "invalid options, only one argument accepted"
#     exit 1
# fi
#

