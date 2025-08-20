##8 Python Corn app Docker File



FROM python:3.9-slim
WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y cron
COPY crontab /etc/cron.d/my-cron
RUN chmod 0644 /etc/cron.d/my-cron && \
    crontab /etc/cron.d/my-cron
RUN touch /var/log/cron.log
EXPOSE 5000
CMD ["cron", "-f"]