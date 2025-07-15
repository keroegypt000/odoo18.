FROM python:3.10-slim

# تثبيت أدوات النظام المطلوبة
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
    libjpeg8-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    build-essential \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# إنشاء بيئة افتراضية
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# نسخ ملفات المشروع
COPY . /app
WORKDIR /app

# تثبيت الاعتمادات
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# إعطاء صلاحيات تنفيذ للملف odoo-bin إن لم يكن قابل للتنفيذ
RUN chmod +x odoo-bin

# تشغيل أودو
CMD ["python", "odoo-bin", "-c", "odoo.conf"]
