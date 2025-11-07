FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    poppler-utils \
    imagemagick \
    qpdf \
    openssl \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Setup working directory
WORKDIR /app

# Copy the local source code
COPY . .

# Convert line endings and make the script executable
RUN dos2unix ghostpdfshield
RUN dos2unix src/core/*.sh
RUN dos2unix src/config/watermark_list.txt
RUN chmod +x ghostpdfshield

# Fix ImageMagick policy to allow PDF operations
RUN sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml

# Create workdir for mounting volumes
RUN mkdir -p workdir

# Default command
CMD ["./ghostpdfshield", "--help"]