---
slug: 2023-11-20-search-k8s-module-on-artifacthub
title: 快来看看，这里有你需要的 Kubernetes 模型！
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Kubernetes, Modules, ArtifactHub]
---

## 简介

在之前的几次更新中，我们为 [KCL 语言](https://github.com/kcl-lang)增加了包管理的能力，解决了如何获取和发布三方库的问题。随之而来的新问题是，在开发程序的过程中，小伙伴们往往不确定该使用哪个库解决自己的问题。在通过包管理工具使用三方库之前，需要结合具体云原生运维场景的需求和各种三方库的能力去挑选合适的库使用。

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言并通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

因此，我们借助同为 CNCF 的 [ArtifactHub](https://artifacthub.io/) 项目构建了一个 KCL 三方库的市场，在这个市场中，有需求的朋友们能够根据自己的需求自由选择自己需要的三方库，有想法愿意分享的朋友们，也可以在这个市场中与大家分享。接下来，我们将通过一个简单的发布应用的案例来近距离感受一下如何在 ArtifactHub 上检索 KCL 三方库，并结合库文档的内容进行 KCL 程序开发。

## 前置工作

安装环境

- 安装 KCL *https://kcl-lang.io/docs/user_docs/getting-started/install/*
- 安装 kubectl *https://kubernetes.io/zh-cn/docs/tasks/tools/#kubectl*
- 安装 minikube *https://minikube.sigs.k8s.io/docs/start/*

使用以下命令启动 minikube

```shell
minikube start --cache-images=true
```

如果您的 minikube 中没有安装 Ingress 控制器，您可以使用如下命令安装：

```shell
minikube addons enable ingress
```

## HelloWorld 案例

首先，我们可以准备一个简单的 js 应用。

```js
const express = require("express");
const app = express();
const port = 8080;

// 定义一个响应 GET 请求的路由
app.get("/", (req, res) => {
  res.send("欢迎来到我的Web应用程序！");
});

// 启动服务器
app.listen(port, () => {
  console.log(`Web app listening http://localhost:${port}`);
});
```

并且为这个应用准备一个镜像，并将镜像上传到镜像中心。

```dockerfile
FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "node", "app.js" ]
```

本文的案例中我们将使用镜像地址 `ghcr.io/test/my-web-app:1.0` 来展示具体的内容。完成了准备工作，我们就可以使用 KCL 编写对应的发布代码了。

## 使用 ArtifactHub 搜索您需要的包

首先，我想要将我的 my-web-app 应用发布，我需要借助 `k8s` 的三方库完成我的工作。直接在 [ArtifactHub](https://artifacthub.io/) 中搜索 `k8s`关键字，可以看到目前提供的 k8s 的三方库。

![index-page](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/index-page.png)

在 `k8s` 模型的主页中，您可以找到关于 `k8s` 包的文档，不同版本等更加详细的内容。

![k8s-page](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/k8s-page.png)

右侧的 `INSTALL` 按钮为您提供了安装 `k8s` 三方库的方式。

![k8s-install-page](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/k8s-install-page.png)

我们这里是使用 `k8s` 作为包的依赖，因此如下命令进行安装：

```shell
kcl mod init my-kubernetes-config && cd my-kubernetes-config && kcl mod add k8s:1.28
```

接下来，我们需要编写发布应用对应的 `deployment`, `service` 和 `ingress` 三个部分。这里需要使用到我们刚才添加的 `k8s` 包中的 `Deployment`, `Service`和 `Ingress` 三个 `schema`。 
更多关于 schema 的内容可以查阅: *https://kcl-lang.io/docs/next/reference/lang/tour#schema*

如果您对这三个内容不太了解，您可以直接在模型的详情页进行搜索。以 `Deployment` 为例，您可以在文档中看到更加详细的信息。

![deployment](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/deployment.png)

根据文档的内容，我们可以在 `main.k` 文件中编写如下 `deployment`

```python
import k8s.api.apps.v1 as d

deployment = d.Deployment {
    metadata.name = "web-app-deployment"
    spec = {
        selector.matchLabels = {app = "web-app"}
        template = {
            metadata.labels = {app = "web-app"}
            spec.containers = [{
                name = "web-app"
                image = "ghcr.io/test/my-web-app:1.0"
                ports = [{containerPort = 80}]
            }]
        }
    }
}
```

关于 `Service`, 可以查到相关文档：

![service](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/service.png)

对应的 `service`内容如下：

```shell
import k8s.api.core.v1 as s
service = s.Service {
    metadata.name = "web-app-service"
    spec.selector = {"app": "web-app"}
    spec.ports = [{
        port: 80
        targetPort: 8080
    }]
}
```

关于 `Ingress`, 可以查到相关文档

![ingress](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/ingress.png)

对应的 `ingress`内容如下：

```python
import k8s.api.networking.v1 as i

ingress = i.Ingress {
    metadata.name = "web-app-ingress"
    spec.rules = [
        {
            host: "web-app.example.com"
            http.paths = [
                {
                    path: "/"
                    pathType: "Prefix"
                    backend.service.name: "web-app-service"
                    backend.service.port: {
                        number: 8080
                    }
                }
            ]
        }
    ]
}
```

最后，在 main.k 文件中增加如下内容，将 deployment, service 和 ingress 渲染为 yaml 格式。

```shell
manifests.yaml_stream([
    deployment
    service
    ingress
])
```

您可以使用如下命令编译对应的 KCL 程序，并且 apply。

```shell
kcl run main.k | kubectl apply -f -
```

进行到这里，我们已经在 ArtifactHub 的帮助下成功发布了应用 my-web-app。

最后，我们通过 kubectl 端口转发，来看一下发布的效果。使用以下命令进行转发。

```shell
kubectl port-forward service/web-app-service 8080:80
```

然后通过如下命令或者直接通过浏览器访问 http://localhost:8080 来访问我们发布的应用。

```shell
curl http://localhost:8080
```

如果您通过 curl 命令行访问，您将会获得输出：

```shell
$ curl http://localhost:8080

欢迎来到我的 Web 应用程序！
```

如果您通过浏览器访问，您将会看到：

![browser](/img/blog/2023-11-20-search-k8s-module-on-artifacthub/browser.png)

## 总结

本文通过一个简单的应用发布，为大家展示了如何在 ArtifactHub 上选择合适的 KCL 三方库，目前 ArtifactHub 上已经提供超过 150 个 KCL 三方库供大家选择，快来看看有没有你需要的 KCL 模型吧 ！

在本文提供的案例中，我们用 KCL 编写了发布应用的程序。在后续的更新中，我们将进一步通过动态参数等特性对本文中的 KCL 程序进行抽象以及使用更多的应用模型介绍如 Open Application Model (OAM) 等，并且打包成一个单独的模块发布到 ArtifactHub 中，如果您也有想要与他人分享的 KCL 模块，我们将继续更新详细的步骤和指南，帮助您成功发布您的包。敬请期待！
