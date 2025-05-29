FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV DJANGO_SETTINGS_MODULE=app.settings

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app.wsgi:application"]
EXPOSE 8000