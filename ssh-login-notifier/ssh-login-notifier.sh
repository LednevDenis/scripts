#!/bin/bash

# Telegram Bot Configuration
BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
CHAT_ID="YOUR_CHAT_ID_HERE"

# 🛡️ PROTECTION AGAINST DUPLICATION
# Send notification ONLY when opening a session
if [ "$PAM_TYPE" != "open_session" ]; then
    exit 0
fi

# Additional check for SSH connection
if [ -z "$SSH_CONNECTION" ]; then
    exit 0
fi

# Create a unique key for this session
SESSION_KEY="${PAM_USER}-${SSH_CONNECTION%% *}"
LOCK_FILE="/tmp/ssh_notify_${SESSION_KEY}.lock"

# Check if we already sent notification for this session
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create lock file to prevent duplication
touch "$LOCK_FILE"

# Automatically remove lock file after 2 minutes
(sleep 120 && rm -f "$LOCK_FILE") &

# Collect data
USER=${PAM_USER}
HOSTNAME=$(hostname)
DATE=$(date "+%d.%m.%Y %H:%M:%S")
IP=$(echo $SSH_CONNECTION | awk '{print $1}')
SERVER_IP=$(curl -s -4 ifconfig.me || hostname -I | awk '{print $1}')

# Additional system information
UPTIME=$(uptime -p)
LOAD=$(uptime | awk -F'load average:' '{print $2}')
MEMORY=$(free -h | grep Mem | awk '{print $3"/"$2}')

# Format message
MESSAGE="🔐 *SSH Login Detected*

*Server:* $HOSTNAME
*Server IP:* $SERVER_IP
*User:* \`$USER\`
*Remote IP:* \`$IP\`
*Time:* $DATE

*System Info:*
• Uptime: $UPTIME
• Load: $LOAD
• Memory: $MEMORY

📍 *Action Required?* 🤔"

# Send to Telegram
curl -s -X POST \
  "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
  -d chat_id=$CHAT_ID \
  -d text="$MESSAGE" \
  -d parse_mode="Markdown" > /dev/null 2>&1

# Log event
echo "$(date): SSH login - User: $USER, IP: $IP" >> /var/log/ssh-logins.log

exit 0
