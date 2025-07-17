# ---------- 构建阶段 ----------
FROM golang:1.24.1 AS builder
COPY . /src
WORKDIR /src

ENV GOOS=linux \
    GOARCH=amd64 \
    CGO_ENABLED=0 \
    GOMEMLIMIT=7000MiB \
    GOMAXPROCS=4

# 下载并安装 gf CLI
RUN wget -qO gf https://github.com/gogf/gf/releases/latest/download/gf_linux_amd64 && \
    chmod +x gf && \
    ./gf install -y && \
    rm ./gf && \
    gf build -ew

# ---------- 运行阶段 ----------
FROM debian:stable-slim

ARG APP_NAME=gf-app
ENV APP_NAME=${APP_NAME}

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates netbase && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && apt-get autoclean -y

WORKDIR /app

# 把构建产物复制进来（假设二进制名为 main）
COPY --from=builder /src/main /app/main

# 入口：打印 APP_NAME
CMD ["sh", "-c", "echo \"Container started for ${APP_NAME}\""]
