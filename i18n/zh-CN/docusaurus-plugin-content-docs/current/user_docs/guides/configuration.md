---
title: "配置"
sidebar_position: 1
---

## 使用 KCL 编写配置代码

KCL 的核心特性是其**建模**和**约束**能力，KCL 核心功能基本围绕 KCL 这个两个核心特性展开，此外 KCL 遵循以用户为中心的配置理念而设计其核心特性，可以从两个方面理解：

- **以领域模型为中心的配置视图**：借助 KCL 语言丰富的特性及 [KCL OpenAPI](https://kcl-lang.io/docs/tools/cli/openapi/) 等工具，可以将社区中广泛的、设计良好的模型直接集成到 KCL 中（比如 K8s 资源模型），用户也可以根据自己的业务场景设计、实现自己的 KCL 模型 (库) ，形成一整套领域模型架构交由其他配置终端用户使用。
- **以终端用户为中心的配置视图**：借助 KCL 的代码封装、抽象和复用能力，可以对模型架构进行进一步抽象和简化（比如将 K8s 资源模型抽象为以应用为核心的 Server 模型），做到**最小化终端用户配置输入**，简化用户的配置界面，方便手动或者使用自动化 API 对其进行修改。

不论是以何为中心的配置视图，对于代码而言（包括配置代码）都存在对配置数据约束的需求，比如类型约束、配置字段必选/可选约束、范围约束、不可变性约束等，这也是 KCL 致力于解决的核心问题之一。

我们可以编写一个名为 `main.k` 的 KCL 配置文件

```python
schema Person:
    gender: "Male" | "Female"
    name: Name

schema Name:
    first: str
    middle?: str  # 可选，但指定时必须非空 
    last: str

    check:
        first != ""
        last != ""
        middle != ""

alice = Person {
    # gender: "Female" # Error: 属性拼写错误 
    gender: "Female"
    name.first: "Alice"
    name.last: "White"
}
```

执行命令

```bash
kcl main.k
```

我们可以通过代码化的方式得到了一个 YAML 配置文件输出，这即是 KCL 的基本使用方式。

```yaml
alice:
  gender: Female
  name:
    first: Alice
    last: White
```

另一个 KCL 例子 (`nginx.k`)

```python
schema Nginx:
    """Schema for Nginx configuration files"""
    http: Http

schema Http:
    server: Server

schema Server:
    listen: int | str    # The attribute `listen` can be int type or a string type.
    location?: Location  # Optional, but must be non-empty when specified

schema Location:
    root: str
    index: str

nginx = Nginx {
    http.server = {
        listen = 80
        location = {
            root = "/var/www/html"
            index = "index.html"
        }
    }
}
```

执行命令

```bash
kcl nginx.k
```

我们可以得到如下 YAML 输出

```yaml
nginx:
  http:
    server:
      listen: 80
      location:
        root: /var/www/html
        index: index.html
```

此外，我们可以通过 KCL 内置函数 `option` 动态接收外部参数。例如，对于下面的 KCL 文件（db.k），我们可以使用命令行 `-D` 标志来接收外部动态参数。

```python
env: str = option("env") or "dev"  # The attribute `env` has a default value "den"
database: str = option("database")
hosts = {
    dev = "postgres.dev"
    stage = "postgres.stage"
    prod = "postgres.prod"
}
dbConfig = {
    host = hosts[env]
    database = database
    port = "2023"
    conn = "postgres://${host}:${port}/${database}"
}
```

```bash
# Use the `-D` flag to input external parameters.
$ kcl db.k -D database="foo"
env: dev
database: foo
hosts:
  dev: postgres.dev
  stage: postgres.stage
  prod: postgres.prod
dbConfig:
  host: postgres.dev
  database: foo
  port: "2023"
  conn: "postgres://postgres.dev:2023/foo"
```
