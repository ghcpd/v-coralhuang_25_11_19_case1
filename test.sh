#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

export NEXT_TELEMETRY_DISABLED="1"

if command -v node >/dev/null 2>&1; then
	NODE_BIN="node"
elif command -v node.exe >/dev/null 2>&1; then
	NODE_BIN="node.exe"
else
	echo "Node.js executable not found on PATH." >&2
	exit 1
fi

"$NODE_BIN" scripts/run-tests.mjs "$@"
