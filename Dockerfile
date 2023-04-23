FROM python:3.9-slim-buster

ENV VIRTUAL_PORT 8000
ENV VIRTUAL_HOST swift.s2mr.jp
ENV LETSENCRYPT_HOST swift.s2mr.jp
ENV LETSENCRYPT_EMAIL kazu.devapp@gmail.com

WORKDIR /app
COPY Bundle ./Bundle
ENTRYPOINT [ "python3", "-m", "http.server", "--directory", "Bundle" ]
