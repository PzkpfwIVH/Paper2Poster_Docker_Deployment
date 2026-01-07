FROM nvidia/cuda:12.6.0-devel-ubuntu24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Configure apt to use multiple mirrors and retry
RUN echo 'Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::http::Timeout "30";' >> /etc/apt/apt.conf.d/80-retries && \
    echo 'Acquire::ftp::Timeout "30";' >> /etc/apt/apt.conf.d/80-retries

# Update package list with retries and install system dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y --fix-missing --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    libreoffice \
    default-jre \
    poppler-utils \
    git \
    curl \
    ca-certificates \
    libgl1 \
    libglib2.0-0t64 \
    libgomp1 \
    fonts-dejavu \
    fonts-dejavu-core \
    fonts-dejavu-extra \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a symbolic link for python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Set working directory
WORKDIR /app

# Copy local repository contents (includes latest fixes)
COPY . .

# Install full Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt

# Create data directory for mounting
RUN mkdir -p /data

# Create startup script
RUN echo '#!/bin/bash\necho "DEEPINFRA_API_KEY=\"sk-dbdc402d7daa4097a2b8205da61ff1ec\"\nOPENAI_API_KEY=\"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\"\nJINA_API_KEY=\"jina_40412a08bb224896a9541c760209318fOWbQb79ZEq9OpFZM1Dth-x6lefZi\"" > /app/.env\ncd /app\nexport PYTHONPATH=/app:$PYTHONPATH\nexec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command (can be overridden)
CMD ["python", "-m", "PosterAgent.new_pipeline", "--help"]
