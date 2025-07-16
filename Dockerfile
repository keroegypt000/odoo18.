FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    git \
    curl \
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
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m odoouser
ENV VIRTUAL_ENV=/home/odoouser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY . /app
WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x odoo-bin

USER odoouser

ENTRYPOINT ["python", "odoo-bin"]
CMD ["-c", "odoo.conf"]
