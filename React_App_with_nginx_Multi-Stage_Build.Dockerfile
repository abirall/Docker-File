# React App with nginx Multi-Stage Build



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