Introduction for Container Orchestration

- Docker is by-and-far the leader. Defines a container format(Dockerfile, registry to host containers (public. and private)
- Auto-scaling, cloud-agnostic-yet-integratable technologies
- Evaluation/Training - minikube (local version of k8s)
- Development - mininkube, dev cluster on a cloud provider
- Deployment - cloud provider or bare metal
- k8s. on AWS can be set. up directly on EC2 instances by hand or using kops, which can produce grade k8s installation, upgrades, and management - maintained by the CNCF
- GCP has high-level support for Kubernetes through its GKE(Google Container Engine) offering, automates cluster setup, maitenance, monitoring, scaling, health checking

Understanding and Using Containers

- A container is a self-contained application. The kernal namespaces. provide stict isolation between system components at different levels
  - network, file, users, processes, IPCs
- The container runtime is running a host platform and establishes communication between the local host kernel and the container. The container runtime allows for starting and running the container on top of the host OS. The container runtime is responseible for all parts of running the container which are not already a part of the running container program itself.
  - docker, podman, lxc, runc, cri-o
- Docker is importatnt in the container landscape,
  - Dockerfile, which is a method for building container images.
  - A way to mangage container images, run containers, manage container instances, share container images
- Images are read-only enviornments that conaitn the runtime environment which includes the application and alll libraries it requires
- Registries are used to storage images. Docker Hub is a common registry, but provide registries can be created also
- Containers are the isolated runtime environments where the application is running. By using the namespaces the containers can be offered as a strictly isolated environment.

Understanding Kubernetes

Creating a Lab Environment







