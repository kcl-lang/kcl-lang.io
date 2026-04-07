---
slug: 2024-06-12-newsletter
title: KCL 最新动态速递 (2024.05.30 - 2024.06.12)
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @shruti2522 对 KCL IDE string union type 类型变量补全和函数符号高亮的贡献 🙌
- 感谢 @ihor-hrytskiv 对 `jsonpatch` 模块的贡献 🙌
- 感谢 @selfuryon 对 KCL Nix Package 的贡献 🙌
- 感谢 @nestoralonso 对 ArgoCD KCL 插件的贡献 🙌
- 感谢 @Vishalk91-4 对 KCL tree-sitter-grammar 的贡献 🙌
- 感谢 @Daksh-10 对 KCL tree-sitter-grammar 的贡献 🙌
- 感谢 @officialasishkumar 对 kcl.mod 文件序列化/反序列化 API 的贡献 🙌
- 感谢 @d4v1d03 对 KCL FAQ 文档的贡献 🙌
- 感谢 @liangyuanpeng, @atelsier, @mproffitt, @steeling, @eshepelyuk, @SjuulJanssen, @riven-blade, @excalq, @Wck-iipi, @Yvan da Silva, @Hai Wu 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

感谢所有贡献者过去一段时间 (2024.05.30 - 2024.06.12) 的杰出工作，以下是重点内容概述

**📦️ 三方库更新**

- jsonpatch 三方库发布 0.0.4 版本，修复 `set_obj` 函数非预期的错误

可以通过 `kcl mod add jsonpatch` 添加 `jsonpatch` 最新依赖。

使用方式如下

```kcl
import jsonpatch as p

test_json_patch = lambda {
    data = {
        "firstName": "John",
        "lastName": "Doe",
        "age": 30,
        "address": {
            "streetAddress": "1234 Main St",
            "city": "New York",
            "state": "NY",
            "postalCode": "10001"
        },
        "phoneNumbers": [
            {
                "type": "home",
                "number": "212-555-1234"
            },
            {
                "type": "work",
                "number": "646-555-5678"
            }
        ]
    }
    phoneNumbers0type: str = p.get_obj(data, "phoneNumbers/0/type")
    addressCity: str = p.get_obj(data, "address/city")
    newType = p.set_obj(data, "phoneNumbers/0/type", "school")
    newState = p.set_obj(data, "address/state", "WA")
    assert phoneNumbers0type == "home"
    assert addressCity == "New York"
    assert newType["phoneNumbers"][0]["type"] == "school"
    assert newState["address"]["state"] == "WA"
}

test_json_patch()
```

**🏄 语言更新**

- 修复 schema 插入属性运算符 `+=` 在配置合并时的错误
- 优化多行字符串插值变量未定义错误信息

**💻 IDE 更新**

- 支持 kcl.mod 文件和 kcl.mod.lock 文件的高亮
- 支持通过 VS Code Command 重启 kcl-language-server 命令
- 改进了当 kcl-language-server 不存在时的提示信息
- 支持字符串联合类型的成员补全
- 新增函数符号的高亮，区分普通变量和函数变量

**📬️ 工具链更新**

- `kcl import` 导入工具支持从 toml 到 KCL 配置的转换
- `kcl import` 导入工具支持 YAML Stream 格式输入并转换为 KCL 配置
- `kcl run` 支持输出 toml 格式
- `kcl run` 和 `kcl mod` 命令支持使用 `-q` 标志禁用额外消息输出
- `kcl mod add` 命令优化下载过程，防止被意外中断导致无法下载包的错误
- `kcl mod add` 支持从不同的 OCI 和 Git 源添加依赖

**⛵️ API 更新**

- 支持 prototext 格式和 KCL schema 输出为 KCL 配置
- 支持任意 Go 类型序列化为 KCL 配置
- `ListVariables` API 支持多文件输入与配置合并输出

**🔥 SDK 更新**

- 新增 KCL WASM 模块，支持在 Rust 中使用 wasmtime 或 Node.js 等运行时使用 KCL WASM 模块编译 KCL 代码，使用方式详见: [https://www.kcl-lang.io/docs/reference/xlang-api/wasm-api](https://www.kcl-lang.io/docs/reference/xlang-api/wasm-api)，后续会支持 KCL 在纯浏览器环境运行。

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
