FROM python:3.14-slim

WORKDIR /app

# Install curl to download frontend assets (shared by every app built on this base)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
