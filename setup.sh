#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$THIS_DIR"

missing_tools=()

command -v python3 >/dev/null 2>&1 || missing_tools+=("python3")
command -v curl >/dev/null 2>&1 || missing_tools+=("curl")

if [ ${#missing_tools[@]} -ne 0 ]; then
  echo "The following required tools are missing: ${missing_tools[*]}" >&2
  echo "Please install them and re-run setup." >&2
  exit 1
fi

echo "Environment verified. No additional dependencies required for the static app."
