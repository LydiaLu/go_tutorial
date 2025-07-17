FROM golang:1.24.1 AS builder

COPY . /src
WORKDIR /src

ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=0

ENV GOMEMLIMIT=7000MiB
ENV GOMAXPROCS=4

# 使用GoFrame CLI构建应用
RUN wget -O gf https://github.com/gogf/gf/releases/latest/download/gf_linux_amd64 && \
    chmod +x gf && \
    ./gf install -y && \
    rm ./gf && \
    gf build -ew

FROM debian:stable-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    netbase \
    && rm -rf /var/lib/apt/lists/ \
    && apt-get autoremove -y && apt-get autoclean -y

# 创建工作目录
ENV WORKDIR /app
WORKDIR $WORKDIR
