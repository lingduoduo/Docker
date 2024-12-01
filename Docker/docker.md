#### 容器生命周期管理命令

**run**

创建一个新的容器。


### 使用docker镜像nginx:latest以后台模式启动一个容器,# 并将容器命名为mynginx。  
```
docker run --name mynginx -d nginx:latest  # 使用镜像 nginx:latest，以后台模式启动一个容器,
```

### 将容器的 80 端口映射到主机的 80 端口,# 主机的目录 /data 映射到容器的 /data。  
```
docker run -p 80:80 -v /data:/data -d nginx:latest  # 使用镜像nginx:latest以交互模式启动一个容器,
```

### 在容器内执行/bin/bash命令。
```  
docker run -it nginx:latest /bin/bash  

docker run -d -it --rm --name [CONTAINER_NAME] -p 8081:80 [IMAGE_NAME]
```
where

- -d runs the container in detached mode. This mode runs the container in the background.
- -it runs in interactive mode, with a terminal session attached.
- --rm removes the container when it exits.
- --name specifies a name for the container.
- -p does port forwarding from host to the container (i.e., host:container) .

后台运行一个docker
```
docker run -d centos /bin/sh -c "while true;do echo 正在运行; sleep 1;done"
```
    # -d  后台运行容器
    # /bin/sh  指定使用centos的bash解释器
    # -c 运行一段shell命令
    # "while true;do echo 正在运行; sleep 1;done"  在linux后台，每秒中打印一次正在运行
    
启动一个bash终端,允许用户进行交互
```
docker run --name mydocker -it centos /bin/bash  
    # --name  给容器定义一个名称
    # -i  让容器的标准输入保持打开
    # -t 让Docker分配一个伪终端,并绑定到容器的标准输入上
    # /bin/bash 指定docker容器，用shell解释器交互
```

```
docker run busybox:latest echo "Hello World"
docker run busybox:latest ls /
docker run -d busybox:latest
docker run -d busybox:latest sleep 1000
docker run --name hello busybox:latest
docker run -it -p 8888:8080 tomcat:latest

docker run -d --name=redis redis
docker run -d --name=db postgres:9.4
docker run -d --name=vote -p 5000:80 --link redis:redis voting-app
docker run -d --name=result 5001:80 --link db:db result-app
docker run -d --name=worker --link db:db --link redis:redis worker
```

Docker run, the -i flag starts an interactive container. The -t flag creates a pseudo-TTY that attaches stdin and stdout. 

- Docker build command takes the path to the build context as an. argument. When build start, docker client would pack all the files in the build context into a. tarball tehn transfer the tarball file to the daemon. By default, docker would search for the Docker file in the buid context path.
  - Commit changes made in a Docker container. For example, Spin up a container from a base image. Install Git package in the container. Commit changes made in the container. Docker commit command would save the changes we made to the Docker container's file system to a new Image.
  - Each RUN command will execute the command on the top writable layer of the container, then commit the container as a new image. The new image is used for the next step in the Docekrfile. So each RUN instruction will create a new image layer. It is recommended to chain the RUN instructions in the Dockerfile to reduce the number of image layers it creates. Sort Multi-line Arguments Alphanumerically.
  - CMD Instruction specifies what command. you want to run when the container starts up. Docker will use the default command defined in the base image.
  - Docker Cache. Each time Docker executes an. instruction it builds a new image layer. The next time, if the instruction doesn't change, Docker will simply reuse the existing layer. Sometime it has issues, e.g, aggressive caching. Specify with --no-cache option
  - Copy Instruction copies new files or directories from build context and adds them to the file system of the container.   Use copy for the sake of transparency, unless you are absolutely sure you need ADD commands.
  - Add Instruction can not only copy files, but also allow you to download a file from. internet and copy to the container. It also has the ability to automatically unpack compressed files.

```
docker images
docker tag 345867df0879  lingh/test
docker login --username=lingh
docker push lingh/test:0.01
```

- docker run container

1. 检查本地是否存在指定的镜像，不存在就从公有仓库下载
2. 利用镜像创建并启动一个容器
3. 分配一个文件系统，并在只读的镜像层外面挂在一层可读写层
4. 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
5. 从地址池配置一个ip地址给容器
6. 执行用户指定的应用程序
7. 执行完毕后容器被终止%%

- docker stopped

```
[root@localhost ~]# docker ps -a  # 先查询记录
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS                    NAMES
ee92fcf6f32d        centos              "/bin/bash"              4 days ago          Exited (137) 3 days ago                                kickass_raman

[root@localhost ~]# docker start ee9  # 再启动这个容器
ee9

[root@localhost ~]# docker exec -it  ee9 /bin/bash  # 进入容器交互式界面
[root@ee92fcf6f32d /]#   # 注意看用户名，已经变成容器用户名
```

- docker run image

1.我们进入交互式的centos容器中，发现没有vim命令
```
    docker run -it centos
```
2.在当前容器中，安装一个vim
```
    yum install -y vim
```
3.安装好vim之后，exit退出容器
```
    exit
```
4.查看刚才安装好vim的容器记录
```
    docker container ls -a
```
5.提交这个容器，创建新的image
```
    docker commit 059fdea031ba chaoyu/centos-vim
```
6.查看镜像文件
```
    docker images%%
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ling/centos-vim   latest              fd2685ae25fe        5 minutes ago       348MB
```

- docker run with -p

```
docker run -d -P training/webapp python app.py
```
 -P 参数会随机映射端口到容器开放的网络端口

检查映射的端口
```
docker ps -l
CONTAINER ID        IMAGE               COMMAND             CREATED            STATUS              PORTS                     NAMES
cfd632821d7a        training/webapp     "python app.py"     21 seconds ago      Up 20 seconds       0.0.0.0:32768->5000/tcp   brave_fermi
#宿主机ip:32768 映射容器的5000端口
```

查看容器日志信息
```
docker logs -f cfd  #不间断显示log

# 也可以通过-p参数指定映射端口

docker run -d -p 9000:5000 training/webapp python app.py
```

**start/stop/restart**

- **docker start** : 启动一个或多个已经被停止的容器。
- **docker stop** : 停止一个运行中的容器。
- **docker restart** : 重启容器。

```
# 启动已被停止的容器mynginx  
docker start mynginx  # 停止运行中的容器mynginx  
docker stop mynginx  # 重启容器mynginx  
docker restart mynginx  
```

**kill**

杀掉一个运行中的容器。可选参数：

- **-s :** 发送什么信号到容器，默认 KILL

```
# 根据容器名字杀掉容器  
docker kill tomcat7  
# 根据容器ID杀掉容器  
docker kill 65d4a94f7a39  
```

**rm**

删除一个或多个容器。

```
# 强制删除容器 db01、db02：  
docker rm -f db01 db02  

# 删除容器 nginx01, 并删除容器挂载的数据卷：  
docker rm -v nginx01  

# 删除所有已经停止的容器：  
docker rm $(docker ps -a -q)  
```

**create**

创建一个新的容器但不启动它。

```
# 使用docker镜像nginx:latest创建一个容器,并将容器命名为mynginx  
docker create --name mynginx nginx:latest     
```

**exec**

在运行的容器中执行命令。可选参数：

- **-d :** 分离模式: 在后台运行
- **-i :** 即使没有附加也保持STDIN 打开
- **-t :** 分配一个伪终端

