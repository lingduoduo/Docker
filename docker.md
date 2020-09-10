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

**Kubernetes**

When a microservice application is deployed in production, it usually has many running containers that need to be allocated the right amount of resources in response to user demands. Also, there is a need to ensure that the containers are online, are running, and are communicating with one another. The need to efficiently manage and coordinate clusters of containerized applications gave rise to Kubernetes.

Kubernetes is a software system that addresses the concerns of deploying, scaling, and monitoring containers. Hence, it is called a container orchestrator. Examples of other container orchestrators in the wild are Docker Swarm, Mesos Marathon, and HashiCorp Nomad.

Kubernetes was built and released by Google as an open source software, which is now managed by the Cloud Native Computing Foundation (CNCF) . Google Cloud Platform offers a managed Kubernetes service called Google Kubernetes Engine (GKE). Amazon Elastic Container Service for Kubernetes (EKS) also provides a managed Kubernetes service.

**Components of Kubernetes**

- Master node(s): Manages the Kubernetes cluster. There may be more than one master node in high availability mode for fault-tolerance purposes. In this case, only one is the master, and the others follow.
- Worker node(s): Machine(s) that runs containerized applications that are scheduled as pod(s).

``