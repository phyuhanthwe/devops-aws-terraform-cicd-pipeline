FROM python:3.12.5-slim

WORKDIR /fastapi-app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY ./app ./app

COPY ./static ./static

# CMD [ "uvicorn", "app.main:app", "--reload" ]
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]