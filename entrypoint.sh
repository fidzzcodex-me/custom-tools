#!/bin/bash
cd /home/container || exit 1

source /scripts/banner.sh
source /scripts/detect-runtime.sh
source /scripts/webhook.sh
source /scripts/backup.sh
source /scripts/web-terminal.sh
source /scripts/tunnel.sh
source /scripts/git-setup.sh
source /scripts/nginx.sh

setup_git_repo

setup_runtime_paths
detect_and_setup_runtime

CHROME_BIN=$(find /opt/browsers -maxdepth 3 -type f -name "chrome" 2>/dev/null | head -n1)
if [ -n "$CHROME_BIN" ]; then
  export PUPPETEER_EXECUTABLE_PATH="$CHROME_BIN"
  export CHROME_PATH="$CHROME_BIN"
fi

start_web_terminal
start_cf_tunnel
start_auto_backup
send_webhook_notification
setup_nginx

print_banner

if [ -z "$STARTUP_CMD" ]; then
  echo -e "\033[1;33mNo STARTUP_CMD set. Dropping into shell.\033[0m"
  exec /bin/bash
fi

eval "xvfb-run -a --server-args='-screen 0 1280x1024x24' $STARTUP_CMD"
