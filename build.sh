#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies
pip install -r requirements.txt

# Create static directory
mkdir -p staticfiles

# Apply database migrations
python manage.py migrate

# Collect static files (continue even if it fails)
python manage.py collectstatic --no-input --clear || true

echo "Build completed successfully!"