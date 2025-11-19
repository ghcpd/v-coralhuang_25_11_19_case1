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

kill_port "$PORT"

if detect_next; then
  LOG="/tmp/nextjs.log"
  echo "Starting Next.js dev server on port $PORT... (logs: $LOG)"
  nohup yarn dev -p "$PORT" > "$LOG" 2>&1 &
  echo $! > /tmp/nextjs.pid
else
  LOG="/tmp/html.log"
  echo "Starting static server on port $PORT... (logs: $LOG)"
  nohup python3 -m http.server "$PORT" > "$LOG" 2>&1 &
  echo $! > /tmp/html.pid
fi

echo "Server started."
