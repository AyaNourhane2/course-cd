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

# Expose port
EXPOSE $PORT

# Start server - TOUT DANS LA COMMANDE
CMD ["sh", "-c", "python manage.py migrate && python manage.py collectstatic --no-input && gunicorn --bind 0.0.0.0:$PORT course_project.wsgi:application"]