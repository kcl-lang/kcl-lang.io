---
title: "使用 KCL 编写简单配置"
linkTitle: "使用 KCL 编写简单配置"
type: "docs"
weight: 2
description: 使用 KCL 编写简单配置
sidebar_position: 1
---
## 1. 介绍

KCL（Kusion Configuration Language）是一种简单易用的配置语言，用户可以简单地编写可重用的配置代码。

在这个第一个教程中，我们将学习如何使用 KCL 编写一个简单的配置。

学习这个代码实验只需要基本的编程知识，如果你有 Python 经验，将会更容易上手。

### 本节将会学习

1. 用一种可编程的方式编写简单的 key-value 配置
2. 使用 KCL 编写简单的逻辑
3. 使用 KCL 编写集合（collections）
4. 使用 KCL 代码进行测试和调试
5. 在 KCL 代码中使用内置（built-in）支持
6. 共享和重用 KCL 代码
7. 使用动态输入参数编写配置

## 2. 编写Key-Value键值对

通过创建 `my_config.k` 来生成一个简单的配置，我们可以填充下面的代码，并且不需要严格的格式描述部署的配置。

```python
cpu = 256
memory = 512
image = "nginx:1.14.2"
service = "my-service"
```

在上述代码中，cpu 和 memory 被声明为 int 类型的值，而 image 和 service 被声明为字符串字面值。

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

KCL 命令:

```bash
kcl my_config.k
```

标准输出:

```yaml
cpu: 256
memory: 512
image: nginx:1.14.2
service: my-service
```

可导出变量（exported variable）默认情况下是不可变的，一旦声明，就不能在其他地方修改它。

## 3. 编写简单逻辑

有时候我们想在配置中编写一些逻辑，那么我们就可以使用:

- 以 `_` 开头的非导出可变变量（mutable and non-exported variable）
- if-else 语句

非导出变量表示它不会出现在输出的 YAML 中，且它可以被多次赋值。

这是一个示例，显示如何根据条件调整资源。

KCL 命令：

```python
kcl my_config.k
```

```python
_priority = 1 # 非导出可变变量
_cpu = 256 # 非导出可变变量

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

cpu = _cpu
memory = _cpu * 2
image = "nginx:1.14.2"
service = "my-service"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

```python
kcl my_config.k
```

标准输出：

```yaml
cpu: 256
memory: 512
image: nginx:1.14.2
service: my-service
```

.. 注意::
KCL 对运算符和字符串成员函数有丰富的支持，请阅读手册和规范以了解更多细节。

## 4. 编写集合

我们可以使用集合来表示复杂的数据类型。已支持的集合类型有:

- list
- dict

```python
_priority = 1  # 非导出可变变量
_cpu = 256  # 非导出可变变量

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

cpu = _cpu
memory = _cpu * 2
command = ["nginx"] # 列表
labels = {run = "my-nginx"} # a dict
image = "nginx:1.14.2"
service = "my-service"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

KCL 命令：

```bash
kcl my_config.k
```

标准输出：

```yaml
cpu: 512
memory: 1024
command:
    - nginx
labels:
    run: my-nginx
image: nginx:1.14.2
service: my-service
```

> 有关集合数据类型和成员函数的更多信息，请查阅手册和规范。

## 5. 在集合中添加元素

我们可以将逻辑表达式、推导式、切片、联合类型等特性组合起来，动态地将元素添加到集合中。

```python
_priority = 1 # 非导出可变变量
_cpu = 256 # 非导出可变变量
_env = "pre-prod"

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

cpu = _cpu
memory = _cpu * 2
_command = ["nginx"] # 列表
_command = _command + ["-f", "file"]  # 使用 + 运算符将元素附加到命令中以连接两个列表
command = [c.lower() for c in _command]  # # 将列表中的每个元素转为小写
_labels = {
    run = "my-nginx"
    if _env:
        env = _env  # 当 _env 不是 None/Undefined 或为空时使用 if 表达式添加一个字典键值对
} # 字典
labels = _labels
image = "nginx:1.14.2"
service = "my-service"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

```python
kcl my_config.k
```

标准输出：

```yaml
cpu: 256
memory: 512
command:
- nginx
- -f
- file
labels:
  run: my-nginx
image: nginx:1.14.2
service: my-service
```

## 6. 编写断言

为了使代码可测试且健壮，我们可以使用断言（assertions）验证配置数据。

```python
_priority = 1 # 非导出可变变量
_cpu = 256 # 非导出可变变量

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

cpu = _cpu
memory = _cpu * 2
command = ["nginx"] # 列表
labels = {run = "my-nginx"} # 字典
image = "nginx:1.14.2"
service = "my-service"
assert "env" in labels, "env label is a must"
assert cpu >= 256, "cpu cannot be less than 256"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

```bash
kcl my_config.k
```

标准错误输出:

```bash
Assertion failure: env label is a must.
```

将 env:pre-prod 对添加到标签中后，我们将得到如下输出：

