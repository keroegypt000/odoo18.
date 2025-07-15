FROM python:3.10-slim

# تثبيت أدوات النظام المطلوبة
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
    wkhtmltopdf \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم جديد غير root
RUN useradd -m odoouser

# إنشاء بيئة افتراضية داخل مجلد قابل للكتابة
ENV VIRTUAL_ENV=/home/odoouser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# نسخ ملفات المشروع
COPY . /app
WORKDIR /app

# تثبيت الاعتمادات
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# إعطاء صلاحيات تنفيذ للملف odoo-bin
RUN chmod +x odoo-bin

# تعيين المستخدم الجديد لتشغيل الحاوية
USER odoouser

# تشغيل أودو مع تحميل قاعدة البيانات
CMD ["python", "odoo-bin", "-c", "odoo.conf", "-i", "base", "--db_host=postgres.railway.internal"]
