#!/bin/bash

BLUE='\e[34m'
GREEN='\e[32m'
RESET='\e[0m'

TOML_FILE="packages.toml"

if ! command -v yq &> /dev/null; then
    echo "yq is required. Install it with: sudo pacman -S yq"
    exit 1
fi

echo -e "${BLUE}--- Starting System Sync ---${RESET}"

sections=$(yq eval '.. | select(tag == "!!seq") | path | join(".")' "$TOML_FILE")

for section in $sections; do
    mapfile -t pkgs < <(yq eval ".${section}[]" "$TOML_FILE")

    if [ ${#pkgs[@]} -gt 0 ]; then
        echo -e "${BLUE}[+] Processing section: ${GREEN}$section${RESET}"
        
        yay -S --needed --noconfirm "${pkgs[@]}"
    fi
done

echo -e "${GREEN}--- All packages processed! ---${RESET}"
