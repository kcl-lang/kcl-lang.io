---
slug: 2023-06-29-k8s-sidecar-2
title: 聊聊 K8S 中的 Sidecar 设计模式·第 2 篇
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, k8s, Sidecar]
---

## 介绍

在前一篇文章 [聊聊 K8S 中的Sidecar设计模式·第 1 篇](/blog/2023-06-05-k8s-sidecar-1/)中，我们介绍了土话说的三蹦子的 Sidecar 设计模式。本文尝试用 KCL 这种现代化的类型安全的配置语言，来展示 Pod 资源的描述，在后续的文章中，我们将以 KCL 来介绍 Sidecar 这种模式的实际应用。

## 1. Pod 的 OpenAPI 定义

先回到最开始最简单的 Nginx 例子，其 YAML 文件几乎是相同的模式：

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

这里的 Pod 数据满足 Kubernetes 规范 中 `io.k8s.api.core.v1.Pod` 模型的定义。完整的 OpenAPI 定义请 [参考](https://github.com/kubernetes/kubernetes/tree/master/api/openapi-spec)。仔细分析可以发现，apiVersion 和 kind 信息都是比较常见的默认配置，我们需要更现代的配置语言来简化。

## 2. 使用 KCL 定义 Pod 资源

KCL 是一门面向云原生领域配置策略语言，详细资料可参考[语言官网](https://kcl-lang.io)

基本的 KCL 配置程序仍然遵循 `K=V` 的形式， YAML 比较相似。比如，我们可以用下面的 KCL 代码来重写 Nginx 容器的配置：

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

其中 import 导入了 k8s 包中的 `k8s/api/core/v1` 包，其中的 Pod 结构定义对应 Pod 模型，其中已经包含了 apiVersion 和 kind 的默认值，因此只需要添加 `metadata.name` 和 `spec.containers` 属性（KCL 也针对一些多级嵌套的属性提供了的语法糖）。

我们可以通过 [kpm 包管理工具](https://kcl-lang.io/docs/user_docs/guides/package-management/installation)，创建一个 KCL 程序来定义一个 Pod 资源。并执行这个程序来得到对应的 YAML。

```shell
# 1. 初始化一个 kcl 程序包 hello.
kpm init hello

# 2. 编辑 hello 包内的 main.k 文件，
# 将前文中提到的 KCL 配置代码添加到 hello/main.k 中
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

# 3. 进入到 hello 包内，添加 k8s 依赖，并且运行 hello 包。
cd hello && kpm add k8s && kpm run
```

可以得到如下 YAML 输出:

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

## 3. 小结

这一篇文章我们简要介绍了如何通过 KCL 构建出 Pod 配置来获得更灵活、更健壮的配置。后续文章中我们将通过 KCL 来提炼和抽象最佳的 Sidecar 模式实践，包括使用 KCL 对 Sidecar 模型进行抽象以及使用 KCL 对已存在的上游 YAML 配置进行 Sidecar 注入。
