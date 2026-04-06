---
slug: 2024-04-17-newsletter
title: KCL 最新动态速递 (2024.04.04 - 2024.04.17)
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

## 内容概述

感谢所有贡献者过去一段时间 (2024.04.04 - 2024.04.17) 的杰出工作，以下是重点内容概述

**🏄 语言更新**

- Schema 的 `instances()` 方法新增关键字参数 `full_pkg` 参数用于读取所有代码中对应 Schema 的实例

```kcl
schema Person:
    name: str

alice = Person {name = "Alice"}
all_persons = Person.instances(True)
```

- 新增 `template` 系统库用于在 KCL 中操作模版

```kcl
import template

content = template.execute("""\
<div class="entry">
{{#if author}}
<h1>{{firstName}} {{lastName}}</h1>
{{/if}}
</div>
""", {
  author: True,
  firstName: "Yehuda",
  lastName: "Katz",
})
```

**⛵️ API 更新**

- OverrideFile API 支持修改/删除非 schema 类型的字段
- 新增 ListVariable API 用于读取 KCL 文件中变量的值

**🔥 SDK 更新**

- KCL Go SDK 发布 0.8.4 版本。
- KCL Rust SDK 新增 `llvm` feature 选项，可以选择是否采用 LLVM 编译，默认为关闭。当关闭 LLVM 特性时，可以降低构建二进制体积 90%。通过以下方式添加依赖

```shell
cargo add --git https://github.com/kcl-lang/lib
```

- KCL Node.js SDK 初版发布，仓库地址 [https://github.com/kcl-lang/lib/tree/main/nodejs](https://github.com/kcl-lang/lib/tree/main/nodejs), 欢迎共建

* `__test__/test_data/schema.k`

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

- `execProgram`

```ts
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(
    new ExecProgramArgs(["__test__/test_data/schema.k"]),
  );
  console.log(result.yamlResult); // 'app:\n  replicas: 2'
}

main();
```

- `listVariables`

```ts
import { listVariables, ListVariablesArgs } from "kcl-lib";

function main() {
  const result = listVariables(
    ListVariablesArgs("__test__/test_data/schema.k", []),
  );
  console.log(result.variables["app"].value); // 'AppConfig {replicas: 2}'
}

main();
```

- `loadPackage`

```ts
import { loadPackage, LoadPackageArgs } from "kcl-lib";

function main() {
  const result = loadPackage(
    LoadPackageArgs(["__test__/test_data/schema.k"], [], true),
  );
  console.log(result.symbols);
}

main();
```

**💻 IDE 更新**

- 新增编译单元缓存提升 IDE 性能

**🌼 集成更新**

- Crossplane KCL Function 发布 v0.5.1 版本
  - 支持读取 Function Context 参数用于不同的函数进行参数传递
  - 支持读写 Function Details 字段用于处理与 Secret 资源相关的敏感信息
  - 支持设置 XR 资源的 status 字段用于输出用户提示信息
  - 修复多个 XR 资源下发集群时并发请求的错误
- KCL 发布 Nix 包，可以通过 `nix-shell` 或者 `devbox shell` 工具一键安装 KCL 命令行工具，详情查看 [https://search.nixos.org/packages?channel=unstable&show=kcl&from=0&size=50&sort=relevance&type=packages&query=kcl](https://search.nixos.org/packages?channel=unstable&show=kcl&from=0&size=50&sort=relevance&type=packages&query=kcl)

## 特别鸣谢

感谢过去两周所有的社区参与者，以下排名不分先后

- 感谢 @bozaro 对 KCL Go SDK 的贡献 🙌
- 感谢 @jheyduk 对 Kubectl KCL 插件的贡献 🙌
- 感谢 @shashank-iitbhu 对 KCL IDE 语法快速修复功能的贡献 🙌
- 感谢 @d4v1d03 对 KCL 官网 FAQ 文档的贡献 🙌
- 感谢 @octonawish-akcodes 对 KCL IDE 根据 kcl.mod 自动更新依赖功能的贡献 🙌
- 感谢 @utnim2 对 KCL IDE 重启 kcl-language-server 命令的贡献 🙌
- 感谢 @AkashKumar7902 对 KCL 包管理工具最小版本选择 MVS 算法的贡献 🙌
- 感谢 @steeling, @bozaro, @vtomilov, @sanzoghenzo, @folliehiyuki, @markphillips100, @wilsonwang371, @zargor, @aleeriz, @reckless-huang, @zhuxw, @jheyduk ,@Vitaly Tomilov, @Sergey Ryabin, @Stephen C, @ytsarev 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

❤️ 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
