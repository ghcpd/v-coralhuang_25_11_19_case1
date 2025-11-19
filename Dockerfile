FROM python:3.11-slim

# Install curl and lsof
RUN apt-get update && apt-get install -y curl lsof && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

RUN chmod +x setup.sh run.sh test.sh

# Run tests during build to validate the static app
CMD ["/bin/bash", "-lc", "./test.sh"]
