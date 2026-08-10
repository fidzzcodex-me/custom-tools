#!/bin/bash

C_A=$'\033[1;36m'
C_B=$'\033[1;34m'
C_C=$'\033[1;35m'
C_TITLE=$'\033[1;37m'
C_LABEL=$'\033[0;36m'
C_VALUE=$'\033[1;37m'
C_MUTED=$'\033[0;90m'
C_RESET=$'\033[0m'

IP=$(hostname -I 2>/dev/null | awk '{print $1}')
[ -z "$IP" ] && IP="unknown"

print_banner() {
  local L1='█████ █████ ████  █████ █████  ████  ███  ████  █████ █   █ '
  local L2='█       █   █   █    █     █  █     █   █ █   █ █      █ █  '
  local L3='███     █   █   █   █     █   █     █   █ █   █ ███     █   '
  local L4='█       █   █   █  █     █    █     █   █ █   █ █      █ █  '
  local L5='█     █████ ████  █████ █████  ████  ███  ████  █████ █   █ '

  printf '%s%s%s\n' "$C_A" "$L1" "$C_RESET"
  printf '%s%s%s\n' "$C_A" "$L2" "$C_RESET"
  printf '%s%s%s\n' "$C_B" "$L3" "$C_RESET"
  printf '%s%s%s\n' "$C_C" "$L4" "$C_RESET"
  printf '%s%s%s\n' "$C_C" "$L5" "$C_RESET"
  echo ""
  echo -e "  ${C_TITLE}Multi-Runtime Terminal${C_RESET}  ${C_MUTED}·${C_RESET}  ${C_LABEL}v1.0.0${C_RESET}"
  echo ""
  echo -e "  ${C_LABEL}Runtime${C_RESET}      : ${C_VALUE}${DETECTED_RUNTIME:-detecting...}${C_RESET}"
  if [ "$DETECTED_RUNTIME" = "Node.js" ]; then
    echo -e "  ${C_LABEL}Version${C_RESET}      : ${C_VALUE}$(node -v 2>/dev/null || echo '-')${C_RESET}"
  elif [ "$DETECTED_RUNTIME" = "Python" ]; then
    echo -e "  ${C_LABEL}Version${C_RESET}      : ${C_VALUE}$(python3 --version 2>/dev/null || echo '-')${C_RESET}"
  fi
  echo -e "  ${C_LABEL}Web Terminal${C_RESET} : ${C_VALUE}http://${IP}:${WEB_TERMINAL_PORT:-7681}${C_RESET} ${C_MUTED}$([ "$ENABLE_WEB_TERMINAL" = "true" ] && echo '(active)' || echo '(disabled)')${C_RESET}"
  echo -e "  ${C_LABEL}Tunnel${C_RESET}       : ${C_VALUE}$([ "$ENABLE_CF_TUNNEL" = "true" ] && echo 'Cloudflare (active)' || echo 'disabled')${C_RESET}"
  echo -e "  ${C_LABEL}Auto Backup${C_RESET}  : ${C_VALUE}$([ "$ENABLE_AUTO_BACKUP" = "true" ] && echo "every ${BACKUP_INTERVAL_HOURS:-24}h" || echo 'disabled')${C_RESET}"
  echo ""
  echo -e "  ${C_MUTED}Type a command to get started${C_RESET}"
  echo ""
}
