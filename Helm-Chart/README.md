## Deploy a model image with Helm

The chart in `Helm-Chart/mychart` is set up for a containerized model-serving application. It lets you reuse the Docker image you already built, then deploy it to Kubernetes with Helm.

### 1. Build and push your image

```bash
docker build -t <registry>/<image>:<tag> .
docker push <registry>/<image>:<tag>
```

### 2. Create your values file

Start from the included example:

```bash
cp Helm-Chart/mychart/values-model-example.yaml Helm-Chart/mychart/my-values.yaml
```

Update these fields for your model service:

- `image.repository` and `image.tag` to point at your pushed Docker image
- `container.port`, `container.command`, and `container.args` to match how your server starts
- `model.name` and `model.path` so the pod exposes your model metadata through env vars
- `service.port` and probe paths to match your application endpoints
- `persistence.*` if your model files should be mounted from a PVC instead of being baked into the image

### 3. Render manifests locally

```bash
helm template model-release ./Helm-Chart/mychart -f ./Helm-Chart/mychart/my-values.yaml
```

### 4. Install to Kubernetes

```bash
helm upgrade --install model-release ./Helm-Chart/mychart \
  --namespace model-serving \
  --create-namespace \
  -f ./Helm-Chart/mychart/my-values.yaml
```

### 5. Verify the deployment

```bash
kubectl get all -n model-serving
kubectl describe deployment model-release-mychart -n model-serving
kubectl logs -n model-serving deploy/model-release-mychart
```

### Chart features

- Configurable container image, port, command, and args
- Built-in `MODEL_NAME` and `MODEL_PATH` environment variables
- Optional ConfigMap and Secret-based environment injection
- Optional PersistentVolumeClaim for model files
- Optional HPA and Ingress support