```
# 在容器 mynginx 中以交互模式执行容器内 /root/nginx.sh 脚本  
docker exec -it mynginx /bin/sh /root/nginx.sh  

# 在容器 mynginx 中开启一个交互模式的终端  
docker exec -i -t  mynginx /bin/bash  

# 也可以通过 docker ps -a 命令查看已经在运行的容器，然后使用容器 ID 进入容器。  
docker ps -a   docker exec -it 9df70f9a0714 /bin/bash  
```

**pause/unpause**

- **docker pause** :暂停容器中所有的进程。
- **docker unpause** :恢复容器中所有的进程。

```
# 暂停数据库容器db01提供服务。  
docker pause db01  

# 恢复数据库容器 db01 提供服务  
docker unpause db0  
```

#### **容器操作命令**

**Inspect**

获取容器/镜像的元数据。可选参数：

-f : 指定返回值的模板文件。
-s : 显示总的文件大小。
–type : 为指定类型返回JSON。

```
docker inspect <ID> | less
docker inspect --format="{{.NetworkSettings.IPAddress}}"containername
docker inspect --format="{{.State.Pid}}"containername
docker run --rm -v /dev/log:/dev/log/ fedoral:latest logger "message from FEDORA"

获取镜像mysql:5.7的元信息。 
docker inspect mysql:5.7  # 获取正在运行的容器mymysql的 IP。  
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mymysql  

```

**ps**

列出容器。可选参数：

-a : 显示所有的容器，包括未运行的。
-f : 根据条件过滤显示的内容。
–format : 指定返回值的模板文件。
-l : 显示最近创建的容器。
-n : 列出最近创建的n个容器。
–no-trunc : 不截断输出。
-q : 静默模式，只显示容器编号。
-s : 显示总的文件大小。

```
# 列出所有在运行的容器信息。  
docker ps  # 列出最近创建的5个容器信息。  
docker ps -n 5  # 列出所有创建的容器ID。  
docker ps -a -q  

补充说明：

容器的7种状态：
created（已创建）
restarting（重启中）
running（运行中）
removing（迁移中）
paused（暂停）
exited（停止）
dead（死亡）

docker ps
docker ps -a

docker run --rm busybox:latest sleep 1
docker inspect ac5763c57b26226a63ea12d0048bf699c1a3ed33637651d9e0615a986c13c85f
docker logs b26f87073ea60472b50040c629ccd532a18577f15496d9bfce319ddb2b964a26

docker system prune
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

docker build -t lingh/docker .
docker commit b26f87073 git/ling:1.0
```

**top**

查看容器中运行的进程信息，支持 ps 命令参数。

```
# 查看容器mymysql的进程信息。  
docker top mymysql  # 查看所有运行容器的进程信息。  
for i in  `docker ps |grep Up|awk '{print $1}'`;
	do echo \ &&docker top $i; 
	done  
```

**events**

获取实时事件。参数说明：

- **-f ：** 根据条件过滤事件；
- **–since ：** 从指定的时间戳后显示所有事件；
- **–until ：** 流水时间显示到指定的时间为止；

```
# 显示docker 2016年7月1日后的所有事件。  
docker events  --since="1467302400"  

# 显示docker 镜像为mysql:5.6 2016年7月1日后的相关事件。  
docker events -f "image"="mysql:5.6" --since="1467302400" 

说明：如果指定的时间是到秒级的，需要将时间转成时间戳。如果时间为日期的话，可以直接使用，如–since=“2016-07-01”。
```

**logs**

获取容器的日志。参数说明：

- **-f :** 跟踪日志输出
- **–since :** 显示某个开始时间的所有日志
- **-t :** 显示时间戳
- **–tail :** 仅列出最新N条容器日志

```
# 跟踪查看容器mynginx的日志输出。  
docker logs -f mynginx  

# 查看容器mynginx从2016年7月1日后的最新10条日志。  
docker logs --since="2016-07-01" --tail=10 mynginx  
```

**export**

将文件系统作为一个tar归档文件导出到STDOUT。参数说明：

- **-o :** 将输入内容写到文件。

```
# 将id为a404c6c174a2的容器按日期保存为tar文件。  docker export -o mysql-`date +%Y%m%d`.tar a404c6c174a2  ls mysql-`date +%Y%m%d`.tar  
```

**port**

列出指定的容器的端口映射。

```
# 查看容器mynginx的端口映射情况。  
docker port mymysql  
```

#### 容器rootfs命令

**commit**

从容器创建一个新的镜像。参数说明：

- **-a :** 提交的镜像作者；
- **-c :** 使用Dockerfile指令来创建镜像；
- **-m :** 提交时的说明文字；
- **-p :** 在commit时，将容器暂停。

```
# 将容器a404c6c174a2 保存为新的镜像,# 并添加提交人信息和说明信息。 
docker commit -a "guodong" -m "my db" a404c6c174a2  mymysql:v1   
```

**cp**

用于容器与主机之间的数据拷贝。参数说明：

- **-L :** 保持源目标中的链接

```
# 将主机/www/runoob目录拷贝到容器96f7f14e99ab的/www目录下。  
docker cp /www/runoob 96f7f14e99ab:/www/  

# 将主机/www/runoob目录拷贝到容器96f7f14e99ab中，目录重命名为www。  
docker cp /www/runoob 96f7f14e99ab:/www  

# 将容器96f7f14e99ab的/www目录拷贝到主机的/tmp目录中。  
docker cp  96f7f14e99ab:/www /tmp/  
```

**diff**

检查容器里文件结构的更改。

```
# 查看容器mymysql的文件结构更改。  
docker diff mymysql  
```

#### 镜像仓库命令 

**login/logout**

**docker login :** 登陆到一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub**docker logout :**登出一个Docker镜像仓库，如果未指定镜像仓库地址，默认为官方仓库 Docker Hub参数说明：

- **-u :** 登陆的用户名
- **-p :** 登陆的密码

```
# 登陆到 Docker Hub  
docker login -u 用户名 -p 密码  
# 登出 Docker Hub  
docker logout  
```

**pull**

从镜像仓库中拉取或者更新指定镜像。参数说明：

- **-a :** 拉取所有 tagged 镜像
- **–disable-content-trust :** 忽略镜像的校验,默认开启

```
# 从Docker Hub下载java最新版镜像。  
docker pull java  

# 从Docker Hub下载REPOSITORY为java的所有镜像。  
docker pull -a java  
```

**push**

将本地的镜像上传到镜像仓库,要先登陆到镜像仓库。参数说明：

- **–disable-content-trust :** 忽略镜像的校验,默认开启

```
# 上传本地镜像myapache:v1到镜像仓库中。  
docker push myapache:v1  
```

**search**

从Docker Hub查找镜像。参数说明：

- **–automated :** 只列出 automated build类型的镜像；
- **–no-trunc :** 显示完整的镜像描述；
- **-f \<过滤条件>:** 列出指定条件的镜像。

```
# 从 Docker Hub 查找所有镜像名包含 java，并且收藏数大于 10 的镜像  
docker search -f stars=10 java  NAME                  DESCRIPTION                           STARS   OFFICIAL   AUTOMATED  java                  Java is a concurrent, class-based...   1037    [OK]         anapsix/alpine-java   Oracle Java 8 (and 7) with GLIBC ...   115                [OK]  develar/java                                                 46                 [OK]  
```

