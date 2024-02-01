---
slug: 2024-02-21-biweekly-newsletter
title: KCL 社区开源双周报 (2024 01.19 - 2024.02.21) | KCL v0.7.5 版本和 Flux KCL 集成更新速递
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Biweekly-Newsletter]
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

感谢所有贡献者过去两周 (2024 01.19 - 2024.02.01) 的杰出工作，以下是重点内容概述

**📦 模型更新**

- 新增 Podinfo 应用配置模型，支持设置外部动态参数如 `replicas` 等，可以直接通过一条命令渲染 Kubernetes 资源配置，并且可以在此模型的基础上修改并自定义资源模版

```shell
kcl run oci://ghcr.io/kcl-lang/podinfo -D replicas=2
```

**🏄 语言更新**

- 改善编译时对象属性找不到的报错信息
- 修复 Schema 对象必选属性递归检查错误
- 提升 Schema 索引签名类型检查健壮性

**🔧 工具链更新**

- **文档工具更新**
  - 支持在生成的 Markdown 格式文档对多行字符使用 HTML 转义

- **CodeQL KCL 工具**
  - 初步支持 CodeQL KCL dbschema 定义以及对 KCL 语法语义进行数据提取，并可通过 CodeQL 进行数据查询对 KCL 代码进行静态分析和扫描，提升代码安全

**💻 IDE 更新**

- **语义高亮**
  - KCL IDE 优化了语义高亮。
- **错误修复**
  - 修复了字符串后跟注释中补全错误的问题
  - 修复了 Schema 内部属性符号不能跳转的问题

**🎁 API 更新**

- 新增语法和语义分析 API 用于对 KCL 代码进行分析
- 新增构建二进制产物 API 用于缓存编译结果
- 新增运行二进制产物 API 用于直接运行编译结果，避免重复编译并提升性能
- 新增代码生成 API 以编程方式实现 KCL 代码生成而不是编写复杂的模版

**🚀 SDK 更新**

- KCL Go SDK 更新至 0.7.5 版本
- KCL Python SDK 更新至 0.7.5 版本
- KCL Rust SDK 更新至 0.7.5 版本
- KCL Java SDK 新增语法树、作用域、符号等语法语义结构定义及相关查询 API

