#!/bin/bash

# SSH Login Notifier Installer
# Author: Denis Lednev
# GitHub: https://github.com/LednevDenis/scripts

set -e

echo "SSH Login Notifier Installer"
echo "================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Copy script
echo "Copying script to /usr/local/bin/"
cp ssh-login-notifier.sh /usr/local/bin/
chmod +x /usr/local/bin/ssh-login-notifier.sh

# Configure PAM
echo "onfiguring PAM..."
if ! grep -q "ssh_login_notify" /etc/pam.d/sshd; then
    echo "# SSH Login Notifier" >> /etc/pam.d/sshd
    echo "session optional pam_exec.so /usr/local/bin/ssh-login-notifier.sh" >> /etc/pam.d/sshd
    echo "PAM configured successfully"
else
    echo "PAM already configured, skipping..."
fi

# Create log file
echo "Creating log file..."
touch /var/log/ssh-logins.log
chmod 644 /var/log/ssh-logins.log

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "1. Edit /usr/local/bin/ssh-login-notifier.sh"
echo "2. Set your BOT_TOKEN and CHAT_ID"
echo "3. Test with: sudo PAM_USER=test SSH_CONNECTION='8.8.8.8 12345 22' /usr/local/bin/ssh-login-notifier.sh"
echo ""
echo "To uninstall run: ./uninstall.sh"
