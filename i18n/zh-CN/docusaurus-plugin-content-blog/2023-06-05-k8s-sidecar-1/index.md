---
slug: 2023-06-05-k8s-sidecar-1
title: 聊聊 K8S 中的 Sidecar 设计模式·第 1 篇
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, k8s, Sidecar]
---
## 介绍

`Sidecar` 北京土话叫三蹦子，通俗叫就是带棚子的三轮摩托车。今天我们要聊的 K8S 中三蹦子也称为边三轮车：边三轮车是在摩托车边上挂靠一个拖斗，云原生中的叫法是主容器和边容器。本系列文章将展示 `Sidecar` 模式的用法，以及如何通过 [KCL](https://kcl-lang.io/) 等面向配置的编程语言来简化 YAML 的编写。

## 一个最简单的云原生 Web 服务

首先以最简方式在 `Kubernetes` 环境启动一个 Web 服务。在下面 `pod.yaml` 文件中定义一个 `Pod`，其中只有一个 `Nginx` 服务，在 80 端口启动一个 `web` 服务。

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

`Pod` 是云原生中的一个基础原语。`Pod` 将多个容器包装为一个逻辑单元，`Kubernetes` 运行时确保 `Pod` 中的容器运行在一个机器上。因此 `Pod` 中的所有容器都共享生命周期、共享磁盘卷、共享网络环境等。`Sidecar` 模式就是在 `Pod` 中增加其他容器来扩展和增强主容器的能力。

然后通过 `kubectl create` 命令行工具创建 `Pod`，然后通过 `kubectl get po` 查看 `Pod` 执行状态：

```shell
$ kubectl create -f pod.yaml
$ kubectl get po
NAME READY STATUS RESTARTS AGE
web-app 1/1 Running 0 45m
```

可以看到一个名为 `web-app` 的 `Pod` 已经正常启动并运行，其中包含 `Nginx` 服务。为了便于外部访问配置端口转发，将宿主的 3999 端口对应到主容器的 80 端口：

```shell
$ kubectl port-forward web-app 3999:80
Forwarding from 127.0.0.1:3999 ->80
Forwarding from [::1]:3999 -> 80
```

端口转发是一个阻塞程序，保持命令行窗口打开。然后在浏览器打开测试页面：

![](/img/blog/2023-06-05-k8s-side-car/port-forward.png)

## 通过 Sidecar 定扩展页面内容

现在我们尝试在不修改原始 `Nginx` 容器镜像的前提下，通过 `Sidecar` 模式为 `Nginx` 服务增加定制 `Web` 页面的能力。在开始前先删除之前启动的 `Pod`：

```shell
$ kubectl delete po web-app
pod "web-app" deleted
```

然后在 `Pod` 中增加第二个 `Busybox Sidecar` 容器，完整的 `pod.yaml` 文件如下：

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

    # --- 以下是新添加的内容 ---
    
    # 和 Sidecar 通过 磁盘卷共享要发布的文件目录
    volumeMounts:
    - name: var-logs
      mountPath: /usr/share/nginx/html
  
  # Sidecar 容器
  - image: busybox
    command: ["/bin/sh"]
    args: ["-c", "while true; do echo $(date -u) 'Hi I am from Sidecar container' > /var/log/index.html; sleep 5;done"]
    name: Sidecar-container
    volumeMounts: var-logs
      mountPath: /var/log

  # Pod 中全部容器共享磁盘卷
  volumes:
  - name: var-logs
    emptyDir: {}
```

`Busybox Sidecar` 容器执行的命令对应以下 `Shell` 脚本：

```bash
while true; do
	echo $(date -u) 'Hi I am from Sidecar container' > /var/log/index.html;
	sleep 5;
done
```

`Sidecar` 容器只有一个功能：每隔 5 秒钟覆盖一次 `/var/log/index.html` 文件，这个文件刚好对应 `Nginx` 的服务的首页页面文件。

然后重新启动 `Pod`，并重新映射本地宿主机端口到容器端口：

```shell
$ kubectl create -f pod.yaml 
pod/web-app created
$ kubectl port-forward web-app 3999:80
Forwarding from 127.0.0.1:3999 -> 80
Forwarding from [::1]:3999 -> 80
```

重新打开浏览器后将看到以下页面：

![](/img/blog/2023-06-05-k8s-side-car/port-forward-1.png)

## Sidecar 模式的工作原理

简单来说，`Busybox` 是 `Sidecar` 容器角色，负责生产首页数据；而 `Nginx` 是主容器，负责消费 `Busybox` 生产的主页数据；两个容器通过 `var-logs` 磁盘卷共享空间。如果以 Go 语言的术语类比，`Nginx` 是主 `Goroutine`，`Busybox` 是后台干脏活的 `Goroutine`，而共享的磁盘卷类似 `Channel` 的作用。

![](/img/blog/2023-06-05-k8s-side-car/how-sidecar-work.png)

在这个例子中 `Nginx` 依然是主容器，`Sidecar` 容器是 `BusyBox`。我们还可以挂更多 `Sidecar` 容器，比如网络、监控、日志等等。

![](/img/blog/2023-06-05-k8s-side-car/how-sidecar-work-1.png)

这样就通过 `Sidecar` 模式，在不修改 `Nginx` 主容器的前提下，扩展出了网络、监控、日志等能力。

## Sidecar 模式的优点

现在容器已经成为一种流行的打包技术，各种不同角色的同学可以通过容器以统一的方式构建、发布和运行程序，甚至管理各种资源。因此容器更像一个功能明确的产品，它有自己的运行时、发布周期、文档和 API 等。好的容器/产品只负责解决一个问题，保持了 KISS 原则可以让容器本身具有极高的重用性和可被替代性。正是因为可重用才使得现代化的构建程序的流程更加敏捷和高效。但是可复用的容器一般都功能单一，我们常常需要通过各种手段扩展容器的功能，以及需要更多的容器之间的协同。

三蹦子 `Sidecar` 可以在不改造主摩托车的前提下增加 N 个拖车功能，相应地云原生 `Sidecar` 模式可以在无需修改主容器的前提下扩展并增强已有主容器功能。如果将云原生的玩法和面向对象编程联系起来，容器镜像就是 `Java` 中的 `class`，而执行中的容器就是 `class` 的实例。而面向对象的 `class` 继承就是基于已有的容器镜像做扩展，`Sidecar` 则是通过类似组合的模式扩展 `class` 的能力。

面向对象编程中有一个“组合优于继承，多用组合少用继承”的规则，因此 Sidecar 也是推荐使用的模式。正是因为三蹦子模式的优点，最近在云原生场景也被大量使用：比如在边车上架一些类似机关枪的网络服务、监控、跟踪等功能。

## 总结

这一篇文章我们简要介绍并在 `Kubernetes` 环境展示了 `Sidecar` 模式，同时结合传统的面向对象编程思想对比了 `Sidecar` 和组合编程模式的关系。`Sidecar` 模式的优势不仅仅体现在无害增强主容器，更灵活的是可以在 `apply` 时动态调整 `Sidecar` 能力。

在后面的文章中，我们将尝试结合 `KCL` 等现代化的云原生配置语言来简化 `Sidecar` 配置的编写。通过尝试探索通过 `KCL` 动态注入和修改 `Sidecar` 来扩展基于已有配置的能力。
