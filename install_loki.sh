#!/bin/bash
# Скачиваем Promtail
wget https://github.com/grafana/loki/releases/download/v2.9.4/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
sudo cp promtail-linux-amd64 /usr/local/bin/promtail
sudo chmod +x /usr/local/bin/promtail

# Создаём папку для позиций
sudo mkdir -p /var/lib/promtail

# Создаём конфиг (ЗАМЕНИТЕ IP НА IP ВАШЕГО LOKI СЕРВЕРА)
sudo tee /etc/promtail-config.yaml > /dev/null << 'EOF'
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /var/lib/promtail/positions.yaml

clients:
  - url: http://192.168.0.116:3100/loki/api/v1/push  # IP сервера Loki

scrape_configs:
  - job_name: jira_system
    static_configs:
      - targets: [localhost]
        labels:
          job: jira
          host: jira-server
          __path__: /var/log/*.log

  - job_name: jira_app
    static_configs:
      - targets: [localhost]
        labels:
          job: jira_app
          host: jira-server
          __path__: /opt/atlassian/jira/logs/*.log
EOF

# Создаём systemd-сервис
sudo tee /etc/systemd/system/promtail.service > /dev/null << 'EOF'
[Unit]
Description=Promtail
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail-config.yaml
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Запускаем
sudo systemctl daemon-reload
sudo systemctl enable --now promtail
sudo systemctl status promtail
