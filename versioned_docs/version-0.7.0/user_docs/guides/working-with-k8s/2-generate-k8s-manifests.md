---
title: "Generate Kubernetes Manifests"
sidebar_position: 2
---

## Introduction

When we manage the Kubernetes resources, we often maintain it by hand, or use Helm and Kustomize tools to maintain our YAML configurations or configuration templates, and then apply the resources to the cluster through kubectl tools. However, as a "YAML engineer", maintaining YAML configuration every day is undoubtedly trivial and boring, and prone to errors. For example as follows:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: ... # Omit
spec:
  selector:
    matchlabels:
      cell: RZ00A
  replicas: 2
  template:
    metadata: ... # Omit
    spec:
      tolerations:
      - effect: NoSchedules
        key: is-over-quota
        operator: Equal
        value: 'true'
      containers:
      - name: test-app
          image: images.example/app:v1 # Wrong ident
        resources:
          limits:
            cpu: 2 # Wrong type. The type of cpu should be str
            memory: 4Gi
            # Field missing: ephemeral-storage
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: is-over-quota
                operator: In
                values:
                - 'true'
```

+ The structured data in YAML is untyped and lacks validation methods, so the validity of all data cannot be checked immediately.
+ YAML has poor programming ability. It is easy to write incorrect indents and has no common code organization methods such as logical judgment. It is easy to write a large number of repeated configurations and difficult to maintain.
+ The design of Kubernetes is complex, and it is difficult for users to understand all the details, such as the `toleration` and `affinity` fields in the above configuration. If users do not understand the scheduling logic, it may be wrongly omitted or superfluous added.

Therefore, KCL expects to solve the following problems in Kubernetes YAML resource management:

+ Use **production level high-performance programming language** to **write code** to improve the flexibility of configuration, such as conditional statements, loops, functions, package management and other features to improve the ability of configuration reuse.
+ Improve the ability of **configuration semantic verification** at the code level, such as optional/required fields, types, ranges, and other configuration checks.
+ Provide **the ability to write, combine and abstract configuration blocks**, such as structure definition, structure inheritance, constraint definition, etc.

## Prerequisite

First, you can visit the [KCL Quick Start](/docs/user_docs/getting-started/kcl-quick-start) to download and install KCL according to the instructions, and then prepare a [Kubernetes](https://kubernetes.io/) environment.

## Quick Start

### 1. Generate Kubernetes Resource

We can write the following KCL code and name it `main.k`. KCL is inspired by Python. Its basic syntax is very close to Python, which is easy to learn. The configuration mode is simple, `k [: T] = v`, where `k` denotes the configured attribute name, `v` denotes the configured attribute value and `: T` denotes an optional type annotation.

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

In the above KCL code, we declare the `apiVersion`, `kind`, `metadata`, `spec` and other variables of a Kubernetes `Deployment` resource, and assign the corresponding contents respectively. In particular, we will assign `metadata.labels` fields are reused in `spec.selector.matchLabels` and `spec.template.metadata.labels` field. It can be seen that, compared with YAML, the data structure defined by KCL is more compact, and configuration reuse can be realized by defining local variables.

We can get a Kubernetes YAML file by executing the following command line

```bash
kcl main.k
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

Of course, we can use KCL together with kubectl and other tools. Let's execute the following commands and see the result:

```shell
kcl main.k | kubectl apply -f -
```

The output is

```shell
deployment.apps/nginx-deployment configured
```

It can be seen from the command line that it is completely consistent with the deployment experience of using YAML configuration and kubectl application directly.

Check the deployment status through kubectl

```shell
kubectl get deploy
```

The output is

```shell
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           15s
```

### 2. Write Code to Manage Kubernetes resources

When publishing Kubernetes resources, we often encounter scenarios where configuration parameters need to be dynamically specified. For example, different environments need to set different `image` field values to generate resources in different environments. For this scenario, we can dynamically receive external parameters through KCL conditional statements and `option` functions. Based on the above example, we can adjust the configuration parameters according to different environments. For example, for the following code, we wrote a conditional statement and entered a dynamic parameter named `env`.

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2" if option("env") == "prod" else "${metadata.name}:latest"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

Use the KCL command line `-D` flag to receive an external dynamic parameter:

```bash
kcl main.k -D env=prod
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

The `image=metadata.name+": 1.14.2" if option ("env")=="prod" else metadata.name + ": latest"` in the above code snippet means that when the value of the dynamic parameter `env` is set to `prod`, the value of the image field is `nginx: 1.14.2`; otherwise, it is' nginx: latest'. Therefore, we can set env to different values as required to obtain Kubernetes resources with different contents.

KCL also supports maintaining the dynamic parameters of the option function in the configuration file, such as writing the ` kcl.yaml ` file.

```yaml
kcl_options:
  - key: env
    value: prod
```

The same YAML output can be obtained by using the following command line to simplify the input process of KCL dynamic parameters.

```bash
kcl main.k -Y kcl.yaml
```

The output is:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

### 3. Get the Kubernetes Modules from Registry

The Kubernetes KCL modules among all versions (v1.14-v1.28) are pre-generated, you get it by executing `kcl mod add k8s:<version>` under your project. More modules can be seen [here](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)

```shell
kcl mod init my-module && cd my-module
kcl mod add k8s
```

Write the KCL code in `main.k`

```python
# Import and use the contents of the external dependency 'k8s'.
import k8s.api.apps.v1 as apps

apps.Deployment {
    metadata.name = "nginx-deployment"
    metadata.labels.app = "nginx"
    spec: {
        replicas = 3
        selector.matchLabels = metadata.labels
        template: {
            metadata.labels = metadata.labels
            spec.containers = [{
                name = metadata.labels.app
                image = "nginx:1.14.2"
                ports: [{
                    containerPort = 80
                }]
            }]
        }
    }
}
```

Run the following code

```shell
kcl run
```

The output is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.14.2
        name: nginx
        ports:
        - containerPort: 80
```

## Summary

KCL can be used to generate and manage Kubernetes resources, addressing the limitations of managing YAML configurations, such as a lack of validation methods and poor programming capabilities. It can also dynamically receive external parameters through conditional statements and option functions, allowing configuration parameters to be adjusted according to different environments. In addition, KCL can be used in conjunction with other tools such as kubectl to apply configuration to the cluster.
