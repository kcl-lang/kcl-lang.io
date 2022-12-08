---
sidebar_position: 3
---

# KCL 语言速览

KCL(Kusion Configuration Language)是 Kusion 内置的面相云原生领域配置策略语言。KCL 设计之初受 Python3 启发，同时吸收了声明式、OOP 编程范式的理念设计等设计，是一种专用于配置策略定义、校验的静态强类型的面相配置和策略场景的语言。本节我们将快速展示 KCL 语言的基本特性。

## 1. Hello KCL

学习新语言的最佳途径是自己亲手写几个小程序，配置语言也是如此。KCL 作为一种配置策略语言，我们可以像写配置一样写 KCL 程序。

下面是一个简单的 `hello.k` 程序：

```python
hello = "KCL"
```

将 `hello` 属性设置为 `"KCL"` 字符串。然后将代码保存到 `hello.k` 文件中。

如何执行这个程序取决于具体的开发环境，我们先假设本地的 macOS 或者是 Linux 系统已经安装了 `kcl` 命令（或者通过 `docker run --rm -it kusionstack/kusion bash` 进入 Docker 环境测试）。然后在文件所在的目录命令行输入以下命令执行：

```shell
$ kcl hello.k
hello: KCL
```

命令行执行的效果如图所示：

![](/img/docs/user_docs/getting-started/hello.gif)

输出的是 YAML 格式的配置数据。这个程序虽然简单，但是我们可以通过执行 KCL 配置程序到输出结果验证了开发环境和 `kcl` 命令行的基本用法。

## 2. 再复杂一点的配置

常见的配置数据除了的普通的 key-value 对，还有嵌套的字典和列表类型，同时 value 基础类型除了字符串还有布尔和数值等类型。下面是更为复杂一点的 `server.k` 配置：

```python
# This is a KCL document

title = "KCL Example"

owner = {
    name = "The KCL Authors"
    data = "2020-01-02T03:04:05"
}

database = {
    enabled = True
    ports = [8000, 8001, 8002]
    data = [["delta", "phi"], [3.14]]
    temp_targets = {cpu = 79.5, case = 72.0}
}

servers = [
    {ip = "10.0.0.1", role = "frontend"}
    {ip = "10.0.0.2", role = "backend"}
]
```

其中 `#` 开头的表示行注释。`owner` 的 value 是一个字典，字典的面值通过 `{}` 方式包含的内容，字典内部的 key-value 和 `hello = "KCL"` 例子的写法类似。`database` 则是另一个字典，其中字典属性的 value 出现了布尔 `True`、列表 `[]` 和 `{}` 字典，其中列表和字典中还出现了数值类型的 value。 最后一个 `servers` 属性则是一个列表，列表内部嵌套着字典（字典和列表以及后续将要讲到的 `schema` 都可以相互嵌套）。

该配置输出的 YAML 结果如下：

```yaml
$ kcl server.k 
title: KCL Example
owner:
  name: The KCL Authors
  data: '2020-01-02T03:04:05'
database:
  enabled: true
  ports:
  - 8000
  - 8001
  - 8002
  data:
  - - delta
    - phi
  - - 3.14
  temp_targets:
    cpu: 79.5
    case: 72.0
servers:
- ip: 10.0.0.1
  role: frontend
- ip: 10.0.0.2
  role: backend
```

## 3. schema 定义配置的结构

KCL 通过 `schema` 语法结构为有着固定属性结构和默认值行为的属性提供抽象支持。

比如上面例子的中 `database` 的配置一般是用默认值即可。这样我们可以通过为数据库的默认配置定义一个结构：

```python
schema DatabaseConfig:
    enabled: bool = True
    ports: [int] = [8000, 8001, 8002]
    data: [[str|float]] = [["delta", "phi"], [3.14]]
    temp_targets: {str: float} = {cpu = 79.5, case = 72.0}
```

`enabled` 是布尔类型；`ports` 为整数列表类型；`data` 为列表的列表，内层的列表元素是字符串或者浮点数类型；`temp_targets` 则是一个字典类型，字典的属性值是浮点数类型。并且 `DatabaseConfig` 的每个属性都定义了默认值。

然后通过 `database = DatabaseConfig {}` 就可以产生和默认值相同属性的结构。用户也可以修改默认值：

```python
database = DatabaseConfig {
    ports = [2020, 2021]
}
```

`schema DatabaseConfig` 不仅仅为属性提供了默认值，还为属性添加了类型信息。因此，如果用户不小心写错属性值类型的话，KCL 将会给出友好的错误提示，比如下面的例子将 `ports` 错误地写成了浮点数类型：

```python
database = DatabaseConfig {
    ports = [1.2, 1.3]
}
```

执行时将产生类似以下的错误（显示的文件路径和本地环境有关）：

```shell
$ kcl server.k 
KCL Compile Error[E2G22] : The type got is inconsistent with the type expected
    ---> File /path/to/server.k:8:2
    8 |    ports = [1.2, 1.3]
      5    ^  -> got [float(1.2)|float(1.3)]
    ---> File /path/to/server.k:3:2
    3 |    ports: [int] = [8000, 8001, 8002]
      5    ~  -> expect [int]
expect [int], got [float(1.2)|float(1.3)]
```

类似地我们可以用以下的代码封装 `servers` 部分的属性：

```python
schema ServerConfig:
    ip: str
    role: "frontend" | "backend"

servers = [
    ServerConfig {ip = "10.0.0.1", role = "frontend"}
    ServerConfig {ip = "10.0.0.2", role = "backend"}
]
```

其中 `ServerConfig` 的 `ip` 是字符串类型，并没有给出默认值。用户在生成 `ServerConfig` 类型的属性时必须手工添加 `ip` 属性的值，否则 KCL 将会报出缺少必填属性的错误。`role` 属性是 `"frontend" | "backend"` 枚举字符串类型。

此外，`schema` 还可以结合 `check`、`mixin`、可选属性、继承和扩展模块实现更为复杂的配置和策略数据的抽象，细节可以参考手册部分的文档。
