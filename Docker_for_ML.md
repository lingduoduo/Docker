### **Use Docker containers for machine learning development**

#### **What you should and shouldn’t include in your machine learning development container**

There isn’t a right answer and how your team operates is up to you, but there are a couple of options for what to include:

1. **Only the machine learning frameworks and dependencies:** This is the cleanest approach. Every collaborator gets the same copy of the same execution environment. They can clone their training scripts into the container at runtime or mount a volume that contains the training code.
2. **Machine learning frameworks, dependencies, and training code:** This approach is preferred when scaling workloads on a cluster. You get a single executable unit of machine learning software that can be scaled on a cluster. Depending on how you structure your training code, you could allow your scripts to execute variations of training to run hyperparameter search experiments.

Sharing your development container is also easy. You can share it as a:

1. **Container image:** This is the easiest option. This allows every collaborator or a cluster management service, such as Kubernetes, to pull a container image, instantiate it, and execute training immediately.
2. **Dockerfile:** This is a lightweight option. [Dockerfiles](https://docs.docker.com/engine/reference/builder/) contain instructions on what dependencies to download, build, and compile to create a container image. Dockerfiles can be versioned along with your training code. You can automate the process of creating container images from Dockerfiles by using continuous integration services.

Container images for widely used open source machine learning frameworks or libraries are available on Docker hub and are usually contributed by the framework maintainers. You’ll find [TensorFlow](https://hub.docker.com/r/tensorflow/tensorflow/), [PyTorch](https://hub.docker.com/r/pytorch/pytorch/), [MXNet](https://hub.docker.com/r/mxnet/python), and others on their repositories. Exercise caution where you download from and what type of container image you download.

Most upstream repositories build their containers to work everywhere, which means they have to be compatible with most CPU and GPU architectures. If you exactly know what system you’ll be running your container on, you’re better off selecting container images that’ve been optimized and qualified for your system configuration.

#### **Setting up your machine learning development environment with Jupyter, using Docker containers**

**Step 1: Launch your development instance.**

C5, P3, or a G4 family instances are all ideal for machine learning workloads. The latter two offer upto eight NVIDIA GPUs per instance. For a short guide on launching your instance, read the [Getting Started with Amazon EC2 documentation](https://aws.amazon.com/ec2/getting-started/).

When selecting the Amazon Machine Image (AMI), choose the latest Deep Learning AMI, which includes all the latest deep learning frameworks, Docker runtime, and NVIDIA driver and libraries. While it may seem handy to use the deep learning framework natively installed on the AMI, working with deep learning containers gets you one step closer to a more portable environment.

**Step 2: SSH to the instance and download a deep learning container.**

```bash
ssh -i ~/.ssh/<pub_key> ubuntu@<IP_ADDR>
```

Log in to the Deep Learning Container registry:

```bash
$(aws ecr get-login --no-include-email --region YOUR_REGION --registry-ids 763104351884)
```

Select the framework you’ll be working with from the list on the [AWS Deep Learning Container webpage](https://docs.aws.amazon.com/deep-learning-containers/latest/devguide/deep-learning-containers-images.html) and pull the container.

To pull the latest TensorFlow container with GPU support in us-west-2 region, run:

```bash
docker pull 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:2.1.0-gpu-py36-cu101-ubuntu18.04
```

**Step 3: Instantiate the container and set up Jupyter.**

```bash
docker run -it --runtime=nvidia -v $PWD:/projects --network=host --name=tf-dev 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:2.1.0-gpu-py36-cu101-ubuntu18.04
```

`--runtime=nvidia` instructs `docker` to make NVIDIA GPUs on the host available inside the container.

`-v` instructs `docker` to mount a directory so that it can be accessed inside the container environment. If you have datasets or code files, make them available on a specific directory and mount it with this option.

`--network=host` instructs the container to share the host’s network namespace. If the container runs a service at port 9999 (as shown below), this lets you access the service on the same port on the host’s IP.

```bash
pip install jupyterlab
```

```bash
jupyter lab --ip=0.0.0.0 --port=9999 --allow-root --NotebookApp.token='' --NotebookApp.password=''
```

Open up a second terminal window on your client machine and run the following to establish a tunnel at port 9999. This lets you access Jupyter notebook server running inside the container on your host machine.

```bash
ssh -N -L 0.0.0.0:9999:localhost:9999 -i ~/.ssh/<pub_key> ubuntu@<IP_ADDR>
```

Open up your favorite browser and enter: `http://0.0.0.0:9999/lab`

And voila, you’ve successfully set up your container-based development environment. Every piece of code you run on this Jupyter notebook will run within the deep learning container environment.

**Step 4: Using the container-based development environment.**

Containers are meant to be stateless execution environments, so save your work on mounted directories that you specified with the `-v` flag when calling `docker run`. To exit a container, stop the Jupyter server and type `exit` on the terminal. To restart your stopped container, run:

```bash
docker start tf-dev
```

And set up your tunnel as described in Step 3 and you can resume your development.

Now, let’s say you made changes to the base container—for example, installing Jupyter into the container as in Step 3. The cleanest way to do this is to track all your custom installations and capture it in a Dockerfile. This allows you to recreate a container image with your changes from scratch. It also serves the purpose of documenting your changes and can be versioned along with the rest of your code.

The quicker way to do this with minimal disruption to your development process is to commit those changes into a new container image by running:

```bash
sudo docker commit tf-dev my-tf-dev:latest
```

Note: Container purists will argue that this isn’t a recommend way to save your changes, and they should be documented in a Dockerfile instead. That’s good advice and it’s good practice to track your customizations by writing a Dockerfile. If you don’t, the risk is that over time you’ll lose track of your changes and will become reliant on one “working” image. Much like relying on a compiled binary with no access to source code.

If you want to share the new container with your collaborators, push it to a container registry, such as Docker Hub or [Amazon Elastic Container Registry (Amazon ECR)](https://aws.amazon.com/ecr/). To push it to an Amazon ECR, first create a registry, log in to it, and push your container:

```bash
aws ecr create-repository --repository-name my-tf-dev
$(aws ecr get-login --no-include-email --region <REGION>)
docker tag my-tf-dev:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/my-tf-dev:latest
docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/my-tf-dev:latest
```

You can now share this container image with a collaborator, and your code should work as it did on your machine. The added benefit is that you can now use the same container to run large-scale workloads on a cluster. Let’s learn how.

#### **Machine learning training containers and scaling them on clusters**

Most cluster management solutions, such as Kubernetes or Amazon ECS, will schedule and run containers on a cluster. Alternatively, you could also use a fully managed service, such as [Amazon SageMaker](https://aws.amazon.com/sagemaker/), where instances are provisioned when you need them and torn down automatically when the job is done. In addition, it also offers a fully managed suite of services for data labeling, hosted Jupyter notebook development environment, managed training clusters, hyperparameter optimization, managed model hosting services and an IDE that ties all of it together.

To leverage these solutions and run machine learning training on a cluster, you must build a container and push it to a registry.

If you’ve incorporated container-based machine learning development as described previously, you can feel assured that the same container environment you’ve been developing on will be scheduled and run at scale on a cluster—no framework version surprises, no dependency surprises.

To run a distributed training job using Kubernetes and KubeFlow on 2 nodes, you’ll need to write up a config file in YAML that looks something like this:

![Excerpt of a Kubernetes config file for distributed training with TensorFlow and Horovod API. Note that the screenshot does not show the full file.](https://d2908q01vomqb2.cloudfront.net/ca3512f4dfa95a03169c5a670a4c91a19b3077b4/2020/03/11/prasanna_f8_2020_03_11.png)

Excerpt of a Kubernetes config file for distributed training with TensorFlow and Horovod API that can be found [here on Github](https://github.com/shashankprasanna/distributed-training-workshop/tree/master/notebooks/part-3-kubernetes/specs). Note that the screenshot does not show the full file.

Under the `image` section, you’ll specify your docker image with your training scripts. Under `command`, you’ll specify the command required for training. Because this is a distributed training job, you’ll run an MPI job with `mpirun` command.

You can submit this job to a Kubernetes cluster as follows (assuming a cluster is set up and running, and you have KubeFlow installed):

```bash
kubectl apply -f eks_tf_training_job-cpu.yaml
```

To do the same with Amazon SageMaker on 8 nodes, you’ll use the Amazon SageMaker SDK and submit a distributed training job using the Estimator API as shown below:

```python
distributions = {'mpi': {
                  'enabled': True,
                  'processes_per_host': hvd_processes_per_host,
                  'custom_mpi_options': '-verbose --NCCL_DEBUG=INFO -x OMPI_MCA_btl_vader_single_copy_mechanism=none'
                   } }
estimator_hvd = TensorFlow(entry_point='cifar10-multi-gpu-horovod-sagemaker.py',
                           source_dir           = 'code',
                           role                 = role,
                           image_name           = <YOUR_DOCKER_IMAGE>,
                           hyperparameters      = hyperparameters,
                           train_instance_count = 8, 
                           train_instance_type  = ’p3.2xlarge’,
                           output_path          = output_path,
                           model_dir            = model_dir,
                           distributions        = distributions)
```

The machine learning community moves fast. New research gets implemented into APIs in open source frameworks within weeks or months of their publication. When software evolves this rapidly, keeping up with the latest and maintaining quality, consistency, and reliability of your products can be challenging. So be paranoid, but don’t panic because you’re not alone and there are plenty of best practices in the community that you can use to make sure you’re benefiting from the latest.

