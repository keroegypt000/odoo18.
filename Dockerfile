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
    fonts-dejavu-core \
    libxrender1 \
    libxext6 \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# تثبيت wkhtmltopdf (نسخة متوافقة مع Odoo)
RUN curl -L -o wkhtmltox.deb https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.bookworm_amd64.deb && \
    apt install -y ./wkhtmltox.deb && \
    rm wkhtmltox.deb

# إنشاء مستخدم غير root
RUN useradd -m odoouser

# إنشاء بيئة افتراضية داخل مجلد قابل للكتابة
ENV VIRTUAL_ENV=/home/odoouser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PIP_NO_CACHE_DIR=1

# نسخ ملفات المشروع
COPY . /app
WORKDIR /app

# تثبيت الاعتمادات
COPY requirements.txt . 
RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt

# إعطاء صلاحيات تنفيذ للملف odoo-bin
RUN chmod +x odoo-bin

# تغيير صلاحية ملفات المشروع للمستخدم odoouser
RUN chown -R odoouser:odoouser /app

# تعيين المستخدم odoouser لتشغيل الحاوية
USER odoouser

# تشغيل أودو تلقائيًا وتثبيت الـ base module عند أول تشغيل
CMD ["python", "odoo-bin", "-c", "odoo.conf", "-i", "base", "--db_host=postgres.railway.internal", "--db_user=odoo_user", "--db_password=odoo_pass123"]
