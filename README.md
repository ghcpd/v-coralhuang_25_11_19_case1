# Product Explorer

A modern, responsive product browsing interface built as a static HTML experience enhanced with Tailwind CSS and vanilla JavaScript. The UI supports instant searching, category filtering, price sorting, simulated loading feedback, and a friendly empty state for unmatched results.

## Features
- Responsive card grid that adapts from mobile to desktop layouts
- Search-as-you-type filtering across product names and descriptions
- Category filter and multiple sorting strategies (featured, price, alphabetical)
- Simulated loading indicator, disabled controls, and accessible `aria-live` updates
- Empty-state messaging when no products satisfy the active filters

## Prerequisites
Ensure the following tooling is available:
- `python3`
- `curl`

The helper scripts validate these dependencies automatically.

## Setup
```bash
./setup.sh
```
Runs prerequisite checks and prepares the environment (no additional installs required for the static app).

## Run the Dev Server
```bash
./run.sh
```
- Detects whether the workspace is a Next.js project or a static site.
- For this static build, starts `python3 -m http.server` on port `3000`.

Visit http://localhost:3000 to explore the UI.

## Automated Tests
```bash
./test.sh
```
- Verifies prerequisites
- Starts the server in the background
- Polls `http://127.0.0.1:3000/` for readiness
- Asserts an HTTP 200 response and checks that critical UI elements render in the served HTML

## Docker
Build the containerized test runner and execute it:
```bash
docker build -t product-explorer .
docker run --rm -p 3000:3000 product-explorer
```
`CMD` within the image runs `./test.sh`, ensuring the application and smoke tests succeed inside the container.

## Project Structure
```
index.html      # Main application entry point
input.html      # Redirect shim for legacy references
setup.sh        # Environment verification
run.sh          # Dev server launcher
test.sh         # Smoke-test harness with HTTP assertions
Dockerfile      # Reproducible environment definition
README.md       # Project documentation
CHANGELOG.md    # High-level change log
```

## Design Notes
- Tailwind CSS CDN keeps the stack lightweight while enabling modern styling.
- Debounced search minimizes unnecessary filter executions as the user types.
- A simulated latency window (360 ms) creates a tangible loading state without external APIs.
- All interactive controls are disabled while loading to avoid conflicting requests.
- The UI announces state changes via `aria-live` and `aria-busy` attributes for assistive technologies.
