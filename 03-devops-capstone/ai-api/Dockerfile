FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app.py .
COPY templates/ templates/
COPY static/ static/

# Accept background image at build time (optional)
ARG BACKGROUND_IMAGE
COPY images/${BACKGROUND_IMAGE} /app/static/bg.jpg

EXPOSE 80
CMD ["python", "app.py"]
