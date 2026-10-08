FROM python:3.11-slim

WORKDIR /app

# Timezone database so TZ (e.g. Asia/Kuala_Lumpur) applies to log timestamps
RUN apt-get update && apt-get install -y --no-install-recommends tzdata && rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY SoluifyCopier.py .

# Runtime data volume
VOLUME ["/data"]
ENV DATA_DIR=/data

# Run interactively
CMD ["python", "-u", "SoluifyCopier.py"]
