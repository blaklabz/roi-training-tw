FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source
COPY app.py .
COPY templates/ templates/
RUN mkdir -p static
COPY images/${BACKGROUND_IMAGE} static/background.jpg

# Expose and run
EXPOSE 80
CMD ["python", "app.py"]
