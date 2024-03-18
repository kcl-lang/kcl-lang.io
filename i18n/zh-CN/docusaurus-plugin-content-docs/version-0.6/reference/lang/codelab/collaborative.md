---
title: "使用配置操作分块编写配置"
linkTitle: "使用配置操作分块编写配置"
type: "docs"
weight: 2
description: 使用配置操作分块编写配置
sidebar_position: 3
---

## 1. Introduction

KCL 是一种简单易用的配置语言，用户可以简单地编写可重复使用的配置代码。

在这个教程中，我们将学习如何使用 KCL 配置操作（config operation）功能以协同的方式编写配置。

### 本节将会学习

1. 定义 schema 并组织项目目录。
2. 通过KCL的配置操作功能创建多个环境配置。
3. 配置编译参数和测试。

## 2. 定义 Schema 和 组织项目目录

### Schema 定义

假设我们想定义具有某些属性的服务器配置，我们可以通过创建一个 `server.k` 文件来创建一个简单的配置，我们可以填写以下代码来定义服务器配置的可重用模式：

```python
import units

type Unit = units.NumberMultiplier

schema Server:
    replicas: int = 1
    image: str
    resource: Resource = {}
    mainContainer: Main = {}
    labels?: {str:str}
    annotations?: {str:str}

schema Main:
    name: str = "main"
    command?: [str]
    args?: [str]
    ports?: [Port]

schema Resource:
    cpu?: int = 1
    memory?: Unit = 1024Mi
    disk?: Unit = 10Gi

schema Port:
    name?: str
    protocol: "HTTP" | "TCP"
    port: 80 | 443
    targetPort: int

    check:
        targetPort > 1024, "targetPort must be larger than 1024"
```

在上面的代码中，我们定义了一个名为 Server 的 schema，该 schema 表示用户将要编写的配置类型，其中包含一些基本类型属性（例如`replicas`、`image` 等）和一些复合类型属性（例如 `resource`、`main` 等）。除了一些在 [schema codelab](./schema.md)中提到的基本类型之外，我们可以看到上面的代码中有两种类型 `Unit` 和 `units.NumberMultiplier`。其中，`units.NumberMultiplier` 表示 KCL 数字单位类型，意味着可以在 KCL 数字后添加自然单位或二进制单位，例如 `1K` 表示 `1000`，`1Ki` 表示 `1024`。 `Unit` 是 `units.NumberMultiplier` 的类型别名，用于简化类型注释的编写。

### 项目目录

为了完成协同的配置的开发，我们首先需要一个配置项目，其中包含测试应用程序的配置以及不同环境的差异化配置，因此我们正在创建以下项目目录：

```
.
├── appops
│   └── test_app
│       ├── base
│       │   └── base.k
│       ├── dev
│       │   ├── ci-test
│       │   │   └── stdout.golden.yaml
│       │   ├── kcl.yaml
│       │   └── main.k
│       └── prod
│           ├── ci-test
│           │   └── stdout.golden.yaml
│           ├── kcl.yaml
│           └── main.k
├── kcl.mod
└── pkg
    └── sever.k
```

该项目目录主要包含三个部分：

- `kcl.mod`：用于标识KCL项目的根目录的文件。
- `pkg`：不同应用程序配置所共用的 `Server Schema` 结构。
- `appops`：不同应用程序的 Server 配置，目前仅包含一个名为 `test_app` 的应用程序。
  - `base`：供所有环境使用的应用程序通用配置。
  - `dev`：供开发环境使用的应用程序配置。
  - `prod`：供生产环境使用的应用程序配置。

后续章节将会介绍`base.k`、`main.k`、`kcl.yaml` 和 `ci-test/stdout.golden.yaml` 的含义。

## 3. 通过 KCL 配置操作功能创建多个环境配置

### 创建基线配置

在组织好项目目录和基本的服务器配置模型之后，我们可以编写用户应用程序的配置。我们可以创建自己的测试应用程序文件夹 `test_app`，并将其放置在应用程序配置文件夹 `appops` 中。

对于应用程序的配置，我们通常将其分为基本配置和多个环境的差异化配置并进行合并。通过 KCL 的配置合并功能，我们可以轻松实现这一点。假设我们有开发环境和生产环境的两个配置，我们可以创建三个文件夹：`base`、`dev` 和 `prod` 分别存储基线、开发环境和生产环境的配置。首先，我们编写 `base/base.k` 的配置：

