FROM python:3.10-slim

# تثبيت أدوات النظام المطلوبة لمكتبات أودو (libpq-dev وغيرها)
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

# إنشاء مستخدم جديد غير root
RUN useradd -m odoouser

# إنشاء بيئة افتراضية في مجلد المستخدم الجديد
ENV VIRTUAL_ENV=/home/odoouser/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# نسخ ملفات المشروع إلى مجلد العمل
COPY . /app
WORKDIR /app

# نسخ ملف المتطلبات
COPY requirements.txt .

# تحديث pip و setuptools و wheel
RUN pip install --upgrade pip setuptools wheel

# تثبيت المتطلبات بدون استخدام الكاش
RUN pip install --no-cache-dir -r requirements.txt

# إعطاء صلاحيات تنفيذ للملف الرئيسي
RUN chmod +x odoo-bin

# تعيين المستخدم الذي سيشغل الحاوية
USER odoouser

# الأمر الافتراضي لتشغيل أودو (عدل الخيارات حسب الحاجة)
CMD ["python", "odoo-bin", "-c", "odoo.conf", "-i", "base", "--db_host=postgres.railway.internal"]
