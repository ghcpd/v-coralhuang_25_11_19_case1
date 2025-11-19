#!/usr/bin/env bash
# Minimal setup: ensure python3 available
set -e
if command -v python3 >/dev/null 2>&1; then
  echo "python3 found"
else
  echo "Please install python3 to run the dev server"
  exit 1
fi
chmod +x run.sh test.sh

echo "Setup completed"