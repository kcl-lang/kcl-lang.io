---
id: gitops-quick-start
sidebar_label: Quick Start
---

# Quick Start

## Introduction

### What is GitOps

GitOps is a modern way to do continuous delivery. Its core idea is to have a Git repository which contains environmental and application configurations. An automated process is also needed for sync the config to cluster.

By changing the files in repository, developers can apply the applications automatically. The benefits of applying GitOps include:

+ Increased productivity. Continuous delivery can speed up the time of deployment.
+ Lower the barrier for developer to deploy. By pushing code instead of container configuration, developers can easily deploy Kubernetes without knowing its internal implementation.
+ Trace the change records. Managing the cluster with Git makes every change traceable, enhancing the audit trail.
+ Recover the cluster with Git's rollback and branch.

### GitOps with KCL

Benefits of Using KCL and ArgoCD Together:

+ KCL can help us **simplify complex Kubernetes deployment configuration files**, reduce the error rate of manually writing YAML files, and improve code readability and maintainability.
+ ArgoCD can **automate** the deployment of Kubernetes applications, achieve continuous deployment, and provide comprehensive monitoring and control functions.
+ By combining KCL and ArgoCD, deployment efficiency can be improved, errors reduced, and management and monitoring of Kubernetes applications strengthened.
+ The combination of KCL and ArgoCD can also help us achieve **Infrastructure as Code (IaC)**, simplify application deployment and management, and better implement DevOps principles.

With GitOps, developer and operation teams can manage application deployment and configuration by modifying KCL code and generating YAML files. The GitOps toolchain will automatically synchronize the changes to the Kubernetes cluster, enabling continuous deployment and ensuring consistency. If there are issues, the GitOps toolchain can be used to quickly rollback.

## How to

### 1. Get the Example

### 2. Setup Config Repository

### 3. Setup App Code Repository

### 4. Install Kubernetes and GitOps Tool

#### Setup Kubernetes Cluster and ArgoCD Controllers

+ Install [K3d](https://github.com/k3d-io/k3d) to create a default cluster.

```bash
k3d cluster delete mycluster && k3d cluster create mycluster
```

+ Install [Kwok](https://kwok.sigs.k8s.io/docs/user/installation/)

```bash
go install sigs.k8s.io/kwok/cmd/{kwok,kwokctl}@v0.2.0
```

```bash
kwokctl create cluster --name=mycluster
```

+ Install [ArgoCD](https://github.com/argoproj/argo-cd/releases/).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.7.4/manifests/install.yaml
# Local install
kubectl apply -n argocd -f install.yaml
```

+ Enable ArgoCD KCL Plugin

Write the patch YAML configuration file and update the ArgoCD configuration:

```bash
cat <<EOF > kcl-cmp.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kcl-cmp
  namespace: argocd
data:
  plugin.yaml: |
    apiVersion: argoproj.io/v1alpha1
    kind: ConfigManagementPlugin
    metadata:
      name: kcl
    spec:
      version: v1.0
      generate:
        command: ["sh"]
        args:
          - -c
          - kcl
EOF
kubectl apply -f kcl-cmp.yaml
kubectl apply -f temp-cmp.yaml
```

After completing the first step, ArgoCD will recognize the KCL plugin, but the KCL plugin has not been loaded into the ArgoCD image. To implement configuration drift detection, we have to tune the Deployment of argocd-repo-server.

Download [patch](https://github.com/KusionStack/examples/blob/main/kusion/argo-cd/patch-argocd-repo-server.yaml) file

```bash
wget -q https://raw.githubusercontent.com/KusionStack/kcl-lang.io/main/examples/kubernetes/argocd/patch-argocd-repo-server.yaml
```

Update configuration

```bash
kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat patch-argocd-repo-server.yaml)"
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

+ Install [ArgoCD CLI](https://github.com/argoproj/argo-cd/releases/download)

Use "admin" and password to login to ArgoCD

```bash
argocd login localhost:8080
```

Create ArgoCD Application

```bash
argocd app create guestbook \
--repo https://github.com/KusionStack/kcl-lang.io \
--path examples/gitops/config \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin my-plugin-v1.0
```

### 5. Modify App Code and Update Deployment Automatically

### 6. Rollback Changes

## Summary

With GitOps, you can easily manage your applications and configuration in your Kubernetes cluster, ensuring that your applications are always in the desired state.

## Reference

+ [DevOps in Argo CD — Installation](https://medium.com/cloud-native-daily/devops-in-argo-cd-installation-4b5bf028caa5)

kubectl exec -it argocd-repo-server-7c5bf6c475-ptsfk /bin/bash -n argocd -c 'argocd-repo-server'