每列参数说明：

- **NAME:** 镜像仓库源的名称
- **DESCRIPTION:** 镜像的描述
- **OFFICIAL:** 是否 docker 官方发布
- **stars:** 类似 Github 里面的 star，表示点赞、喜欢的意思
- 另外搜索公众号GitHub猿后台回复“赚钱”，获取一份惊喜礼包。
- **AUTOMATED:** 自动构建

#### 本地镜像管理命令 

**images**

列出本地镜像。参数说明：

- **-a :** 列出本地所有的镜像（含中间映像层，默认情况下，过滤掉中间映像层）；
- **–digests :** 显示镜像的摘要信息；
- **-f :** 显示满足条件的镜像；
- **–format :** 指定返回值的模板文件；
- **–no-trunc :** 显示完整的镜像信息；
- **-q :** 只显示镜像ID。

```
# 查看本地镜像列表。  
docker images  

# 列出本地镜像中REPOSITORY为ubuntu的镜像列表。  
docker images  ubuntu  
```

**rmi**

删除本地一个或多个镜像。参数说明：

- **-f :** 强制删除；
- **–no-prune :** 不移除该镜像的过程镜像，默认移除；
- 另外，搜索公众号Linux就该这样学后台回复“Linux”，获取一份惊喜礼包。

```
# 强制删除本地镜像 guodong/ubuntu:v4。  
docker rmi -f guodong/ubuntu:v4  
```

**tag**

标记本地镜像，将其归入某一仓库。

```
# 将镜像ubuntu:15.10标记为 runoob/ubuntu:v3 镜像。  
docker tag ubuntu:15.10 runoob/ubuntu:v3  
```

**build**

用于使用 Dockerfile 创建镜像。参数说明：

- **–build-arg=[] :** 设置镜像创建时的变量；
- **–cpu-shares :** 设置 cpu 使用权重；
- **–cpu-period :** 限制 CPU CFS周期；
- **–cpu-quota :** 限制 CPU CFS配额；
- **–cpuset-cpus :** 指定使用的CPU id；
- **–cpuset-mems :** 指定使用的内存 id；
- **–disable-content-trust :** 忽略校验，默认开启；
- **-f :** 指定要使用的Dockerfile路径；
- **–force-rm :** 设置镜像过程中删除中间容器；
- **–isolation :** 使用容器隔离技术；
- **–label=[] :** 设置镜像使用的元数据；
- **-m :** 设置内存最大值；
- **–memory-swap :** 设置Swap的最大值为内存+swap，"-1"表示不限swap；
- **–no-cache :** 创建镜像的过程不使用缓存；
- **–pull :** 尝试去更新镜像的新版本；
- **–quiet, -q :** 安静模式，成功后只输出镜像 ID；
- **–rm :** 设置镜像成功后删除中间容器；
- **–shm-size :** 设置/dev/shm的大小，默认值是64M；
- **–ulimit :** Ulimit配置。
- **–squash :** 将 Dockerfile 中所有的操作压缩为一层。
- **–tag, -t:** 镜像的名字及标签，通常 name:tag 或者 name 格式；可以在一次构建中为一个镜像设置多个标签。
- **–network:** 默认 default。在构建期间设置RUN指令的网络模式

```
# 使用当前目录的 Dockerfile 创建镜像，标签为 runoob/ubuntu:v1  
docker build -t runoob/ubuntu:v1 .   

# 使用URL github.com/creack/docker-firefox 的 Dockerfile 创建镜像  
docker build github.com/creack/docker-firefox  

# 通过 -f Dockerfile文件的位置 创建镜像  
docker build -f /path/to/a/Dockerfile .  
```

**history**

查看指定镜像的创建历史。参数说明：

- **-H :** 以可读的格式打印镜像大小和日期，默认为true；
- **–no-trunc :** 显示完整的提交记录；
- **-q :** 仅列出提交记录ID。

```
# 查看本地镜像 guodong/ubuntu:v3 的创建历史。  
docker history guodong/ubuntu:v3  
```

**save**

将指定镜像保存成 tar 归档文件。参数说明：

- **-o :** 输出到的文件。

```
# 将镜像 runoob/ubuntu:v3 生成 my_ubuntu_v3.tar 文档  
docker save -o my_ubuntu_v3.tar runoob/ubuntu:v3  
```

**load**

导入使用 `docker save` 命令导出的镜像。参数说明：

- **–input , -i :** 指定导入的文件，代替 STDIN。
- **–quiet , -q :** 精简输出信息。

```
# 导入镜像  
docker load --input fedora.tar  
```

**import**

从归档文件中创建镜像。参数说明：

- **-c :** 应用docker 指令创建镜像；
- **-m :** 提交时的说明文字；

```
# 从镜像归档文件my_ubuntu_v3.tar创建镜像，命名为runoob/ubuntu:v4  
docker import  my_ubuntu_v3.tar runoob/ubuntu:v4    
```

Docker Container Links

- The main use for doker container links is when we build an application with a micro service architecture, we are able to run many independent componnents in different containers.
- Docker creates a secure tunnel between the containers that doesn't. need to expose any ports externally on the container.

Docker Compose

- Manual linking contianers and configuring services become impractical when the number of containers grows.

- Docker compose uses yaml files to store the configuration of all the containers, which removes the burden to maintain our scripts for docker orchestration.

  ```
  docker-compose up -d 
  docker-compose ps
  docker-compose logs -f
  docker-compose logs dockerappname
  docker-compose stop
  docker-compose rm -all
  docker-compose build
  ```

  - docker compose up starts up all the containers.
  - docker compose ps checks the status of the containers managed by docker compose.
  - docker compose logs outputs colored and aggregated logs for the composed-managed containers.
  - docker compose logs  with -f outus appended log when the log grows.
  - docker compose logs  with the container name in the end outputs the logs of a specific container.
  - docker compose stop stops all the running containers without removing them.
  - docker compose rm removes all the containers.
  - docker compose build rebuids all the images.


#### Docker command examples

```
docker version
docker version  --format '{{json .}}'
docker info

docker images
docker image ls  # 查看本地所有镜像
docker images  # 查看docker镜像
docker image rmi hello-docker # 删除centos镜像

docker search --> hub.docker.com
docker search mysql --filter=STARS=500

docker pull mysql
docker pull mysql:5.7
docker pull hello-docker # 获取centos镜像

docker rmi mysql:5.7
docker rmi -f {image-id}
docker images -aq | xargs docker rmi -f
docker  rm `docker ps -aq`    # 一次性删除所有容器记录
docker rmi  `docker images -aq`   # 一次性删除所有本地的镜像记录

docker search  hello-docker  # 搜索hello-docker的镜像
docker search centos # 搜索centos镜像

docker run  hello-world   #运行一个docker镜像，产生一个容器实例（也可以通过镜像id前三位运行）

docker ps  #列出正在运行的容器（如果创建容器中没有进程正在运行，容器就会立即停止）
docker ps -a  # 列出所有运行过的容器记录

docker save centos > /opt/centos.tar.gz  # 导出docker镜像至本地

docker load < /opt/centos.tar.gz   #导入本地镜像到docker镜像库

docker stop  `docker ps -aq`  # 停止所有正在运行的容器
```

- install docker
```
yum install docker
```
- 启动docker 
```
systemctl start/status docker 
```
- 查看docker启动状态
```
docker version
docker version  --format '{{json .}}'
docker info
```
- docker help
```
docker --help
```

