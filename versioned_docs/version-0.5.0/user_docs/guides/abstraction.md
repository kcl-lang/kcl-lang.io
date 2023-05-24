---
title: "Abstraction"
sidebar_position: 3
---

## Introduction

Abstraction refers to a simplified representation of an entity, typically used in computing. It allows for the concealment of specific details while presenting the most relevant information to the programmer. Each abstraction is tailored to suit a specific need, and can greatly enhance the usability of a given entity. In the context of KCL, abstraction can make code easier to understand and maintain, while also simplifying the user interface.

It should be noted that code abstraction is not meant to reduce code size, but rather to improve maintainability and extendability. During the process of abstracting code, factors such as reusability, readability, and scalability should be taken into consideration, and the code should be optimized as needed.

The values of the good abstraction

1. Provides distinct focal points for better comprehension for specific identities, roles, and scenarios.
2. Shields lower-level details to avoid potential errors.
3. Enhances user-friendliness and automation with better portability and good APIs.

KCL may not assess the rationality of a user's abstraction, but it offers technical solutions to facilitate the process.

## Use KCL for Abstraction

**Now, let's begin to abstract Docker Compose and Kubernetes models into an application config.**

Application centric development allows developers to focus on their workload's architecture rather than the tech stack in the target environment, infrastructure or platform. We define our application once with the `App` schema and then use the KCL CLI to translate it to multiple platforms, such as `Docker Compose` or `Kubernetes` with different versions.

`Docker Compose` is a tool for defining and running multi-container Docker applications. With Docker Compose, you can define your application's services, networks, and volumes in a single file, and then use it to start and stop your application as a single unit. Docker Compose simplifies the process of running complex, multi-container applications by handling the details of networking, storage, and other infrastructure concerns.

`Kubernetes manifests` are YAML files that define Kubernetes objects such as Pods, Deployments, and Services. Manifests provide a declarative way to define the desired state of your application, including the number of replicas, the image to use, and the network configuration. Kubernetes uses the manifests to create and manage the resources needed to deploy and run your application.

Here are some references to learn more about Docker Compose and Kubernetes manifests:

+ [Docker Compose documentation](https://docs.docker.com/compose/)
+ [Kubernetes manifest documentation](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)

The application model aims to reduce developer toil and cognitive load by only having to define a single KCL file that works across multiple platforms, and it is designed to be applied to multiple environments to reduce the amount of configuration. Now, let's learn how to do this.

### 1. Get the Example

Firstly, let's get the example.

```bash
git clone https://github.com/KusionStack/kcl-lang.io.git/
cd ./kcl-lang.io/examples/abstraction
```

We can run the following command to show the config.

```bash
cat main.k
```

The output is

```python
import .app

app.App {
    name = "app"
    containers.ngnix = {
        image = "ngnix"
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
}
```

In the above code, we defined a configuration using the `App` schema, where we configured an `ngnix` container and configured it with an `80` service port.

Besides, KCL allows developers to define the resources required for their applications in a declarative manner and is tied to a platform such as Docker Compose or Kubernetes manifests and allows to generate a platform-specific configuration file such as `docker-compose.yaml` or a Kubernetes `manifests.yaml` file. Next, let's generate the corresponding configuration.

### 2. Convert the Application Config into Docker Compose Config

If we want to convert the application config into the docker compose config, we can run the command simply:

```shell
$ kcl main.k docker_compose_render.k
services:
  app:
    image: ngnix
    ports:
      - published: 80
        target: 80
        protocol: TCP
```

### 3. Convert the Application Config into Kubernetes Deployment and Service Manifests

If we want to convert the application config into the Kubernetes manifests, we can run the command simply:

```shell
$ kcl main.k kubernetes_render.k
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  labels:
    app: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: ngnix
          image: ngnix
          ports:
            - protocol: TCP
              containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: app
  labels:
    app: app
spec:
  selector:
    app: app
  ports:
    - port: 80
      protocol: TCP
```

Look, it's so simple. If you want to learn more information about the application model, you can refer to [here](https://github.com/KusionStack/kcl-lang.io/tree/main/examples/abstraction).

## Summary

Through the use of KCL, we are able to separate the abstraction and implementation details of a model, allowing for the abstract model to be mapped to various infrastructures or platforms. This is achieved through flexible switching between different implementations and the combination of compilation, which shields configuration differences and ultimately reduces the cognitive burden.

## Further Information

In addition to manually maintaining the configuration, we can also use KCL APIs to integrate **automatic configuration changes** into our applications. For specific instructions, please refer to [here](/docs/user_docs/guides/automation).
