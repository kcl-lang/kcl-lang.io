---
slug: 2023-07-31-kcl-github-argocd-gitops
title: Implementing GitOps using Github, Argo CD, and KCL to Simplify DevOps
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Github, ArgoCD, GitOps]
---

## Introduction

In modern software development, GitOps, as a single truth automation method for managing infrastructure and applications, plays a key role in improving efficiency and reducing Human error, and is now widely popular in cloud-native and other fields. However, there are not many practical examples related to GitOps. This blog will use KCL, Github and ArgoCD as examples to introduce GitOps in detail, hoping to help everyone practice their own GitOps automation process and simplify DevOps.

### What is GitOps

GitOps is a modern way to do continuous delivery. Its core idea is to have a Git repository which contains environmental and application configurations. An automated process is also needed for sync the config to cluster.

By changing the files in repository, developers can apply the applications automatically. The benefits of applying GitOps include:

+ Increased productivity. Continuous delivery can speed up the time of deployment.
+ Lower the barrier for developer to deploy. By pushing code instead of container configuration, developers can easily deploy Kubernetes without knowing its internal implementation.
+ Trace the change records. Managing the cluster with Git makes every change traceable, enhancing the audit trail.
+ Recover the cluster with Git's rollback and branch.

### GitOps with KCL

Benefits of Using KCL and ArgoCD Together:

+ KCL can help us **simplify complex Kubernetes deployment configuration files**, reduce the error rate of manually writing YAML files, control configuration constraint checking during compilation, and perceive errors immediately upon writing; At the same time, KCL can be used to eliminate redundant configuration templates, enhance the scalability of multi-environment and multi-tenant configurations, and improve the readability and maintainability of configurations.
+ ArgoCD can **automate** the deployment of Kubernetes applications, achieve continuous deployment, and provide comprehensive monitoring and control functions.
+ By combining KCL and ArgoCD, deployment efficiency can be improved, errors reduced, and management and monitoring of Kubernetes applications strengthened.
+ The combination of KCL and ArgoCD can also help us achieve **Infrastructure as Code (IaC)**, simplify application deployment and management, and better implement DevOps principles.

With GitOps, developer and operation teams can manage application deployment and configuration by modifying KCL code and generating YAML files. The GitOps toolchain will automatically synchronize the changes to the Kubernetes cluster, enabling continuous deployment and ensuring consistency. If there are issues, the GitOps toolchain can be used to quickly rollback.

## Workflow

We hope to implement the end-to-end application development process by using containers, Continuous Integration (CI) for generation, and GitOps for Continuous Deployment (CD). In this scheme, we use a **Flask application** and **Github Actions** as examples.

> Note: You can use any containerized application and different CI systems such as **Gitlab CI**, **Jenkins CI**, etc. in this solution.

We divide the Python Flask application code and configuration code into two repos, *to achieve the separation of concerns of different roles, such as developers and operation and maintenance teams*

+ App code repo: https://github.com/kcl-lang/flask-demo
+ Config manifest repo: https://github.com/kcl-lang/flask-demo-kcl-manifests

The overall workflow is as follows:

![workflow](/img/blog/2023-07-31-kcl-github-argocd-gitops/workflow.jpg)

1. Pull application code from Github.
2. Develop and submit application code to the GitHub repository.
3. Trigger GitHub Actions to compile the application code, generate container images, and push the container images to the Docker Hub container registry.
4. Trigger GitHub Actions to synchronously update the Kubernetes manifest files defined by KCL based on the version of the container image in the `docker.io` container registry.
5. ArgoCD obtains Kubernetes manifest changes and updates deployment to Kubernetes cluster.

## Steps

### 0. Prerequisite

+ Familiar with the basic commands of Unix/Linux
+ Familiar with Git and Github Action
+ Understand the basics of Kubernetes
+ Understand tools such as ArgoCD
+ Understand the basic knowledge of KCL

### 1. Setup Kubernetes Cluster

