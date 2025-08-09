#!/bin/bash

# Color codes that work in most terminals
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
MAGENTA='\e[35m'
BOLD='\e[1m'
RESET='\e[0m'

clear

# Aesthetic header
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════╗"
echo "║         🚀  B I R A L O  ⚡           ║"
echo "╚══════════════════════════════════════╝"
echo -e "${RESET}"

# Step 1: Install base packages
echo -e "${YELLOW}🔧 Installing required packages...${RESET}"
sudo apt update -y >/dev/null 2>&1
sudo apt install -y python3 python3-pip git -y >/dev/null 2>&1
echo -e "${GREEN}✅ System dependencies installed.${RESET}"

# Step 2: Install discord.py
echo -e "${YELLOW}📦 Installing Python modules...${RESET}"
pip3 install -U discord.py >/dev/null 2>&1

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to install discord.py. Check Python setup.${RESET}"
    exit 1
fi
echo -e "${GREEN}✅ discord.py installed.${RESET}"

# Step 3: Clone repo
echo -e "${YELLOW}📁 Cloning Biralo project...${RESET}"
git clone https://github.com/PowerEdgeR710/discord-vps-creator.git >/dev/null 2>&1

if [ ! -d "discord-vps-creator" ]; then
    echo -e "${RED}❌ Failed to clone repository. Check your internet.${RESET}"
    exit 1
fi

cd discord-vps-creator || exit 1
echo -e "${GREEN}✅ Repo cloned successfully.${RESET}"

# Step 4: Ask for bot token
echo -ne "${CYAN}🤖 Enter your Discord Bot Token: ${RESET}"
read -r BOT_TOKEN

# Step 5: Insert token into v2.py
if grep -q "^TOKEN=" v2.py; then
    sed -i "s|^TOKEN=.*|TOKEN='${BOT_TOKEN}'|" v2.py
else
    echo "TOKEN='${BOT_TOKEN}'" >> v2.py
fi
echo -e "${GREEN}✅ Token saved to v2.py${RESET}"

# Final Step: Start bot
echo -e "\n${MAGENTA}${BOLD}🚀 Starting Biralo bot...${RESET}"
sleep 1
python3 v2.py

# Optional: If bot fails
if [ $? -ne 0 ]; then
    echo -e "\n${RED}❌ Bot failed to start. Make sure your token is valid.${RESET}"
else
    echo -e "\n${GREEN}✅ Biralo bot is now running!${RESET}"
fi
