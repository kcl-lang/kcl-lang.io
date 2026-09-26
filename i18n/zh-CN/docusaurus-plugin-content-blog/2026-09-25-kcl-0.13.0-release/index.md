---
slug: 2026-09-25-kcl-0.13.0-release
title: KCL v0.13.0 重磅发布 — 更一致的语言、更完善的标准库与跨语言 API
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.13.0 新版本现已可用**！本次发布为大家带来了三个方向的更新：

- _更一致、更具表达力的 KCL 语言：ES6 风格配置项简写、更灵活的 Lambda 表达式、更友好的多行字符串以及更完善的相等性语义_
- _更完善的标准库与跨语言 API：新增 `reduce`、`json.merge`、`file.readbase64` 与 `net.is_IPv6` 等函数，支持 RFC 7396 JSON Merge Patch，Source Map v3 输出以及行级测试覆盖率_
- _更快、更可靠的工具链与 IDE：显著提升编译与求值性能，提供包级 lint、dry-run 格式化以及更丰富的 LSP 能力_

[KCL](https://github.com/kcl-lang) 是一个由 CNCF（云原生计算基金会）托管的、基于约束的记录与函数式语言。它借助成熟的编程语言技术和工程实践，改善云原生等复杂配置场景下的编写体验，致力于围绕配置构建更好的模块化、扩展性与稳定性，让逻辑编写更简单、自动化更顺畅，并提供丰富的内置与 API 驱动的集成能力。

## ❤️ 特别鸣谢

**衷心感谢 v0.12 → v0.13 版本迭代过程中所有社区贡献者，以下排名不分先后。**

_@Peefy, @zong-zhe, @liangyuanpeng, @johngmyers, @priyansh-saxena1, @jfharden, @aliazlan4, @vlada-dudr, @turner-hemmer, @Arpit529Srivastava, @DCchoudhury15, @jschoone, @ytsarev, @f4z3r, @rtainaan, @31puneet, @Viscous106, @56steve, @neo0007777_

## 📚 重点更新内容

### 🔧 核心功能

#### 语言

- KCL 支持 **ES6 风格的配置项简写**：在 config / schema 字面量中，单独的标识符等价于 `key = key`，可以与普通条目混合书写。例如 `{ name, age = 18 }` 等价于 `{ name = name, age = 18 }`。
- **Lambda 表达式支持使用花括号包裹参数列表**，参数因此可以写在多行。使用花括号时必须显式声明返回类型。

```kcl
func = lambda {
    x: int,
    y: int = 5
} -> int {
    x + y
}
```

- **多行（三引号）字符串会自动去除公共缩进**：会剥离所有非空行的公共前导空白，使内嵌文本可以跟随外层代码自然缩进。

```kcl
s = """
  foo
  bar
"""  # "foo\nbar\n"
```

- **`!=` 运算符现在除了基础类型外，也支持列表、字典与 schema** 进行比较，例如 `{} != {k = "v"}` 与 `[0] != [1]`。
- **量词表达式（`all` / `any` / `filter` / `map`）支持以选择子表达式作为迭代目标**，包括安全导航选择子，因此可以直接迭代嵌套集合，例如 `all y in data?.items { y > 0 }`。
- YAML 输出可通过新的 `multiline_string` 编码选项选用 **多行 block-scalar 字符串**，并保留 YAML block-scalar 的尾部换行。
- 修正 `math.floor` 返回整数而非浮点数。
- 修正字符串格式化，使 **宽度、对齐与填充** 说明符作用于字符串值，例如 `"{:*^10}".format("hi")` 得到 `"****hi****"`。
- 修复了与 lazy scope 缓存、schema 属性 override、mixin replay、前向引用以及 config 条目遮蔽外层 schema 属性相关的一系列求值问题，使求值结果更加稳定、可预期。

#### 工具链

- **`kcl lint ./...`**：lint 命令现支持 `./...` 模式，可一次性对当前目录或指定目录下的所有 KCL 包执行 lint，每个目录对应一个包，类似 `go build ./...`。
- **`kcl fmt --dry-run`**：在不修改文件的前提下报告需要格式化的文件，便于在 CI 中进行检查。格式化器同时会遵守 `.editorconfig` 中的缩进设置，保留同一行上的行尾注释，并在解析失败时保持源码不变。
- **`kcl test` 提供行级覆盖率**：测试 API 会按文件收集测试运行的行级覆盖率信息。
- **将 KCL 程序打包为单文件** 形式，便于分发和执行。
- **性能**：本次发布带来一系列显著的性能改进 —— 编译器索引使用更快的哈希表、为配置键启用小字符串优化、用单调递增的 AST 索引替代 UUID、加载过程中缓存路径规范化与包解析、对全限定名查找做记忆化与增量更新，并跳过未使用包的编译步骤。在中大型项目上，编译与求值速度都有可感知的提升。
- 发布产物覆盖更多平台，包括 Linux glibc 2.17 与 musl（Alpine Linux）构建。

#### IDE

- KCL 语言服务器可在每个测试函数上方的 CodeLens **点击直接运行单元测试**。
- 语言服务器可 **通过 `kcl mod` 工具链自动更新依赖**，并响应 `kcl.mod` / `kcl.yaml` 的修改事件。
- 语言服务器会 **向上回溯目录寻找 `kcl.mod` / `kcl.yaml` / `kcl.work` 工作区根**，在工作区文件监听中遵守 `.gitignore`，并加快导入补全速度。
- 修复了语言服务器中 schema 解析时继承属性查找错误、错误的导入补全以及缺失的 schema 类型恢复等问题。

#### API

- **Source Map v3 输出**：`kcl run --sourcemap <file>` 会随生成的 YAML 一并写入一份 Source Map v3 文档，使下游工具可以把生成出来的 YAML 行反查回源 `.k` 文件、所在行与列。
- **Schema 类型 API 扩展**：`KclType` 现在携带 **索引签名** 与 **函数类型** 信息；为带 `@info(type="attr")` 装饰器的属性生成 `__kcl_info_meta__` 标记。
- **新增 `GetSchemaTypeMappingUnderPath` RPC**：按包名返回 schema 类型映射。与 `GetSchemaTypeMapping` 不同的是，从外部依赖包导入的 schema 会以各自包名作为 key，而不是被拍平到 `__main__` 下。
- **C API 支持 `error_format` 选项**，提供机器可读的诊断输出格式（`pretty`、`short`、`arcanist`、`sarif`）。
- `ExecProgramArgs` 支持仅使用 `k_code_list` 运行程序；当显式指定 `--format` 时，未请求的格式编码器会被跳过。

### 📦️ 标准库与三方库

#### 标准库

- 新增内建函数 **`reduce`**，对列表元素累积地施加归约函数。

```kcl
reduce(lambda acc: int, item: int -> int { acc * item }, [2, 3, 4])  # 24
```

- 新增 `json` 模块函数 **`merge`**，实现 [RFC 7396 JSON Merge Patch](https://datatracker.ietf.org/doc/html/rfc7396)。patch 中值为 `None` / `Undefined` 的键会被删除，字典按字段递归合并，其他值直接替换原值。

```kcl
import json

result = json.merge({a = 1, b = {c = 2}}, {b = {c = None, d = 3}})
# {"a": 1, "b": {"d": 3}}
```

- 新增 `file` 模块函数 **`readbase64`**，以原始字节读取文件并以 base64 字符串返回内容，可安全处理图片等非 UTF-8 文件。
- 新增 `net` 模块函数 **`is_IPv6`**；`to_IP16` 重命名为 **`to_IP6`**，并修正对 IPv4-mapped IPv6 地址的转换。
- `datetime.now` 接受可选的 **`ticks`** 参数，可用于格式化任意 epoch（自 Unix 纪元起的秒数），而不再仅限于当前时间；同时增强了 `datetime` 的日期校验。
- 修复了 `net.to_IP4` / `to_IP6` 的解析问题，并明确了 `crypto` 模块文档中说明的 UUID 版本。

#### 三方库

- `k8s` 包在 1.14 - 1.31 之间收到了一系列补丁版本更新，并修正了 apimachinery 的 import alias。
- `external-secrets` 升级到 2.9.0。
- 更新了多个 Crossplane provider，包括 `crossplane_provider_keycloak` v2.24.1、`crossplane-provider-kubernetes` v1.2.1、`crossplane-provider-openstack` v0.10.0 以及 `crossplane-provider-http` v1.0.14（含 cluster / namespaced 结构）。
- `git-promoter` 更新到 0.36.0。

### ☸️ 生态集成

- [Upbound](https://www.upbound.io/) 已被加入 [ADOPTERS.md](https://github.com/kcl-lang/kcl/blob/main/ADOPTERS.md)。
- 新增 [KubeStellar Console](https://kubestellar.io/) 的引导式安装参考。

### 📖 文档更新

- 语言规范文档新增配置项简写、Lambda 参数花括号、多行字符串去缩进、列表/字典/Schema 上的 `!=` 语义，以及选择子表达式作为量词迭代目标等说明。
- 系统包参考文档新增 `reduce`、`json.merge`、`file.readbase64`、`net.is_IPv6`、`net.to_IP6` 与 `datetime.now(ticks)` 等函数说明。
- 多语言 API 参考已与 v0.13.0 Protobuf 服务定义同步，包括 `GetSchemaTypeMappingUnderPath` 与测试覆盖率消息，并重新生成了 Go API 参考。
- CLI 参考文档新增 `kcl fmt` 的 `--dry-run` 参数、`kcl lint` 的 `./...` 模式，以及 `kcl run` 与 `kcl vet` 的最新参数与示例。

## 🌐 其他资源

🔥 了解并加入 [KCL 社区](https://github.com/kcl-lang/community) 🔥

更多资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)