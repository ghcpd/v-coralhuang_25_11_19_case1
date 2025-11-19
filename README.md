# Product Browser (Static HTML)

A simple static product browsing UI with search, category filter, and price sorting. Built with Tailwind CSS and vanilla JavaScript.

## Features
- Responsive grid with product cards
- Search input filters products by name, description, and category
- Category filter dropdown
- Sort by price (ascending/descending)
- Simulated loading state and friendly empty state
- Automation scripts for setup, running, and testing

## Files
- `index.html` — main app entrypoint
- `setup.sh` — ensures prerequisites (python3, curl)
- `run.sh` — runs a local static server on port 3000
- `test.sh` — non-interactive checks for server and expected content
- `Dockerfile` — reproducible environment executing the `test.sh`
- `README.md` — this file
- `CHANGELOG.md` — change log

## How to run

Prerequisites: Python 3.8+, curl

Install dependencies (optional):

    bash ./setup.sh

Start a dev server:

    bash ./run.sh

Open http://localhost:3000/ in your browser.

Run automated checks:

    bash ./test.sh

Build and run Docker image (requires Docker):

    docker build -t product-browser .
    docker run --rm product-browser

## Design decisions & caveats
- Implemented as vanilla HTML/JS with Tailwind CDN for simplicity and portability.
- Product data is embedded in `index.html` for demo purposes; a real app would fetch data from an API.
- The `test.sh` script is intentionally conservative and non-destructive: it starts the server and kills it when done.

## License
MIT
