#### What is Docker

- Docker is a platform that allows you to "build, shipa nd run any app, anywhere".Docker enables you to seperate your applications from your infrastructre so you can deliver software quickly.
- Docker daemon listened for Docker API requests and manages Docker objects ushc as images, containers, networks, and volumes. A daemon can also communicate with other daemons to mange Docker servies.
- Docker client is the primary way that many Docker users interact with Docker. When you use commands such as "docker run", the client sends these commands to docker daemon.
- Docker registry stores Docker images. Docker Hub is a public registry that anyone can use, and Docker is configured to look for images on Docker Hub by default. 
- Docker image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization.
- Docker container is a runnable instance of an image. By default, a conatiner is relatively well isolated from other containers and its host machine. When a container is removed, any changes to its state that are not stored in persistent storage disappear.

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

**Running a Docker Container**

docker run -d -it --rm --name [CONTAINER_NAME] -p 8081:80 [IMAGE_NAME]

where

- -d runs the container in detached mode. This mode runs the container in the background.
- -it runs in interactive mode, with a terminal session attached.
- --rm removes the container when it exits.
- --name specifies a name for the container.
- -p does port forwarding from host to the container (i.e., host:container) .

##  Docker

Clients - docker build,  docker pull, docker run

```
docker run busybox:latest echo "Hello World"
docker run busybox:latest ls /
docker run -d busybox:latest
docker run -d busybox:latest sleep 1000
docker run --name hello busybox:latest

docker run -it -p 8888:8080 tomcat:latest

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

- Docker run, the -i flag starts an interactive container. The -t flag creates a pseudo-TTY that attaches stdin and stdout. 
- Docker build command takes the path to the build context as an. argument. When build start, docker client would pack all the files in the build context into a. tarball tehn transfer the tarball file to the daemon. By default, docker would search for the Docker file in the buid context path.
  - Commit changes made in a Docker container. For example, Spin up a container from a base image. Install Git package in the container. Commit changes made in the container. Docker commit command would save the changes we made to the Docker container's file system to a new Image.
  - Each RUN command will execute the command on the top writable layer of the container, then commit the container as a new image. The new image is used for the next step in the Docekrfile. So each RUN instruction will create a new image layer. It is recommended to chain the RUN instructions in the Dockerfile to reduce the number of image layers it creates. Sort Multi-line Arguments Alphanumerically.
  - CMD Instruction specifies what command. you want to run when the container starts up. Docker will use the default command defined in the base image.
  - Docker Cache. Each time Docker executes an. instruction it builds a new image layer. The next time, if the instruction doesn't change, Docker will simply reuse the existing layer. Sometime it has issues, e.g, aggressive caching. Specify with --no-cache option
  - Copy Instruction copies new files or directories from build context and adds them to the file system of the container.   Use copy for the sake of transparency, unless you are absolutely sure you need ADD commands.
  - Add Instruction can not only copy files, but also allow you to download a file from. internet and copy to the container. It also has the ability to automatically unpack compressed files.

Docker_Hosts

- Docker daemon - Docker Engine, Docker Server
- Images - read-only templates used to create containers
- Containers - lightweight and portable encapsulations of an environment in which to. run applications
- If an image is a class, then a container is an instance of a class - a runtime object.  Container are created from images. Inside a container, if has all teh ibnaries and dependencies to run the application.
- Go to https://

Registry

- A registry is where we store our images.
- You can host your own registry, or you can use Docker's public registry which is called DockerHub
- Inside a registry, images are stored in repositories.
- Docker repository is a collection of different docker images with the same name, that have different tags, each tag usually represents a different version of the image. 
  - Docker will use latest as a default tag when no tag is provided. 
  - A lot of repositories use it to tag the most up-to-date table image.  However, this is still only. a convention and is entirely not being enforced.
  - Images which are tagged latest will not be updated automatically when a newer version of the image is pushed to the repository.

Image Layers

- All changes made into the running containers will be written into the writable layer

- When the container is deleted, the wirtable layer is also deleted, but the underlying image remains unchanged.

- Multiple containers can share access to the same underlying image.

  ```
  docker images
  
  docker tag 345867df0879  lingh/test
  docker login --username=lingh
  docker push lingh/test:0.01
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

    



