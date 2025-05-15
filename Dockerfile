# Use official Python 3.12.4 image
FROM python:3.12.4-slim

# Install system dependencies
RUN apt update && \
    apt upgrade -y && \
    apt install -y curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set application working directory
WORKDIR /app

# Copy application source code
COPY . /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose application port (adjust if needed)
EXPOSE 8000

# Run Gunicorn and Python scripts concurrently
CMD ["bash", "-c", "gunicorn app:app & python3 main.py & python3 ping.py"]
