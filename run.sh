#!/usr/bin/env bash

set -e

echo "🚀 Starting Time Tracker Project..."

# =========================
# Load environment variables
# =========================
if [ -f ".env" ]; then
  echo "Loading .env file"
  export $(grep -v '^#' .env | xargs)
else
  echo "env file not found"
fi

# =========================
# Backend
# =========================
echo "🔧 Starting backend (FastAPI)..."

cd backend

# Run migrations (safe to run many times)
alembic upgrade head

# Start FastAPI
uvicorn app.main:app \
  --host ${HOST:-0.0.0.0} \
  --port ${PORT:-8000} \
  --reload
