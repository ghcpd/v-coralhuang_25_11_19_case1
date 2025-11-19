#!/bin/bash
set -e

echo "================================================"
echo "Product Browser - Automated Test Suite"
echo "================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test result
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

# Cleanup function
cleanup() {
    if [ ! -z "$SERVER_PID" ]; then
        echo ""
        echo "Stopping test server (PID: $SERVER_PID)..."
        kill $SERVER_PID 2>/dev/null || true
        wait $SERVER_PID 2>/dev/null || true
    fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Step 1: Verify dependencies
echo "Step 1: Verifying dependencies..."
if command -v python3 &> /dev/null; then
    print_result 0 "Python 3 is installed"
else
    print_result 1 "Python 3 is not installed"
    exit 1
fi

# Step 2: Check if index.html exists
echo ""
echo "Step 2: Checking project files..."
if [ -f "index.html" ]; then
    print_result 0 "index.html exists"
else
    print_result 1 "index.html not found"
    exit 1
fi

# Step 3: Start the server in background
echo ""
echo "Step 3: Starting test server..."
python3 -m http.server 3000 > /tmp/test-server.log 2>&1 &
SERVER_PID=$!
echo "Server started with PID: $SERVER_PID"

# Wait for server to be ready
echo "Waiting for server to be ready..."
MAX_ATTEMPTS=30
ATTEMPT=0
SERVER_READY=false

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        SERVER_READY=true
        break
    fi
    sleep 1
    ((ATTEMPT++))
    echo -n "."
done
echo ""

if [ "$SERVER_READY" = true ]; then
    print_result 0 "Server is responding on port 3000"
else
    print_result 1 "Server failed to start within 30 seconds"
    echo "Server log:"
    cat /tmp/test-server.log
    exit 1
fi

# Step 4: Test HTTP 200 response
echo ""
echo "Step 4: Testing HTTP responses..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/)
if [ "$HTTP_CODE" = "200" ]; then
    print_result 0 "GET / returns HTTP 200"
else
    print_result 1 "GET / returned HTTP $HTTP_CODE (expected 200)"
fi

# Step 5: Verify HTML content
echo ""
echo "Step 5: Verifying HTML content..."
HTML_CONTENT=$(curl -s http://localhost:3000/)

# Check for essential UI elements
if echo "$HTML_CONTENT" | grep -q "Product Browser"; then
    print_result 0 "Page title is present"
else
    print_result 1 "Page title not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"search\""; then
    print_result 0 "Search input is present"
else
    print_result 1 "Search input not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"category\""; then
    print_result 0 "Category filter is present"
else
    print_result 1 "Category filter not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"sort\""; then
    print_result 0 "Sort dropdown is present"
else
    print_result 1 "Sort dropdown not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"products\""; then
    print_result 0 "Products container is present"
else
    print_result 1 "Products container not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"loading\""; then
    print_result 0 "Loading state element is present"
else
    print_result 1 "Loading state not found"
fi

if echo "$HTML_CONTENT" | grep -q "id=\"empty-state\""; then
    print_result 0 "Empty state element is present"
else
    print_result 1 "Empty state not found"
fi

# Check for product data in JavaScript
if echo "$HTML_CONTENT" | grep -q "productsData"; then
    print_result 0 "Product data is defined"
else
    print_result 1 "Product data not found"
fi

# Check for Tailwind CSS
if echo "$HTML_CONTENT" | grep -q "tailwindcss"; then
    print_result 0 "Tailwind CSS is loaded"
else
    print_result 1 "Tailwind CSS not loaded"
fi

# Step 6: Final results
echo ""
echo "================================================"
echo "Test Results Summary"
echo "================================================"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
