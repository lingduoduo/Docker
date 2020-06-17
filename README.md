### UNDERSTANDING JARGON AROUND DOCKER

Now that we have Docker installed and running, let’s understand the different terminologies that are associated with Docker.

#### Layers

A *layer* is a modification applied to a Docker image as represented by an instruction in a Dockerfile. Typically, a layer is created when a base image is changed—for example, consider a Dockerfile that looks like this:

FROM ubuntu

Run mkdir /tmp/logs

RUN apt-get install vim

RUN apt-get install htop

Now in this case, Docker will consider Ubuntu image as the base image and add three layers:

- One layer for creating /tmp/logs
- One other layer that installs vim
- A third layer that installs htop

When Docker builds the image, each layer is stacked on the next and merged into a single layer using the union filesystem. Layers are uniquely identified using sha256 hashes. This makes it easy to reuse and cache them. When Docker scans a base image, it scans for the IDs of all the layers that constitute the image and begins to download the layers. If a layer exists in the local cache, it skips downloading the cached image.

#### Docker Image

Docker image is a read-only template that forms the foundation of your application. It is very much similar to, say, a shell script that prepares a system with the desired state. In simpler terms, it’s the equivalent of a cooking recipe that has step-by-step instructions for making the final dish.

A Docker image starts with a base image—typically the one selected is that of an operating system are most familiar with, such as Ubuntu. On top of this image, we can add build our application stack adding the packages as and when required.

There are many pre-built images for some of the most common application stacks, such as Ruby on Rails, Django, PHP-FPM with nginx, and so on. On the advanced scale, to keep the image size as low as possible, we can also start with slim packages, such as Alpine or even Scratch, which is Docker’s reserved, minimal starting image for building other images.

Docker images are created using a series of commands, known as instructions, in the Dockerfile. The presence of a Dockerfile in the root of a project repository is a good indicator that the program is container-friendly. We can build our own images from the associated Dockerfile and the built image is then published to a registry. We will take a deeper look at Dockerfile in later chapters. For now, consider the Docker image as the final executable package that contains everything to run an application. This includes the source code, the required libraries, and any dependencies.

#### Docker Container

A Docker image, when it’s run in a host computer, spawns a process with its own namespace, known as a *Docker container*. The main difference between a Docker image and a container is the presence of a thin read/write layer known as the container layer. Any changes to the filesystem of a container, such as writing new files or modifying existing files, are done to this writable container layer than the lower layers.

An important aspect to grasp is that when a container is running, the changes are applied to the container layer and when the container is stopped/killed, the container layer is not saved. Hence, all changes are lost. This aspect of containers is not understood very well and for this reason, stateful applications and those requiring persistent data were initially not recommended as containerized applications. However, with Docker Volumes, there are ways to get around this limitation. We discuss Docker Volumes more in Chapter [5](https://learning.oreilly.com/library/view/practical-docker-with/9781484237847/html/463857_1_En_5_Chapter.xhtml), “Understanding Docker Volumes”.

#### Bind Mounts and Volumes

We mentioned previously that when a container is running, any changes to the container are present in the container layer of the filesystem. When a container is killed, the changes are lost and the data is no longer accessible. Even when a container is running, getting data out of it is not very straightforward. In addition, writing into the container’s writable layer requires a storage driver to manage the filesystem. The storage driver provides an abstraction on the filesystem available to persist the changes and this abstraction often reduces performance.

For these reasons, Docker provides different ways to mount data into a container from the Docker host: volumes, bind mounts, and tmpfs volumes. While tmpfs volumes are stored in the host system’s memory only, bind mounts and volumes are stored in the host filesystem.

We explore Docker Volumes in detail in Chapter [5](https://learning.oreilly.com/library/view/practical-docker-with/9781484237847/html/463857_1_En_5_Chapter.xhtml), “Understanding Docker Volumes”.

#### Docker Registry

We mentioned earlier that you can leverage existing images of common application stacks—have you ever wondered where these are and how you can use them in building your application? A Docker Registry is a place where you can store Docker images so that they can be used as the basis for an application stack. Some common examples of Docker registries include the following:

- Docker Hub
- Google Container Registry
- Amazon Elastic Container Registry
- JFrog Artifactory

Most of these registries also allow for the visibility level of the images that you have pushed to be set as public/private. Private registries will prevent your Docker images from being accessible to the public, allowing you to set up access control so that only authorized users can use your Docker image.

#### Dockerfile

A *Dockerfile* is a set of instructions that tells Docker how to build an image. A typical Dockerfile is made up of the following:

- A FROM instruction that tells Docker what the base image is
- An ENV instruction to pass an environment variable
- A RUN instruction to run some shell commands (for example, install-dependent programs not available in the base image)
- A CMD or an ENTRYPOINT instruction that tells Docker which executable to run when a container is started

As you can see, the Dockerfile instruction set has clear and simple syntax, which makes it easy to understand. We take a deeper look at Dockerfiles later in the book.

#### Docker Engine

Docker Engine is the core part of Docker. Docker Engine is a client-server application that provides the platform, the runtime, and the tooling for building and managing Docker images, Docker containers, and more. Docker Engine provides the following:

- Docker daemon
- Docker CLI
- Docker API

##### Docker Daemon

- The Docker daemon is a service that runs in the background of the host computer and handles the heavy lifting of most of the Docker commands. The daemon listens for API requests for creating and managing Docker objects, such as containers, networks, and volumes. Docker daemon can also talk to other daemons for managing and monitoring Docker containers. Some examples of inter-daemon communication include communication Datadog for container metrics monitoring and Aqua for container security monitoring.

##### Docker CLI

Docker CLI is the primary way that you will interact with Docker. Docker CLI exposes a set of commands that you can provide. The Docker CLI forwards the request to Docker daemon, which then performs the necessary work.

While the Docker CLI includes a huge variety of commands and sub-commands, the most common commands that we will work with in this book are as mentioned:

docker build

docker pull

docker run

docker exec
