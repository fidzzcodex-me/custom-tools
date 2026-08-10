#!/bin/bash
cd /home/container || exit 1

source /scripts/banner.sh
source /scripts/detect-runtime.sh
source /scripts/webhook.sh
source /scripts/backup.sh
source /scripts/web-terminal.sh
source /scripts/tunnel.sh
source /scripts/git-setup.sh

setup_git_repo

detect_and_setup_runtime

start_web_terminal
start_cf_tunnel
start_auto_backup
send_webhook_notification

print_banner

if [ -z "$STARTUP_CMD" ]; then
  echo -e "\033[1;33mNo STARTUP_CMD set. Dropping into shell.\033[0m"
  exec /bin/bash
fi

eval "$STARTUP_CMD"
