#!/bin/bash

# test.sh - Automated tests comparing broken vs fixed SSR output

echo "======================================"
echo "Running SSR Tests"
echo "======================================"
echo ""

# Install Playwright browsers if not already installed
echo "Installing Playwright browsers..."
npx playwright install chromium --with-deps

echo ""
echo "======================================"
echo "Building both versions..."
echo "======================================"

# Build both versions
echo "Building broken version..."
npm run build:broken

echo ""
echo "Building fixed version..."
npm run build:fixed

echo ""
echo "======================================"
echo "Running Playwright tests..."
echo "======================================"

# Run Playwright tests
npx playwright test

TEST_EXIT_CODE=$?

echo ""
echo "======================================"
echo "Test Results"
echo "======================================"

if [ $TEST_EXIT_CODE -eq 0 ]; then
  echo "✅ All tests passed!"
  echo ""
  echo "Summary:"
  echo "  - Broken version correctly fails SSR style checks"
  echo "  - Fixed version passes all SSR style checks"
  echo "  - No hydration warnings in fixed version"
  echo "  - Styles persist with JavaScript disabled"
else
  echo "❌ Some tests failed"
  echo "Check the output above for details"
fi

exit $TEST_EXIT_CODE
