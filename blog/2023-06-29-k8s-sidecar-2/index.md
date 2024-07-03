---
slug: 2023-06-29-k8s-sidecar-2
title: Talking about the SideCar design pattern in K8S - Part 2
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, k8s, SideCar]
---

## Introduction

In the previous blog [Exploring the Sidecar Design Pattern in K8s - Part 1](/blog/2023-06-05-k8s-sidecar-1/), we introduced the Sidecar design pattern using layman's terms. In this blog, we'll use KCL, a modern, type-safe configuration language, to showcase the description of Pod resources. In the subsequent blogs, we'll use KCL to explore the practical applications of the Sidecar pattern.

### 1. OpenAPI Definition for Pods

Let's go back to the simplest example of Nginx, where the YAML file follows a similar pattern:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
    - image: nginx
      name: main-container
      ports:
        - containerPort: 80
```

Here, the Pod data follows the definition of the io.k8s.api.core.v1.Pod model in the Kubernetes specification. The complete OpenAPI definition can be found here. By analyzing it carefully, we can see that the apiVersion and kind information are commonly used default configurations. We need a more modern configuration language to simplify it.

### 2. Defining Pod Resources with KCL

KCL is a configuration policy language for the cloud-native domain. For more information, please refer to the [official website](https://kcl-lang.io/). Basic KCL configuration programs still follow the `K=V` format, which is similar to YAML. For example, we can rewrite the configuration of the Nginx container using the following KCL code:

```python
import k8s.api.core.v1 as k8core

k8core.Pod {
    metadata.name = "web-app"
    spec.containers = [{
        name = "main-container"
        image = "nginx"
        ports = [{containerPort: 80}]
    }]
}
```

Here, the `import` statement imports the `k8s/api/core/v1` package from the k8s package, and the `Pod` structure definition corresponds to the `Pod` model. The default values for apiVersion and kind have already been included, so we only need to add the `metadata.name` and `spec.containers` properties (KCL also provides syntax sugar for some multi-level nested properties). We can use the package management tool to create a KCL program to define a Pod resource and execute the program to get the corresponding YAML:

```shell
# 1. Initialize a kcl program package called hello.
kpm init hello
# 2. Edit the main.k file inside the hello package and add the KCL configuration code mentioned earlier.
cat <<EOF > hello/main.k
import k8s.api.core.v1 as k8core
k8core.Pod {
    metadata.name = "web-app"
    spec.containers = [{
        name = "main-container"
        image = "nginx"
        ports = [{containerPort: 80}]
    }]
}
EOF
# 3. Navigate to the hello package, add the k8s dependency, and run the hello package.
cd hello && kpm add k8s && kpm run
```

The following YAML output can be obtained:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
    - image: nginx
      name: main-container
      ports:
        - containerPort: 80
```

### 3. Conclusion

In this blog, we briefly introduced how to use KCL to build Pod configurations for more flexible and robust configurations. In the subsequent blogs, we'll use KCL to extract and abstract the best Sidecar pattern practices, including using KCL to abstract the Sidecar model and using KCL to inject Sidecars into existing upstream YAML configurations.
