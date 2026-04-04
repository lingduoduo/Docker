## Model Deployment

This repo is focused on deployment, not training.

Use this repo for:

- Kubernetes manifests
- Helm chart configuration
- environment-specific deployment values
- rollout patterns such as canary and shadow deployment

Use another repo for:

- model training
- model evaluation
- Docker image build and publish
- application source code for the model server

### Deployment flow

1. Build the model-serving image in another repo or pipeline.
2. Pass the image repository and tag into this repo.
3. Deploy to Kubernetes with Helm.
4. Expose traffic through a Kubernetes `Service` and optionally an `Ingress`.

For local Minikube testing, you can skip the publish step and build the image directly into Minikube.

### Local test flow

Use this when you want to verify the deployment locally with Minikube before touching Helm or any remote registry.

#### 1. Start clean if needed

```bash
docker system prune -a
minikube delete
```

#### 2. Start Minikube

```bash
minikube start
kubectl config use-context minikube
kubectl get nodes
```

If `kubectl get nodes` fails, stop here. The cluster must be healthy before any deploy step will work.

#### 3. Build the image inside Minikube

Run these in the same terminal:

```bash
eval $(minikube -p minikube docker-env)
cd /Users/linghuang/Git/Recommendation/TFRecommenders-MLops-Sandbox
docker build -t ling-mlops-sandbox:latest .
docker image ls | grep ling-mlops-sandbox
```

Important:

- `eval $(minikube -p minikube docker-env)` only affects the current shell
- build the image after that command, in that same shell
- this makes the image available to Kubernetes in Minikube

#### 4. Test raw Kubernetes manifests first

```bash
cd /Users/linghuang/Git/Model-Deployment
kubectl apply -f Kubernetes/local-model-deployment.yaml
kubectl apply -f Kubernetes/local-model-service.yaml
kubectl get deploy,pods,svc
```

Watch the pod:

```bash
kubectl get pods -w
```

If the pod shows `ErrImageNeverPull`, the image is still not in Minikube's runtime.

#### 5. Test the service locally

When the pod is `Running`:

```bash
kubectl port-forward svc/local-model-service 8080:8080
```

In another terminal:

```bash
curl http://localhost:8080/health

curl -X POST http://localhost:8080/predict \
  -H "Content-Type: application/json" \
  -d '{"user_id":"u1","top_k":5}'

```

#### 6. Move to Helm after raw manifests work

After the raw manifest test succeeds, continue with the Helm chart flow in:

- [Helm chart guide](/Users/linghuang/Git/Model-Deployment/Helm-Chart/README.md)
- [Kubernetes guide](/Users/linghuang/Git/Model-Deployment/Kubernetes/README.md)

#### 7. Verify the same setup with Helm

From the deployment repo:

```bash
cd /Users/linghuang/Git/Model-Deployment

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

Check the release:

```bash
kubectl get pods,svc -n model-serving
helm list -n model-serving
```

Port-forward the Helm-managed service:

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

This confirms the same working setup through Helm:

- image: `ling-mlops-sandbox:latest`
- pull policy: `Never`
- service port: `8080`
- liveness probe: `/health`
- readiness probe: `/health`

### Recommended traffic pattern

- `Deployment` runs the serving pods
- `Service` with `ClusterIP` load-balances internally across pod replicas
- `Ingress` or gateway handles external access, TLS, and advanced traffic routing

### AWS helper layout

For AWS-related deployment helpers, use a structure that separates generic stateless utilities from service-specific integrations. A recommended layout is documented in the [deployment guide](/Users/linghuang/Git/Model-Deployment/deploy/README.md) under `AWS utility functions`, including folders for `util`, shared `aws` wrappers, and service areas such as `athena`, `cloudformation`, `cloudwatch`, `glue`, `personalize`, `rekognition`, and `sagemaker`.

### Main entry points

- [Helm chart guide](/Users/linghuang/Git/Model-Deployment/Helm-Chart/README.md)
- [Deployment guide](/Users/linghuang/Git/Model-Deployment/deploy/README.md)
- [Raw Kubernetes guide](/Users/linghuang/Git/Model-Deployment/Kubernetes/README.md)
