---
id: gitops-quick-start
sidebar_label: 使用 ArgoCD 支持 KCL 实现 GitOps
---

# 快速开始

## 简介

### 什么是 GitOps

GitOps 是一种实现持续交付的现代方式。它的核心思想是拥有一个包含环境和应用程序配置的 Git 存储库。通过更改应用存储库中的文件，可以自动部署应用程序。应用 GitOps 的好处包括：

- 提高生产力，持续交付可以加快部署时间。
- 降低开发人员部署的障碍。通过推送代码而不是容器配置，开发人员可以在不知道其内部实现的情况下轻松部署 Kubernetes 集群和应用。
- 追踪变更记录。使用 Git 管理配置使每一项更改都具有可跟踪性，从而增强审计跟踪。

### 将 KCL 与 ArgoCD 一起使用

将 [KCL](https://github.com/kcl-lang/kcl) 与 [ArgoCD](https://github.com/argoproj/argo-cd) 等 GitOps 工具一起使用具有如下好处:

- 通过 KCL 语言的[抽象能力](/docs/user_docs/guides/abstraction)和可编程能力可以帮助我们**简化复杂的 Kubernetes 部署配置文件**，降低手动编写 YAML 文件的错误率，消除多余的配置模版，提升多环境多租户的配置扩展能力，同时提高配置的可读性和可维护性。
- KCL 允许开发人员以声明式的方式定义应用程序所需的资源，通过将 KCL 和 ArgoCD 相结合可以帮助我们更好地实现**基础设施即代码（IaC）**，提高部署效率，简化应用程序的配置管理。
- ArgoCD 可以**自动化**地实现应用程序的连续部署，并提供友好的可视化界面。

使用 GitOps，开发人员和运维团队可以通过分别修改应用和配置代码来管理应用程序的部署，GitOps 工具链将自动同步对配置的更改，从而实现持续部署并确保一致性。如果出现问题，可以使用 GitOps 工具链快速回滚。

## 先决条件

- 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

## 快速开始

### 1. 获取示例

首先，我们执行 git 命令获得用例

```bash
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/gitops
```

我们可以运行以下命令来显示配置

```bash
cat config/main.k
```

The output is

```python
import .app

config = app.App {
    name = "kcl-guestbook-ui"
    containers.guestbook = {
        image = "gcr.io/heptio-images/ks-guestbook-demo:0.2"
        ports = [{containerPort = 80}]
    }
    service.ports = [{ port = 80 }]
    service.type = "LoadBalancer"
}
```

在上述代码中，我们定义使用 `App` schema 定义了应用的配置，其中我们配置了一个镜像为 `gcr.io/heptio-images/ks-guestbook-demo:0.2` 容器，并启用了 `80` 端口。

### 2. 安装 Kubernetes 和 GitOps 工具

#### 配置 Kubernetes 集群和 ArgoCD 控制器

- 安装 [K3d](https://github.com/k3d-io/k3d) 并创建一个集群

```bash
k3d cluster create mycluster
```

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

- 安装 [ArgoCD](https://github.com/argoproj/argo-cd/releases/).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- 安装 ArgoCD KCL 插件

```bash
kubectl apply -f ./install/kcl-cmp.yaml && kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat ./install/patch-argocd-repo-server.yaml)"
```

- 通过 `kubectl get` 命令查看 argocd 控制器容器是否初始化完成进入运行（Running）状态。

```bash
kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

- 通过如下命令打开 ArgoCD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

- 打开浏览器 `https://localhost:8080` 输入用户名 "admin" 和密码登陆 ArgoCD UI，密码可以通过如下命令得到:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

#### 安装 ArgoCD 客户端工具

- 安装 [ArgoCD 客户端工具](https://github.com/argoproj/argo-cd/releases)

- 使用用户名 "admin" 和刚才得到的密码登陆

```bash
argocd login localhost:8080
```

通过如下命令创建一个 ArgoCD KCL 应用

```bash
argocd app create guestbook \
--repo https://github.com/kcl-lang/kcl-lang.io \
--path examples/gitops/config \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin kcl-v1.0
```

如果创建成功，您可以看到如下输出:

```bash
application 'guestbook' created
```

> 如果您使用的是私有存储库，则在执行 create 命令之前，需要使用私钥凭据配置专用私有存储库访问权限。请参阅[这里](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/)以获取更多详细信息。

通过 ArgoCD UI，您可以看到创建的应用程序尚未同步，您可以手动进行配置同步或设置为自动同步。

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app.jpg)

有关同步策略的更多信息，可以请参阅[这里](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)

![](/img/docs/user_docs/guides/gitops/argocd-kcl-app-dashboard.jpg)