更多内容详见: [https://github.com/kcl-lang/lib](https://github.com/kcl-lang/lib)

**🚢 集成更新**

- 除了使用 ArgoCD KCL 插件，KCL 现在支持使用 KCL Flux Controller 对存储在 Git 仓库的 KCL 配置进行 GitOps，详见 [https://github.com/kcl-lang/flux-kcl-controller](https://github.com/kcl-lang/flux-kcl-controller)，欢迎共建 👏

## 特别鸣谢

以下排名不分先后

- 感谢 @octonawish-akcodes 对 KCL 代码清理和 FAQ 文档的持续贡献 🙌
- 感谢 @satyazzz123 对 KRM KCL 支持读取环境变量功能的贡献 🙌
- 感谢 @AkashKumar7902 对 KCL 包管理工具功能的贡献 🙌
- 感谢 @UtkarshUmre 对 KCL linux-arm64 构建 CI 的贡献 🙌
- 感谢 @steeling, @rozaliev, @CloudZero357, @martingreber, @az, @Art3mK,@AdmiralNemo 和 @Erick 等在近两周使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 精选更新

### Flux KCL 集成

将 KCL 与 Flux 等 GitOps 工具一起使用具有如下好处:

- 通过 KCL 语言的抽象能力和可编程能力可以帮助我们**简化复杂的 Kubernetes 部署配置文件**，降低手动编写 YAML 文件的错误率，将配置约束检查控制在编译时，编写即感知错误；同时可以消除多余的配置模版，提升多环境多租户的配置扩展能力，提高配置的可读性和可维护性。
- KCL 允许开发人员以声明式的方式定义应用程序所需的资源，通过将 KCL 和 Flux 相结合可以帮助我们更好地实现**基础设施即代码（IaC）**，提高部署效率，简化应用程序的配置管理。
- 使用 Flux，开发人员和运维团队可以通过分别修改应用和配置代码来管理应用程序的部署，Flux Controller 将自动同步对配置的更改，从而实现持续部署并确保一致性。如果出现问题，可以实现快速回滚。

#### 工作流程

在此示例中，我们使用一个 Python Flask 应用和 Github Actions 作为 CI 示例，使用部署在集群中 Flux KCL Controller 作为 CD 示例，使用 KCL 定义需要部署的 Kubernetes 资源

> 注意：你可以在此方案中使用任何容器化应用以及不同的 CI 和 CD 系统如 Gitlab CI，Jenkins CI，ArgoCD 等

我们将 Python Flask 应用代码和配置代码分成两个仓库，_以实现不同角色如开发人员和运维团队的关注点分离_

- 业务代码仓库: https://github.com/kcl-lang/flask-demo
- 配置清单仓库: https://github.com/kcl-lang/flask-demo-kcl-manifests

整体工作流程如下：

1. 从 Github 拉取应用代码
2. 应用代码开发并提交到提交到 GitHub 存储库
3. 触发 GitHub Actions 对应用代码进行编译，生成容器镜像，并将容器镜像推送到 Docker Hub 容器注册表
4. 触发 GitHub Actions 根据 docker.io 容器注册表中容器镜像的版本号并同步更新 KCL 定义的 Kubernetes 清单部署文件
5. Flux KCL Controller 获取 KCL 定义的 Kubernetes 清单更改并更新部署至 Kubernetes 集群

#### 具体步骤

##### 1. 配置 Kubernetes

- 安装 [K3d](https://github.com/k3d-io/k3d) 并创建一个集群

```bash
k3d cluster create
```

> 注意：你可以在此方案中使用其他方式创建您自己的 Kubernetes 集群，如 kind, minikube 等。

+ 安装 Kubectl
+ 安装 Kustomize

##### 2. 安装 Flux KCL Controller

![flux-kcl-workflow](/img/blog/2024-02-21-biweekly-newsletter/flux-kcl-workflow.png)

```shell
git clone https://github.com/kcl-lang/flux-kcl-controller.git && cd flux-kcl-controller && make deploy
```

##### 3. 配置需要持续交付的 Git 仓库

通过 `gitrepo.yaml` 文件，定义 `GitRepository` 和 `KCLRun` 对象，用来配置监控需要持续交付的 Git 仓库以及运行 KCL 配置所需的额外参数

```yaml
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kcl-deployment
  namespace: default
spec:
  interval: 10s # 每隔 10s 检查一次仓库
  url: https://github.com/kcl-lang/flask-demo-kcl-manifests.git
  ref:
    branch: main # 监控 main 分支
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

使用命令 `kubectl apply -f gitrepo.yaml` 将该对象部署到集群中。

> 如果您使用的是私有存储库，需要使用私钥凭据配置专用私有存储库访问权限。请参阅[这里](https://fluxcd.io/flux/components/source/gitrepositories/)以获取更多详细信息。

> 注意：你也可以在此方案中使用 [OCIRepository](https://fluxcd.io/flux/components/source/ocirepositories/)，对文章开头提到的 `oci://ghcr.io/kcl-lang/podinfo` 配置包进行持续交付，比如下面的配置

```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: OCIRepository
metadata:
  name: podinfo
  namespace: default
spec:
  interval: 5m0s
  url: oci://ghcr.io/kcl-lang/podinfo
  ref:
    tag: latest
---
apiVersion: krm.kcl.dev.fluxcd/v1alpha1
kind: KCLRun
metadata:
  name: kcl-git-controller
  namespace: default
spec:
  sourceRef:
    kind: OCIRepository
    name: podinfo
```

##### 4. 提交业务代码

+ 获取代码

```shell
git clone https://github.com/kcl-lang/flask-demo.git/
cd flask-demo
```

flask-demo 仓库提交代码后，Github 会自动构建容器镜像，并将制品推送到 Docker hub 中，会再触发 flask-demo-kcl-manifests 仓库的 Action，[通过 KCL 自动化 API](/docs/user_docs/guides/automation) 修改部署清单仓库中的镜像地址。现在让我们为 flask-demo 仓库创建一个提交，我们可以看到代码提交后触发业务仓库 Github CI 流程

![](/img/docs/user_docs/guides/ci-integration/app-ci.png)

##### 5. 配置自动更新

当业务仓库 Github CI 流程执行完成后，会自动在存放 KCL 资源配置的仓库触发一个 CI 自动更新配置并提交到 flask-demo-kcl-manifests main 分支，commit 信息如下

![](/img/docs/user_docs/guides/ci-integration/image-auto-update.png)

- 我们可以获得部署清单源码进行编译验证

```shell
git clone https://github.com/kcl-lang/flask-demo-kcl-manifests.git/
cd flask-demo-kcl-manifests
git checkout main && git pull && kcl
```

输出 YAML 为

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

从上述配置可以看出资源的镜像确实自动更新为了新构建的镜像内容。同时 Flux KCL Controller 会自动拉取配置并更新到集群，这样就实现了业务代码提交并部署 Kubernetes 的 e2e 完整自动化流程，每次只需提交业务代码即可，当然可以进一步搭配 Flagger 实现多种部署策略如金丝雀发布、蓝绿发布等。

## 其他资源

❤️ 感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会发布更多 KCL 云原生模型和工具集成文章，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
