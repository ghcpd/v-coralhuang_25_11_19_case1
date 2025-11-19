#!/usr/bin/env bash
set -euo pipefail

# Minimal setup for static HTML demo
# Installs curl if not present (Debian/Ubuntu) and checks for python3

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found. Please install Python 3.8+"
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not found. Attempting to install..."
  if [ -f /etc/debian_version ]; then
    apt-get update && apt-get install -y curl
  else
    echo "Please install curl manually for your OS"
    exit 1
  fi
fi

echo "Setup complete."