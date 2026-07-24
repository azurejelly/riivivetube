FROM python:3.12-slim-trixie

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl ffmpeg openjdk-21-jre-headless \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p flvcache
RUN chmod +x scripts/docker-entrypoint.sh

EXPOSE 5005/tcp

ENTRYPOINT ["scripts/docker-entrypoint.sh"]

CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5005", "main:app"]
