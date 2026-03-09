#!/bin/bash

RED='\e[31m'
BLU='\e[34m'
GRN='\e[32m'
DEF='\e[0m'

hypr_packages=("hyprland" "hyprpaper" "hyprlock" "hyprpicker" "hyprshot" "hypridle" "hyprcursor")

echo -e "${BLU} [+] Installing" "${hypr_packages[@]}" "${DEF}"

yay -Sya -q --noconfirm "${hypr_packages[@]}" >>/dev/null

echo -e "${GRN} Installed. Copying configs..."

mkdir ~/.config/hypr
cp -rf ./dots/hypr ~/.config/hypr

packages=("neovim" "librewolf-bin" "")
