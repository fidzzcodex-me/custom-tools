#!/bin/bash

setup_identity() {
  local uid gid uname
  uid=$(id -u)
  gid=$(id -g)
  uname="${CONSOLE_USER:-container}"

  if ! grep -q "^[^:]*:x:${uid}:" /etc/passwd 2>/dev/null; then
    echo "${uname}:x:${uid}:${gid}:${uname}:/home/container:/bin/bash" >> /etc/passwd
  fi

  export USER="$uname"
  export HOME=/home/container

  local prompt='\[\e[1;32m\]'"${uname}"'\[\e[0m\]@\[\e[1;36m\]codex\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '

  {
    echo "export PS1='${prompt}'"
    echo "export TERM=xterm-256color"
  } > /etc/profile.d/console-prompt.sh

  if ! grep -q "console-prompt.sh" /etc/bash.bashrc 2>/dev/null; then
    echo "source /etc/profile.d/console-prompt.sh" >> /etc/bash.bashrc
  fi
}
