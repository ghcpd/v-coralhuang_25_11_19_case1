#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

detect_next() {
  [[ -f package.json && -f app/page.tsx ]]
}

maybe_install_with_apt() {
  if command -v apt-get >/dev/null 2>&1; then
    # best-effort; ignore failures if not root
    if [[ ${CI:-} == "true" ]]; then
      apt-get update -y && apt-get install -y python3 python3-pip curl lsof >/dev/null 2>&1 || true
    else
      sudo apt-get update -y && sudo apt-get install -y python3 python3-pip curl lsof >/dev/null 2>&1 || true
    fi
  fi
}

ensure_tool() {
  local tool="$1"
  local install_hint="$2"
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: $tool is required. $install_hint" >&2
    exit 1
  fi
}

maybe_install_with_apt

if detect_next; then
  ensure_tool npm "Install Node.js (https://nodejs.org/) to get npm."
  if command -v corepack >/dev/null 2>&1; then
    corepack enable || true
  fi

  if ! command -v yarn >/dev/null 2>&1; then
    echo "Yarn not found; installing globally via npm..."
    npm install -g yarn >/dev/null 2>&1 || {
      echo "Failed to install yarn. Install it manually and re-run." >&2
      exit 1
    }
  fi

  yarn install --frozen-lockfile >/dev/null 2>&1 || yarn install >/dev/null 2>&1
fi

ensure_tool python3 "Install python3 (e.g., apt-get install -y python3)."
ensure_tool curl "Install curl (e.g., apt-get install -y curl)."

echo "Setup complete."
