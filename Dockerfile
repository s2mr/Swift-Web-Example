FROM python:3.9-slim-buster
WORKDIR /app
COPY Bundle ./Bundle
ENTRYPOINT [ "python3", "-m", "http.server", "--directory", "Bundle" ]