```yaml
cpu: 512
memory: 1024
command:
    - nginx
labels:
    run: my-nginx
    env: pre-prod
image: nginx:1.14.2
service: my-service
```

## 7. 使用方便的内置支持

更重要的是，我们可以使用内置函数来帮助我们调试或简化编码。

```python
_priority = 1  # 非导出可变变量
_cpu = 256  # 非导出可变变量

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

_name = "nginx"
# exported variables
cpu = _cpu
memory = _cpu * 2
command = [_name] # 列表
labels = {
    run = "my-{}".format(_name)
    env = "pre-prod"
} # a dict
image = "{}:1.14.2".format(_name) # 字符串格式
service = "my-service"

# debugging
print(labels) # 通过打印调式

# test
assert len(labels) > 0, "labels can't be empty" # 使用 len() 得到列表长度
assert "env" in labels, "env label is a must"
assert cpu >= 256, "cpu cannot be less than 256"
```

此示例展示了我们如何使用 `format()`、`len()`、`print()` 函数来帮助自定义配置。

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

KCL 命令:

```bash
kcl my_config.k
```

标准输出:

```yaml
cpu: 512
memory: 1024
command:
    - nginx
labels:
    run: my-nginx
    env: pre-prod
image: nginx:1.14.2
service: my-service
run: my-nginx
env: pre-prod
```

注意：更多的内置函数和模块可以在 spec/module 目录中查看。

## 8. 重用另一个模块的变量

为了使我们的代码得到良好的组织，我们可以将代码简单地分为 `my_config.k` 和 `my_config_test.k` 两个文件。

在 `my_config.k` 中定义配置数据：

```python
_priority = 1  # 非导出可变变量 
_cpu = 256  # 非导出可变变量 

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048
_name = "nginx"

# 可导出变量
cpu = _cpu
memory = _cpu * 2
command = [_name] # 列表
labels = {
    run = "my-{}".format(_name)
    env = "pre-prod"
} # a dict
image = "{}:1.14.2".format(_name) # 字符串格式
service = "my-service"
```

而测试代码定义在 `my_config_test.k` 中，我们可以在其中导入 `my_config.k`：

```python
import my_config

# debugging
print(my_config.labels) # 通过打印调试 

# test
assert len(my_config.labels) > 0, "labels can't beempty" # 使用 len() 得到列表长度
assert "env" in my_config.labels, "env label is a must"
assert my_config.cpu >= 256, "cpu cannot be less than256"
```

## 9. 配置输入参数

有时我们需要获得通过从最终用户或平台动态获取的外部输入参数。

在这种情况下，我们可以按需传递 `priority` 和 `env` 参数：

- 通过参数传递: `-D priority=1 -D env=pre-prod`
- 可以在 KCL 代码中使用 `option` 关键字获取这些值

```python
_priority = option("priority") # 非导出可变变量
_env = option("env") # 非导出可变变量
_cpu = 256 # 非导出可变变量

if _priority == 1:
    _cpu = 256
elif _priority == 2:
    _cpu = 512
elif _priority == 3:
    _cpu = 1024
else:
    _cpu = 2048

_name = "nginx"
# 可导出变量
cpu = _cpu
memory = _cpu * 2
command = [_name] # 列表
labels = {
    run = "my-{}".format(_name)
    env = _env
} # a dict
image = "{}:1.14.2".format(_name) # 字符串格式 
service = "my-service"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

```bash
kcl -D priority=2 -D env=pre-prod my_config.k
```

标准输出:

```yaml
cpu: 512
memory: 1024
command:
    - nginx
labels:
    run: my-nginx
    env: pre-prod
image: nginx:1.14.2
service: my-service
```

## 10. 使用 Dict 简化逻辑表达式

当我们需要编写复杂的逻辑时，可以使用dict来简化逻辑的编写。

```python
_priority = option("priority") # 非导出可变变量
_env = option("env") # 非导出可变变量
_priorityCpuMap = {
    "1" = 256
    "2" = 512
    "3" = 1024
}
# 使用字典简化逻辑，默认值为2048
_cpu = _priorityCpuMap[_priority] or 2048
_name = "nginx"
# 可导出变量
cpu = _cpu
memory = _cpu * 2
command = [_name] # 列表
labels = {
    run = "my-{}".format(_name)
    env = _env
} # a dict
image = "{}:1.14.2".format(_name) # 字符串格式
service = "my-service"
```

使用 KCL 运行上述代码，将会看到以 yaml 格式生成的如下数据：

KCL 命令:

```bash
kcl -D priority=2 -D env=pre-prod my_config.k
```

标准输出：

```yaml
cpu: 512
memory: 1024
command:
    - nginx
labels:
    run: my-nginx
    env: pre-prod
image: nginx:1.14.2
service: my-service
```

## 11. 最后

恭喜！

我们已经完成了关于 KCL 的第一课程，我们使用 KCL 来替换我们的键值文本文件，以获得更好的编程支持。

建议立即查看架构代码实验，以了解如何使用 KCL `schema` 机制协作编写高级配置。
