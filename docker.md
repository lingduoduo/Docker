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
