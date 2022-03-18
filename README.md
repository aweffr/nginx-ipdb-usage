# 编译 nginx ipdb 插件

```bash
# 本地构建镜像(编译so)
docker build -t nginx-ipdb:0.1 .

# 从镜像中拷贝so文件到宿主机的build/目录
docker-compose up
```