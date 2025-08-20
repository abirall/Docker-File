#java Dockerfile


FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/myapp.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]