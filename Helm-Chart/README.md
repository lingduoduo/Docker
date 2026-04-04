## Deploy a model image with Helm

The chart in `Helm-Chart/mychart` is for deployment only. The model is expected to be trained, packaged, and published as a container image in another repo or pipeline. This repo takes that image reference and deploys it to Kubernetes with Helm.

### Local-first workflow on macOS

This is the recommended path for testing the deployment locally before using any remote registry or cloud environment.

#### 1. Build and verify the Docker image locally

Build in your application repo:

```bash
docker build -t ling-mlops-sandbox .
```

Run it locally and verify the API:

```bash
docker run --rm -p 8080:8080 ling-mlops-sandbox
```

In another terminal:

```bash
curl http://localhost:8080/health

curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"user_id":"u1","top_k":5}'
```

Important detail:

- the application inside the container should usually bind to `0.0.0.0:8080`
- you still call it from your Mac with `http://localhost:8080`

#### 2. Start your local Kubernetes cluster

If you use Minikube:

```bash
minikube start
kubectl config use-context minikube
kubectl get nodes
```

If `kubectl get nodes` fails, stop here and fix the cluster first. Helm cannot deploy if the cluster is unreachable.

#### 3. Load the local image into the cluster

For Minikube, the most reliable approach is to build the image inside Minikube's Docker daemon.

Important:

- `eval $(minikube -p minikube docker-env)` only affects the current shell session
- it does not affect other terminal tabs or windows
- after running it, build the image in that same shell

In the same terminal:

```bash
eval $(minikube -p minikube docker-env)
docker info
```

Then, still in the same terminal, rebuild the image from your application repo:

```bash
cd /Users/linghuang/Git/Recommendation/TFRecommenders-MLops-Sandbox
docker build -t ling-mlops-sandbox:latest .
docker image ls | grep ling-mlops-sandbox
```

For other local clusters:

- Kind: `kind load docker-image ling-mlops-sandbox:latest`
- Docker Desktop Kubernetes: local images often work with `image.pullPolicy=IfNotPresent`

If you prefer the copy-based Minikube approach instead of rebuilding in Minikube:

```bash
minikube image load ling-mlops-sandbox:latest
minikube image ls | grep ling-mlops-sandbox
```

If `minikube image ls` shows nothing, the load did not complete successfully.

#### 4. Deploy from this repo

```bash
brew install helm kubectl
chmod +x scripts/run-local-deploy.sh ci/deploy_with_helm.sh

cd /Users/linghuang/Git/Model-Deployment
export IMAGE_REPOSITORY=ling-mlops-sandbox
export IMAGE_TAG=latest
export DEPLOY_ENVIRONMENT=staging
./scripts/run-local-deploy.sh
```

This flow:

- deploys a local Docker image into your local Kubernetes workflow
- uses Helm with local overrides on top of `values-staging.yaml`

Useful environment variables:

- `IMAGE_TAG`
- `RELEASE_NAME`
- `KUBE_NAMESPACE`
- `DEPLOY_STRATEGY`

#### 5. Check the deployment

```bash
kubectl get deploy,pods,svc -n model-serving
kubectl describe deployment model-release-mychart -n model-serving
kubectl logs -n model-serving deploy/model-release-mychart
```

If the pod is `Pending` or shows `ErrImageNeverPull`, inspect it:

```bash
kubectl get pods -n model-serving
kubectl describe pod -n model-serving <pod-name>
```

Common local causes:

- the image was not loaded into Minikube or not built inside Minikube's Docker daemon
- the cluster is not running
- CPU or memory is insufficient
- a PVC is waiting for storage

If you just loaded or rebuilt the image, redeploy or restart:

```bash
helm upgrade --install model-release ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/values-staging.yaml \
  --set image.repository=ling-mlops-sandbox \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --set livenessProbe.httpGet.path=/health \
  --set readinessProbe.httpGet.path=/health

kubectl rollout restart deployment/model-release-mychart -n model-serving
kubectl get pods -n model-serving -w
```

