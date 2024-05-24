### Kubernetes 

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

**Kubernetes**

When a microservice application is deployed in production, it usually has many running containers that need to be allocated the right amount of resources in response to user demands. Also, there is a need to ensure that the containers are online, are running, and are communicating with one another. The need to efficiently manage and coordinate clusters of containerized applications gave rise to Kubernetes.

Kubernetes is a software system that addresses the concerns of deploying, scaling, and monitoring containers. Hence, it is called a container orchestrator. Examples of other container orchestrators in the wild are Docker Swarm, Mesos Marathon, and HashiCorp Nomad.

Kubernetes was built and released by Google as an open source software, which is now managed by the Cloud Native Computing Foundation (CNCF) . Google Cloud Platform offers a managed Kubernetes service called Google Kubernetes Engine (GKE). Amazon Elastic Container Service for Kubernetes (EKS) also provides a managed Kubernetes service.

- Kubernetes maintains high availability and fault tolerance through replication, self-healing, and automated scaling.
- A Kubernetes cluster consists of a master node and multiple worker nodes.
- The master node manages the cluster, while worker nodes host containers.
- Key components of the master node include the API Server, Etcd, Controller Manager, and Scheduler.

Pods are the smallest deployable units in Kubernetes - They can contain one or more containers that share the same network namespace.

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

### Basic kubectl command

```
kubectl create deployment [name]
kubectl edit deployment [name]
kubectl delete deployment [name]
```


```
kubectl get node | pod | services | replicaset | deployment
```

### Load Balancer in Kubernetes

Ensuring efficient distribution of traffic across pods/nodes.

Improving scalability, reliability, and high availability.

Enhancing fault tolerance: redirecting traffic in case of pod/node failures. 

Configurable parameters and annotations allow fine-tuning of load balancing strategies.

In Kubernetes, Services act as Load Balancers


### Desired State Configuration (DSC) in Kubernetes

Automated Reconciliation in Kubernetes  

Kubernetes continuously monitors the cluster's state.

Kubernetes DSC ensures that the cluster components, applications, and configurations match the defined desired state.

Automatic reconciliation reduces manual intervention, making the cluster self-healing and ensuring high availability.

By defining the desired state, operators can set specific configurations, security policies, and resource limits, ensuring consistency across deployments.

## Kubernetes Deployment

Understanding Replica Sets and Pods.
Creating and managing a basic Deployment.
Scaling applications using Deployments - HPA based on CPU utilization
Performing rolling updates and rollbacks.

- How to define deployments with their Configuration and Specifications
- Creating Deployment configurations using YAML.
- What are the different types of deployments and when to use them.

- Ensuring High Availability and Fault Tolerance: 

Deployments provide an abstraction layer, managing replica sets and pods, ensuring your application is always available even if one or more instances fail.

- Rolling Updates and Rollbacks for Seamless Deployments: 

Deployments allow you to update your application without downtime, ensuring smooth transitions between versions. If issues arise, rollbacks can be executed quickly.

- Zero-Downtime Deployments and Scalability: 

With rolling updates, new versions of your application can be deployed with zero downtime. Additionally, Deployments enable easy scaling, both vertically and horizontally, to handle varying workloads.

- Key Points:

  Deployments in Kubernetes offer crucial features for managing applications, including high availability, seamless updates, rollbacks, and scalability.

  By abstracting the underlying complexity, Deployments simplify the management of applications, allowing focus on functionality and user experience.

  Deployments act as the cornerstone of Kubernetes, providing essential features for managing applications efficiently.

### Creating Kubernetes Deployments: Configuration and Specification

Defining Deployments in YAML: Configuration and Specifications

In Kubernetes, deployments are defined using YAML files, allowing for precise configuration and specifications.

Understanding the YAML Structure: API Version, Kind, Metadata, and Spec

 - API Version: Specifies the Kubernetes API version to use for this object.

 - Kind: Defines the type of Kubernetes object, e.g., Deployment, Service.

 - Metadata: Contains information like name, labels, and annotations.

 - Spec: Specifies the desired state of the Deployment, including pod template and replicas.


To apply this Deployment, save the YAML content to a file (e.g.,nginx-deployment.yaml) and use the kubectl apply command: 

```
kubectl apply -f nginx-deployment.yaml
```

### Replica Sets and Labels: Specifying Desired Replica Count and Identifying Pods


Replica Sets: Ensure the desired number of pod replicas are running at any given time.

Labels: Identifiers used to select and manage subsets of pods.

### Selectors and Templates: Defining Pod Templates with Containers, Ports, and Volumes

Selectors: Criteria used to identify which pods belong to a Replica Set.

Templates: Define pod specifications, including containers, ports, and storage volumes.

### Pod Templates and Stateful vs. Stateless Deployments

Pod Templates

In Kubernetes, a pod template is a blueprint used to create pods. It defines the configuration of containers within the pod, including the Docker image to use, resources like CPU and memory limits, and environment variables. Pod templates also specify how data is stored through volumes, allowing for various types of storage, such as temporary or persistent data. Additionally, ports are mapped within pod templates, allowing communication between containers inside the pod and with external services.

Pod Templates: Specifying Containers, Volumes, and Ports:

  Containers: Defining the application containers, specifying the image, resources, and environment variables.

  Volumes: Configuring data storage, defining the type (emptyDir, hostPath, persistentVolumeClaim, etc.).

  Ports: Mapping container ports to host ports, allowing external access.


### Stateful and Stateless Deployments: Differences and Use Cases

Stateful Deployments: Applications that require stable network identities, persistent storage, and ordered deployment.

Use Cases: Databases, key-value stores, applications relying on unique network identifiers.

Stateless Deployments: Applications where each instance is independent and can handle requests without relying on previous states.

Use Cases: Web servers, microservices, stateless APIs.

### Scaling and Rolling Updates

Deployments enable horizontal scaling to handle varying workloads and vertical scaling for optimizing resource utilization.

Rolling updates ensure seamless transitions between application versions, maintaining high availability.

Rollbacks provide a safety net, allowing quick reverting to previous versions in case of deployment issues.

### Deployment Security

  Role-Based Access Control (RBAC) in Deployments.
  Secrets Management: Safeguarding Sensitive Information.
  Network Policies: Controlling Communication Between Pods.
  Runtime Security: Scanning Containers for Vulnerabilities.


### Best Practices for Kubernetes Deployments

  Labels and Selectors: Effective Use in Deployments.
  Resource Requests and Limits: Optimizing Resource Utilization.
  Monitoring and Logging: Ensuring Health and Performance.
  Security Policies: Protecting Deployed Applications.


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

