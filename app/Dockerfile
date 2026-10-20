# ---------- build the virtualenv ----------
FROM python:3.14-slim@sha256:a2b82f3c48559aa0a8446d9af49826b6e2b2016f4cd2afabfe6013ec53729170 AS builder

WORKDIR /build
COPY requirements.txt .
RUN python -m venv /opt/venv \
 && /opt/venv/bin/pip install --no-cache-dir --require-hashes -r requirements.txt

# ----------minimal runtime ----------
FROM python:3.14-slim@sha256:a2b82f3c48559aa0a8446d9af49826b6e2b2016f4cd2afabfe6013ec53729170 AS runtime

LABEL org.opencontainers.image.source="https://github.com/AlexCornej0/Devsu-technical-test" \
      org.opencontainers.image.title="demo-devops-python" \
      org.opencontainers.image.description="Django REST demo API for the Devsu DevOps technical test"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

RUN groupadd --system --gid 10001 app \
 && useradd --system --uid 10001 --gid app --no-create-home --shell /usr/sbin/nologin app \
 && mkdir -p /data \
 && chown app:app /data

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
COPY . .

RUN DJANGO_SECRET_KEY=build-only DATABASE_NAME=/tmp/build.sqlite3 \
    python manage.py collectstatic --noinput

USER 10001:10001
EXPOSE 8000

HEALTHCHECK --interval=35s --timeout=5s --start-period=10s --retries=3 \
  CMD ["python", "-c", "import sys, urllib.request; sys.exit(0 if urllib.request.urlopen('http://localhost:8000/health/live', timeout=3).status == 200 else 1)"]

CMD ["gunicorn", "demo.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "2", "--timeout", "30", "--worker-tmp-dir", "/dev/shm", "--access-logfile", "-", "--error-logfile", "-"]