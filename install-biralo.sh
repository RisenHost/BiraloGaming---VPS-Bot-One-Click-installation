#!/bin/bash

# Banner
sudo apt update > /dev/null
sudo apt install -y figlet curl git docker.io python3 python3-pip > /dev/null
clear
figlet -w 120 BIRALO
echo "🔥 Subscribed... Installing Dependencies 🔧"

# Clone the repo
git clone https://github.com/PowerEdgeR710/discord-vps-creator.git
cd discord-vps-creator || exit

# Build Docker images
echo "📦 Building Docker Images..."
docker build -t ubuntu-22.04-with-tmate -f Dockerfile1 .
docker build -t debian-with-tmate -f Dockerfile2 .

# Ask for Discord Bot Token
read -p "🤖 Enter your Discord Bot Token: " BOT_TOKEN

# Insert token into script
sed -i "s|TOKEN=.*|TOKEN='$BOT_TOKEN'|" v2.py

# Done
echo ""
echo "✅ Setup Complete!"
echo "👉 You can now run your bot using:"
echo "   python3 v2.py"
