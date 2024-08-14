---
title: "模型定义"
sidebar_position: 3
---

## 简介

KCL 的核心场景是写配置和校验，因此 KCL 被设计之初的一个核心特性就是**建模**，对应到 KCL 的关键字 `schema`，`schema` 可以被用于定义结构和约束，比如字段的类型，默认值，字段的范围和各种其他约束等内容。此外，使用 KCL schema 定义的结构可以反过来用于验证实现、验证输入（JSON、YAML 等结构化数据）或生成代码（生成多语言结构体、OpenAPI 等）。

## 使用 KCL 定义结构和约束

### 0. 先决条件

- 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

### 1. 获得示例

```shell
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/definition
```

我们可以执行如下命令显示配置

```bash
cat main.k
```

输出为

```python
import .app_module  # A relative path import

app: app_module.App {
    domainType = "Standard"
    containerPort = 80
    volumes = [
        {
            mountPath = "/tmp"
        }
    ]
    services = [
        {
            clusterIP = "None"
            $type = "ClusterIP"
        }
    ]
}
```

我们将 `App` 模型放入单独的 `app_module.k` 中，在需要时我们可以在 `main.k` 中使用 `import` 关键字进行模块化管理，比如下面的文件结构

```
.
├── app_module.k
└── main.k
```

其中 `app_module.k` 的内容为

```python
schema App:
    domainType: "Standard" | "Customized" | "Global"
    containerPort: int
    volumes: [Volume]
    services: [Service]

    check:
        1 <= containerPort <= 65535

schema Service:
    clusterIP: str
    $type: str

    check:
        clusterIP == "None" if $type == "ClusterIP"

schema Volume:
    container: str = "*"  # `container` 的默认值为 "*"
    mountPath: str

    check:
        mountPath not in ["/", "/boot", "/home", "dev", "/etc", "/root"]
```

在上面的文件中。在其中，我们使用 `schema` 关键字定义了三个模型 `App`，`Service` 和 `Volume`。并且 `App` 模型具有四个属性 `domainType`, `containerPort`, `volumes` 和 `services`，其中

- `domainType` 的类型为字符串字面值联合类型，与“枚举”类似，这表明 `domainType` 的值只能取 `"Standard"`, `"Customized"` 和 `"Global"` 中的一个
- `containerPort` 的类型为整数 `int`, 此外我们使用 `check` 关键字定义了其取值范围 1 ~ 65535
- `services` 的类型为 `Service` 列表类型，`Service`，并且我们用 `?` 标记了它是一个可选属性，这意味着我们可以不为其赋值。
- `volumes` 的类型为 `Volume` 列表类型，并且我们用 `?` 标记了它是一个可选属性，这意味着我们可以不为其赋值。

### 2. 输出配置

我们可以使用如下命令行可以获得 `app` 实例的 YAML 输出

```shell
kcl main.k
```

输出为

```yaml
app:
  domainType: Standard
  containerPort: 80
  volumes:
    - container: "*"
      mountPath: /tmp
  services:
    - clusterIP: None
      type: ClusterIP
```

## 小结

KCL 是一种用于定义配置和约束的语言，其核心功能是使用 schema 关键字进行建模，schema 允许定义具有属性、默认值、范围检查和其他约束的结构。使用 KCL schema 定义的结构可以用于验数据或生成代码。该文档演示了如何使用 schema 定义模型，使用 import 导入模型进行模块化管理，并使用 kcl 命令输出已定义结构实例的 YAML 配置。
