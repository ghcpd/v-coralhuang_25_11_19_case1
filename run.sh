#!/usr/bin/env bash
# Start the static server on port 3000
set -e
PORT=3000
if [ -f package.json ]; then
  echo "No Next.js detected; starting simple static server"
fi
nohup python3 -m http.server "$PORT" > /tmp/html.log 2>&1 &
PID=$!
echo "Server started (pid $PID). Check http://localhost:$PORT"
sleep 1
cat /tmp/html.log | tail -n 10 || true