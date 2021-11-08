#! /bin/zsh

#update system
sudo pacman -Syu

#install base
sudo pacman -S base

#configure git
git config --global init.defaultBranch main
git config --global user.name "lucas-mezencio"
git config --global user.email "lucasmezss@hotmail.com"

#install fonts
sudo pacman -S ttf-fira-code
sudo pacman -S ttf-meslo-nerd-font-powerlevel10k


sudo pacman -S alacritty yay

echo criando pastas
# create local bin directory
mkdir -p ~/.local/bin
#create config files and folders
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/awesome

echo copiando arquivos de configuração
cp config/.zshrc ~
cp config/.vimrc ~
cp config/alacritty.yml ~/.config/config/alacritty
cp config/awesome/* ~/.config/awesome

#oh-my-zsh
echo "Instalando oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zinit
echo "Instalando zinit"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/master/doc/install.sh)"


# vim-plug
echo "Instalando vim_plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# java 11 openjdk
echo "Instalando openjdk 11"
sudo pacman -S openjdk11-doc jdk11-openjdk

echo "instalando ides via snap"
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install intellij-idea-ultimate --classic
sudo snap install android-studio --classic
sudo snap install dbeaver-ce

echo "instalando softwares de uso diario"
yay -S spotify
sudo pacman -S vim
