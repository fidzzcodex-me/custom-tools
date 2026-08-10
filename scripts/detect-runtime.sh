#!/bin/bash

detect_and_setup_runtime() {
  local cmd="$STARTUP_CMD"
  DETECTED_RUNTIME=""

  case "$cmd" in
    *node\ * | node* | *npm\ * | npm* | *npx\ * | *bun\ * | bun*)
      DETECTED_RUNTIME="Node.js"
      export NVM_DIR="/usr/local/nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

      if [ -n "$NODE_VERSION" ]; then
        nvm install "$NODE_VERSION" >/tmp/nvm-install.log 2>&1
        nvm use "$NODE_VERSION" >/dev/null 2>&1
      fi

      if [ -f "package.json" ]; then
        case "$INSTALL_DEPS" in
          pnpm) pnpm install ;;
          yarn) yarn install ;;
          bun)  bun install ;;
          *)    npm install ;;
        esac
      fi
      ;;

    *python3\ * | python3* | *python\ * | python*)
      DETECTED_RUNTIME="Python"
      if [ -n "$PYTHON_VERSION" ] && command -v "python$PYTHON_VERSION" >/dev/null 2>&1; then
        update-alternatives --set python3 "/usr/bin/python$PYTHON_VERSION" >/dev/null 2>&1
      fi

      if [ -f "requirements.txt" ]; then
        pip install --break-system-packages -r requirements.txt
      fi
      ;;

    *)
      DETECTED_RUNTIME="Unknown"
      ;;
  esac

  export DETECTED_RUNTIME
}
