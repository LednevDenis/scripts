#!/bin/bash

set -e

SSH_CONFIG="/etc/ssh/sshd_config"

echo "[*] Проверяем наличие SSH ключа у root..."
if [ ! -f /root/.ssh/authorized_keys ]; then
    echo "!!! У ROOT нет /root/.ssh/authorized_keys — без ключа ты потеряешь доступ!"
    echo "Добавь ключ и запусти скрипт снова."
    exit 1
fi

echo "[*] Делаем бэкап sshd_config..."
cp "$SSH_CONFIG" "${SSH_CONFIG}.bak_$(date +%F_%T)"

echo "[*] Проверяем ключи у остальных пользователей..."
for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do
    HOME_DIR=$(eval echo "~$user")
    if [ ! -f "$HOME_DIR/.ssh/authorized_keys" ]; then
        echo "!!! Внимание: у пользователя $user нет authorized_keys — он НЕ сможет войти после выключения паролей."
    fi
done

echo "[*] Настраиваем SSH: только вход по ключу..."

set_param() {
    local param="$1"
    local value="$2"
    sed -i "s/^#\?\s*${param}.*/${param} ${value}/" "$SSH_CONFIG"
    if ! grep -q "^${param} ${value}" "$SSH_CONFIG"; then
        echo "${param} ${value}" >> "$SSH_CONFIG"
    fi
}

set_param "PermitRootLogin" "prohibit-password"
set_param "PasswordAuthentication" "no"
set_param "ChallengeResponseAuthentication" "no"
set_param "PubkeyAuthentication" "yes"
set_param "AuthenticationMethods" "publickey"

echo "[*] Перезапускаем SSH..."
systemctl restart sshd || systemctl restart ssh

echo "[✓] Готово!"
echo "Парольный вход полностью отключён."
