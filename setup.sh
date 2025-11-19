#!/bin/bash
set -e

echo "================================================"
echo "Product Browser - Setup Script"
echo "================================================"
echo ""

# Check if Python 3 is installed
echo "Checking for Python 3..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✓ Found: $PYTHON_VERSION"
else
    echo "✗ Python 3 is not installed"
    echo ""
    echo "Please install Python 3:"
    echo "  - Ubuntu/Debian: sudo apt-get update && sudo apt-get install -y python3"
    echo "  - macOS: brew install python3"
    echo "  - Windows: Download from https://www.python.org/downloads/"
    exit 1
fi

echo ""
echo "================================================"
echo "Setup Complete!"
echo "================================================"
echo ""
echo "All dependencies are ready."
echo "Run './run.sh' to start the development server."
echo ""
