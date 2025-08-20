# simply Build React

FROM node:18-alpine as build
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build