+ Install [K3d](https://github.com/k3d-io/k3d) to create a default cluster.

```bash
k3d cluster create mycluster
```

> Note: You can use other methods in this solution to create your own Kubernetes cluster, such as `kind`, `minikube`, etc.

### 2. Setup ArgoCD

#### Setup ArgoCD Controllers

+ Install [ArgoCD](https://github.com/argoproj/argo-cd/releases/).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

+ Enable ArgoCD KCL Plugin

Write the patch YAML configuration file and update the ArgoCD configuration:

```bash
kubectl apply -f ./install/kcl-cmp.yaml
```

After completing the first step, ArgoCD will recognize the KCL plugin, but the KCL plugin has not been loaded into the ArgoCD image. To implement configuration drift detection, we have to tune the Deployment of argocd-repo-server.

```bash
kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat ./install/patch-argocd-repo-server.yaml)"
```

Wait for the init container to complete execution (Running).

```bash
kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

+ To access the ArgoCD web UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

+ Open a browser and go to: `https://localhost:8080`

+ The username is "admin" and password get be obtained from the following command:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### Setup ArgoCD CLI

+ Install [ArgoCD CLI](https://github.com/argoproj/argo-cd/releases)

Use "admin" and password to login to ArgoCD

```bash
argocd login localhost:8080
```

Create ArgoCD Application

```bash
argocd app create flaskdemo \
--repo https://github.com/kcl-lang/flask-demo-kcl-manifests \
--path . \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin kcl-v1.0
```

After successfully creating, you can see the following output:

```bash
application 'flaskdemo' created
```

> If you are using a private repository, you need to configure the private repository access with private key credentials before executing the create command.Please refer [Private Repositories](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/#ssh-private-key-credential) for more details.

Through the ArgoCD UI, you can see that the created applications have not been synchronized yet. Here, you can manually synchronize or set automatic synchronization.

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app.jpg)

For more information on synchronization strategies, see [Sync Options](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app-dashboard.jpg)

### 3. Get the Application Code

```shell
git clone https://github.com/kcl-lang/flask-demo.git/
cd flask-demo
```

This is a web application written in Python. We can use the `Dockerfile` in the application directory to generate a container image of this application, and also use Github CI to automatically build a image named `flask_demo`, the CI configuration is as follows

```yaml
# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the workflow will run
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  # This workflow contains a single job called "build"
  build:
    # The type of runner that the job will run on
    runs-on: ubuntu-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
      # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
      - uses: actions/checkout@v2
      
      - name: Docker Login
        uses: docker/login-action@v1.10.0
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
          logout: true

      # Runs a set of commands using the runners shell
      - name: build image
        run: |
          make image
          docker tag flask_demo:latest ${{ secrets.DOCKER_USERNAME }}/flask_demo:${{ github.sha }}
          docker push ${{ secrets.DOCKER_USERNAME }}/flask_demo:${{ github.sha }}

      # Trigger KCL manifest
      - name: Trigger CI
        uses: InformaticsMatters/trigger-ci-action@1.0.1
        with:
          ci-owner: kcl-lang
          ci-repository: flask-demo-kcl-manifests
          ci-ref: refs/heads/main
          ci-user: kcl-bot
          ci-user-token: ${{ secrets.DEPLOY_ACCESS_TOKEN }}
          ci-name: CI
          ci-inputs: >-
            image=${{ secrets.DOCKER_USERNAME }}/flask_demo
            sha-tag=${{ github.sha }}
```

We need the workflow in the source code repository to automatically trigger the workflow in the deployment manifest repository. At this point, we need to create a `secrets.DEPLOY_ACCESS_TOKEN` with Github CI operation permissions and **Docker Hub** image push account information `secrets.DOCKER_USERNAME` and `secrets.DOCKER_PASSWORD`  can be configured in the `Secrets and variables` settings of the Github, as shown in the following figure

![](/img/docs/user_docs/guides/ci-integration/github-secrets.png)

### 4. Commit the Application Code

After submitting in the `flask-demo` repository, Github will automatically build a container image and push it to the Docker hub. It will also then trigger the Action of the `flask-demo-kcl-manifest` repository and modify the image value in the deployment manifest repository through [KCL Automation API](/docs/user_docs/guides/automation). Now let's create a submission in the `flask-demo` repository, and we can see that the code submission triggers the Github CI process for the application repository.

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 5. Configuration Automatic Update

After the Github CI process in the application repository is completed, an automatic update configuration CI will be triggered in the repository where the KCL configuration is stored and submitted to the main branch of the `flask-demo-kcl-manifests` repository. The commit information is as follows

![](/img/docs/user_docs/guides/ci-integration/image-auto-update.png)

+ We can obtain the deployment manifest source code for compilation and validation

```shell
git clone https://github.com/kcl-lang/flask-demo-kcl-manifests.git/
cd flask-demo-kcl-manifests
git checkout main && git pull && kcl
```

The output YAML is

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask_demo
  template:
    metadata:
      labels:
        app: flask_demo
    spec:
      containers:
        - name: flask_demo
          image: "kcllang/flask_demo:6428cff4309afc8c1c40ad180bb9cfd82546be3e"
          ports:
            - protocol: TCP
              containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: flask_demo
  labels:
    app: flask_demo
spec:
  type: NodePort
  selector:
    app: flask_demo
  ports:
    - port: 5000
      protocol: TCP
      targetPort: 5000
```

From the above configuration, it can be seen that the image of the resource is indeed automatically updated to the newly constructed image value. In addition, we can also use the **Argo CD KCL plugin** to automatically synchronize data from the Git repository and deploy the application to the Kubernetes cluster.

## Conclusion

Through the blog, we can use Github, ArgoCD, and KCL to create GitOps automated pipelines, which can efficiently and stably build containerized applications, while automatically updating the latest Dbroker image labels and keeping Git configuration consistent with cluster configuration. In addition, the combination of KCL and ArgoCD can help us better realize Infrastructure as Code (IaC), improve deployment efficiency, achieve the separation of concerns of different roles, and simplify the configuration management of applications.
