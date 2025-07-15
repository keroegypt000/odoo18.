RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    libxml2-dev \
    libxslt1-dev \
    libldap2-dev \
    libsasl2-dev \
    libpq-dev \
    libjpeg-dev \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    build-essential \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*
