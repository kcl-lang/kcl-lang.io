---
sidebar_position: 1
---

# 简介

KCL 是声明式配置策略语言，对于不方便通过配置直接描述的复杂的业务逻辑可以通过通用的编程语言开发 KCL 插件对语言进行扩展。KCL 支持通过通用语言开发插件，KCL 程序导入插件中的函数。KCL 通过插件运行时和辅助的命令行工具提供插件支持。KCL 插件框架支持多种不同的通用语言开发插件，这里我们以 Python 为例简单说明插件的使用。

插件的 Git 仓库: [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin)

## 0. 前置依赖

使用 KCL Python 插件需要您的 `PATH` 中存在 `Python3.7+`。

## 1. 你好插件

KCL 插件在 KCL 的 `plugins` 子目录（通常安装在 `$HOME/.kcl/plugins` 目录），或者通过 `$KCL_PLUGINS_ROOT` 环境变量设置（环境变量优先级更高）。此外，`plugins` 插件目录还可以放在执行 KCL 命令的 `pwd` 路径或者父路径中。对于插件开发人员，插件都在 Git 仓库管理： [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin) ，可以将插件仓库克隆到该目录进行开发。

输入 `kcl-plugin info` 命令查看查看插件目录（将其中的 `/Users/kcl_user` 替换成本地的 `$HOME` 路径）：

```shell
$ kcl-plugin info
# plugin_root: /Users/kcl_user/.kcl/plugins
```

通过 `kcl-plugin list` 子命令查看插件列表：

```shell
$ kcl-plugin list
hello: hello doc - 0.0.1
```

其中 `hello` 是 KCL 内置的示例插件（不要修改改插件）。

在 KCL 代码中，可以通过 `kcl_plugin.hello` 导入 `hello` 插件。`main.k` 代码如下：

```python
import kcl_plugin.hello

name = "kcl"
three = hello.add(1,2)
```

输出结果如下：

```shell
$ python3 -m kclvm main.k
name: kcl
three: 3
```

## 2. `kcl-plugin` 辅助命令

`kcl-plugin` 是提供的插件辅助工具，命令行帮助如下：

```shell
$ kcl-plugin
usage: kcl-plugin [-h] {list,info,init,gendoc,test} ...
positional arguments:
  {list,info,init,gendoc,test}
                        kcl plugin sub commands
    list                list all plugins
    info                show plugin document
    init                init a new plugin
    gendoc              gen all plugins document
    test                test plugin
optional arguments:
  -h, --help            show this help message and exit
```

其中 `list` 子命令用于查看插件列表；`info` 用户查看插件目录和每个插件的信息；`init` 可以用户初始化新插件；`gendoc` 更新全部插件的 API 文档；`test` 测试指定的插件。

## 3. 插件信息和文档

输入 `kcl-plugin info hello` 查看 `hello` 插件信息：

```shell
$ kcl-plugin info hello
{
    "name": "hello",
    "describe": "hello doc",
    "long_describe": "long describe",
    "version": "0.0.1",
    "method": {
        "add": "add two numbers, and return result",
        "foo": "no doc",
        "list_append": "no doc",
        "say_hello": "no doc",
        "tolower": "no doc",
        "update_dict": "no doc"
    }
}
```

插件的信息主要包含插件的名字和版本信息，插件提供的函数信息。该信息和插件目录中自动生成的 `api.md` 文件是一致的（插件 API 变化时通过 `kcl-plugin gendoc` 为全部的插件重新生成 `api.md` 文件）。

## 4. 插件的目录结构

插件的目录结构如下（将其中的 `/Users/kcl_user` 替换成本地的 `$HOME` 路径）：

```shell
$ tree /Users/kcl_user/.kcl/plugins/
/Users/kcl_user/.kcl/plugins/
├── _examples
├── _test
└── hello
    ├── api.md
    ├── plugin.py
    └── plugin_test.py
$
```

其中 `_examples` 目录下是插件的示例代码，`_test` 目录下是插件的 KCL 测试代码，其他以字母开头的目录是普通的插件（目录中同时包含 `plugin.py` 和 `plugin_test.py` 文件）。

KCL 的插件是有一个独立的纯 Python 代码文件实现，并且插件相互之间不能直接调用。插件的内容如下：

```shell
$ cat ./hello/plugin.py
# Copyright 2020 The KCL Authors. All rights reserved.
INFO = {
    'name': 'hello',
    'describe': 'hello doc',
    'long_describe': 'long describe',
    'version': '0.0.1',
}
def add(a: int, b: int) -> int:
    """add two numbers, and return result"""
    return a + b
...
```

其中 `INFO` 指明了插件的名字、概要说明、详细说明和版本信息。而所有名字以字母开头的函数是插件给 KCL 提供的函数，因此 KCL 中可以直接调用 `add` 函数。

## 5. 创建一个插件

通过 `kcl-plugin init` 命令可以创建一个插件示例：

```
$ kcl-plugin init hi
$ kcl-plugin list
hello: hello doc - 0.0.1
hi: hi doc - 0.0.1
```

`kcl-plugin init` 命令会以内置的模板构造一个新的插件，然后通过 `kcl-plugin list` 命令可以查看到新创建的插件。

## 6. 插件的删除

KCL 插件在 KCL 的 `plugins` 子目录（通常安装在 `$HOME/.kcl/plugins` 目录）。
可以通过命令 `kcl-plugin info` 查询插件安装目录。

```shell
$ kcl-plugin info
/Users/kcl_user/.kcl/plugins/
$ tree /Users/kcl_user/.kcl/plugins/
/Users/kcl_user/.kcl/plugins/
├── _examples
├── _test
└── hello      -- 删除这个目录就可以删除 hello plugin
    ├── api.md
    ├── plugin.py
    └── plugin_test.py
$
```

## 7. 插件的测试

插件是独立的纯 Python 文件实现，插件目录下有个 `plugin_test.py` 文件是插件的单元测试文件（基于 pytest 测试框架）。此外在 `_test` 目录下放置的是 KCL 文件的插件集成测试。`plugin_test.py` 单元测试是必须的，`_test` 目录下的 KCL 集成测试可以根据情况添加。

可以通过 `kcl-plugin test` 执行插件的单元测试：

```shell
$ kcl-plugin test hello
============================= test session starts ==============================
platform darwin -- Python 3.7.6+, pytest-5.3.5, py-1.9.0, pluggy-0.13.1
rootdir: /Users/kcl_user
collected 5 items
.kcl/plugins/hello/plugin_test.py .....      [100%]
============================== 5 passed in 0.03s ===============================
$
```

集成测试可以通过在 `_test` 目录下执行 `python3 -m pytest` 命令进行测试。
