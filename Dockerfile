FROM ubuntu:latest

# Install system dependencies and build tools
RUN apt update && \
    apt upgrade -y && \
    apt install -y python3 python3-pip curl

# Set application working directory
WORKDIR /app

# Copy application source code
COPY . /app

# Install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt --break-system-packages

# Expose application port (adjust if needed)
EXPOSE 8000

# Run Gunicorn and Python scripts concurrently
CMD ["bash", "-c", "gunicorn app:app & python3 main.py & python3 ping.py"]
