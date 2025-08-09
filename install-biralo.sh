#!/bin/bash

# Simple color setup
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'
BOLD='\033[1m'

# Clear screen
clear

# Cool title
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════╗"
echo "║          Installing Biralo           ║"
echo "╚══════════════════════════════════════╝"
echo -e "${RESET}"

# Installing dependencies
echo -e "${YELLOW}Installing dependencies...${RESET}"
sudo apt update -y >/dev/null 2>&1
sudo apt install -y python3 python3-pip git figlet >/dev/null 2>&1

# Optional: Fancy banner
if command -v figlet >/dev/null; then
    figlet Biralo
else
    echo -e "${BOLD}${CYAN}BIRALO${RESET}"
fi

# Clone repo
echo -e "\n${CYAN}Cloning project...${RESET}"
git clone https://github.com/PowerEdgeR710/discord-vps-creator.git >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to clone repo.${RESET}"
    exit 1
fi

cd discord-vps-creator || { echo -e "${RED}❌ Couldn't enter folder.${RESET}"; exit 1; }

# Ask for token
echo -ne "\n${YELLOW}Enter your Discord Bot Token: ${RESET}"
read -r BOT_TOKEN

# Inject into v2.py
if grep -q "^TOKEN=" v2.py; then
    sed -i "s|^TOKEN=.*|TOKEN='$BOT_TOKEN'|" v2.py
else
    echo "TOKEN='$BOT_TOKEN'" >> v2.py
fi

# Done, run it
echo -e "\n${GREEN}✅ All done! Starting Biralo bot now...${RESET}"
sleep 1
python3 v2.py
