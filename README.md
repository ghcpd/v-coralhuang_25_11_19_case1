# Product Browser (Static HTML)

A minimal static product browsing UI with search, category filters, sorting and simulated loading.

How to run:

- Setup: ./setup.sh
- Start server: ./run.sh
- Run tests: ./test.sh

Docker:

- docker build -t product-browser .
- docker run --rm product-browser

Design notes: Uses Tailwind CDN for quick styling and a small JS app to render products and handle filters.
