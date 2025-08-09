#!/bin/bash

# Terminal color codes for style
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"
BOLD="\033[1m"
RESET="\033[0m"

# Function to print slow text (for dramatic effect)
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

# Show a big, colorful Biralo banner with figlet + lolcat if available
if command -v figlet &>/dev/null; then
  if command -v lolcat &>/dev/null; then
    figlet -f slant "Biralo" | lolcat -a -d 10
  else
    figlet -f slant "Biralo"
  fi
else
  echo -e "${MAGENTA}${BOLD}*** BIRALO ***${RESET}"
fi

echo -e "\n${YELLOW}${BOLD}🔥 Subscribed... Installing Biralo Dependencies 🔧${RESET}"
sleep 1

# Update and install dependencies quietly with progress dots
echo -ne "${CYAN}Updating system and installing required packages"
sudo apt update -y >/dev/null 2>&1 && sudo apt install -y figlet curl git docker.io python3 python3-pip >/dev/null 2>&1 &

spinner="/|\\-/|\\-"
i=0
while kill -0 $! 2>/dev/null; do
  i=$(( (i+1) %8 ))
  printf "\r${CYAN}Updating system and installing required packages ${spinner:$i:1}${RESET}"
  sleep 0.1
done
printf "\r${GREEN}✔ Dependencies installed successfully!               ${RESET}\n"

# Clone repository
slow_print "${CYAN}📁 Cloning the discord-vps-creator repository...${RESET}"
if git clone https://github.com/PowerEdgeR710/discord-vps-creator.git; then
  cd discord-vps-creator || { echo -e "${RED}❌ Failed to enter project directory.${RESET}"; exit 1; }
else
  echo -e "${RED}❌ Failed to clone repository. Check your internet.${RESET}"
  exit 1
fi

# Build Docker images with progress spinner
slow_print "${CYAN}🐳 Building Docker images...${RESET}"
(
  docker build -t ubuntu-22.04-with-tmate -f Dockerfile1 . >/dev/null 2>&1 &&
  docker build -t debian-with-tmate -f Dockerfile2 . >/dev/null 2>&1
) &

pid=$!
i=0
while kill -0 $pid 2>/dev/null; do
  i=$(( (i+1) %8 ))
  printf "\r${CYAN}Building Docker images ${spinner:$i:1}${RESET}"
  sleep 0.1
done
wait $pid
if [ $? -ne 0 ]; then
  echo -e "\n${RED}❌ Docker build failed. Make sure Docker is running.${RESET}"
  exit 1
fi
printf "\r${GREEN}✔ Docker images built successfully!                  ${RESET}\n"

# Prompt user for Discord bot token
echo -ne "\n${YELLOW}${BOLD}🤖 Enter your Discord Bot Token: ${RESET}"
read -sr BOT_TOKEN
echo ""

# Insert token into v2.py safely
if grep -q "^TOKEN=" v2.py; then
  sed -i "s|^TOKEN=.*|TOKEN='$BOT_TOKEN'|" v2.py
else
  echo "TOKEN='$BOT_TOKEN'" >> v2.py
fi

slow_print "${GREEN}${BOLD}\n✅ Biralo setup complete!${RESET}"
echo -e "${CYAN}👉 To start your bot, run:${YELLOW}\n   python3 v2.py${RESET}\n"

# End with a friendly message
echo -e "${MAGENTA}Thanks for choosing Biralo! Have fun creating awesome VPS bots! 🚀${RESET}"
