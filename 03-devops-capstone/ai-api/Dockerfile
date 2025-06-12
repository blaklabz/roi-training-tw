FROM python:3.11-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all app code
COPY . .

# Accept background image at build time
ARG BACKGROUND_IMAGE
COPY images/${BACKGROUND_IMAGE} /app/static/background.jpg

EXPOSE 80
CMD ["python", "app.py"]
