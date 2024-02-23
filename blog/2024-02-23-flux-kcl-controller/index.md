---
slug: 2024-02-23-flux-kcl-controller
title: Implementing GitOps with KCL & FluxCD
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Github, FluxCD, GitOps]
---

## Introduction

In modern software development, GitOps has become an important technology for managing infrastructure and applications. It can significantly improve automation levels, reduce human intervention, reducing the error rate, and improve overall operational efficiency. This approach has been widely used in cloud-native and other fields.

In a previous article, we shared how to use ArgoCD, KCL, and Github to practice GitOps automation.

- [Implementing GitOps using Github, Argo CD, and KCL to Simplify DevOps](https://kcl-lang.io/blog/2023-07-31-kcl-github-argocd-gitops/)

This article will continue to expand KCL's practice in the field of GitOps, integrate with the continuous integration tool FluxCD, and use KCL, GitHub, and FluxCD to provide a specific practice example, detailing how to build and run a GitOps automation process.

### What is GitOps

GitOps is a software deployment model based on Git. It aims to use Git's version control capabilities to manage and automate the deployment of infrastructure and applications. In GitOps, the Git repository is not only the storage location of the code, but also a reflection of the real environment state. Any changes are implemented through commits to the Git repository, and these changes are then automatically synchronized to the production environment.

Through GitOps, you can effectively:

- Enhance collaboration between developers and operations: Developers and operations can work more collaboratively through a unified Git workflow.
- Improve deployment efficiency and security: GitOps simplifies deployment through automated processes, while providing the necessary audit and rollback mechanisms.
- Improve system traceability: Using Git to manage configurations ensures that every change is traceable, enhancing audit tracking.

### KCL & FluxCD

FluxCD is an automated tool that implements the GitOps model, specifically for Kubernetes clusters. It is responsible for monitoring changes in Git repositories and ensuring that the state of the Kubernetes cluster is consistent with the state defined in the repository. The features of FluxCD include:

- Automated synchronization: Automatically synchronize changes in the Git repository to Kubernetes, achieving continuous deployment of configurations.
- Declarative infrastructure: Manage clusters through declarative configuration files, making infrastructure version control more intuitive.
- Security and compliance: Provide more secure change management and audit tracking through Git's branch and PR mechanisms.

KCL significantly simplifies complex Kubernetes configurations through its abstraction and programmability. It minimizes the error rate, allowing developers to detect potential problems in a timely manner during the writing phase, rather than waiting until runtime. This means fewer configuration templates and stronger multi-environment and multi-tenant configuration capabilities, improving the readability and maintainability of configurations.

By using KCL, developers can precisely define the resources required by the application in a declarative manner. Combined with FluxCD, this declarative foundation can promote the implementation of infrastructure as code (IaC), improve deployment efficiency, and simplify application configuration management. FluxCD, as an automated continuous deployment tool, combined with support for KCL, provides a user-friendly visual management interface for configurations.


In GitOps, developers and operations teams can manage application deployment by modifying application and configuration code separately. The GitOps toolchain, such as FluxCD, will automatically synchronize these changes, ensuring continuous deployment while maintaining the consistency of the environment state. If any problems occur during deployment, you can use the GitOps toolchain to quickly roll back.

### Flux KCL Controller

The Flux KCL Controller is a FluxCD Controller developed for KCL, responsible for monitoring the Git repository that stores KCL programs. Through this controller, FluxCD can expand its automated deployment capabilities, continuously monitor and apply configuration files written in KCL.

![flux-cd](/img/blog/2024-02-23-flux-kcl-controller/fluxcontroller.jpg)

With the help of the Source Controller provided by FluxCD, the Flux KCL Controller can periodically check the KCL files in the associated Git repository. Once it detects new commits or updates in the repository, it automatically triggers the synchronization process of the configuration. This means that any changes to the KCL configuration will be detected and automatically reflected in the state of the Kubernetes cluster, maintaining the latest state and consistency of the configuration.

- [More details about Flux KCL Controller](https://github.com/kcl-lang/flux-kcl-controller)
- [More details about Source Controller](https://github.com/fluxcd/source-controller)

## Case Introduction

We still use a Python Flask application and Github Actions as a CI example, using Flux KCL Controller to integrate FluxCD's capabilities for continuous integration.

We split the Python Flask application code and configuration code into two repositories to separate the focus of different roles such as developers and operations teams.

- Source code repository: https://github.com/kcl-lang/flask-demo
- Configuration repository: https://github.com/kcl-lang/flask-demo-kcl-manifests

The overall workflow is as follows:

![workflow](/img/blog/2024-02-23-flux-kcl-controller/workflow.jpg)

- Pull the application code from Github
- Develop and submit the application code to the Github repository
- Trigger Github Actions to compile the application code, generate a container image, and push the container image to the Docker Hub container registry
- Trigger Github Actions to update the KCL-defined Kubernetes manifest files based on the version number of the container image in the docker.io container registry
- Flux KCL Controller monitors the changes in the Git repository and automatically updates the Kubernetes cluster based on the KCL-defined Kubernetes manifest changes

## Steps

### 0. Prerequisites

- Familiar with basic Unix/Linux commands
- Familiar with Git and Github Action usage
- Understand Kubernetes basics
- Understand FluxCD and KCL

### 1. Configure Kubernetes Cluster

- Install [K3d](https://github.com/k3d-io/k3d) and create a cluster

```bash
k3d cluster create mycluster
```

> Note: You can use other methods to create your own Kubernetes cluster, such as kind, minikube, etc.

### 2. Install Flux KCL Controller

- Install Flux KCL Controller in the cluster using the following command

```bash
git clone https://github.com/kcl-lang/flux-kcl-controller.git/ && cd flux-kcl-controller && make deploy
```

For more detailed content about the installation and usage of Flux KCL Controller, please refer to [Flux-KCL-Controller](https://github.com/kcl-lang/flux-kcl-controller/blob/main/README-zh.md).

### 3. Get the Source Code

```shell
git clone https://github.com/kcl-lang/flask-demo.git/
cd flask-demo
```

This is a web application written in Python. We can use the application directory's `Dockerfile` to generate a container image for this application. We can also automatically build the `flask_demo` image through Github CI. 

Because we have already completed this part of the work in a previous article, we will not repeat the content here. You can find more about the Github CI in [here](https://kcl-lang.io/blog/2023-07-31-kcl-github-argocd-gitops/#3-get-the-application-code).


### 4. Submit the Application Code

After the application code is submitted to the flask-demo repository, Github will automatically build the container image and push the artifact to the Docker Hub. This will trigger the Github CI process for the flask-demo repository. 

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 5. Configure Automatic Updates

After the Github CI process is completed, it will automatically trigger a CI to update the configuration and submit it to the main branch of the flask-demo-kcl-manifests repository. The commit information is as follows

This part of the content has been completed in a previous article, and we will not repeat it here. You can find more [here](https://kcl-lang.io/blog/2023-07-31-kcl-github-argocd-gitops/#5-configuration-automatic-update).

### 6. Use Flux KCL Controller to Monitor the Configuration Repository

We can use the following command to set the Github repo of the Flux KCL Controller to monitor the configuration repository and automatically update the resources in the Kubernetes cluster based on the configuration content.

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kcl-deployment
  namespace: default
spec:
  interval: 10s # Every 10 seconds, check the configuration repository for updates
  url: https://github.com/kcl-lang/flask-demo-kcl-manifests.git
  ref:
    branch: main # Monitor the main branch of the configuration repository
---
apiVersion: krm.kcl.dev.fluxcd/v1alpha1
kind: KCLRun
metadata:
  name: kcl-git-controller
  namespace: default
spec:
  sourceRef:
    kind: GitRepository
    name: kcl-deployment
```

### 7. View Resources Using kubectl

You can use the following command to view the resources in the Kubernetes cluster

```shell
kubectl get deplopments
```

From the output, you can see that the deployed resources have been updated to the latest image

```shell
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
flask-demo   1/1     1            1           16d
```

## Conclusion

Through this article, we show how to use Flux KCL Controller and FluxCD to integrate KCL to create a GitOps automation pipeline, achieving efficient and stable construction of containerized applications. By using Flux KCL Controller and FluxCD to automatically update Docker image tags, and ensure that the configuration in Git is synchronized with the cluster state, we optimized the deployment process, achieved the separation of responsibilities between development and operations, and simplified the management of application configurations. This integration provides a transparent, traceable, and reproducible way to continuously deliver software, ensuring the flexibility of development and the stability of the production environment.
