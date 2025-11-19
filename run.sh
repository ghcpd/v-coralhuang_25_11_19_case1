#!/bin/bash
set -e

echo "================================================"
echo "Product Browser - Starting Development Server"
echo "================================================"
echo ""

# Check if index.html exists
if [ ! -f "index.html" ]; then
    echo "✗ Error: index.html not found in current directory"
    exit 1
fi

echo "Starting server on http://localhost:3000"
echo "Press Ctrl+C to stop the server"
echo ""

# Start Python HTTP server on port 3000
python3 -m http.server 3000
