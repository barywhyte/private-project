FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy dependency files
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy ALL project files
COPY app/ .

# Set environment variable for Django settings (pointing to prod)
ENV DJANGO_SETTINGS_MODULE=app.settings.prod
ENV PYTHONPATH=/app

# Expose port
EXPOSE 8000

# Start the Django app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi:application"]
