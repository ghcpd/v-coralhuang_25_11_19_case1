FROM python:3.11-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

COPY . .

RUN chmod +x setup.sh run.sh test.sh \
    && ./setup.sh

EXPOSE 3000

CMD ["./test.sh"]
