#### What Is Docker?

Docker describe themselves as "an opoen platform fro developers and sysadmins to build, ship, and run distributed applications".

Docker allow ou ot run containers. A container is a sandoxed process running an application and its dependencies on the host operating system. The application inside the container considers itself to be the only process runnign on the machien while the machine can run multiple containers independently. 

Docker has three key components. 

First, the Docker engineer, which provides a way to start containers on mulitple different operating system platforms.

Second, the Docker client, which allows you to communicate with eht Engine.

Third, public Docker registry, which hosts Docker images. These images can be launched or extended to match your requirements and application deployment.

#### Step 1 - Running A Container

To start a container, you can either build your Docker image or, using an existing image created by Docker and the community. 

For example, to find an image for Redis, an object-relational database system, you would use

```
docker search --filter=stars=3 redis
```

**Task**

After identifying the image name using *search*, you can launch it using 

```
docker run <option> <image-name>  
```

By default, Docker will run a command in the foreground. To run in the background, you need to specify the option *-d*.

At this stage, you will not have a local copy of the image so that it will be downloaded from the Docker registry. If you launch a second container, the local image will be used.

All containers are given a name and id for use in other Docker commands. You can set the friendly name by providing the option *--name * when launching a container such as *--name redis*. we used the *-d* to execute the container in a detached, background, state. 

```
docker run -d redis:latest
```

#### Step 2 - Listing Running Containers

```docker ps```  lists all running containers, the image used to start the container and uptime.

```
docker inspect <friendly-name|container-id>
``` 
provides more details about a running container, such as IP address, volumes mounted and their locations and its current execution state.

```
docker logs <friendly-name|container-id>
``` 
will display messages the container has written to standard error or standard out.

#### Step 3 - Binding Ports

Each contianer is sandoxedf rom other containers. If a service needs to be accessible externally, then you need to expose a port to be mapped to the host. Once mapped, you will then be able to access the serivce as if the process was runnign on the host OS iteself instead of in a container.

When starting the container, you define which ports you want to bind using the *-p :* option. The Redis container exposes the service on port 6379. If you wanted to map this port directly on the host, we'd use the option *-p 6379:6379*.

```
docker run -d --name redisHostPort -p 6379:6379 redis:latest
```

#### Step 4 - Binding Ports

```
docker run -d --name redisDynamic -p 6379 redis:latest
```

```
docker port redisDynamic 6379
```

#### Step 5 - Binding Directories

Containers are designed to be stateless. Any data we want to be persisted after a container is stopped should be saved to the host machine. This is done by mounting/binding host directories into the container.

Binding directories (also known as volumes) in Docker is similar to binding ports using the option *-v :*. When a directory is mounted, the files which exist in that directory on the host can be accessed by the container and any data changed/written to the directory inside the container will be stored on the host. This allows you to upgrade or change containers without losing your data. Docker allows you to use $PWD as a placeholder for the current directory.

```
docker run -d --name redisMapped -v "$PWD/data":/data redis
```

#### Step 6 - Running A Container In The Foreground

 If we wanted to interact with the container (for example, to access a command shell) instead of just seeing the output, we'd include the options *-ti*.

As well as defining whether the container runs in the background or foreground, certain images allow you to override the command used to launch the image. Being able to replace the default command makes it possible to have a single image that can be re-purposed in multiple ways. For example, the Ubuntu image can either run OS commands or run an interactive bash prompt using */bin/bash*

The command 
```
docker run ubuntu ps
```
launches an Ubuntu container and executes the command *ps* to view all the processes running in a container.

