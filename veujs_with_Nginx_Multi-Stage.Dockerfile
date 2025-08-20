# veujs app with Nginx Multi-Stage Dockerfile



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