- docker image
```
FROM scratch #制作base image 基础镜像，尽量使用官方的image作为base image
FROM centos #使用base image
FROM ubuntu:14.04 #带有tag的base image

LABEL version=“1.0” #容器元信息，帮助信息，Metadata，类似于代码注释
LABEL maintainer=“ling@163.com"

#对于复杂的RUN命令，避免无用的分层，多条命令用反斜线换行，合成一条命令！
RUN yum update && yum install -y vim 
    Python-dev #反斜线换行
RUN /bin/bash -c "source $HOME/.bashrc;echo $HOME”

WORKDIR /root #相当于linux的cd命令，改变目录，尽量使用绝对路径！！！不要用RUN cd
WORKDIR /test # 如果没有就自动创建
WORKDIR demo # 再进入demo文件夹
RUN pwd     # 打印结果应该是/test/demo

ADD and COPY 
ADD hello /  # 把本地文件添加到镜像中，吧本地的hello可执行文件拷贝到镜像的/目录
ADD test.tar.gz /  # 添加到根目录并解压

WORKDIR /root
ADD hello test/  # 进入/root/ 添加hello可执行命令到test目录下，也就是/root/test/hello 一个绝对路径
COPY hello test/  # 等同于上述ADD效果

ADD与COPY
   - 优先使用COPY命令
    -ADD除了COPY功能还有解压功能
添加远程文件/目录使用curl或wget

ENV # 环境变量，尽可能使用ENV增加可维护性
ENV MYSQL_VERSION 5.6 # 设置一个mysql常量
RUN yum install -y mysql-server=“${MYSQL_VERSION}” 


VOLUME and EXPOSE 
存储和网络

RUN and CMD and ENTRYPOINT
RUN：执行命令并创建新的Image Layer
CMD：设置容器启动后默认执行的命令和参数
ENTRYPOINT：设置容器启动时运行的命令

Shell格式和Exec格式
RUN yum install -y vim
CMD echo ”hello docker”
ENTRYPOINT echo “hello docker”

Exec格式
RUN [“apt-get”,”install”,”-y”,”vim”]
CMD [“/bin/echo”,”hello docker”]
ENTRYPOINT [“/bin/echo”,”hello docker”]

通过shell格式去运行命令，会读取$name指令，而exec格式是仅仅的执行一个命令，而不是shell指令
cat Dockerfile
    FROM centos
    ENV name Docker
    ENTRYPOINT [“/bin/echo”,”hello $name”]#这个仅仅是执行echo命令，读取不了shell变量
    ENTRYPOINT  [“/bin/bash”,”-c”,”echo hello $name"]

CMD
容器启动时默认执行的命令
如果docker run指定了其他命令(docker run -it [image] /bin/bash )，CMD命令被忽略
如果定义多个CMD，只有最后一个执行

ENTRYPOINT
让容器以应用程序或服务形式运行
不会被忽略，一定会执行
最佳实践：写一个shell脚本作为entrypoint
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT [“docker-entrypoint.sh]
EXPOSE 27017
CMD [“mongod”]

[root@master home]# more Dockerfile
FROm centos
ENV name Docker
#CMD ["/bin/bash","-c","echo hello $name"]
ENTRYPOINT ["/bin/bash","-c","echo hello $name”]
```

- docker hub
```
注册docker id后，在linux中登录dockerhub
    docker login

注意要保证image的tag是账户名，如果镜像名字不对，需要改一下tag
    docker tag chaoyu/centos-vim ling104/centos-vim
    # 语法是：docker tag   仓库名   ling104/仓库名

推送docker image到dockerhub
    docker push ling104/centps-cmd-exec:latest

去dockerhub中检查镜像
先删除本地镜像，然后再测试下载pull 镜像文件
    docker pull ling104/centos-entrypoint-exec
```

```
## private repo
1.下载一个docker官方私有仓库镜像
    docker pull registry
  
2.运行一个docker私有容器仓库
docker run -d -p 5000:5000 -v /opt/data/registry:/var/lib/registry  registry
    -d 后台运行 
    -p  端口映射 宿主机的5000:容器内的5000
    -v  数据卷挂载  宿主机的 /opt/data/registry :/var/lib/registry 
    registry  镜像名
    /var/lib/registry  存放私有仓库位置
# Docker 默认不允许非 HTTPS 方式推送镜像。我们可以通过 Docker 的配置选项来取消这个限制

3.修改docker的配置文件，让他支持http方式，上传私有镜像
    vim /etc/docker/daemon.json 
    # 写入如下内容
    {
        "registry-mirrors": ["http://f1361db2.m.daocloud.io"],
        "insecure-registries":["192.168.11.37:5000"]
    }
4.修改docker的服务配置文件
    vim /lib/systemd/system/docker.service
# 找到[service]这一代码区域块，写入如下参数
    [Service]
    EnvironmentFile=-/etc/docker/daemon.json
5.重新加载docker服务
    systemctl daemon-reload
6.重启docker服务
    systemctl restart docker
    # 注意:重启docker服务，所有的容器都会挂掉

7.修改本地镜像的tag标记，往自己的私有仓库推送
    docker tag docker.io/ling104/hello-world-docker 192.168.11.37:5000/ling-hello
    # 浏览器访问http://192.168.119.10:5000/v2/_catalog查看仓库
8.下载私有仓库的镜像
    docker pull 192.168.11.37:5000/ling-hello


Example
1.准备好app.py的flask程序
    [root@localhost ~]# cat app.py
    from flask import Flask
    app=Flask(__name__)
    @app.route('/')
    def hello():
        return "hello docker"
    if __name__=="__main__":
        app.run(host='0.0.0.0',port=8080)
    [root@master home]# ls
    app.py  Dockerfile

2.编写dockerfile
    [root@localhost ~]# cat Dockerfile
    FROM python:2.7
    LABEL maintainer="温而新"
    RUN pip install flask
    COPY app.py /app/
    WORKDIR /app
    EXPOSE 8080
    CMD ["python","app.py"]

3.构建镜像image,找到当前目录的Dockerfile，开始构建
    docker build -t ling104/flask-hello-docker .

4.查看创建好的images
    docker image ls

5.启动此flask-hello-docker容器，映射一个端口供外部访问
    docker run -d -p 8080:8080 ling104/flask-hello-docker

6.检查运行的容器
    docker container ls

7.推送这个镜像到私有仓库
    docker tag  ling104/flask-hello-docker   192.168.11.37:5000/ling-flaskweb
    docker push 192.168.11.37:5000/ling-flaskweb

```

docker run @gcp

```
docker run -it -v /Users/lingh/Git/ml-testing/_qstyx:/etc/_qstyx 
-e STYX_COMPONENT_ID=ml-testing 
-e STYX_WORKFLOW_ID=ml-testing.PushLabelJob 
-e STYX_PARAMETER=2019-10-09 
-e STYX_DOCKER_IMAGE=gcr.io/formats-insights/ml-testing 
-e STYX_DOCKER_ARGS="wrap-luigi 
--module luigi_tasks_train PushLabelJob 
--channel Push 
--date 2019-10-09
" -e STYX_EXECUTION_ID=styx-run-5754550a-f9d9-462d-849f-95cdb55887ca 
-e STYX_TRIGGER_ID=qstyx-f3048723-9887-4cba-af51-4eece3aada2b 
-e STYX_ENVIRONMENT=qstyx 
-e STYX_LOGGING=text 
-e GOOGLE_APPLICATION_CREDENTIALS=/etc/_qstyx/gcp-sa-key.json 
-e STYX_SERVICE_ACCOUNT=ml-testing-workflow-sa@formats-insights.iam.gserviceaccount.com 
gcr.io/formats-insights/ml-testing wrap-luigi --module luigi_tasks_train PushLabelJob --channel Push --date 2019-10-09`

