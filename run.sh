#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$THIS_DIR"

./setup.sh

cleanup() {
  if [ -n "${SERVER_PID:-}" ] && ps -p "$SERVER_PID" > /dev/null 2>&1; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

if [ -f package.json ] && grep -q '"next"' package.json; then
  echo "Detected Next.js project. Starting dev server on port 3000."
  nohup yarn dev -p 3000 >/tmp/nextjs.log 2>&1 &
  SERVER_PID=$!
  wait "$SERVER_PID"
else
  echo "Starting static site with python3 -m http.server on port 3000."
  python3 -m http.server 3000
fi
