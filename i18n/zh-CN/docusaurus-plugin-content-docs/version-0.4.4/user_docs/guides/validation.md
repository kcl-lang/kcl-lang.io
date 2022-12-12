---
title: "校验"
sidebar_position: 2
---

## 使用 KCL 校验数据

除了使用 KCL 代码生成 JSON/YAML 等配置格式，KCL 还支持对 JSON/YAML 数据进行格式校验。作为一种配置语言，KCL 在验证方面几乎涵盖了 OpenAPI 的所有功能。在 KCL 中可以通过一个结构定义来约束配置数据，同时支持通过 check 块自定义约束规则，在 schema 中书写校验表达式对 schema 定义的属性进行校验和约束。通过 check 表达式可以非常清晰简单地校验输入的 JSON/YAML 是否满足相应的 schema 结构定义与 check 约束。

## 简介

在 schema 定义当中可以使用 check 关键字编写 schema 属性的校验规则, 如下所示，check 代码块中的每一行都对应一个条件表达式，当满足条件时校验成功，当不满足条件时校验失败, 条件表达式后可跟 `, "check error message"` 表示当校验失败时需要显示的信息。

```python
import regex

schema Sample:
    foo: str  # Required, 不能为None/Undefined, 且类型必须为str
    bar: int  # Required, 不能为None/Undefined, 且类型必须为int
    fooList: [int]  # Required, 不能为None/Undefined, 且类型必须为int列表
    color: "Red" | "Yellow" | "Blue"  # Required, 字面值联合类型，且必须为"Red", "Yellow", "Blue"中的一个，枚举作用
    id?: int  # Optional，可以留空，类型必须为int

    check:
        0 <= bar < 100  # bar必须大于等于0，小于100
        0 < len(fooList) < 100  # fooList不能为None/Undefined，并且长度必须大于0,小于100
        regex.match(foo, "^The.*Foo$") # regex 正则表达式匹配
        bar in range(100) # range, bar范围只能为1到99
        bar in [2, 4, 6, 8] # enum, bar只能取2, 4, 6, 8
        bar % 2 == 0  # bar必须为2的倍数
        all foo in fooList {
            foo > 1
        }  # fooList中的所有元素必须大于1
        any foo in fooList {
            foo > 10
        }  # fooList中至少有一个元素必须大于10
        abs(id) > 10 if id  # check if 表达式，当 id 不为空时，id的绝对值必须大于10
```

综上所述，KCL Schema 中支持的校验类型为:

| 校验类型 | 使用方法                                                |
| -------- | ------------------------------------------------------- |
| 范围校验 | 使用 `<`, `>` 等比较运算符                                |
| 正则校验 | 使用 `regex` 系统库中的 `match` 等方法                      |
| 长度校验 | 使用 `len` 内置函数，可以求 `list/dict/str` 类型的变量长度 |
| 枚举校验 | 使用字面值联合类型                                      |
| 非空校验 | 使用 schema 的可选/必选属性                             |
| 条件校验 | 使用 check if 条件表达式                                |

基于此，KCL 提供了相应的[校验工具](/docs/tools/cli/kcl/vet) 直接对 JSON/YAML 数据进行校验。此外，通过 KCL schema 的 check 表达式可以非常清晰简单地校验输入的 JSON 是否满足相应的 schema 结构定义与 check 约束。

## 未来计划

KCL 校验能力的提升将逐渐围绕“静态化”方面展开工作，即在编译时结合形式化验证的能力直接分析出数据是否满足约束条件，约束条件是否冲突等问题，并且可以通过 IDE 实时透出约束错误，而无需在运行时发现错误。
