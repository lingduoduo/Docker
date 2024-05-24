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

