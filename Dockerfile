FROM python:3.11.13-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY backend/ .
CMD ["python", "app.py"]
