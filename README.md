# Devsu DevOps Technical Test

## Overview
## Live URL
## Repository structure
## Run locally
Requires Python 3.14.
    cd app
    python -m venv .venv
    .venv\Scripts\Activate.ps1          # Windows;
    pip install --require-hashes -r requirements.txt -r requirements-dev.txt
    Copy-Item .env.example .env          # Linux/macOS: cp .env.example .env
    python manage.py migrate
    python manage.py test
    python manage.py runserver

Dependencies are declared in `requirements.in` / `requirements-dev.in` and locked with hashes by pip-tools:

pip-compile --generate-hashes --strip-extras -o requirements.txt requirements.in
## Environment variables
| Variable | Required | Default | Description |
| --- | --- | --- | --- |
| `DJANGO_SECRET_KEY` | yes | - | Django cryptographic key. Comes from a Kubernetes Secret in the cluster. |
| `DATABASE_NAME` | yes | - | SQLite file. Relative to `app/` locally; `/data/db.sqlite3` in containers. |
| `DJANGO_DEBUG` | no | `False` | Never `True` outside local development. |
| `DJANGO_ALLOWED_HOSTS` | no | empty | Comma-separated hosts Django will answer. Must include `localhost` (probes). |
| `DJANGO_LOG_LEVEL` | no | `INFO` | Root log level, written to stdout. |
## CI/CD pipeline
## Kubernetes resources
## Infrastructure as Code
## Security
## Evidence
## Design decisions and trade-offs
## Operations runbook
## Not done and why
## Production recommendations