# Use Debian-based Python 3.10 slim image
FROM --platform=$BUILDPLATFORM python:3.10-slim AS base

# Builder stage for installing dependencies
FROM base AS builder

# Install required system packages for building dependencies
RUN apt-get update && apt-get install -y \
    gcc libffi-dev python3-dev rustc cargo \
    && rm -rf /var/lib/apt/lists/*

# Set working directory for dependencies
WORKDIR /dependencies

# Copy dependency files
COPY requirements.txt setup.py ./

# Install dependencies in a temporary directory with binary wheels
RUN pip install --no-cache-dir -r requirements.txt --target /dependencies/python --only-binary=:all:

# Final runtime stage
FROM base

# Enable unbuffered logging
ENV PYTHONUNBUFFERED=1

# runtime dependencies (minimal system packages)
RUN apt-get update && apt-get install -y libffi-dev && rm -rf /var/lib/apt/lists/*

# Set working directory for the application
WORKDIR /app

# Copy installed dependencies from builder stage
COPY --from=builder /dependencies/python /usr/local/lib/python3.10/site-packages/

# Copy application code
COPY . .

# Set listen port
ENV PORT "7860"
EXPOSE 7860

# Ensure Vector Store is initialized before app runs
ENTRYPOINT ["sh", "-c", "python store_index.py && exec python app.py"]
