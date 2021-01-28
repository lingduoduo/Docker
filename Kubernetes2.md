### Kubernetes + Docker

Docker

Clients

docker build,  docker pull, docker run

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
- Each RUN command will. execute the command on the top writable layer of the container, then commit the container as a new image. The new image is used for the next step in the Docekrfile. So each RUN instruction will create a new image layer. It is recommended to chain the RUN instructions in the Dockerfile to reduce the number of image layers it creates. Sort Multi-line Arguments Alphanumerically.
- CMD Instruction specifies what command. you want to run when the container starts up. Docker will use the default command defined in the base image.
- 

Docker_Hosts

- Docker daemon - Docker Engine, Docker Server
- Images - read-only templates used to create containers
- Containers - lightweight and portable encapsulations of an environment in which to. run applications
- If an image is a class, then a container is an instance of a class - a runtime object.  Container are created from images. Inside a container, if has all teh ibnaries and dependencies to run the application.

Registry

- A registry is where we store our images.
- You can host your own registry, or you can use Docker's public registry which is called DockerHub
- Inside a registry, images are stored in repositories.
- Docker repository is a collection of different docker images with the same name, that have different tags, each tag usually represents a different version of the image.

Image Layers

- All changes made into the running containers will be written into the writable layer
- When the container is deleted, the wirtable layer is also deleted, but the underlying image remains unchanged.
- Multiple containers can sare access to the same underlying image.

**Kubernetes**

When a microservice application is deployed in production, it usually has many running containers that need to be allocated the right amount of resources in response to user demands. Also, there is a need to ensure that the containers are online, are running, and are communicating with one another. The need to efficiently manage and coordinate clusters of containerized applications gave rise to Kubernetes.

Kubernetes is a software system that addresses the concerns of deploying, scaling, and monitoring containers. Hence, it is called a container orchestrator. Examples of other container orchestrators in the wild are Docker Swarm, Mesos Marathon, and HashiCorp Nomad.

Kubernetes was built and released by Google as an open source software, which is now managed by the Cloud Native Computing Foundation (CNCF) . Google Cloud Platform offers a managed Kubernetes service called Google Kubernetes Engine (GKE). Amazon Elastic Container Service for Kubernetes (EKS) also provides a managed Kubernetes service.

**Components of Kubernetes**

- Master node(s): Manages the Kubernetes cluster. There may be more than one master node in high availability mode for fault-tolerance purposes. In this case, only one is the master, and the others follow.
- Worker node(s): Machine(s) that runs containerized applications that are scheduled as pod(s).

### Launch Single Node Kubernetes Cluster

#### Step 1 - Start Minikube

Minikube has been installed and configured in the environment. Check that it is properly installed, by running the *minikube version* command:

```
minikube version
```

Start the cluster, by running the *minikube start* command:

```
minikube start --wait=false
```

Great! You now have a running Kubernetes cluster in your online terminal. Minikube started a virtual machine for you, and a Kubernetes cluster is now running in that VM.

#### Step 2 - Cluster Info

The cluster can be interacted with using the *kubectl* CLI. This is the main approach used for managing Kubernetes and the applications running on top of the cluster.

Details of the cluster and its health status can be discovered via `kubectl cluster-info`

To view the nodes in the cluster using `kubectl get nodes`

If the node is marked as **NotReady** then it is still starting the components.

This command shows all nodes that can be used to host our applications. Now we have only one node, and we can see that it’s status is ready (it is ready to accept applications for deployment).

#### Step 3 - Deploy Containers

With a running Kubernetes cluster, containers can now be deployed.

Using `kubectl run`, it allows containers to be deployed onto the cluster -

 `kubectl create deployment first-deployment --image=katacoda/docker-http-server`

The status of the deployment can be discovered via the running Pods - `kubectl get pods`

Once the container is running it can be exposed via different networking options, depending on requirements. One possible solution is NodePort, that provides a dynamic port to a container.

```
kubectl expose deployment first-deployment --port=80 --type=NodePort
```

The command below finds the allocated port and executes a HTTP request.

```
export PORT=$(kubectl get svc first-deployment -o go-template='{{range.spec.ports}}{{if .nodePort}}{{.nodePort}}{{"\n"}}{{end}}{{end}}') echo "Accessing host01:$PORT" curl host01:$PORT
```

The result is the container that processed the request.

#### Step 4 - Dashboard

Enable the dashboard using Minikube with the command `minikube addons enable dashboard`

Make the Kubernetes Dashboard available by deploying the following YAML definition. This should only be used on Katacoda.

```
kubectl apply -f /opt/kubernetes-dashboard.yaml
```

The Kubernetes dashboard allows you to view your applications in a UI. In this deployment, the dashboard has been made available on port *30000* but may take a while to start.

To see the progress of the Dashboard starting, watch the Pods within the *kube-system* namespace using `kubectl get pods -n kubernetes-dashboard -w`

Once running, the URL to the dashboard is https://2886795290-30000-host12nc.environments.katacoda.com/

