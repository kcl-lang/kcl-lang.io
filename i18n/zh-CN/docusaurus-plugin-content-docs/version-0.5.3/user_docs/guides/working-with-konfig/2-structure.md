---
id: structure
sidebar_label: 工程结构
---
# Konfig 工程结构

本文主要解释 Konfig 配置大库的目录和代码结构

## 整体结构

```bash
.
├── .github             # CI 脚本
├── Makefile            # 通过 Makefile 封装常用命令
├── README.md           # 配置大库说明
├── appops              # 应用运维目录，用来放置所有应用的 KCL 运维配置
│   ├── clickhouse-operator
│   ├── code-city
│   ├── guestbook
│   ├── http-echo
│   └── nginx-example
├── base                # 模型库
│   ├── examples        # 样例代码
│   │   ├── monitoring  # 监控配置样例
│   │   ├── native      # Kubernetes 资源配置样例
│   │   ├── provider    # 基础资源配置样例
│   │   └── server      # 云原生应用运维配置模型样例
│   └── pkg
│       ├── kusion_kubernetes   # Kubernetes 底层模型库
│       ├── kusion_models       # 核心模型库
│       ├── kusion_prometheus   # Prometheus 底层模型库
│       └── kusion_provider     # 基础资源 底层模型库
└── kcl.mod             # 大库配置文件，通常用来标识大库根目录位置以及大库所需依赖
```

## 核心模型库结构

核心模型库一般命名为 kusion_models，主要包含前端模型、后端模型、Mixin、渲染器等，目录结构为：

```bash
├── commons         # 基础资源核心模型库
├── kube            # 云原生资源核心模型库
│   ├── backend         # 后端模型
│   ├── frontend        # 前端模型
│   │   ├── common          # 通用前端模型
│   │   ├── configmap       # ConfigMap 前端模型
│   │   ├── container       # 容器前端模型
│   │   ├── ingress         # Ingress 前端模型
│   │   ├── resource        # 资源规格前端模型
│   │   ├── secret          # Secret 前端模型
│   │   ├── service         # Service 前端模型
│   │   ├── sidecar         # Sidecar 容器前端模型
│   │   ├── strategy        # 策略前端模型
│   │   ├── volume          # Volume 前端模型
│   │   └── server.k        # 云原生应用运维前端模型
│   ├── metadata        # 应用运维的元数据模型
│   ├── mixins          # 统一放置可复用的 Mixin
│   ├── render          # 渲染器，把前后端模型联系在一起的桥梁
│   ├── templates       # 静态配置
│   └── utils           # 工具方法
└── metadata        # 通用元数据模型
```

## Project 和 Stack 结构

![](/img/docs/user_docs/concepts/project-stack.png)

Project 和 Stack 是用于组织 Konfig 的逻辑隔离概念。

### Project

任何包含文件 "project.yaml" 的文件夹都将被视为一个 Project，"project.yaml" 用于描述此 Project 的元数据，如 "name" 和 "tenant" 等。项目必须具有明确的业务语义，用户可以将应用程序或运维场景映射到项目。

### Stack

与Project一样，包含文件 "stack.yaml" 的任何文件夹都将被视为一个 Stack，"stack.yaml" 用于描述此 Stack 的元数据。Stack 是一组 KCL 文件，表示可以单独配置和部署的最小操作单元，它通常代表 CI/CD 过程中的不同阶段。

### Project 与 Stack 之间的关系

一个 Project 包含一个或多个 Stack，Stack 必须属于且只能属于一个 Project。用户可以根据自己的需要解释 Project 和 Stack 的含义，并灵活组织 Konfig 结构。根据我们的经验，我们提供以下示例作为最佳实践：

```bash
├── README.md       # Project 介绍文件
├── base            # 各环境通用配置
│   └── base.k      # 通用 KCL 配置
├── dev             # 环境特有配置
│   ├── ci-test     # 测试目录
│   │   ├── settings.yaml       # 测试数据
│   │   └── stdout.golden.yaml  # 测试期望结果
│   ├── kcl.yaml    # 多文件编译配置，是 KCL 编译的入口
│   ├── main.k      # 当前环境 KCL 配置
│   └── stack.yaml  # Stack 配置文件
└── project.yaml    # Project 配置文件
```

Project 通常表示一个应用程序，Stack 表示该应用程序的不同环境的配置，例如 dev、pre 和 prod 等。通用配置可以存储在该 Project 下的 "base" 目录中。
