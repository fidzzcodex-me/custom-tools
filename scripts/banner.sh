#!/bin/bash

C_LABEL=$'\033[0;36m'
C_VALUE=$'\033[1;37m'
C_MUTED=$'\033[0;90m'
C_ON=$'\033[1;32m'
C_OFF=$'\033[0;90m'
C_ACCENT=$'\033[1;35m'
C_RESET=$'\033[0m'

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP" ] && IP="unknown"

print_banner() {
  local node_ver python_ver php_ver os_name kernel cpu_cores ram_str disk_used disk_total uptime_str

  node_ver=$(node -v 2>/dev/null || echo "not active")
  python_ver=$(python3 --version 2>/dev/null | awk '{print $2}' || echo "not active")
  php_ver=$(php -v 2>/dev/null | head -n1 | awk '{print $2}' || echo "not active")

  os_name=$(grep -oP '(?<=PRETTY_NAME=").*(?=")' /etc/os-release 2>/dev/null)
  [ -z "$os_name" ] && os_name="unknown"
  kernel=$(uname -r)
  cpu_cores=$(get_container_cpu_cores)
  ram_str=$(get_container_memory)
  disk_used=$(df -h /home/container 2>/dev/null | awk 'NR==2 {print $3}')
  disk_total=$(df -h /home/container 2>/dev/null | awk 'NR==2 {print $2}')
  uptime_str=$(get_container_uptime)

  echo ""
  echo -e "${C_ACCENT}  ╭──────────────────────────────────────────────╮${C_RESET}"
  echo -e "${C_ACCENT}  │${C_RESET}  ${C_VALUE}root's Console${C_RESET}"
  echo -e "${C_ACCENT}  ╰──────────────────────────────────────────────╯${C_RESET}"
  echo ""
  echo -e "  ${C_LABEL}OS${C_RESET}            : ${C_VALUE}${os_name}${C_RESET}"
  echo -e "  ${C_LABEL}Kernel${C_RESET}        : ${C_VALUE}${kernel}${C_RESET} ${C_MUTED}(host-shared)${C_RESET}"
  echo -e "  ${C_LABEL}CPU Cores${C_RESET}     : ${C_VALUE}${cpu_cores}${C_RESET}"
  echo -e "  ${C_LABEL}RAM${C_RESET}           : ${C_VALUE}${ram_str}${C_RESET}"
  echo -e "  ${C_LABEL}Disk${C_RESET}          : ${C_VALUE}${disk_used} / ${disk_total}${C_RESET}"
  echo -e "  ${C_LABEL}Uptime${C_RESET}        : ${C_VALUE}${uptime_str}${C_RESET}"
  echo -e "  ${C_LABEL}IP Address${C_RESET}    : ${C_VALUE}${IP}${C_RESET}"
  echo ""
  echo -e "  ${C_LABEL}Node.js${C_RESET}       : ${C_VALUE}${node_ver}${C_RESET}"
  echo -e "  ${C_LABEL}Python${C_RESET}        : ${C_VALUE}${python_ver}${C_RESET}"
  echo -e "  ${C_LABEL}PHP${C_RESET}           : ${C_VALUE}${php_ver}${C_RESET}"
  echo -e "  ${C_LABEL}Headless Mode${C_RESET} : ${C_VALUE}${HEADLESS_MODE:-true}${C_RESET}"
  echo ""
  echo -e "  ${C_LABEL}Nginx${C_RESET}         : $([ "$ENABLE_NGINX" = "true" ] && echo "${C_ON}http://${IP}:${NGINX_PORT:-8080}${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Web Terminal${C_RESET}  : $([ "$ENABLE_WEB_TERMINAL" = "true" ] && echo "${C_ON}http://${IP}:${WEB_TERMINAL_PORT:-7681}${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Tunnel${C_RESET}        : $([ "$ENABLE_CF_TUNNEL" = "true" ] && echo "${C_ON}Cloudflare${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo -e "  ${C_LABEL}Auto Backup${C_RESET}   : $([ "$ENABLE_AUTO_BACKUP" = "true" ] && echo "${C_ON}every ${BACKUP_INTERVAL_HOURS:-24}h${C_RESET}" || echo "${C_OFF}disabled${C_RESET}")"
  echo ""
}
