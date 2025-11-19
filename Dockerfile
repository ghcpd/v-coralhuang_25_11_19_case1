FROM node:20-bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends python3 python3-pip curl lsof \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY . .

RUN chmod +x setup.sh run.sh test.sh
RUN ./setup.sh

EXPOSE 3000

CMD ["./test.sh"]