docker run -it -v $(pwd)/ml-testing-workflow-sa.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json  gcr.io/formats-insights/ml-testing:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module luigi_tasks_train PushLabelJob --date 2019-10-10  --channel Push"

docker run -it -v $(pwd)/ml-testing-workflow-sa.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json  gcr.io/formats-insights/ml-testing:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module luigi_tasks_train PushLabelJob --date 2019-10-11  --channel Push"

docker run -it -v $(pwd)/../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train LabelJob --date 2019-08-13 --channel Push"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train FeatureToTfRecord --channel Push --date 2019-08-11 --days-back 1 --schema-file push.pbtxt --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train FeatureToTfRecord --channel Push --date 2019-08-13 --days-back 1 --schema-file push.pbtxt --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train FeatureToTfRecord --channel Push --date 2019-08-21 --days-back 1 --schema-file push.pbtxt --base-path gs://mo_ml/lingh/"
docker run -it -v $(pwd)/../../key.json:/key.json -e 

docker run -it -v $(pwd)/../../key.json:/key.json -e 
GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train FeatureToTfRecord --channel Push --date 2019-09-18 --days-back 1 --schema-file push.pbtxt --base-path gs://mo_ml/lingh/"


===== Luigi Execution Summary =====

Scheduled 5 tasks of which:
* 2 complete ones were encountered:
    - 1 CommunicationsHealth(date=2019-08-21)
    - 1 UserCommunicationSnapshot(date=2019-08-17)
* 3 ran successfully:
    - 1 FeatureToTfRecord(...)
    - 1 LabelJob(date=2019-08-21, channel=Push)
    - 1 UserAggregatesJob(date=2019-08-17, date_label_table_to_join=2019-08-21, channel=Push)

This progress looks :) because there were no failed tasks or missing dependencies

===== Luigi Execution Summary =====

INFO:luigi-interface:
===== Luigi Execution Summary =====

Scheduled 5 tasks of which:
* 2 complete ones were encountered:
    - 1 CommunicationsHealth(date=2019-08-21)
    - 1 UserCommunicationSnapshot(date=2019-08-17)
* 3 ran successfully:
    - 1 FeatureToTfRecord(...)
    - 1 LabelJob(date=2019-08-21, channel=Push)
    - 1 UserAggregatesJob(date=2019-08-17, date_label_table_to_join=2019-08-21, channel=Push)

This progress looks :) because there were no failed tasks or missing dependencies

===== Luigi Execution Summary =====
```

- PreprocessingJob

```
FeatureToTfRecord(date=2019-09-18, days_back=7, channel=Push, test_run=False, schema_file=push.pbtxt, sample=True, sample_rate=0.5, over_sample_rate=1.0, base_path=gs://mo_ml/push/tf)

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train PreprocessingJob --date 2019-08-11 --channel Push --label-name os_level_unsub --schema-file push.pbtxt --feature-set OneHotFeatures --sample-rate 0.50 --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train PreprocessingJob --date 2019-08-12 --channel Push --label-name os_level_unsub --schema-file push.pbtxt --feature-set OneHotFeatures --sample-rate 0.50 --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train PreprocessingJob --date 2019-08-13 --channel Push --label-name os_level_unsub --schema-file push.pbtxt --feature-set OneHotFeatures --sample-rate 0.50 --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train PreprocessingJob --date 2019-08-21 --channel Push --label-name os_level_unsub --schema-file push.pbtxt --feature-set OneHotFeatures --sample-rate 0.50 --base-path gs://mo_ml/lingh/"

docker run -it -v $(pwd)/../../key.json:/key.json -e GOOGLE_APPLICATION_CREDENTIALS=/key.json gcr.io/paradox-mo/tf-supervised/lingh:latest bash -c "PYTHONPATH=python luigi --local-scheduler --module tasks.luigi_task_train PreprocessingJob --date 2019-09-18 --channel Push --label-name os_level_unsub --schema-file push.pbtxt --feature-set OneHotFeatures --sample-rate 0.50 --base-path gs://mo_ml/lingh/"

===== Luigi Execution Summary =====

Scheduled 2 tasks of which:
* 1 complete ones were encountered:
    - 1 FeatureToTfRecord(...)
* 1 ran successfully:
    - 1 PreprocessingJob(...)

This progress looks :) because there were no failed tasks or missing dependencies

===== Luigi Execution Summary =====

INFO:luigi-interface:
===== Luigi Execution Summary =====

Scheduled 2 tasks of which:
* 1 complete ones were encountered:
    - 1 FeatureToTfRecord(...)
* 1 ran successfully:
    - 1 PreprocessingJob(...)

This progress looks :) because there were no failed tasks or missing dependencies

===== Luigi Execution Summary =====

Outputs -

gsutil ls gs://mo_ml/lingh/preprocessing/pdx_mo.Push.os_level_unsub.PreprocessingV1.OneHotFeatures/2019-08-21

gs://mo_ml/lingh/preprocessing/pdx_mo.Push.os_level_unsub.PreprocessingV1.OneHotFeatures/2019-08-21/20190827T190136.586152-1a00748f68d8/training/transformed_metadata/schema.pbtxt

gs://mo_ml/lingh/preprocessing/pdx_mo.Push.os_level_unsub.PreprocessingV1.OneHotFeatures/2019-08-21/20190827T190136.586152-1a00748f68d8/transformed_metadata/schema.pbtxt \

```

**Commands for Creating Docker Files**

| Command        | Description                                                  |
| :------------- | :----------------------------------------------------------- |
| **FROM**       | The base Docker image for the Dockerfile.                    |
| **LABEL**      | Key-value pair for specifying image metadata.                |
| **RUN**        | It executes commands on top of the current image as new layers. |
| **COPY**       | Copies files from the local machine to the container file system. |
| **EXPOSE**     | Exposes runtime ports for the Docker container.              |
| **CMD**        | Specifies the command to execute when running the container. This command is overridden if another command is specified at runtime. |
| **ENTRYPOINT** | Specifies the command to execute when running the container. Entrypoint commands are not overridden by a command specified at runtime. |
| **WORKDIR**    | Set working directory of the container.                      |
| **VOLUME**     | Mount a volume from the local machine file system to the Docker container. |
| **ARG**        | Set Environment variable as a key-value pair when building the image. |
| **ENV**        | Set Environment variable as a key-value pair that will be available in the container after building. |

**Docker Commands for Managing Images**

| Command                        | Description                                           |
| :----------------------------- | :---------------------------------------------------- |
| docker images                  | List all images on the machine.                       |
| docker rmi [IMAGE_NAME]        | Remove the image with name IMAGE_NAME on the machine. |
| docker rmi $(docker images -q) | Remove all images from the machine.                   |

**Docker Commands for Managing Containers**

| Command                      | Description                                                  |
| :--------------------------- | :----------------------------------------------------------- |
| docker ps                    | List all containers. Append –a to also list containers not running. |
| docker stop [CONTAINER_ID]   | Gracefully stop the container with [CONTAINER_ID] on the machine. |
| docker kill CONTAINER_ID]    | Forcefully stop the container with [CONTAINER_ID] on the machine. |
| docker rm [CONTAINER_ID]     | Remove the container with [CONTAINER_ID] from the machine.   |
| docker rm $(docker ps -a -q) | Remove all containers from the machine.                      |
| docker start                 |                                                              |
| docker restart               |                                                              |

**Docker Commands**

```
docker [OPTIONS] COMMAND [arg...]
       docker daemon [ --help | ... ]
       docker [ --help | -v | --version ]
