## Step 1: Generate your first chart
The best way to get started with a new chart is to use the helm create command to scaffold out an example we can build on. Use this command to create a new chart named mychart in a new directory:

```
helm create mychart
```

### Templates

service.yaml

```
helm install mychart --dry-run --debug ./mychart

helm install mychart --dry-run --debug ./mychart --set service.internalPort=8080
```

Values
The template in service.yaml makes use of the Helm-specific objects .Chart and .Values.. 
- objects .Chart provides metadata about the chart to your definitions such as the name, or version. 
- objects .Values is a key element of Helm charts, used to expose configuration that can be set at the time of deployment. The defaults for this object are defined in the values.yaml file. 

Try changing the default value for service.internalPort and execute another dry-run, you should find that the targetPort in the Service and the containerPort in the Deployment changes. The service.internalPort value is used here to ensure that the Service and Deployment objects work together correctly. The use of templating can greatly reduce boilerplate and simplify your definitions.

