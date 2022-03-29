### Docker Commands

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

### Docker command examples

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

docker build
docker pull
docker run

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
- docker run
```
后台运行一个docker
docker run -d centos /bin/sh -c "while true;do echo 正在运行; sleep 1;done"
    # -d  后台运行容器
    # /bin/sh  指定使用centos的bash解释器
    # -c 运行一段shell命令
    # "while true;do echo 正在运行; sleep 1;done"  在linux后台，每秒中打印一次正在运行
docker ps  # 检查容器进程
docker  logs  -f  容器id/名称  # 不间断打印容器的日志信息 
docker stop centos  # 停止容器
```

```
启动一个bash终端,允许用户进行交互
docker run --name mydocker -it centos /bin/bash  
    # --name  给容器定义一个名称
    # -i  让容器的标准输入保持打开
    # -t 让Docker分配一个伪终端,并绑定到容器的标准输入上
    # /bin/bash 指定docker容器，用shell解释器交互

docker run container
1. 检查本地是否存在指定的镜像，不存在就从公有仓库下载
2. 利用镜像创建并启动一个容器
3. 分配一个文件系统，并在只读的镜像层外面挂在一层可读写层
4. 从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
5. 从地址池配置一个ip地址给容器
6. 执行用户指定的应用程序
7. 执行完毕后容器被终止%%

docker stopped
[root@localhost ~]# docker ps -a  # 先查询记录
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                        PORTS                    NAMES
ee92fcf6f32d        centos              "/bin/bash"              4 days ago          Exited (137) 3 days ago                                kickass_raman

[root@localhost ~]# docker start ee9  # 再启动这个容器
ee9

[root@localhost ~]# docker exec -it  ee9 /bin/bash  # 进入容器交互式界面
[root@ee92fcf6f32d /]#   # 注意看用户名，已经变成容器用户名
```
- docker run image
```
1.我们进入交互式的centos容器中，发现没有vim命令
    docker run -it centos
2.在当前容器中，安装一个vim
    yum install -y vim
3.安装好vim之后，exit退出容器
    exit
4.查看刚才安装好vim的容器记录
    docker container ls -a
5.提交这个容器，创建新的image
    docker commit 059fdea031ba chaoyu/centos-vim
6.查看镜像文件
    docker images%%
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ling/centos-vim   latest              fd2685ae25fe        5 minutes ago       348MB
```

- docker run with -p
```
docker run -d -P training/webapp python app.py
 -P 参数会随机映射端口到容器开放的网络端口

检查映射的端口
docker ps -l
CONTAINER ID        IMAGE               COMMAND             CREATED            STATUS              PORTS                     NAMES
cfd632821d7a        training/webapp     "python app.py"     21 seconds ago      Up 20 seconds       0.0.0.0:32768->5000/tcp   brave_fermi
#宿主机ip:32768 映射容器的5000端口

查看容器日志信息
docker logs -f cfd  # #不间断显示log

# 也可以通过-p参数指定映射端口
docker run -d -p 9000:5000 training/webapp python app.py
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
