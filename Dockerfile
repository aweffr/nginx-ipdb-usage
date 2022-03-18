FROM ubuntu:20.04

ENV NGINX_VERSION 1.18.0

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse \n\
deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \n\
deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse \n\
" > /etc/apt/sources.list && cat /etc/apt/sources.list


RUN apt update -y && \
  apt install -y build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev && \
  apt install -y curl libjson-c-dev

# 网络状况良好时
RUN mkdir -p /tmp && \ 
  curl -sSL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz -o /tmp/nginx-${NGINX_VERSION}.tar.gz && \
  cd /tmp && \
  tar -zxvf nginx-${NGINX_VERSION}.tar.gz

ADD nginx-archive/ngx_http_ipdb_module.tar.gz /tmp

RUN find /tmp

RUN cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure --prefix=/usr/sbin/nginx --add-dynamic-module=/tmp/ngx_http_ipdb_module --with-compat --with-cc-opt="-Wno-implicit-fallthrough -Wno-unused-result" && \
  make && \
  mkdir -p /build && \
  echo "ngx_http_ipdb_module.so md5: $(md5sum /tmp/nginx-${NGINX_VERSION}/objs/ngx_http_ipdb_module.so)" > /tmp/nginx-${NGINX_VERSION}/ngx_http_ipdb_module_${NGINX_VERSION}.so.md5

RUN echo "\n\
cp /tmp/nginx-${NGINX_VERSION}/objs/ngx_http_ipdb_module.so /build/ngx_http_ipdb_module_${NGINX_VERSION}.so \n\
cp /tmp/nginx-${NGINX_VERSION}/ngx_http_ipdb_module_${NGINX_VERSION}.so.md5 /build/ \n\
" > /run.sh

ENTRYPOINT [ "/bin/bash", "/run.sh" ]