#!/bin/bash

start_cf_tunnel() {
  [ "$ENABLE_CF_TUNNEL" != "true" ] && return 0
  if [ -z "$CF_TOKEN" ]; then
    echo -e "\033[1;33m[tunnel] ENABLE_CF_TUNNEL is true but CF_TOKEN is empty, skipping.\033[0m"
    return 0
  fi
  cloudflared tunnel run --token "$CF_TOKEN" >/tmp/cloudflared.log 2>&1 &
}
