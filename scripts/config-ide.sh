#! /bin/bash

# java 11 openjdk
echo "Instalando openjdk 11"
sudo pacman -S openjdk11-doc jdk11-openjdk

echo "instalando ides via snap"
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install intellij-idea-ultimate --classic
sudo snap install android-studio --classic
sudo snap install dbeaver-ce