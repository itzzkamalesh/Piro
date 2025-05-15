FROM ubuntu:latest

# Install system dependencies and build tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        wget \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libncurses5-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        git \
        curl && \
    rm -rf /var/lib/apt/lists/*

# Download, compile, and install Python 3.12.4
RUN wget https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz && \
    tar -xzf Python-3.12.4.tgz && \
    cd Python-3.12.4 && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd / && \
    rm -rf Python-3.12.4* 

# Set application working directory
WORKDIR /app

# Copy application source code
COPY . /app

# Install Python dependencies
RUN python3.12 -m pip install --upgrade pip && \
    python3.12 -m pip install -r requirements.txt

# Expose application port (adjust if needed)
EXPOSE 8000

# Run Gunicorn and Python scripts concurrently
CMD ["bash", "-c", "gunicorn app:app & python3.12 main.py & python3.12 ping.py"]
