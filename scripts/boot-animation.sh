#!/bin/bash

C_LOGO=$'\033[1;35m'
C_OK=$'\033[1;32m'
C_STEP=$'\033[0;37m'
C_RESET=$'\033[0m'

print_logo() {
  echo -e "${C_LOGO}"
  cat << 'LOGO'
  ┌─────────────────────────┐
  │       C O D E X         │
  │      custom  tools      │
  └─────────────────────────┘
LOGO
  echo -e "${C_RESET}"
}

boot_step() {
  local label="$1"
  printf "  ${C_STEP}[    ] %s${C_RESET}\r" "$label"
  sleep 0.12
  printf "  ${C_OK}[ OK ]${C_RESET} %s\n" "$label"
}

run_boot_animation() {
  clear 2>/dev/null
  print_logo
  echo -e "  ${C_STEP}Booting root's environment...${C_RESET}"
  echo ""
  boot_step "Registering console identity"
  boot_step "Mounting workspace"
  boot_step "Detecting runtime environment"
  boot_step "Starting background services"
  boot_step "Finalizing system"
  echo ""
}
