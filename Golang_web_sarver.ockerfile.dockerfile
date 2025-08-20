#Golang web sarver Dockerfile


FROM golang:1.18-alpine
WORKDIR  /app
COPY go.mod go.sum
RUN go mod download
COPY . .
RUN go build -v -0 /usr/local/bin/app/. .
EXPOSE 8080
CMD ["main", "main.go"]