---
title: "自动化"
sidebar_position: 6
---

在 KCL 中提供了很多自动化相关的能力，主要包括工具和多语言 API。 通过 `package_identifier : key_identifier`的模式支持对任意配置键值的索引，从而完成对任意键值的增删改查。比如下图所示修改某个应用配置的镜像内容，可以直接执行如下指令修改镜像，修改前后的 diff 如下图所示。

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

此外，KCL 的自动化能力也可以被集成到 CI/CD 中。

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

KCL 允许使用通过 CLI `-O|--overrides` 参数修改配置模型中的值，这个参数通常由三个部分组成: 包名 `pkg`, 配置标识符 `identifier`, 配置属性 `attribute` 和覆盖值 `override_value`

```bash
kcl main.k -O override_spec
```

- `override_spec`: 表示需要修改的配置模型字段和值的统一表示

```
override_spec: [[pkgpath] ":"] identifier ("=" value | "-")
```

- `pkgpath`: 表示需要修改标识符的包路径，通常为 `a.b.c` 的形式，对于 main 包，`pkgpath` 表示为 `__main__`, 可省略，省略不写时表示 main 包
- `identifier`: 表示需要修改配置的标识符，通常为 `a.b.c` 的形式
- `value`: 表示需要修改配置的值，可以是任意合法的 KCL 表达式，比如数字/字符串字面值，list/dict/schema 表达式等
- `=`: 表示修改identifier的值
  - 当 identifier 存在时，修改已有 identifier的值为 value
  - 当 identifier 不存在时，添加 identifier属性，并将其值设置为 value
- `-`: 表示删除 identifier属性
  - 当 identifier 存在时，直接进行删除
  - 当 identifier 不存在时，对配置不作任何修改

请注意，当 `identifier` 出现多次时，修改/删除全部 `identifier` 的值

此外，在 KCL 中还提供了 API 用于变量查询和修改，详见 [API 文档](/docs/reference/xlang-api/)

## 示例

### 修改示例

KCL 代码：

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

执行如下命令

```bash
kcl main.k -O :person.name=\"Bob\" -O :person.age=10
```

输出结果为：

```yaml
person:
  name: Bob
  age: 10
```

此外，当我们使用 KCL CLI `-d` 参数时，KCL 文件将同时修改为以下内容

```bash
kcl main.k -O :person.name=\"Bob\" -O :person.age=10 -d
```

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Bob"
    age = 10
}
```

另外一个更复杂的例子

```python
schema Person:
    name: str
    age: int
    ids?: [int]

person = Person {
    name = "Alice"
    age = 10
}
```

执行如下命令

```bash
kcl main.k -O :person.ids=\[1,2\]
```

输出为

```yaml
person:
  name: Alice
  age: 10
  ids:
  - 1
  - 2
```

### 删除示例

KCL 代码：

```python
schema Config:
    x?: int = 1
    y?: str = "s"
    
config = Config {
    x = 2
}
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

### API

此外，我们还可以通过[多语言 API](/docs/reference/xlang-api/overview) 自动修改配置属性

以下面的 KCL 代码片段 (命名为 main.k) 和 RestAPI 为例

```python
import regex

schema AppConfig:
    image: str

    check:
        regex.match(image, r"^([a-z0-9\.\:]+)\.([a-z]+)\:([a-z0-9]+)\/([a-z0-9\.]+)\/([a-z0-9-_.:]+)$"), "image name should satisfy the \`REPOSITORY:TAG\` form"

appConfig = AppConfig {
    image = "nginx:1.13.9"
}
```

执行如下命令启动 RestAPI 服务端

```bash
python3 -m pip install kclvm -U
python3 -m gunicorn "kclvm.program.rpc-server.__main__:create_app()" -t 120 -w 4 -k uvicorn.workers.UvicornWorker -b :2021
```

通过如下命令 POST 命令请求配置修改服务

```bash
curl -X POST http://127.0.0.1:2021/api:protorpc/KclvmService.OverrideFile -H 'content-type: accept/json' -d '{
    "file": "main.k",
    "specs": ["appConfig.image=\"nginx:1.14.0\""]
}'
```

服务调用完成后，main.k 会被修改为如下形式:

```python
import regex

schema AppConfig:
    image: str

    check:
        regex.match(image, r"^([a-z0-9\.\:]+)\.([a-z]+)\:([a-z0-9]+)\/([a-z0-9\.]+)\/([a-z0-9-_.:]+)$"), "image name should satisfy the \`REPOSITORY:TAG\` form"

appConfig = AppConfig {
    image = "nginx:1.14.0"
}
```
