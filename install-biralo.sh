#!/bin/bash

# Terminal color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
RESET="\033[0m"

# Function to print slow text
slow_print() {
  local text="$1"
  local delay=0.04
  for (( i=0; i<${#text}; i++ )); do
    printf "${text:$i:1}"
    sleep $delay
  done
  printf "\n"
}

clear

# Show banner
if command -v figlet &>/dev/null; then
  if command -v lolcat &>/dev/null; then
    figlet -f slant "Biralo" | lolcat
  else
    figlet -f slant "Biralo"
  fi
else
  echo -e "${MAGENTA}${BOLD}*** BIRALO ***${RESET}"
fi

echo -e "\n${YELLOW}${BOLD}🔥 Installing Biralo Dependencies...${RESET}"

# Install required packages with spinner
(
  sudo apt update -y >/dev/null 2>&1
  sudo apt install -y figlet curl git python3 python3-pip >/dev/null 2>&1
) &

pid=$!
spinner="/|\\-/|\\-"
i=0
while kill -0 $pid 2>/dev/null; do
  printf "\r${CYAN}Installing dependencies ${spinner:$i:1}${RESET}"
  i=$(( (i+1) %8 ))
  sleep 0.1
done
wait $pid

echo -e "\r${GREEN}✔ Dependencies installed successfully!${RESET}"

# Clone repo
slow_print "${CYAN}📁 Cloning Biralo repository...${RESET}"
if git clone https://github.com/PowerEdgeR710/discord-vps-creator.git; then
  cd discord-vps-creator || { echo -e "${RED}❌ Failed to enter project folder.${RESET}"; exit 1; }
else
  echo -e "${RED}❌ Failed to clone repository.${RESET}"
  exit 1
fi

# Ask for bot token
echo -ne "\n${YELLOW}${BOLD}🤖 Enter your Discord Bot Token: ${RESET}"
read -sr BOT_TOKEN
echo ""

# Insert token into v2.py
if grep -q "^TOKEN=" v2.py; then
  sed -i "s|^TOKEN=.*|TOKEN='$BOT_TOKEN'|" v2.py
else
  echo "TOKEN='$BOT_TOKEN'" >> v2.py
fi

# Final message and run bot
slow_print "${GREEN}${BOLD}\n✅ Biralo setup complete! Starting the bot...${RESET}"
echo ""

# Run the bot
python3 v2.py

# Friendly exit
echo -e "\n${MAGENTA}Thanks for using Biralo! 🚀 Enjoy your VPS bot.${RESET}"