```python
import pkg

server: pkg.Server {
    # 设置镜像的值为 "nginx:1.14.2"
    image = "nginx:1.14.2"
    # 添加 app label
    labels.app = "test_app"
    # 添加一个mainContainer配置，它的端口是 [{protocol = "HTTP", port = 80, targetPort = 1100}]
    mainContainer.ports = [{
        protocol = "HTTP"
        port = 80
        targetPort = 1100
    }]
}
```

正如上述代码中所示，我们使用 `import` 关键字在 `base.k` 中导入放置在 `pkg` 下的 `Server` schema，并使用它实例化一个名为`server` 的配置，在其中将 `image` 属性设置为 `"nginx:1.14.2"`，并添加一个带有值为 `test_app` 的标签 `app`。此外，我们还在 `ports` 属性中添加了主容器 `mainContainer` 的配置，其值为 `[{protocol = "HTTP", port = 80, targetPort = 1100}]`。

KCL 命令:

```bash
kcl appops/test_app/base/base.k
```

输出:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
```

当前，我们已经有了一个基线配置。

### 创建多重环境配置

接下来我们将配置一个差异化的多环境配置。首先假设我们想在开发环境中使用自己的临时镜像 `nginx:1.14.2-dev`，然后使用它来覆盖基准中的服务器配置，我们可以在 `dev/main.k` 中编写以下配置：

```python
import pkg

server: pkg.Server {
    # 覆盖 base 配置中的声明的镜像
    image = "nginx:1.14.2-dev"
}
```

KCL 命令:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

输出:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
```

可以看出输出的 YAML 文件的 `image` 字段被覆盖为 `nginx:1.14.2-dev`。假设我们还想将一个具有键为 `env`，值为 `dev` 的标签添加到 `dev` 环境中，我们将以下代码添加到 `dev/main.k` 中：

```python
import pkg

server: pkg.Server {
    # 覆盖 base 配置中的声明的镜像
    image = "nginx:1.14.2-dev"
    # 将新标签 env 合并到 base 标签中
    labels.env = "dev"
}
```

KCL 命令:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
    env: dev
```

可以看到输出的 YAML 文件的 `labels` 字段中有两个标签。

此外，我们还可以使用 `+=` 运算符将新值添加到列表类型属性中，例如在基准环境中的 `mainContainer.ports` 配置，继续修改 `dev/main.k` 中的代码：

```python
import pkg

server: pkg.Server {
    # 覆盖 base 配置中的声明的镜像
    image = "nginx:1.14.2-dev"
    # 将新标签 env 合并到 base 标签中
    labels.env = "dev"
    # 在 base ports配置中添加一个 port
    mainContainer.ports += [{
        protocol = "TCP"
        port = 443
        targetPort = 1100
    }]
}
```

KCL 命令:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

输出:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
      - protocol: TCP
        port: 443
        targetPort: 1100
  labels:
    app: test_app
    env: dev
```

使用相同的方法，我们可以构建生产配置，在 `dev/main.k` 文件中编写代码，并为其添加标签。

```python
import pkg

server: pkg.Server {
    # 将新标签 env 合并到 base 标签中
    labels.env = "prod"
}
```

KCL 命令:

```bash
kcl appops/test_app/base/base.k appops/test_app/prod/main.k
```

输出:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
    env: prod
```

## 4. 配置编译参数和测试

在前面的章节中，我们通过代码构建了一个多环境配置。可以看出不同环境的 KCL 命令行编译参数相似，因此我们可以将这些编译参数配置到一个文件中，并将其输入到 KCL 命令行中进行调用。请将以下代码配置在 `dev/kcl.yaml`中：

```yaml
kcl_cli_configs:
  files:
    - ../base/base.k
    - main.k
  output: ./ci-test/stdout.golden.yaml
```

然后我们可以使用以下命令在开发环境中编译配置：

```bash
cd appops/test_app/dev && kcl -Y ./kcl.yaml
```

此外，我们已经在 `dev/kcl.yaml` 中配置了 `output` 字段，以将 YAML 输出到文件，以便进行后续配置分发或测试。您可以通过遍历每个环境中的 `kcl.yaml` 构建，并将其与 `./ci-test/stdout.golden.yaml` 进行比较，可以验证应用程序的配置是否符合预期。

## 5. 最后

恭喜！

我们已经完成了关于 KCL 的第三课。
