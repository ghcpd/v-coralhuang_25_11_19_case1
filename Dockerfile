FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN chmod +x ./test.sh ./run.sh ./setup.sh || true
RUN ./setup.sh || true
CMD ["/bin/bash", "./test.sh"]