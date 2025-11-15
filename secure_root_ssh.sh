#!/bin/bash

set -e

SSH_CONFIG="/etc/ssh/sshd_config"

echo "[*] Проверяю наличие SSH ключей у root..."
if [ ! -f /root/.ssh/authorized_keys ]; then
    echo "!!! У root нет authorized_keys. Добавь ключ, иначе потеряешь доступ."
    exit 1
fi

echo "[*] Делаю бэкап sshd_config..."
cp $SSH_CONFIG ${SSH_CONFIG}.bak_$(date +%F_%T)

echo "[*] Включаю root login по ключам и отключаю парольный вход..."

# Разрешить root по ключу
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin prohibit-password/' $SSH_CONFIG

# Отключить пароли полностью
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' $SSH_CONFIG

# На всякий случай отключить ChallengeResponse
sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' $SSH_CONFIG

echo "[*] Перезапускаю SSH..."
systemctl restart sshd || systemctl restart ssh

echo "[✓] Готово! Root входит только по ключам, пароли отключены."
