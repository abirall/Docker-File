# React Frontend + Node.js Backend Dockerfile


#Stage1
FROM node:18-slim
WORKDIR /app
COPY package.json .
RUN npm install
COPY frontend
RUN npm run build

#stage2
FROM nginx
COPY nginx/nginx.conf/ etc/nginx/conf.d/defult
RUN rm/etc/nginx/conf.d/defult/conf
COPY --from=builder /app/build /usr/share/nginx
EXPOSE 80