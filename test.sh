#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

PORT="${PORT:-3000}"

detect_next() {
  [[ -f package.json && -f app/page.tsx ]]
}

kill_port() {
  local port="$1"
  if command -v lsof >/dev/null 2>&1; then
    lsof -tiTCP:"$port" -sTCP:LISTEN | xargs -r kill -9 || true
  elif command -v fuser >/dev/null 2>&1; then
    fuser -k "$port"/tcp || true
  fi
}

start_server() {
  if detect_next; then
    LOG="/tmp/nextjs.log"
    nohup yarn dev -p "$PORT" > "$LOG" 2>&1 &
    SERVER_PID=$!
  else
    LOG="/tmp/html.log"
    nohup python3 -m http.server "$PORT" > "$LOG" 2>&1 &
    SERVER_PID=$!
  fi
}

cleanup() {
  kill_port "$PORT"
  if [[ -n "${SERVER_PID:-}" ]]; then
    kill "$SERVER_PID" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

./setup.sh

kill_port "$PORT"
start_server

echo "Waiting for server on http://localhost:$PORT ..."
for i in {1..60}; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT" || true)
  if [[ "$STATUS" == "200" ]]; then
    READY=1
    break
  fi
  sleep 1
done

if [[ -z "${READY:-}" ]]; then
  echo "Server did not become ready in time. Logs:" >&2
  tail -n 50 "$LOG" >&2 || true
  exit 1
fi

HTML=$(curl -s "http://localhost:$PORT")

if ! grep -q 'id="search-input"' <<<"$HTML"; then
  echo "Expected search input not found in HTML." >&2
  exit 1
fi

if ! grep -q 'id="product-list"' <<<"$HTML"; then
  echo "Expected product list container not found in HTML." >&2
  exit 1
fi

echo "All checks passed."
