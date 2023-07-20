---
id: github-actions
sidebar_label: Github Actions
---
# Github Actions Integration

## Introduction

In the GitOps section, we have introduced how to integrate KCL with GitOps. In this section, we will continue to provide sample solutions for KCL and CI integrations. We hope to implement the end-to-end application development process by using containers, Continuous Integration (CI) for generation, and GitOps for Continuous Deployment (CD). In this scheme, we use a **Flask application** and **Github Actions** as examples.

> Note: You can use any containerized application and different CI systems such as **Gitlab CI**, **Jenkins CI**, etc. in this solution.

The overall workflow is as follows:

+ Develop application code and submit it to the GitHub repository to trigger CI.
+ GitHub Actions generate container images from application code and push them to the `docker.io` container registry.
+ GitHub Actions automatically synchronizes and updates the KCL manifest deployment file based on the version of the container image in the docker.io container registry.

## How to

### 1. Get the Example

We put the application source code and infrature deployment code in different repos, which can be maintained by different roles to achieve the separation of concerns.

+ Get the application code

```shell
git clone https://github.com/kcl-lang/flask-demo.io.git/
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

### 2. Commit the Application Code

After submitting in the `flask-demo` repository, Github will automatically build a container image and push it to the Docker hub. It will also then trigger the Action of the `flask-demo-kcl-manifest` repository and modify the image value in the deployment manifest repository through [KCL Automation API](/docs/user_docs/guides/automation). Now let's create a submission in the `flask-demo` repository, and we can see that the code submission triggers the Github CI process for the application repository.

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

### 3. Configuration Automatic Update

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

## Summary

By integrating KCL and Github CI, we can integrate the container build and delivery workflow by automatically updating the image values in the configuration, in order to achieve end-to-end application development process and improve R&D deployment efficiency.
