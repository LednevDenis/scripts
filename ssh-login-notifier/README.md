# SSH Login Notifier 🔐

Telegram notifications for SSH logins on your Linux server.

## Features

- ✅ Instant Telegram notifications on SSH login
- ✅ System information (uptime, load, memory)
- ✅ Protection against duplicate notifications
- ✅ Easy installation/uninstallation
- ✅ Configurable trusted IPs
- ✅ Logging to file

## Prerequisites

1. **Telegram Bot** - [Create via @BotFather](https://t.me/botfather)
   - Get `BOT_TOKEN`
   - Get `CHAT_ID` (send message to @userinfobot)

2. **Linux server** with:
   - bash
   - curl
   - PAM support

## Installation

```bash
# Clone repository
git clone https://github.com/LednevDenis/scripts.git
cd scripts/ssh-login-notifier

# Run installer
sudo ./install.sh
