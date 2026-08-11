#!/bin/bash

setup_identity() {
  export USER="root"
  export HOME="/home/container"
  export TERM="xterm-256color"
  export PS1='\[\e[1;32m\]root\[\e[0m\]@\[\e[1;36m\]codex\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
}
