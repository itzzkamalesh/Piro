FROM ubuntu:latest

# Set Python version
ENV PYTHON_VERSION=3.12.4

# Install dependencies and build tools
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

# Download, compile, and install Python
RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make -j$(nproc) && \
    make altinstall && \
    cd / && \
    rm -rf Python-${PYTHON_VERSION}* 

# Set working directory
WORKDIR /app

# Copy application source
COPY . /app

# Install Python requirements
RUN python3.12 -m pip install --upgrade pip && \
    python3.12 -m pip install -r requirements.txt

# Expose any ports (if needed)
EXPOSE 8000

# Start the processes
CMD ["bash", "-c", "gunicorn app:app & python3.12 main.py & python3.12 ping.py"]
