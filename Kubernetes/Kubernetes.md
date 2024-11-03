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

  ```
  ➜  Docker git:(master) docker --version
  Docker version 20.10.2, build 2291f61
  
  ➜  Docker git:(master) launchctl list | grep -i docker
  -	0	com.docker.helper
  445	0	com.docker.docker.43364
  
  ➜  Docker git:(master) launchctl list com.docker.docker.43364
  {
  	"LimitLoadToSessionType" = "Aqua";
  	"Label" = "com.docker.docker.43364";
  	"TimeOut" = 30;
  	"OnDemand" = true;
  	"LastExitStatus" = 0;
  	"PID" = 445;
  	"Program" = "/Applications/Docker.app/Contents/MacOS/Docker";
  	"ProgramArguments" = (
  		"/Applications/Docker.app/Contents/MacOS/Docker";
  	);
  	"PerJobMachServices" = {
  		"com.apple.tsm.portname" = mach-port-object;
  		"com.apple.coredrag" = mach-port-object;
  		"com.apple.axserver" = mach-port-object;
  	};
  };
  
  ➜  Docker git:(master) brew install pstree
  ➜  Docker git:(master) pstree -p 445
  ➜  Docker git:(master) ✗ echo hello from docker  >> ./var/www/index.html
  ➜  Docker git:(master) ✗ docker run -d -p 8080:80 --name="myapache" -v /var/www/html:/var/www/html httpd
  831f786f605bc3640e7e0248d6a00453c38b312adb6ba08f235a29102815d598
  ➜  Docker git:(master) ✗ docker ps
  CONTAINER ID   IMAGE     COMMAND              CREATED          STATUS          PORTS                  NAMES
  831f786f605b   httpd     "httpd-foreground"   39 seconds ago   Up 38 seconds   0.0.0.0:8080->80/tcp   myapache
  ➜  Docker git:(master) ✗ curl http://localhost:8080
  <html><body><h1>It works!</h1></body></html>
  
  ➜  Docker git:(master) ✗ docker run -it busybox
  
  And ctrl-p, ctrl-q to disconnect and keep it running

  ```

Understanding Kubernetes

- Understanding Kubernetes Core Functions
  - Kubernettes is. an open-source system for automating. deployment, scaling and managing of containerized applications
- Understanding Kubernetes Origins
- Understanding Kubernetes Management interfaces
  - API/REST -> etcd
    - The kubernetes API defines objects in a Kubernetes environment
    - kubectl commands - the kubectl command line utility provides convenient administrator access, allowing us to run many tasks against the cluster
    - dashboard
    - Direct API access using commands, such as curl allows develpers to addresst the cluster using API calls from custom scripts (curl, python code))

EKS is Amazon's implementation of the Kubernetes. Most of the K8S concentps are universal ot any Kubernetes platfrom, unless stated otherwise.

| K8s/EKS | Description                                                  |
| ------- | ------------------------------------------------------------ |
| Image   | Docker image                                                 |
| Pod     | A unit of workload that shares local host, consists of one or more containers |
|  Container    | A instantialtion of Docker image |
|  Sidecar    | An additional container in the pod that performas supporting fucntion (proxu/logging etc) |
|  Service    | An entity you can address that load-balances betwen pods, as opposed to address each pod individually |
|  Horizontal Pod Autoscaler    | Rules to define how many pods to run |
|  Resources: CPU/MEM    | Requests and limits or compute resources |
|  Deployment    | Defines workload, allows rolling updates |
|  Rollout    | Deployedment + advanced canary deployment |
|  ReplicaSet    | Controls number of running pods and groups them. Created by DeploymentRollout |
|  Ingress    | Definition of the inbound "gate" for the traffic into Kubernetes |
|  ConfigMap    | Key-value entry |
|  Secrets    | Opaque ConfigMap |
|  ServiceAccount    | The account that can be granted permissions and attached to a pod. IAM role is possible to be attached in EKS |
|  PodDisruptionBudget    | Assertion on how many pods should run at minimum durign nodes drain/replacement |
|  Istio VirtualService    | Istio-sprcific |
|  ServiceEntry    | Istio-specific. Specifies exteranlservices that are outside the service mesh |

```
kubectl get pods

kubectl run nginx --image=nginx

kubectl describe pod nginx

kubectl get pods -o wide

kubectl run redis --image=redis123 --dry-run -o yaml

kubectl run redis --image=redis123 --dry-run=client -o yaml > redis-pod.yaml

kubectl create -f redis-pod.yaml

kubectl apply -f redis-pod.yaml
```