A
self-sufficient runtime for containers.

Options:
  --config=~/.docker              Location of client config files  #客户端配置文件的位置
  -D, --debug=false               Enable debug mode  #启用Debug调试模式
  -H, --host=[]                   Daemon socket(s) to connect to  #守护进程的套接字（Socket）连接
  -h, --help=false                Print usage  #打印使用
  -l, --log-level=info            Set the logging level  #设置日志级别
  --tls=false                     Use TLS; implied by--tlsverify  #
  --tlscacert=~/.docker/ca.pem    Trust certs signed only by this CA  #信任证书签名CA
  --tlscert=~/.docker/cert.pem    Path to TLS certificate file  #TLS证书文件路径
  --tlskey=~/.docker/key.pem      Path to TLS key file  #TLS密钥文件路径
  --tlsverify=false               Use TLS and verify the remote  #使用TLS验证远程
  -v, --version=false             Print version information and quit  #打印版本信息并退出

Commands:
    attach    Attach to a running container  #当前shell下attach连接指定运行镜像
    build     Build an image from a Dockerfile  #通过Dockerfile定制镜像
    commit    Create a new image from a container's changes  #提交当前容器为新的镜像
    cp    Copy files/folders from a container to a HOSTDIR or to STDOUT  #从容器中拷贝指定文件或者目录到宿主机中
    create    Create a new container  #创建一个新的容器，同run 但不启动容器
    diff    Inspect changes on a container's filesystem  #查看docker容器变化
    events    Get real time events from the server#从docker服务获取容器实时事件
    exec    Run a command in a running container#在已存在的容器上运行命令
    export    Export a container's filesystem as a tar archive  #导出容器的内容流作为一个tar归档文件(对应import)
    history    Show the history of an image  #展示一个镜像形成历史
    images    List images  #列出系统当前镜像
    import    Import the contents from a tarball to create a filesystem image  #从tar包中的内容创建一个新的文件系统映像(对应export)
    info    Display system-wide information  #显示系统相关信息
    inspect    Return low-level information on a container or image  #查看容器详细信息
    kill    Kill a running container  #kill指定docker容器
    load    Load an image from a tar archive or STDIN  #从一个tar包中加载一个镜像(对应save)
    login    Register or log in to a Docker registry#注册或者登陆一个docker源服务器
    logout    Log out from a Docker registry  #从当前Docker registry退出
    logs    Fetch the logs of a container  #输出当前容器日志信息
    pause    Pause all processes within a container#暂停容器
    port    List port mappings or a specific mapping for the CONTAINER  #查看映射端口对应的容器内部源端口
    ps    List containers  #列出容器列表
    pull    Pull an image or a repository from a registry  #从docker镜像源服务器拉取指定镜像或者库镜像
    push    Push an image or a repository to a registry  #推送指定镜像或者库镜像至docker源服务器
    rename    Rename a container  #重命名容器
    restart    Restart a running container  #重启运行的容器
    rm    Remove one or more containers  #移除一个或者多个容器
    rmi    Remove one or more images  #移除一个或多个镜像(无容器使用该镜像才可以删除，否则需要删除相关容器才可以继续或者-f强制删除)
    run    Run a command in a new container  #创建一个新的容器并运行一个命令
    save    Save an image(s) to a tar archive#保存一个镜像为一个tar包(对应load)
    search    Search the Docker Hub for images  #在docker # hub中搜索镜像
    start    Start one or more stopped containers#启动容器
    stats    Display a live stream of container(s) resource usage statistics  #统计容器使用资源
    stop    Stop a running container  #停止容器
    tag         Tag an image into a repository  #给源中镜像打标签
    top       Display the running processes of a container #查看容器中运行的进程信息
    unpause    Unpause all processes within a container  #取消暂停容器
    version    Show the Docker version information#查看容器版本号
    wait         Block until a container stops, then print its exit code  #截取容器停止时的退出状态值
  
