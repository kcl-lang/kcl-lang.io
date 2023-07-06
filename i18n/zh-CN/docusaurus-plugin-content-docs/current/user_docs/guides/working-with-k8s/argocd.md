---
title: "ArgoCD"
sidebar_position: 6
---

## 简介

目前，ArgoCD 内置了一些常见的配置插件，包括 helm、jsonnet、kustomize。而对于 KCL 来说，作为一门全新的配置语言，想要使用 ArgoCD 实现漂移检查的能力，需要遵循它的插件化的机制。

## 先决条件

安装 ArgoCD：

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## 快速开始

### 1. 配置插件

下载 [patch](https://github.com/KusionStack/examples/blob/main/kusion/argo-cd/patch-argocd-cm.yaml) 文件

```bash
wget -q https://raw.githubusercontent.com/KusionStack/examples/main/kusion/argo-cd/patch-argocd-cm.yaml
```

更新配置

```bash
kubectl -n argocd patch cm/argocd-cm -p "$(cat patch-argocd-cm.yaml)"
```

### 2. 更新 ArgoCD 部署

完成第一步，ArgoCD 就可以识别 KCL 插件，但 KCL 插件还没有载入到 ArgoCD 的镜像中。要实现配置漂移检查，需要修改 argocd-repo-server 的 Deployment。

下载 [patch](https://github.com/KusionStack/examples/blob/main/kusion/argo-cd/patch-argocd-repo-server.yaml) 文件

```bash
wget -q https://raw.githubusercontent.com/KusionStack/examples/main/kusion/argo-cd/patch-argocd-repo-server.yaml
```

更新配置

```bash
kubectl -n argocd patch deploy/argocd-repo-server -p "$(cat patch-argocd-repo-server.yaml)"
```

升级完成

```bash
kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-repo-server
```

### 3. 创建 KCL 项目

到此，准备工具已经完成，现在开始验证。这里我们使用开源 Konfig 大库中的示例项目。

开启本地端口转发

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

登录 ArgoCD

```bash
argocd login localhost:8080
```

创建 ArgoCD Application

```bash
argocd app create guestbook-test \
--repo https://github.com/KusionStack/konfig.git \
--path appops/guestbook/prod  \
--dest-namespace default \
--dest-server https://kubernetes.default.svc \
--config-management-plugin kusion
```

注意：如果你正在使用私有仓库，需要先配置私有仓库的访问私钥凭证，再执行创建命令。详细操作，请参见 [Private Repositories](https://argo-cd.readthedocs.io/en/stable/user-guide/private-repositories/#ssh-private-key-credential)。

创建成功后，可以看到以下输出：

```bash
application 'guestbook-test' created
```

通过ArgoCD UI，可以看到，已经创建的应用暂未同步，此处可以手动同步，也可以设置自动同步。

![](/img/docs/user_docs/guides/argocd/out-of-sync.jpg)

设置同步策略（仅同步 `unsynced` 的资源）：

```bash
argocd app set guestbook-test --sync-option ApplyOutOfSyncOnly=true
```

有关同步策略的详细信息，请参见 [Sync Options](https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/)

同步成功：

![](/img/docs/user_docs/guides/argocd/synced.jpg)

### 4. 配置漂移检查

到此，已经完成了 ArgoCD 监听 KCL 项目，实现配置漂移检查并实现结果一致性。我们来修改 `guestbook-test` 的镜像版本，实现配置变更。

更新镜像

```diff
 appConfiguration: frontend.Server {
-    image = "gcr.io/google-samples/gb-frontend:v4"
+    image = "gcr.io/google-samples/gb-frontend:v5"
     schedulingStrategy.resource = res_tpl.tiny
 }
```

更新编译结果

```bash
kusion compile -w appops/guestbook/prod
```

Git 提交并推送

```bash
git add .
git commit -m "manual drifted config for appops/guestbook/prod"
git push origin main
```

漂移配置自动收敛

![](/img/docs/user_docs/guides/argocd/reconcile-drifted-config.jpg)

## 小结

本文档介绍了如何将 KCL 作为第三方插件集成到 ArgoCD 中进行配置漂移检测。它包括安装 ArgoCD 的先决条件，快速启动步骤，包括配置插件、更新 ArgoCD 部署、创建 KCL 项目和配置漂移检测等。
