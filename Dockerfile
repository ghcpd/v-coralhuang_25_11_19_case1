# syntax=docker/dockerfile:1
FROM node:20-bullseye

WORKDIR /app

COPY . .
RUN chmod +x setup.sh run.sh test.sh
RUN ./setup.sh

CMD ["./test.sh"]
