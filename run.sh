#!/usr/bin/env bash
set -euo pipefail

PORT=3000
LOG=/tmp/html.log

# Kill any process listening on port 3000 (best effort)
if lsof -i :${PORT} >/dev/null 2>&1; then
  echo "Killing process on port ${PORT}..."
  lsof -ti :${PORT} | xargs -r kill
fi

# Start a simple static file server
nohup python3 -m http.server ${PORT} > ${LOG} 2>&1 &
SERVER_PID=$!

echo "Started static server (PID: ${SERVER_PID}). Logs: ${LOG}"

echo "Use: tail -f ${LOG}"