Run 'docker COMMAND --help' for more information on a command.  
运行docker命令在帮助可以获取更多信息
```



### 目录

1. 什么是Docker？
2. Docker的应用场景有哪些？
3. Docker的优点有哪些？
4. Docker与虚拟机的区别是什么？
5. Docker的三大核心是什么？
6. 如何快速安装Docker？
7. 如何修改Docker的存储位置？
8. Docker镜像常用管理有哪些？
9. 如何创建Docker容器？
10. Docker在后台的标准运行过程是什么？
11. Docker网络模式有哪些？
12. 什么是Docker的数据卷
13. 如何搭建Docker私有仓库
14. Docker如何迁移备份？
15. Docker如何部署MySQL？

### 1.什么是Docker？

- Docker 是一个开源的应用容器引擎，基于go 语言开发并遵循了apache2.0 协议开源
- Docker 是在Linux 容器里运行应用的开源工具，是一种轻量级的“虚拟机”
- Docker 的容器技术可以在一台主机上轻松为任何应用创建一个轻量级的，可移植的，自给自足的容器

也可以这样形象的比喻：

> Docker 的Logo设计为蓝色鲸鱼，拖着许多集装箱，鲸鱼可以看作为宿主机，集装箱可以理解为相互隔离的容器，每个集装箱中都包含自己的应用程序。

### 2.Docker的应用场景有哪些？

- Web 应用的自动化打包和发布。
- 自动化测试和持续集成、发布。
- 在服务型环境中部署和调整数据库或其他的后台应用。
- 从头编译或者扩展现有的 OpenShift 或 Cloud Foundry 平台来搭建自己的 PaaS 环境。

在这里我重点介绍下Docker作为内部开发环境的场景

在容器技术出现之前，公司往往是通过为每个开发人员提供一台或者多台虚拟机来充当开发测试环境。开发测试环境一般负载较低，大量的系统资源都被浪费在虚拟机本身的进程上了。

Docker容器没有任何CPU和内存上的额外开销，很适合用来提供公司内部的开发测试环境。而且由于docker镜像可以很方便的在公司内部分享，这对开发环境的规范性也有极大的帮助。

如果要把容器作为开发机使用，需要解决的是远程登录容器和容器内进程管理问题。虽然docker的初衷是为“微服务”架构设计的，但根据我们的实际使用经验，在docker内运行多个程序，甚至sshd或者upstart也是可行的。

### 3.Docker的优点有哪些？

容器化越来越受欢迎，Docker的容器有点总结如下：

- 灵活：即使是最复杂的应用也可以集装箱化。
- 轻量级：容器利用并共享主机内核。
- 可互换：可以即时部署更新和升级。
- 便携式：可以在本地构建，部署到云，并在任何地方运行。
- 可扩展：可以增加并白动分发容器副本。
- 可堆叠：可以垂直和即时堆叠服务。

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB8oibHU8Xe0x29dY0gCibbrZSbiaaPoYhnsNrs5URy54GGtQmsmToUiaA7YA/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

Docker 是一个用于开发，交付和运行应用程序的开放平台。Docker 使您能够将应用程序与基础架构分开，从而可以快速交付软件。借助 Docker，您可以与管理应用程序相同的方式来管理基础架构。通过利用 Docker 的方法来快速交付，测试和部署代码，您可以大大减少编写代码和在生产环境中运行代码之间的延迟。

### 4.Docker与虚拟机的区别是什么？

虚拟机通过添加Hypervisor层（虚拟化中间层），虚拟出网卡、内存、CPU等虚拟硬件，再在其上建立虚拟机，每个虚拟机都有自己的系统内核。而Docker容器则是通过隔离（namesapce）的方式，将文件系统、进程、设备、网络等资源进行隔离，再对权限、CPU资源等进行控制（cgroup），最终让容器之间互不影响，容器无法影响宿主机。

与虚拟机相比，容器资源损耗要少。同样的宿主机下，能够建立容器的数量要比虚拟机多

但是，虚拟机的安全性要比容器稍好，而docker容器与宿主机共享内核、文件系统等资源，更有可能对其他容器、宿主机产生影响。

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB83vDs1RFOicYyrDFQE1Xx0PEa4EqicH3f6rgEMNztbWWgBwPLPNn9YZaw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

### 5.Docker的三大核心是什么？

##### 镜像 image

Docker的镜像是创建容器的基础，类似虚拟机的快照，可以理解为一个面向Docker容器引擎的只读模板。

通过镜像启动一个容器，一个镜像是一个可执行的包，其中包括运行应用程序所需要的所有内容包含代码，运行时间，库、环境变量、和配置文件。

Docker镜像也是一个压缩包，只是这个压缩包不只是可执行文件，环境部署脚本，它还包含了完整的操作系统。因为大部分的镜像都是基于某个操作系统来构建，所以很轻松的就可以构建本地和远端一样的环境，这也是Docker镜像的精髓。

##### 容器 container

Docker的容器是从镜像创建的运行实例，它可以被启动、停止和删除。所创建的每一个容器都是相互隔离、互不可见，以保证平台的安全性。可以把容器看做是一个简易版的linux环境（包括root用户权限、镜像空间、用户空间和网络空间等）和运行在其中的应用程序。

##### 仓库 repository

仓库注册服务器上往往存放着多个仓库，每个仓库中包含了多个镜像，每个镜像有不同标签（tag）。

仓库分为公开仓库（Public）和私有仓库（Private）两种形式。

最大的公开仓库是 Docker Hub:`https://hub.docker.com`，存放了数量庞大的镜像供用户下载。

国内的公开仓库包括阿里云 、网易云等。

### 6.如何快速安装Docker？

执行以下安装命令去安装依赖包

```
yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager
–add-repo
https://download.docker.com/linux/centos/docker-ce.repo
[root@centos7 ~] yum -y install docker-ce docker-ce-cli containerd.io
[root@centos7 ~]# docker ps --查看docker
```

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB87HyDSUJeISnTnichXcZMeOpKQvwJJ2G8ZkCwYsibuCX4wicuKygbwfn4w/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

```
[root@centos7 ~]# systemctl enable docker
[root@centos7 ~]# systemctl start docker
[root@centos7 ~]# systemctl status docker
[root@centos7 ~]# docker ps --查看容器
[root@centos7 ~]# docker version --查看版本
[root@centos7 ~]# docker info --查看版本
```

### 7.如何修改Docker的存储位置？

默认情况下 Docker的存放位置为：`/var/lib/docker`

可以通过命令查看具体位置：`docker info | grep “Docker Root Dir”`

##### 修改到其它目录

首先停掉 Docker 服务：

```
systemctl stop docker
```

然后移动整个/var/lib/docker 目录到目的路径

```
mkdir -p /root/data/docker
mv /var/lib/docker /root/data/docker
ln -s /root/data/docker /var/lib/docker --快捷方式
```

### 8.Docker镜像常用管理有哪些？

##### 快速检索镜像

格式：`docker search` 关键字

##### 获取镜像

格式：`docker   pull`  仓库名称[:标签] 如果下载镜像时不指定标签，则默认会下载仓库中最新版本的镜像，即选择标签为 latest 标签

##### 查看镜像信息

镜像下载后默认存放在 `/var/lib/docker`

- `REPOSITORY`: 镜像所属仓库
- `TAG`: 镜像的标签信息，标记同一个仓库中的不同镜像
- `IMAGE ID` ：镜像的唯一ID号，唯一标识一个镜像
- `CREATED`: 镜像创建时间
- `SIZE`: 镜像大小

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB85kgRFoA3k7NGlMG40qIEmUT8yEt5FwhybRLY8J3ambyESutLgfDO3A/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

##### 获取镜像的详细信息

格式：`docker   inspect`  镜像ID号

镜像ID 号可以不用打全。

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB81MLYxrTLHeSIfiaAlwib6NtQHPBqiamS5GibCfMmUZ5L2RibeqiaQSibanELw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

##### 为本地镜像添加新的标签

格式：`docker   tag  名称:[ 标签]`

##### 删除镜像

格式1：`docker   rmi   仓库名称:标签`

当一个镜像有多个标签时，只是删除其中指定的标签

格式2: `docker   rmi  镜像ID  [-f]`

如果该镜像已经被容器使用，正确的做法是先删除依赖该镜像的所有容器，再去删除镜像

##### 将镜像保存为本地文件

格式：`docker   save   -o  存储文件名   存储的镜像`

```
[root@localhost ~]# docker save -o /opt/nginx.tar nginx:latest
#将本地镜像传给另一台主机
[root@localhost ~]# scp /opt/nginx.tar 192.168.1.54:/opt
```

### 9.如何创建Docker容器？

```
#docker images   --镜像
docker run -d --name centos7.8 -h centos7.8 \
-p 220:22 -p 3387:3389 \
--privileged=true \
centos:7.8.2003 /usr/sbin/init

#我想拥有一个 linux 8.2 的环境
docker run -d --name centos8.2 -h centos8.2 \
-p 230:22 -p 3386:3389 \
--privileged=true \
daocloud.io/library/centos:8.2.2004 init

# 进入容器
docker exec -it centos7.8bash
docker exec -it centos8.2 bash
cat /etc/redhat-release    --查看系统版本
```

### 10.Docker在后台的标准运行过程是什么？

当利用 `docker run` 来创建容器时， Docker 在后台的标准运行过程是：

- 检查本地是否存在指定的镜像。当镜像不存在时，会从公有仓库下载；
- 利用镜像创建并启动一个容器；
- 分配一个文件系统给容器，在只读的镜像层外面挂载一层可读写层；
- 从宿主主机配置的网桥接口中桥接一个虚拟机接口到容器中；
- 分配一个地址池中的 IP 地址给容器；
- 执行用户指定的应用程序，执行完毕后容器被终止运行。

### 11.Docker网络模式有哪些？

##### host模式

host 模式 ：使用 `--net=host` 指定

相当于VMware 中的桥接模式，与宿主机在同一个网络中，但是没有独立IP地址

