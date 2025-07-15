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
    libjpeg62-turbo-dev \
    liblcms2-dev \
    libblas-dev \
    libatlas-base-dev \
    build-essential \
    python3-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# إنشاء مستخدم غير root لتشغيل أودو (لتجنب تحذيرات الأمان)
RUN useradd -m odoouser
USER odoouser

# إنشاء بيئة افتراضية
ENV VIRTUAL_ENV=/opt/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# نسخ ملفات المشروع
COPY --chown=odoouser:odoouser . /app
WORKDIR /app

# تثبيت الاعتمادات
COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# تثبيت الاعتماديات اللي ظهرت مفقودة (rjsmin, pyopenssl)
RUN pip install rjsmin pyopenssl

# إعطاء صلاحيات تنفيذ للملف odoo-bin
RUN chmod +x odoo-bin

# أمر بدء تشغيل مخصص:
# 1. يهيئ قاعدة البيانات إذا كانت جديدة (يعمل تثبيت base module)
# 2. ثم يبدأ أودو بشكل عادي

CMD ["sh", "-c", "\
    if ! psql \"$PGDATABASE\" -h \"$PGHOST\" -U \"$PGUSER\" -c '\\q' 2>/dev/null; then \
        echo 'Initializing database...'; \
        python odoo-bin -c odoo.conf -d $PGDATABASE -i base --stop-after-init; \
    fi; \
    python odoo-bin -c odoo.conf -d $PGDATABASE"]
