FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . .

# Debug structure
RUN ls -la
RUN find . -name "manage.py" -type f

# Build steps directly in Dockerfile
RUN python manage.py collectstatic --no-input
RUN python manage.py makemigrations
RUN python manage.py migrate

# Expose port
EXPOSE $PORT

# Start server
CMD ["gunicorn", "--bind", "0.0.0.0:$PORT", "course_project.wsgi:application"]