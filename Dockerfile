# Stage 1: build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: runtime
FROM python:3.11-slim
WORKDIR /app

# Create a non-root user
RUN useradd --create-home --uid 1001 appuser
COPY --from=builder /install /usr/local
COPY app.py .
USER 1001

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8080/healthz')"]
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
