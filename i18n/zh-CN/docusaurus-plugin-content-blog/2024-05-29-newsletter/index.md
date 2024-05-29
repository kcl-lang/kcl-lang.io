---
slug: 2024-05-29-newsletter
title: KCL 最新动态速递 (2024.05.15 - 2024.05.29)
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

- 恭喜 @AkashKumar7902 完成 LFX 1 期任务，kpm 版本管理模块的 mvp 版本成功合并入 main 分支  🙌 
- 感谢 @shashank-iitbhu 在 IDE Quick Fix 功能上做的持续贡献 🙌 
- 感谢 @Wck-iipi 在 IDE 悬停功能上做的持续贡献 🙌 
- 感谢 @warjiang 为 devcontainer 作出的贡献 🙌 
- 感谢 @shruti2522 为 IDE 悬停效果的优化作出的持续贡献 🙌
- 感谢 @XiaoK29 为 KCL go SDK 的代码优化作出的持续贡献 🙌
- 感谢 @d4v1d03 为 KCL 文档作出的持续贡献 🙌
- 感谢 @officialasishkumar 在包管理工具三方依赖重命名功能的贡献 🙌
- 感谢 @Vishalk91-4, @Daksh-10 对 KCL tree sitter 语法和解析器生成器的贡献 🙌
- 感谢 @SamirMarin 对 Crossplane KCL 函数的贡献 🙌
- 感谢 @officialasishkumar, @d4v1d03, @karlhepler, @Hai Wu, @ron18219, @olinux, @Alexander Fuchs, @Emmanuel Alap, @excalq, @leon-andria, @taylormonacelli, @dennybaa, @zhuxw, @aleeriz, @steeling 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 内容概述

感谢所有贡献者过去一段时间 (2024.05.15 - 2024.05.29) 的杰出工作，以下是重点内容概述

**📦️ 三方库更新**

- 新增 difflib 三方库，支持比较配置差异。

通过 `kcl mod add difflib` 添加 `difflib` 依赖。

通过 `difflib` 三方库提供的 `diff` 方法，输出配置差异。

```python
import difflib
import yaml

data1 = {
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
data2 = {
    "firstName": "John",
    "lastName": "Doe",
    "age": 30,
    "address": {
        "streetAddress": "1234 Main St",
        "city": "New York",
        "state": "NY",
        "postalCode": None
    },
    "phoneNumbers": [
        {
            "type": "work",
            "number": "646-555-5678"
        }
    ]
}
diff = difflib.diff(yaml.encode(data1), yaml.encode(data2))
```

然后，对应配置的 diff 如下：

```
+   postalCode: null
+ phoneNumbers:
+ - type: work
+   number: '646-555-5678'
-   postalCode: '10001'
- phoneNumbers:
- - type: home
-   number: '212-555-1234'
- - type: work
-   number: '646-555-5678'
```

**🏄 语言更新**

- kcl 0.9.0-beta.1 新版本发布。
- 强化了 schema 结构中属性非空的检查过程，优化了在空属性导致的 check 语句失效时的诊断信息。
- 修复了 doc parse 将字符串字面值解析成 doc 的问题。
- 修复了编译过程中 resolver 节点类型丢失的问题。
- 新增语法错误类型以支持 IDE 语法错误的快速恢复。
- 修复了 KCL 运行时内存泄漏的问题。

**💻 IDE 更新**

- IDE 增加对于部分编译错误的快速恢复。
- 新增了部分语法 IDE 悬停高亮。

IDE 支持部分语法悬停高亮。

![hover](/img/blog/2024-05-29-biweekly-newsletter/hover.png)

对于字符串字面值，新增悬停高亮

![hoverstrlit](/img/blog/2024-05-29-biweekly-newsletter/hoverstrlit.png)

- Devcontainer 配置新增 vscode 扩展。
- IDE 新增 config 表达式悬停提示对应 schema 字段。
- IDE 支持通过 kcl.mod 文件识别编译单元。
- IDE 修复了文档悬停格式错误。
- IDE 修复了由于 LSP 的 panic 导致的编译错误。
- 优化了 LSP 输入的日志内容。

**📬️ 工具链更新**

- KCL 测试工具支持 fast eval 模式。
- 新增 `kcl clean` 支持清理 module 缓存。
- KCL Import 工具修复 YAML Stream 格式导入过程非预期的错误

- 包管理工具更新
- kcl 支持通过 mod add --rename 参数和 kcl.mod 文件中重命名依赖防止名称冲突。
- 修复了添加本地文件目录作为依赖时，kcl.mod 文件依赖丢失的问题。
- 支持通过分支名称添加 git 三方库。
- 移除了在更新依赖时输出的无效日志。
- 新增 API 支持写入 kcl.mod 和 kcl.mod.lock 文件。
- 移除了加载三方库过程中请求 metadata 过程。
- 在打包和上传 KCL 三方库时，针对 KCL 包中存在本地依赖的情况，输出诊断信息。
- LFX 1 期题目完成，版本管理模块 mvp 版本合并入 main 分支。
- 支持 kcl.mod 文件中通过 include 和 exclude 字段指定需要打包和跳过的文件。
- 移除本地计算三方库 checksum 过程。

**⛵️ API 更新**

- 新增 UpdateDependencies API 支持更新 KCL 三方库。
- 新增 API 支持写入 kcl.mod 和 kcl.mod.lock 文件。
- OverrideFile API 返回值中新增编译错误信息。
- OverrideFile API 支持通过运算符 ":" 和 "+=" 插入配置。
- ListVariable API 返回值支持解析 List 和 Dict 结构。
- 修复了 OverrideFile API 在插入 import 语句时导致的配置格式错乱的问题。
- 重构了获取 schema type 相关的 API。
- 修复了 LSP handle_semantic_tokens_full 和 handle_document_symbol 方法导致的 panic 问题。

**🔥 SDK 更新**

- KCL SDK v0.9.0-beta.1 版本发布, 同步支持 API 更新。
- KCL go SDK 支持通过 proto 导入 KCL Schema。

**📂 文档更新**

- 修复了开发向导文档中的错误拼写与一些环境配置描述。
- 新增关于 file.read_env 库函数的文档说明。
- 语言文档中补充了关于 schema 属性名称中“-”，“.”等符号的说明。
- 新增了一些 Q&A。

**📺 生态集成**

- 修复了 crossplane kcl function 导致的 pod 内存泄漏问题。
- KCL tree sitter 新增 schema, mixin, rule 等语法支持和对应测试。

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
