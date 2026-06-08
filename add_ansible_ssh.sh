#!/bin/bash

set -e

KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCt3Nj87sw4UrNmlTcTv70r/VepIPqbz+t/QzaoR8gtK1cu6xdzmxajRcimhEDB8yuT4pSuhV5Idzs/twyom3NzXx4O+xi3D4XZL8rPIlQt+BHeON3FSBjJvbjrMbjAl0H6+iQmurogsWAFz3ApoL0rOO6h/GBf6vH7ZqIQPUP9S2sdeAMTsJ2q3RqRcMZTduZ9WTNJOK8g6ApF6mEE09kPFj49pWPNJTXH4t7+hvpXcLaXMxyd6nV0QSsiIeYhUg5TrQh+k794vPBkKstqhNpMeZ80XZh/Yoq7//L118vEPKNabtv1777XUl+0a0QuOajI6Okn2+qm1wFjKIGV5W1kvRRfxcn3m8IfSaN0T96TBm8xlEQl45NRxYrFBGdFOPArTG2xRdxJhAcSHzVpuSDL9/WCWBOH953/mIzTKlueNMscU/asPhOCcsUVMCEb8X9j/44vTzSYm2rMJzEVRDSoIQxbyHVJf17MTjqrUph72H9dWLs8UVLpjQgMernI080= root@ansible"
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
