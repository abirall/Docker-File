
#1
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


#2 
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]


#3
# Stage 1 - Build React App
FROM node:18-alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build

# Stage 2 - Serve with Nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]



#4 Python Flask Aapp
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]


#5 React App with Multi-Stage Build
#stage 1
FROM node:18-alpine as build
WORKDIR /app
COPY package.json .
RUN npm install 
RUN npm run build
#stage 2
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "deamon off";]



#7 Run a HTML CSS app
FROM httpd:alpine
COPY . /usr/local/apache2/htdocs/
EXPOSE 80




#8 Python Corn app
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


#9 veu.js app with Nginx
#stage 1
FROM node:18-alpine as build
WORKDIR /app
COPY package.json .
RUN npm install
RUN npm run Build
#stage 2
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD {"nginx", "-g", "deamon off;"}





#10 Task run a go (Golang) web sarver                                                                                                           
FROM golang:1.18-alpine
WORKDIR  /app
COPY go.mod go.sum
RUN go mod download
COPY . .
RUN go build -v -0 /usr/local/bin/app/. .
EXPOSE 8080
CMD ["main", "main.go"]



#1. Lets make a Node.js Express app
#The Docker file
FROM node:18-alpine
WORKDIR /app
COPY . .
RUN npm install
EXPOSE 3000
CMD ["node", "sarver.js"]


#2. Django + PostgreSQL web app
#The Dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 3600
CMD ["python", "manage.py"]


#3: React Frontend + Node.js Backend Dockerfile
#The Docker file
FROM node:18-slim
WORKDIR /app
COPY package.json .
RUN npm install
COPY frontend
RUN npm run build

FROM nginx
COPY nginx/nginx.conf/ etc/nginx/conf.d/defult
RUN rm/etc/nginx/conf.d/defult/conf
COPY --from=builder /app/build /usr/share/nginx
EXPOSE 80


#Task 4: PHP Laravel App + MySQL
#the  Dockerfile
FROM composer:latest AS composer
FROM php:8.2-fpm
WORKDIR /var/www/html
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY . .
RUN composer install --no-dev --optimize-autoloader
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html
EXPOSE 9000
CMD ["php-fpm"]

------------------------------------


FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

#12
FROM redis:6.2-alpine
COPY redis.conf /usr/local/etc/redis/redis.conf
CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]


#13 java Dockerfile
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/myapp.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]


#14
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApi.dll"]

