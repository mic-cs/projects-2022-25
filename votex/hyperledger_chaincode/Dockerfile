FROM golang:1-20-alpine
WORKDIR /app
COPY . .
RUN go mod init chaincode && go mod tidy && go build -o chaincode

FROM alpine:latest
WORKDIR /chaincode
ENTRYPOINT [ "./chaincode" ]
