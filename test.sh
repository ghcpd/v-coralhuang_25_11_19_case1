#!/usr/bin/env bash
set -euo pipefail

# Non-interactive test script for static HTML app
ROOT_DIR=$(pwd)
PORT=3000
LOG=/tmp/html.log

# Ensure setup
bash ./setup.sh

# Start server
nohup python3 -m http.server ${PORT} > ${LOG} 2>&1 &
SERVER_PID=$!

cleanup() {
  echo "Stopping server ${SERVER_PID}..."
  kill ${SERVER_PID} || true
}
trap cleanup EXIT

# Wait for up to 30 seconds for HTTP 200
URL="http://localhost:${PORT}/"
STATUS=0
TRIES=0

while [ ${TRIES} -lt 30 ]; do
  HTTP_CODE=$(curl -s -o /tmp/html_output -w "%{http_code}" ${URL} || true)
  if [ "${HTTP_CODE}" = "200" ]; then
    STATUS=200
    break
  fi
  TRIES=$((TRIES+1))
  sleep 1
done

if [ "${STATUS}" != "200" ]; then
  echo "Server did not return HTTP 200 after timeout. Check logs: ${LOG}"
  cat ${LOG} || true
  exit 1
fi

echo "Server returned 200 OK. Running content checks..."

HTML=$(cat /tmp/html_output)

# Basic checks
if ! echo "$HTML" | grep -q "Product Browser"; then
  echo "Missing title 'Product Browser'"
  exit 2
fi

if ! echo "$HTML" | grep -q "id=\"search\""; then
  echo "Missing search input"
  exit 3
fi

if ! echo "$HTML" | grep -q "id=\"products\""; then
  echo "Missing products container"
  exit 4
fi

# Success
echo "All checks passed."
exit 0