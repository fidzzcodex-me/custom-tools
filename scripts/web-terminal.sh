#!/bin/bash

start_web_terminal() {
  [ "$ENABLE_WEB_TERMINAL" != "true" ] && return 0
  local port="${WEB_TERMINAL_PORT:-7681}"
  ttyd -p "$port" -W bash >/tmp/ttyd.log 2>&1 &
}
