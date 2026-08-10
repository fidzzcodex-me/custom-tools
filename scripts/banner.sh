#!/bin/bash

C_LABEL=$'\033[0;36m'
C_VALUE=$'\033[1;37m'
C_MUTED=$'\033[0;90m'
C_ON=$'\033[1;32m'
C_OFF=$'\033[0;90m'
C_RESET=$'\033[0m'

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP" ] && IP="unknown"

print_banner() {
  local node_ver python_ver php_ver
  node_ver=$(node -v 2>/dev/null || echo "not active")
  python_ver=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "not active")
  php_ver=$(php -v 2>/dev/null | head -n1 | awk '{print $2}' || echo "not active")

  echo ""
  echo -e "  ${C_LABEL}Node.js${C_RESET}      : ${C_VALUE}${node_ver}${C_RESET}"
  echo -e "  ${C_LABEL}Python${C_RESET}       : ${C_VALUE}${python_ver}${C_RESET}"
  echo -e "  ${C_LABEL}PHP${C_RESET}          : ${C_VALUE}${php_ver}${C_RESET}"
  echo -e "  ${C_LABEL}Nginx${C_RESET}        : $([ "$ENABLE_NGINX" = "true" ] && echo "${C_ON}http://${IP}:${NGINX_PORT:-8080}${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Web Terminal${C_RESET} : $([ "$ENABLE_WEB_TERMINAL" = "true" ] && echo "${C_ON}http://${IP}:${WEB_TERMINAL_PORT:-7681}${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Tunnel${C_RESET}       : $([ "$ENABLE_CF_TUNNEL" = "true" ] && echo "${C_ON}Cloudflare${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Auto Backup${C_RESET}  : $([ "$ENABLE_AUTO_BACKUP" = "true" ] && echo "${C_ON}every ${BACKUP_INTERVAL_HOURS:-24}h${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo ""
}
