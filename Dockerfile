# Product Browser - Dockerfile
# This Dockerfile creates a reproducible environment for testing the application

FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY index.html .
COPY setup.sh .
COPY run.sh .
COPY test.sh .

# Make scripts executable
RUN chmod +x setup.sh run.sh test.sh

# Run setup to verify dependencies
RUN ./setup.sh

# Expose port 3000
EXPOSE 3000

# Health check
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/ || exit 1

# Run tests by default
CMD ["./test.sh"]
