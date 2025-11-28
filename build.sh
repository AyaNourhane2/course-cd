#!/usr/bin/env bash
# Exit on error
set -o errexit

echo "=== Starting build process ==="
echo "Current directory: $(pwd)"
echo "Python version: $(python --version)"
echo "Pip version: $(pip --version)"

echo "=== File structure ==="
ls -la

echo "=== Checking for manage.py ==="
if [ -f "manage.py" ]; then
    echo "✓ manage.py found in current directory"
else
    echo "✗ manage.py NOT found in current directory"
    echo "Searching for manage.py..."
    find . -name "manage.py" -type f
    exit 1
fi

echo "=== Installing dependencies ==="
pip install -r requirements.txt

echo "=== Checking Django configuration ==="
python -c "
import django
from django.conf import settings
print('Django version:', django.__version__)
try:
    print('DEBUG:', settings.DEBUG)
    print('ALLOWED_HOSTS:', settings.ALLOWED_HOSTS)
    print('Database:', settings.DATABASES['default']['ENGINE'])
    print('✓ Django settings are valid')
except Exception as e:
    print('✗ Django settings error:', e)
    exit(1)
"

echo "=== Collecting static files ==="
python manage.py collectstatic --no-input

echo "=== Making migrations ==="
python manage.py makemigrations

echo "=== Applying migrations ==="
python manage.py migrate

echo "=== Build completed successfully! ==="