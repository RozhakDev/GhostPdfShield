FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    poppler-utils \
    imagemagick \
    qpdf \
    git \
    && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /app

# Clone GhostPdfShield
RUN git clone https://github.com/RozhakDev/GhostPdfShield.git .
RUN chmod +x ghostpdfshield

# Default command
CMD ["./ghostpdfshield", "--help"]