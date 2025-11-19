#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$THIS_DIR"

./setup.sh

SERVER_PID=""
start_server() {
  if [ -f package.json ] && grep -q '"next"' package.json; then
    nohup yarn dev -p 3000 >/tmp/nextjs-test.log 2>&1 &
  else
    nohup python3 -m http.server 3000 >/tmp/html-test.log 2>&1 &
  fi
  SERVER_PID=$!
}

stop_server() {
  if [ -n "$SERVER_PID" ] && ps -p "$SERVER_PID" > /dev/null 2>&1; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
    wait "$SERVER_PID" 2>/dev/null || true
  fi
}

trap stop_server EXIT

start_server

ATTEMPTS=30
until curl -sSf -o /tmp/app-root.html http://127.0.0.1:3000/ >/dev/null 2>&1; do
  ATTEMPTS=$((ATTEMPTS - 1))
  if [ "$ATTEMPTS" -le 0 ]; then
    echo "Server failed to respond on port 3000 within the expected time." >&2
    exit 1
  fi
  sleep 1
done

grep -q 'id="searchInput"' /tmp/app-root.html || { echo "Search input not found in rendered HTML." >&2; exit 1; }
grep -q 'id="productContainer"' /tmp/app-root.html || { echo "Product container not found in rendered HTML." >&2; exit 1; }

echo "All checks passed."