#### 6. Access the service locally

When the pod is `Running`, port-forward the Service:

```bash
kubectl port-forward -n model-serving svc/model-release-mychart 8080:8080
```

Then in another terminal:

```bash
curl http://localhost:8080/health

curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"user_id":"u1","top_k":5}'
```

#### 7. Docker to Kubernetes command mapping

- `docker run --rm -p 8080:8080 ling-mlops-sandbox` -> `helm upgrade --install ...` + `kubectl port-forward svc/model-release-mychart 8080:8080`
- `docker logs <container>` -> `kubectl logs -n model-serving deploy/model-release-mychart`
- `docker exec -it <container> sh` -> `kubectl exec -it -n model-serving deploy/model-release-mychart -- sh`

### Manual Helm flow

#### 1. Choose the image to deploy

```bash
export IMAGE_REPOSITORY=<registry>/<image>
export IMAGE_TAG=<tag>
```

#### 2. Pick a values file

Start from the included example:

```bash
cp Helm-Chart/mychart/values-model-example.yaml Helm-Chart/mychart/my-values.yaml
```

Or use one of the environment files already added:

- `Helm-Chart/mychart/values-staging.yaml`
- `Helm-Chart/mychart/values-production.yaml`
- `Helm-Chart/mychart/values-production-canary.yaml`

Update these fields for your model service:

- `image.repository` and `image.tag` to point at the image built elsewhere
- `container.port`, `container.command`, and `container.args` to match how your server starts
- `model.name` and `model.path` so the pod exposes your model metadata through env vars
- `service.port` and probe paths to match your application endpoints
- `persistence.*` if your model files should be mounted from a PVC instead of being baked into the image

#### 3. Render manifests locally

```bash
helm template model-release ./Helm-Chart/mychart -f ./Helm-Chart/mychart/my-values.yaml
```

For the built-in staging values:

```bash
helm template model-release ./Helm-Chart/mychart -f ./Helm-Chart/mychart/values-staging.yaml
```

#### 4. Install to Kubernetes

```bash
helm upgrade --install model-release ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/my-values.yaml
```

With the staging file:

```bash
helm upgrade --install model-release ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/values-staging.yaml \
  --set image.repository="${IMAGE_REPOSITORY}" \
  --set image.tag="${IMAGE_TAG}" \
  --set image.pullPolicy=IfNotPresent
```

For local Minikube testing, prefer:

```bash
helm upgrade --install model-release ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/values-staging.yaml \
  --set image.repository=ling-mlops-sandbox \
  --set image.tag=latest \
  --set image.pullPolicy=Never \
  --set container.port=8080 \
  --set service.port=8080 \
  --set livenessProbe.httpGet.path=/health \
  --set readinessProbe.httpGet.path=/health
```

#### 5. Verify the deployment

```bash
kubectl get all -n model-serving
kubectl describe deployment model-release-mychart -n model-serving
kubectl logs -n model-serving deploy/model-release-mychart
```

#### 6. Canary deployment

For a simple canary release, install a second Helm release with the canary values:

```bash
helm upgrade --install model-release-canary ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/values-production-canary.yaml \
  --set image.repository=<registry>/<image> \
  --set image.tag=<tag>
```

Traffic splitting depends on your ingress, gateway, or rollout controller.

### Service exposure

Recommended default:

- `service.type: ClusterIP`
- one or more pod replicas behind the `Service`
- `Ingress` in front when external traffic is needed

Why:

- the Kubernetes `Service` already load-balances traffic to healthy pods
- `Ingress` is the better place for hostname routing, TLS, canary traffic, and shadow traffic
- `LoadBalancer` is useful, but usually only when you want direct cloud-provider exposure without a separate ingress layer

### Chart features

- Configurable container image, port, command, and args
- Built-in `MODEL_NAME` and `MODEL_PATH` environment variables
- Optional ConfigMap and Secret-based environment injection
- Optional PersistentVolumeClaim for model files
- Optional HPA and Ingress support
