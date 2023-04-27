# KCL Module 和 Package

本节主要介绍如何组织 KCL 中的文件。

## 概述

在一个**module**中，KCL 按**package**进行组织文件。package 可以在 module 内定义，也可以通过 KCL 包管理器 `kpm` 从外部导入。在后一种情况下，KCL 在专用位置中维护包的副本。

## Module

KCL 模块按目录层次结构布置配置。它包含了确定 KCL 配置结果所需的一切。此目录的根标记为包含 `kcl.mod` 目录。此目录的内容大多由 kcl 工具（如 `kpm` 等）管理。从这个意义上讲，`kcl.mod` 类似于 `.git` 目录，标记着仓库的根目录，但它的内容主要由 git 工具管理。此外，KCL 模块是文件组织的最大单位，具有所有 KCL 文件和依赖项的固定位置。

> 注意: 使用 KCL 模块（例如 `kcl.mod`）是可选的，但如果您想使用语义版本管理、分发、共享和重用代码，则需要使用它。

### 创建一个 module

可以通过在模块根目录中运行以下命令来创建模块:

```bash
kpm init [module name]
```

模块名在需要在模块内导入另一个模块的包时是**必需的**。也可以通过手动设置 `kcl.mod` 文件来创建模块。

## Package

在 KCL 中，一个包通常由包含 KCL 文件的“文件夹”组成。这个文件夹可以是实际的磁盘物理路径，也可以由多个 KCL 文件（通常是主包）组成。不同的包通过不同的包路径（如 `kubernetes.core.v1`）唯一地定位。

在同一个模块内，可以通过相对或绝对路径的 import 语句互相导入不同的包。在 KCL 解析过程中，相对 import 将被替换为绝对 import，并通过包路径找到相应的 KCL 代码。

### 相对导入路径

我们可以使用 `.` 运算符来实现 KCL 入口文件的相对路径导入。


main.k:

```python
import .model1  # Current directory module
import ..service  # Parent directory
import ...root  # Parent of parent directory

s = service.ImageService {}
m = root.Schema {}
```

### 绝对导入路径

KCL 语句`import a.b.c.d` 的语义是：

1. 如果 `kcl.mod` 不存在，则将当前目录视为包根目录，并从当前目录搜索路径 `a/b/c/d`。
2. 如果当前目录搜索失败，则从根路径 `ROOT_PATH/a/b/c/d` 搜索，否则引发导入错误。

根路径 `ROOT_PATH` 的定义是相对于 `kcl.mod` 文件的目录。

代码结构:

```
. 
└── root
    ├── kcl.mod
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   └── service1.k
    └── mixin
        └── mixin1.k
```

### 内置包

KCL 有一系列内置包，例如 `math`，`regex` 等。要使用内置包，直接导入并使用其限定标识符调用函数。例如，

```python
import regex

image = "nginx:1.14.2"
is_match = regex.match(image, "^[a-zA-Z]+:\d+\.\d+\.\d+$")

```

输出的 YAML 为

```yaml
image: nginx:1.14.2
is_match: true
```

### 插件包

<!--TODO: scenario-related kcl-plugin examples-->

KCL 还有一系列插件包，例如 `hello`，`project_context` 等。要使用插件包，需要用 `kcl_plugin.` 包路径前缀导入，并使用其限定标识符调用函数。例如，

```python
import kcl_plugin.hello

result = hello.add(1, 1)
```

输出的 YAML 为

```yaml
result: 2
```

### 主包

在 KCL 中，主包的组成通常由编译器参数确定。这是因为KCL模式和约束可以在包中的文件中分隔，甚至可以在目录中组织，考虑将配置写入和维护在隔离块中的便利性。

#### 属于主包的文件

用户可以使用KCL命令行决定使用哪些配置和约束，例如，

```bash
kcl file1.k file2.k
```

因此，主包包含两个名为 `file1.k` 和 `file2.k` 的 KCL 文件。

如果 KCL 被告知为特定目录加载文件，例如：

```bash
kcl ./path/to/package
```

它将只查找 `.k` 后缀的 KCL 文件，并忽略 `_` 或 `_test.k` 前缀的 KCL 文件合并到主包中。此外，如果 `./path/to/package` 包含 `kcl.yaml` 文件，则 `kcl.yaml` 文件将被忽略。

此外，我们可以通过配置命令行编译设置文件（例如 `kcl.yaml`）来设置主包文件，如下所示：

```yaml
kcl_cli_configs:
  files:
    - file1.k
    - file2.k
```

```bash
kcl -Y kcl.yaml
```

> 注意：如果没有为 KCL 指定任何输入文件，KCL 将从命令行执行路径查找默认的 `kcl.yaml` 文件读取输入文件。此外，如果我们告诉KCL输入文件和编译设置文件，KCL将把用户输入的输入文件作为最终值。

```bash
# 无论`kcl.yaml` 中是否配置 `files` 字段，输入文件的最终值为["file1.k", "file2.k"]
kcl -Y kcl.yaml file1.k file2.k
```

## kcl.mod 和 kcl.yaml 异同

首先，在 KCL 中，`kcl.mod` 和 `kcl.yaml` 都是可选的。它们之间的区别在于 `kcl.mod` 确定包路径的根路径以及 KCL 模块是否具有分发和重用要求，而 `kcl.yaml` 确定主包的 KCL 文件组成。

其次，对于仅用于外部使用的 kcl module，`kcl.yaml` 是可选的，但 `kcl.mod` 是必需的，因为它需要声明 KCL 版本，模块版本，依赖关系和其他信息。

最后，对于 KCL IDE 插件，它需要知道主包信息才能形成完整的编译过程，因此它需要根据光标位置自动查找主包组成，因为没有人可以通过 KCL 命令行指定这些信息。一般的查询逻辑是查找 `kcl.yaml` 的存在性。如果找到了，主包由 `kcl.yaml` 中的文件属性组成，如果找不到，主包由当前文件组成。KCL IDE 插件会有选择地了解 `kcl.mod` 文件。当 `kcl.mod` 文件存在时，IDE 插件会读取所有包路径及其在外部依赖项中的实际路径的相应信息。
