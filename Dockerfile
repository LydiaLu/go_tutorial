FROM alpine:3.20
WORKDIR /app
COPY . .
CMD ["sh", "-c", "echo 'QA image OK' && sleep 30"]