#!/bin/bash
# start.sh

echo "=== Starting Application ==="

# Apply migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --no-input

# Start server
exec gunicorn --bind 0.0.0.0:$PORT course_project.wsgi:application