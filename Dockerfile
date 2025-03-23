FROM --platform=$BUILDPLATFORM python:3.10.0-alpine@sha256:9e36371740748c3b72f10490a261a7d201a8e9f30bcd185769b37d3ca39dc2bd AS base

FROM base AS builder
RUN apk update \
    && apk add --no-cache g++ linux-headers \
    && rm -rf /var/cache/apk/*
# get packages
COPY requirements.txt .
RUN pip install -r requirements.txt

FROM base
# Enable unbuffered logging
ENV PYTHONUNBUFFERED=1

RUN apk update \
    && apk add --no-cache libstdc++ \
    && rm -rf /var/cache/apk/*

WORKDIR /app

# Grab packages from builder
COPY --from=builder /usr/local/lib/python3.12/ /usr/local/lib/python3.12/

# Add the application
COPY . .

# set listen port
ENV PORT "7860"
EXPOSE 7860

# Ensure Vector Store is intialised before app
RUN python store_index.py

CMD ["python", "app.py"]