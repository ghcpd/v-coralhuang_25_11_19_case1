#!/bin/bash

# run.sh - Launch dev or production server to observe both broken and fixed version behavior

MODE="${1:-dev}"

echo "============================================"
echo "Running Next.js servers in $MODE mode"
echo "============================================"
echo ""

if [ "$MODE" = "dev" ]; then
  echo "Starting BROKEN version on http://localhost:3000"
  echo "Starting FIXED version on http://localhost:3001"
  echo ""
  echo "Press Ctrl+C to stop both servers"
  echo ""
  
  # Run both dev servers in parallel
  npm run dev:broken &
  BROKEN_PID=$!
  
  npm run dev:fixed &
  FIXED_PID=$!
  
  # Wait for both processes
  wait $BROKEN_PID $FIXED_PID
  
elif [ "$MODE" = "prod" ]; then
  echo "Building both versions..."
  npm run build:broken
  npm run build:fixed
  
  echo ""
  echo "Starting BROKEN version on http://localhost:3000"
  echo "Starting FIXED version on http://localhost:3001"
  echo ""
  echo "Press Ctrl+C to stop both servers"
  echo ""
  
  # Run both production servers in parallel
  npm run start:broken &
  BROKEN_PID=$!
  
  npm run start:fixed &
  FIXED_PID=$!
  
  # Wait for both processes
  wait $BROKEN_PID $FIXED_PID
  
else
  echo "Usage: ./run.sh [dev|prod]"
  echo "  dev  - Start development servers (default)"
  echo "  prod - Build and start production servers"
  exit 1
fi
