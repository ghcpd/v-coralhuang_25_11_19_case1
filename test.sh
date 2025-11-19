#!/usr/bin/env bash
set -e
./setup.sh
./run.sh
# Wait for server
sleep 2
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/input.html)
if [ "$STATUS" != "200" ]; then
  echo "Server not ready or returned $STATUS" >&2
  tail -n 50 /tmp/html.log
  exit 1
fi
# Check for expected elements in the HTML
HTML=$(curl -s http://localhost:3000/input.html)
if ! echo "$HTML" | grep -q "id=\"search\""; then
  echo "Search input not found" >&2
  exit 2
fi
if ! echo "$HTML" | grep -q "id=\"products\""; then
  echo "Products container not found" >&2
  exit 3
fi
# All checks passed
echo "Checks passed. HTTP 200 and expected UI elements present."