# Product Browser UI

Modern, responsive product browsing UI with search, category filter, price sorting, loading state, and empty state. Runs as a static HTML app (Tailwind CDN) with reusable scripts for setup, run, and test, plus a Docker image for reproducibility.

## Features
- **Product grid** with cards showing name, price, category, and description.
- **Search** across name, description, and category (case-insensitive).
- **Category filter** and **price sort (asc/desc)**.
- **Simulated loading state** on filter changes.
- **Friendly empty state** with reset button.
- **Responsive layout** (1/2/3 columns for mobile/tablet/desktop).
- **Accessibility**: labels, `aria-live` updates, focusable cards.

## Project Type
- Static HTML app (entrypoint: `index.html`).
- No build step required.

## Prerequisites
- Unix-like shell with `bash`
- `python3` (for static server)
- `curl` (for tests)
- Optional: `node`/`yarn` if you later convert to Next.js

## Quick Start
```bash
./setup.sh      # install prerequisites (best-effort) and dependencies
./run.sh        # start server on port 3000
# visit http://localhost:3000
```

## Tests
```bash
./test.sh       # runs setup, starts server, waits for readiness, asserts key elements
```

## Scripts
- `setup.sh` — installs dependencies (yarn if Next.js detected) and ensures `python3`/`curl`.
- `run.sh` — detects Next.js (`app/page.tsx`) vs static; starts appropriate server on port `3000`.
- `test.sh` — ensures setup, starts server, polls readiness, verifies HTML contains `search-input` and `product-list`.

Logs:
- Static: `/tmp/html.log`
- Next.js: `/tmp/nextjs.log`

## Docker
```bash
docker build -t product-browser .
docker run --rm -p 3000:3000 product-browser
# container runs ./test.sh by default
```

## Design Notes
- Chose **static HTML + Tailwind CDN** for simplicity and zero build.
- Simulated loading via `setTimeout` (350ms) on filter changes.
- IDs `search-input` and `product-list` are stable for tests and automation.

## Windows Notes
- Use WSL or Git Bash to run the scripts, or open `index.html` directly in a browser for a quick view.

## Troubleshooting
- If port 3000 is busy, scripts attempt to free it (`lsof`/`fuser` if available).
- Check logs in `/tmp/html.log` or `/tmp/nextjs.log` when servers fail to start.