Docker 使用了Linux 的Namespace 技术来进行资源隔离，如`PID Namespace`隔离进程，`Mount Namespace`隔离文件系统，`Network Namespace` 隔离网络等。

一个`Network Namespace` 提供了一份独立的网络环境，包括网卡，路由，iptable 规则等都与其他`Network Namespace` 隔离。

一个Docker 容器一般会分配一个独立的`Network Namespace`

但是如果启动容器的时候使用host 模式，那么这个容器将不会获得一个独立的`Network Namespace` ，而是和宿主机共用一个`Network Namespace` 。容器将不会虚拟出自己的网卡，配置自己的IP等，而是使用宿主机的IP和端口.此时容器不再拥有隔离的、独立的网络栈。不拥有所有端口资源

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB80If17VF9yUiaxoXe8YjqWwEBEicFARkc0UylL8HYdWN3hvAfnyVBI2Xg/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

##### container模式

container模式：使用`–net=contatiner:NAME_or_ID `指定

这个模式指定新创建的容器和已经存在的一个容器共享一个`Network Namespace`，而不是和宿主机共享。**新创建的容器不会创建自己的网卡，配置自己的IP，而是和一个指定的容器共享IP，端口范围等。** 可以在一定程度上节省网络资源，容器内部依然不会拥有所有端口。

同样，两个容器除了网络方面，其他的如文件系统，进程列表等还是隔离的。

两个容器的进程可以通过lo网卡设备通信

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB8bNMcAdjian2X8BL5LpLPHibk2MRnGe9FFOzX7Zuib0KEe0liag7ia4qibuZw/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

##### none 模式

none模式:使用 `--net=none`指定

使用none 模式，docker 容器有自己的`network Namespace` ，但是并不为Docker 容器进行任何网络配置。也就是说，这个Docker 容器没有网卡，ip， 路由等信息。

这种网络模式下，容器只有lo 回环网络，没有其他网卡。

这种类型没有办法联网，但是封闭的网络能很好的保证容器的安全性

该容器将完全独立于网络，用户可以根据需要为容器添加网卡。此模式拥有所有端口。（none网络模式配置网络）特殊情况下才会用到，一般不用

##### bridge 模式

相当于Vmware中的 nat 模式，容器使用独立`network Namespace`，并连接到docker0虚拟网卡。通过docker0网桥以及`iptables nat`表配置与宿主机通信，此模式会为每一个容器分配`Network Namespace`、设置IP等，并将一个主机上的 Docker 容器连接到一个虚拟网桥上。

当Docker进程启动时，会在主机上创建一个名为docker0的虚拟网桥，此主机上启动的Docker容器会连接到这个虚拟网桥上。虚拟网桥的工作方式和物理交换机类似，这样主机上的所有容器就通过交换机连在了一个二层网络中。

从docker0子网中分配一个IP给容器使用，并设置docker0的IP地址为容器的默认网关。在主机上创建一对虚拟网卡`veth pair`设备。veth设备总是成对出现的，它们组成了一个数据的通道，数据从一个设备进入，就会从另一个设备出来。因此，veth设备常用来连接两个网络设备。

Docker将`veth pair` 设备的一端放在新创建的容器中，并命名为eth0（容器的网卡），另一端放在主机中， 以`veth*`这样类似的名字命名，并将这个网络设备加入到docker0网桥中。可以通过 `brctl show` 命令查看。

容器之间通过`veth pair`进行访问

使用 `docker run -p` 时，docker实际是在iptables做了DNAT规则，实现端口转发功能。

可以使用`iptables -t nat -vnL` 查看。

![Image](https://mmbiz.qpic.cn/mmbiz_png/8KKrHK5ic6XBBkjg9F1QSQxP8nUib0JvB8HuS4gqTTdXKzaSMcbRen5NbcfdFYtB2PwTe9k6icrHlRl2wR6wJpcww/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)

### 12.什么是Docker的数据卷

数据卷是一个供容器使用的特殊目录，位于容器中。可将宿主机的目录挂载到数据卷上，对数据卷的修改操作立刻可见，并且更新数据不会影响镜像，从而实现数据在宿主机与容器之间的迁移。数据卷的使用类似于Linux下对目录进行的mount操作。

如果需要在容器之间共享一些数据，最简单的方法就是使用数据卷容器。数据卷容器是一个普通的容器，专门提供数据卷给其他容器挂载使用。

容器互联是通过容器的名称在容器间建立一条专门的网络通信隧道。简单点说，就是会在源容器和接收容器之间建立一条隧道，接收容器可以看到源容器指定的信息

### 13.如何搭建Docker私有仓库

1.拉取私有仓库镜像

```
[root@jeames ~]# docker pull registry
Using default tag: latest
```

2.启动私有仓库容器

```
docker run -di --name registry -p 5000:5000 registry
docker update --restart=always registry   --开机自启动
docker ps -a  --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
```

访问网址：`http://192.168.1.54:5000/v2/_catalog`

3.设置信任

```
[root@jeames ~]# vi /etc/docker/daemon.json
{
"registry-mirrors":["https://docker.mirrors.ustc.edu.cn"],
"insecure-registries":["192.168.1.54:5000"]
}

[root@jeames ~]# systemctl restart docker   --重启docker
```

4.上传本地镜像

```
[root@jeames ~]# docker images
[root@jeames ~]# docker tag postgres:11 192.168.1.54:5000/postgres

[root@jeames ~]# docker push 192.168.1.54:5000/postgres
```

5.重新拉取镜像

```
[root@jeames ~]# docker rmi 192.168.1.54:5000/postgres
[root@jeames ~]# docker images
[root@jeames ~]# docker pull 192.168.1.54:5000/postgres
```

### 14.Docker如何迁移备份？

1.容器保存为镜像

```
[root@jeames ~]# docker images
[root@jeames ~]# docker ps -a
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
[root@jeames ~]# docker commit redis myredis
##使用新的镜像创建容器
docker run -di --name myredis myredis
```

2.镜像的备份

```
[root@jeames ~]# docker save -o myredis.tar myredis
```

默认放到当前目录

```
[root@jeames ~]# ll
[root@jeames ~]# pwd
```

3.恢复过程

```
##删除容器
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
docker stop myredis
docker rm myredis
##删除镜像
docker images
docker rmi myredis
[root@jeames ~]# docker load -i myredis.tar
```

### 15. Docker如何部署MySQL？

##### 1.下载镜像

```
https://hub.docker.com/ 中搜索mysql
[root@jeames ~]# docker pull mysql:5.7.30
[root@jeames ~]# docker pull mysql:8.0.20
```

##### 2.安装部署

2.1 创建容器

```
mkdir -p /usr/local/mysql5730/
mkdir -p /usr/local/mysql8020/

docker run -d --name mysql5730 -h mysql5730 \
-p 3309:3306 \
-v /usr/local/mysql5730/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root -e TZ=Asia/Shanghai \
mysql:5.7.30

docker run -d --name mysql8020 -h mysql8020 \
-p 3310:3306 \
-v /usr/local/mysql8020/conf:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=root -e TZ=Asia/Shanghai \
mysql:8.0.20
```

2.2 访问Mysql

```
##登陆容器
docker exec -it mysql5730 bash
mysql -uroot -proot
mysql> select user,host from mysql.user

##远程访问
mysql -uroot -proot -h192.168.59.220 -P3309

```
