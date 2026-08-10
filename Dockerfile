FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

RUN apt-get update -y && apt-get install -y \
    curl wget git unzip zip tar \
    ca-certificates gnupg lsb-release \
    build-essential \
    software-properties-common \
    jq nano vim htop \
    sqlite3 \
    ffmpeg \
    openssh-client \
    cron \
    supervisor \
    && rm -rf /var/lib/apt/lists/*

ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p $NVM_DIR && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
RUN . $NVM_DIR/nvm.sh && \
    nvm install 22 && \
    nvm alias default 22 && \
    npm install -g pnpm yarn bun
ENV PATH="$NVM_DIR/versions/node/v22.0.0/bin:$PATH"

RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update -y && \
    apt-get install -y \
      python3.11 python3.11-venv python3.11-distutils \
      python3.12 python3.12-venv python3.12-distutils \
      python3.13 python3.13-venv \
      python3-pip \
    && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13

RUN apt-get update -y && apt-get install -y \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 libasound2t64 \
    libpango-1.0-0 libcairo2 fonts-liberation \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --break-system-packages playwright && \
    python3 -m playwright install chromium --with-deps

RUN ARCH=$(dpkg --print-architecture) && \
    curl -Lo /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.${ARCH}" && \
    chmod +x /usr/local/bin/ttyd

RUN curl https://rclone.org/install.sh | bash

RUN ARCH=$(dpkg --print-architecture) && \
    curl -Lo /usr/local/bin/cloudflared "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}" && \
    chmod +x /usr/local/bin/cloudflared

WORKDIR /home/container
ENV HOME=/home/container
ENV USER=container

COPY entrypoint.sh /entrypoint.sh
COPY scripts/ /scripts/
RUN chmod +x /entrypoint.sh /scripts/*.sh

CMD ["/bin/bash", "/entrypoint.sh"]
