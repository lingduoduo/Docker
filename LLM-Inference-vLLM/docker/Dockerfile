FROM python:3.11-slim

WORKDIR /app
COPY requirements-cpu.txt /app/requirements-cpu.txt
RUN pip install --no-cache-dir -r requirements-cpu.txt

COPY . /app
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
