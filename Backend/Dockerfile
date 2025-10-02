FROM python:3.10-slim

WORKDIR /app

# Install system dependencies for debugging
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    netcat-openbsd \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt gunicorn

# Copy backend code
COPY . .

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "rds:app"]


