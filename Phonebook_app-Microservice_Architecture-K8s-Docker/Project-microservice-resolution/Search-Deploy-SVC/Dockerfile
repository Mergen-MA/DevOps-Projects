FROM python:alpine
COPY requirements.txt requirements.txt
RUN pip install -r requirements
COPY . /phoneapp
WORKDIR /phoneapp
EXPOSE 80
CMD python /app.py