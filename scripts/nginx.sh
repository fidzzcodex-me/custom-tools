#!/bin/bash

setup_nginx() {
  [ "$ENABLE_NGINX" != "true" ] && return 0

  local app_port="${APP_PORT:-3000}"
  local listen_port="${NGINX_PORT:-8080}"
  local conf_path="/etc/nginx/sites-enabled/app.conf"

  cat > "$conf_path" << NGINXEOF
server {
    listen ${listen_port};
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:${app_port};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINXEOF

  nginx -t >/tmp/nginx-test.log 2>&1
  if [ $? -eq 0 ]; then
    nginx >/tmp/nginx.log 2>&1
  else
    echo -e "${C_RED}[nginx] config test failed, check /tmp/nginx-test.log${C_RESET}"
  fi
}
