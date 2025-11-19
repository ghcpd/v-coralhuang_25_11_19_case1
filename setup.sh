#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

export NEXT_TELEMETRY_DISABLED="1"

echo "Installing project dependencies..."
npm install
