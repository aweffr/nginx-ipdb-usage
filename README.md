# 如何在nginx中使用ipdb

ipdb有一个社区项目 [ngx_http_ipdb_module](https://github.com/vislee/ngx_http_ipdb_module).

由于项目没有提供编译后的版本, 遂折腾了一下, 得到了编译的动态库, 并且在nginx中能够正常使用。

为了可复现的构建过程，并适配多个nginx版本，遂有了使用Dockerfile来构建的想法。使用方法如下:

```bash
# 本地构建镜像(编译so)
docker build -t nginx-ipdb:0.1 .

# 从镜像中拷贝so文件到宿主机的build/目录
docker-compose up
```

此外，之所以会调研ipdb是为了简单地保护一下我个人项目的API，让其仅能在城市地区访问。

经验证ipdb的试用数据库能满足使用要求。nginx配置代码段见[nginx-conf-to-limit-by-region.conf](./nginx-conf-to-limit-by-region.conf)。

ipdb试用数据库下载地址(需注册)[下载地址](http://www.ipip.net/download.html)

