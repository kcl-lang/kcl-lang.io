---
title: "自动化"
sidebar_position: 6
---

## 简介

在 KCL 中提供了很多自动化相关的能力，主要包括工具和多语言 API。 通过 `package_identifier : key_identifier`的模式支持对任意配置键值的索引，从而完成对任意键值的增删改查。比如下图所示修改某个应用配置的镜像内容，可以直接执行如下指令修改镜像，修改前后的 diff 如下图所示。

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

此外，KCL 的自动化能力也可以被集成到 CI/CD 中。

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

## 使用 KCL 进行自动化

### 0. 先决条件

- 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

### 1. 获得示例

```bash
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/automation
```

我们可以执行如下命令显示配置

```bash
cat main.k
```

输出为

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "app"
    replicas = 1
    labels.key = "value"
}
```

我们可以执行如下命令输出配置

```bash
kcl main.k
```

输出为

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
    key: value
```

### 2. 使用 KCL CLI 进行自动化

KCL 允许使用通过 CLI `-O|--overrides` 参数修改配置模型中的值，这个参数通常由三个部分组成: 包名 `pkg`, 配置标识符 `identifier`, 配置属性 `attribute` 和覆盖值 `override_value`

```bash
kcl main.k -O override_spec
```

- `override_spec`: 表示需要修改的配置模型字段和值的统一表示

```bash
override_spec: [[pkgpath] ":"] identifier ("=" value | "-")
```

- `pkgpath`: 表示需要修改标识符的包路径，通常为 `a.b.c` 的形式，对于 main 包，`pkgpath` 表示为 `__main__`, 可省略，省略不写时表示 main 包
- `identifier`: 表示需要修改配置的标识符，通常为 `a.b.c` 的形式
- `value`: 表示需要修改配置的值，可以是任意合法的 KCL 表达式，比如数字/字符串字面值，`list`/`dict`/`schema` 表达式等
- `=`: 表示修改identifier的值
- `-`: 表示删除 identifier 属性

请注意，当 `identifier` 多次出现时，修改/删除全部 `identifier` 的值

#### 修改配置

执行如下命令可以更新应用名称:

```bash
kcl main.k -O app.name='new_app'
```

输出为

```yaml
app:
  name: new_app
  replicas: 1
  labels:
    app: new_app
    key: value
```

可以看出 `app` 的 `name` 属性的值被修改为了 `new_app`

此外，当我们使用 KCL CLI `-d` 参数时，KCL 文件将同时修改为以下内容

```bash
kcl main.k -O app.name='new_app' -d
```

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "new_app"
    replicas = 1
    labels: {key = "value"}
}
```

#### 删除配置

执行如下命令可以删除 `labels` 中的 `key` 字段

```bash
kcl main.k -O app.labels.key-
```

输出为:

```yaml
app:
  name: app
  replicas: 1
  labels:
    app: app
```

执行如下命令

```bash
kcl main.k -O config.x-
```

输出结果为：

```yaml
config:
  x: 1
  y: s
```

### 3. 使用 KCL API 进行自动化

此外，我们还可以通过[多语言 API](/docs/reference/xlang-api/overview) 自动修改配置属性

以 RestAPI 为例

执行如下命令启动 RestAPI 服务端

```bash
python3 -m pip install kclvm -U
python3 -m gunicorn "kclvm.program.rpc-server.__main__:create_app()" -t 120 -w 4 -k uvicorn.workers.UvicornWorker -b :2021
```

通过如下命令 POST 命令请求配置修改服务

```bash
curl -X POST http://127.0.0.1:2021/api:protorpc/KclvmService.OverrideFile -H 'content-type: accept/json' -d '{
    "file": "main.k",
    "specs": ["app.name=\"nginx\""]
}'
```

服务调用完成后，`main.k` 会被修改为如下形式:

```python
schema App:
    """The application model."""
    name: str
    replicas: int
    labels?: {str:str} = {app = name}

app: App {
    name = "nginx"
    replicas = 1
    labels: {
        "key" = "value"
    }
}
```

## 小结

该文档介绍了KCL的自动化功能，包括工具和多语言 API。它支持对任何配置的键值进行索引，允许添加、删除、修改和查询任何键值。它也可以集成到 CI/CD 中。本文档提供了一个使用 KCL 自动化配置管理的示例，包括使用 KCL CLI/API 覆盖和删除配置。更多信息请参阅[此处](/docs/reference/lang/tour#KCL-cli-variable-Override)。
