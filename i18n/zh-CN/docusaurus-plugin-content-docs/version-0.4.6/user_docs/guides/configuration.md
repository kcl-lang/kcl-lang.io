---
title: "配置"
sidebar_position: 1
---

## 简介

配置是软件系统的一个重要方面，由于不断发展的业务需求、基础设施需求和其他因素，这些系统会不断发生变化。通常，快速改变这些系统的行为可能具有挑战性，尤其是当这样做需要昂贵且耗时的重建和重新部署过程时。在这种情况下，仅仅对业务代码进行更改可能是不够的。幸运的是，配置提供了一种低开销的方式来修改系统功能。

我们可以根据需要将静态配置存储在 JSON 或 YAML 等文件中。此外，配置也可以存储在高级语言中，从而实现更灵活的配置。这种语言可以进行编码、呈现和静态配置。KCL 是一种提供此类功能的配置语言。开发人员可以编写 KCL 代码来生成JSON/YAML 和其他配置。

## 使用 KCL 编写配置代码

KCL 的核心特性是其**建模**和**约束**能力，KCL 核心功能基本围绕 KCL 这个两个核心特性展开，对于代码而言（包括配置代码）都存在对配置数据约束的需求，比如类型约束、配置字段必选/可选约束、范围约束、不可变性约束等，这也是 KCL 致力于解决的核心问题之一。

现在我们已经了解了 KCL 的基本功能，让我们探索如何使用它来生成配置。

### 1. 获取示例

首先，执行如下命令获取示例

```shell
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/configuration
```

我们可以执行如下命令显示配置代码

```shell
cat nginx.k
```

输出为:

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

### 2. 使用 KCL 生成 YAML

执行如下命令:

```bash
kcl nginx.k
```

我们可以获得如下 YAML 输出

```yaml
nginx:
  http:
    server:
      listen: 80
      location:
        root: /var/www/html
        index: index.html
```

### 3. 为配置添加动态参数

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

## 小结

通过使用KCL，我们可以生成更低低级别的数据配置。此外啊，我们通过 `-D` 标志设置动态参数以满足不同的场景需求。有关更多 KCL 的功能和教程，请参阅[此处](/docs/reference/lang/tour)。
