### Kubernetes 

**Kubernetes**

When a microservice application is deployed in production, it usually has many running containers that need to be allocated the right amount of resources in response to user demands. Also, there is a need to ensure that the containers are online, are running, and are communicating with one another. The need to efficiently manage and coordinate clusters of containerized applications gave rise to Kubernetes.

Kubernetes is a software system that addresses the concerns of deploying, scaling, and monitoring containers. Hence, it is called a container orchestrator. Examples of other container orchestrators in the wild are Docker Swarm, Mesos Marathon, and HashiCorp Nomad.

Kubernetes was built and released by Google as an open source software, which is now managed by the Cloud Native Computing Foundation (CNCF) . Google Cloud Platform offers a managed Kubernetes service called Google Kubernetes Engine (GKE). Amazon Elastic Container Service for Kubernetes (EKS) also provides a managed Kubernetes service.

**Components of Kubernetes**

- Master Node: Controls and manages the cluster. Manages the Kubernetes cluster. There may be more than one master node in high availability mode for fault-tolerance purposes. In this case, only one is the master, and the others follow. 
-  Worker node(s): Worker machine where containers are launched. Machine(s) that runs containerized applications that are scheduled as pod(s).
- Etcd: Consistent and highly-available key-value store.
- Kubelet: Ensures containers are running in a Pod.
- Kube Proxy: Maintains network rules.


### Kubernetes Cluster

- How we can deploy our Machine learning models using this Architecture
- What are the Master and Worker Node Components, How we can use them to deploy our ML Models.
- How we can use YAML files by providing our requirements
- Use cases of kubectl cli to communicate to our cluster
- What is DSC and how we can benefit from that

Gain Insights into Scaling and High Availability

Control Plane's Role: The Control Plane oversees container distribution across nodes, issuing deployment commands and managing container placement.

Developer Interaction: Developers use Kubectl within the Control Plane to command the deployment of containers. They specify details like the number of containers and their types.

YAML Configuration Files: YAML files contain vital application configurations, such as container names, replica numbers, pod details, and service settings (e.g., load balancer configurations). These files guide container deployment.

Kubectl Communication: Developers send YAML files to the Control Plane via Kubectl, enabling seamless communication and ensuring the accurate deployment of containers based on specified configurations.

### Container Deployment Process

Interaction with Kubelet: Deployment involves communication with Kubelet, a key Kubernetes component within nodes.

Request Handling: Kubelet processes commands issued by the Scheduler & Controller Manager, initiating container deployment within specific nodes, such as Node1 with Container-1 & Container-2.

Impact of Node Failure: If a node, like Node 2, crashes, containers on that node (e.g., Container-3) are affected.

Desired State Configuration (DSC): Kubernetes uses Desired State Configuration (DSC) to ensure the desired number of containers (e.g., 5) specified by the developer are consistently running in the cluster, even in the event of node failures.

### Container Recovery Process

Automatic Rescheduling: If a container crashes, Kubernetes initiates automatic rescheduling on other available nodes.

Resource Availability Check: Kubernetes checks available resources, starting with Node-1, and moves to Node-3 if resources are insufficient on the first node.

Ensuring Container Uptime: Kubernetes ensures all containers remain operational by redistributing them across healthy nodes.

### User Access to Applications

Direct Node Access: Users can access applications installed in nodes directly, bypassing the Control Plane.

Load Balancer Implementation: Instead of accessing containers directly, users go through a Load Balancer, which distributes requests across multiple application instances (e.g., Container-4, Container-1, Container-2, Container-3) based on its decisions.

### Key Concepts

Pods:
Pods are high level structure that wrap one or more containers. This is because containers are not run directly in Kubernetes, Containers in the same pod share a local network & the same resources, allowing them to easily communicate with other containers in the same pod as if they are on the same machine while at the same time maintaining a degree of isolation.

Kube-scheduler:
Assigns Nodes to newly created Pods.

NameSpace:
Used for dividing cluster resources between multiple users.
Initial NameSpaces – Default, Kube-system, Kube-public.

Kubelet:
Is a service agent that controls & maintains a set of pods by watching for pod specs through the Kubernetes api server. It preserves the pod life-cycle by ensuring that a given set of containers are all running as they should.
The Kubelet runs on each Node & enables the communication b/w the Master and Slave Nodes.

Kube-proxy:
Is responsible for directing traffic to the right container based on IP and Port Number of Incoming requests.

Kubernetes Master Components
Etcd: The Cluster's Brain
Distributed Key-Value Store for Config Data

API Server: Frontend to the Cluster Control Plane
Validates and Configures Data for API Objects

Controller Manager: Maintaining Desired State
Regulates the State of the System

Scheduler: Assigning Work to Nodes
Selects Nodes for Pods to Run Based on Policies

### Interacting with Kubernetes: Kubectl CLI and YAML Files

Kubectl (Kube Control) is the command-line tool for interacting with Kubernetes clusters.

Key commands: kubectl get, kubectl create, kubectl apply, kubectl delete

YAML (YAML Ain't Markup Language) is used for configuration and resource definition in Kubernetes.

Structure: API version, kind, metadata, spec.

Kubectl provides a powerful interface for managing clusters, allowing both beginners and experts to interact with Kubernetes.

YAML files offer a declarative and version-controlled way to define and manage Kubernetes resources.

Version history and rollback capabilities with YAML files.

Kubectl is the primary command-line interface for interacting with Kubernetes clusters, offering a wide range of functionality for managing resources.

## Basic kubectl command

```
kubectl create deployment [name]
kubectl edit deployment [name]
kubectl delete deployment [name]
```


```
kubectl get node | pod | services | replicaset | deployment
```

### Step 1 - Start Minikube

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

