#!/bin/bash

# SSH Login Notifier Uninstaller

set -e

echo "🗑SH Login Notifier Uninstaller"
echo "================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Remove from PAM
echo "emoving from PAM..."
sed -i '/ssh-login-notifier.sh/d' /etc/pam.d/sshd
sed -i '/SSH Login Notifier/d' /etc/pam.d/sshd

# Remove script
echo "Removing script..."
rm -f /usr/local/bin/ssh-login-notifier.sh

# Optional: Remove log file
read -p "Remove log file (/var/log/ssh-logins.log)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f /var/log/ssh-logins.log
fi

# Remove lock files
echo "Cleaning up lock files..."
rm -f /tmp/ssh_notify_*.lock

echo ""
echo "✅ Uninstall complete!"
echo "You may want to restart SSH service: systemctl restart sshd"
