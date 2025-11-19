#!/usr/bin/env sh
set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 input|fixed [dev|prod] [port]" >&2
  exit 1
fi

target="$1"
mode="${2:-dev}"
port="${3:-3000}"

case "$target" in
  input|fixed)
    ;;
  *)
    echo "Unknown target: $target" >&2
    exit 1
    ;;
esac

export NEXT_TELEMETRY_DISABLED="1"

if [ "$mode" = "dev" ]; then
  echo "Starting $target in development mode on port $port..."
  exec npx next dev "$target" --port "$port"
fi

if [ "$mode" = "prod" ] || [ "$mode" = "production" ]; then
  echo "Building $target for production..."
  npx next build "$target" --no-lint
  echo "Starting $target in production mode on port $port..."
  exec npx next start "$target" --port "$port"
fi

echo "Unknown mode: $mode" >&2
exit 1
