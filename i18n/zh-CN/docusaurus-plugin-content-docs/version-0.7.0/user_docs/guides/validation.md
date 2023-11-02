---
title: "校验"
sidebar_position: 2
---

## 简介

验证是校验数据是否准确、可靠并满足某些要求或限制的过程，包括检查数据的完整性、一致性、准确性和相关性。进行数据验证是为了确保数据符合其预期目的，并能有效使用。

我们可以使用 KCL 及其校验工具手动或自动进行数据验证，以确保数据的一致性。

## 使用 KCL 校验数据

除了使用 KCL 代码生成 JSON/YAML 等配置格式，KCL 还支持对 JSON/YAML 数据进行格式校验。作为一种配置语言，KCL 在验证方面几乎涵盖了 OpenAPI 的所有功能。在 KCL 中可以通过一个结构定义来约束配置数据，同时支持通过 check 块自定义约束规则，在 schema 中书写校验表达式对 schema 定义的属性进行校验和约束。通过 check 表达式可以非常清晰简单地校验输入的 JSON/YAML 是否满足相应的 schema 结构定义与 check 约束。

### 0. 先决条件

+ 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)

### 1. 获得示例

```shell
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/validation
```

我们可以执行如下命令显示配置

```bash
cat schema.k
```

输出为

```python
schema User:
    name: str
    age: int
    message?: str
    data: Data
    labels: {str:}
    hc: [int]
        
    check:
        age > 10, "age must > 10"

schema Data:
    id: int
    value: str
```

在 schema 中，我们可以使用 `check` 关键字来编写每个 schema 属性的验证规则。`check` 块中的每一行都对应于一个条件表达式。当满足条件时，验证成功。条件表达式后面可以跟 `, "报错信息"`，以指示检查失败时要给用户显示的消息。

综上所述，KCL Schema 中支持的校验类型为:

| 校验类型 | 使用方法                                                |
| -------- | ------------------------------------------------------- |
| 范围校验 | 使用 `<`, `>` 等比较运算符                                |
| 正则校验 | 使用 `regex` 系统库中的 `match` 等方法                      |
| 长度校验 | 使用 `len` 内置函数，可以求 `list/dict/str` 类型的变量长度 |
| 枚举校验 | 使用字面值联合类型                                      |
| 非空校验 | 使用 schema 的可选/必选属性                             |
| 条件校验 | 使用 check if 条件表达式                                |

### 2. 验证数据

新建一个名为 `data.json` 的 JSON 配置文件:

```json
{
    "name": "Alice",
    "age": 18,
    "message": "This is Alice",
    "data": {
        "id": 1,
        "value": "value1"
    },
    "labels": {
        "key": "value"
    },
    "hc": [1, 2, 3]
}
```

执行如下命令获得校验结果

```bash
kcl vet data.json schema.k
```

## 小结

KCL 是一种配置语言，通过其结构定义和用户定义的约束规则来支持数据验证。KCL Schema 中支持的验证类型包括范围、正则表达式、长度、枚举、可选/必需和条件。并且可以使用 KCL 验证工具或在此基础上构建的可视化产品来验证数据。

## 未来计划

KCL 校验能力的提升将逐渐围绕"静态化"方面展开工作，即在编译时，结合形式化验证的能力直接分析得出数据是否满足约束条件、约束条件是否冲突等结论，并且可以通过 IDE 实时透出约束错误，而无需在运行时发现错误。

我们还期望 KCL Schema 和约束可以作为一个包来管理（这个包只有 KCL 文件）。例如，Kubernetes 模型和约束可以开箱即用。用户可以生成配置或验证现有配置，并且可以通过 KCL 继承简单地扩展用户想要的模型和约束。
