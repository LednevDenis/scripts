#!/bin/bash

set -e

KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNE+XjDbSEVz41MvVT4jHy1DNXdc+dUzE0t1EWgQcki"
AUTH="/root/.ssh/authorized_keys"

echo "[*] Подготовка каталога /root/.ssh ..."
mkdir -p /root/.ssh
chmod 700 /root/.ssh

echo "[*] Проверка файла authorized_keys ..."
touch "$AUTH"
chmod 600 "$AUTH"

echo "[*] Добавление SSH ключа (если отсутствует)..."
if grep -Fxq "$KEY" "$AUTH"; then
    echo "[✓] Ключ уже присутствует — изменений нет."
else
    echo "$KEY" >> "$AUTH"
    echo "[✓] Ключ добавлен."
fi

echo "[✓] Готово."
