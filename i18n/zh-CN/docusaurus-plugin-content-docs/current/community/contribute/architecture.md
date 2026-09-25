---
sidebar_position: 3
---

# 架构：组件依赖关系图

本文说明 KCL 各主要仓库之间的依赖关系，面向希望了解「某个功能在哪个仓库、PR 应该提到哪里」的开发者。

## 仓库及职责

| 仓库 | 语言 | 职责 |
|---|---|---|
| [kcl-lang/kcl](https://github.com/kcl-lang/kcl) | Rust | 编译器核心：以一组 `kcl-*` Rust crates（`kcl-lib`、`kcl-sema`、`kcl-evaluator`、`kcl-parser` 等）实现解析、语义分析和求值器。`kcl-lib` crate 构建 Rust API 和动态库（`libkcl.so` / `libkcl.dylib` / `kcl.dll`）。同时发布 `kcl-language-server`、`kcl-fmt`、`kcl-vet` 和 `kcl-test`。 |
| [kcl-lang/lib](https://github.com/kcl-lang/lib) | Go（内嵌） | 为各支持的操作系统/架构预编译的 `libkcl` 动态库（`libkcl.so` / `libkcl.dylib` / `kcl.dll`），以 `kcl-lang.io/lib` Go module 的形式发布。 |
| [kcl-lang/kcl-go](https://github.com/kcl-lang/kcl-go) | Go | Go SDK。通过 cgo 和内嵌的动态库调用 Rust 核心，提供 `Run`/`Test`/`Format`/`Vet`/`Validate`/`ListVariables` 等 API，是绝大多数下游工具的基础。 |
| [kcl-lang/kpm](https://github.com/kcl-lang/kpm) | Go | KCL 包管理器（`kcl mod ...`）。依赖 kcl-go，因此传递依赖 libkcl。 |
| [kcl-lang/cli](https://github.com/kcl-lang/cli) | Go | 面向用户的 `kcl` 命令。内嵌 kcl-go（run/test/fmt/vet/...）和 kpm（mod/init/registry...）。 |
| [kcl-lang/kcl-openapi](https://github.com/kcl-lang/kcl-openapi) | Go | OpenAPI / JSON Schema 与 KCL schema 之间的转换，供导入工具使用。 |
| [kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin) | Go | 用 Go 编写 KCL 插件的 SDK。 |

## 依赖关系图

```
                      +-------------------------------+
                      |      kcl-lang/kcl (Rust)      |
                      |  kcl-* crates: 解析/语义分析/  |
                      |  求值器; libkcl cdylib        |
                      |  kcl-language-server, kcl-fmt |
                      +---------------+---------------+
                                      | 构建
                                      v
                      +-------------------------------+
                      |  kcl-lang/lib: 按 OS/架构     |
                      |  预编译的 libkcl              |
                      +---------------+---------------+
                                      | cgo 内嵌 (kcl-lang.io/lib)
                                      v
              +-------------------------------------------+
              |      kcl-lang.io/kcl-go (Go SDK)          |
              |  Run/Test/Format/Vet/Validate/...         |
              +-------+---------------------------+-------+
                      |                           |
              +-------v------+          +---------v--------+
              | kcl-lang.io/ |          | kcl-lang.io/cli  |
              | kpm (kcl mod)|          |  (kcl 命令行)    |
              +--------------+          +---------+--------+
                                                  | 使用
        +---------------------------+-------------+----------------+
        v                           v                              v
 kcl-lang.io/kcl-openapi    kcl-lang.io/kcl-plugin    kcl-operator、helm-kcl、
 (OpenAPI <-> KCL schema)   (Go 插件 SDK)             crossplane-kcl、IDE 插件等
```

## 如何理解这张图

- **所有执行路径最终都落到 Rust 核心。** 每一条 `kcl` 命令、每一次 Go API 调用、每一次 IDE 操作，最终都由 `kcl-lang/kcl` 中的求值器完成——要么通过 `libkcl` CLI 驱动，要么通过 cgo + `kcl-lib` crate 构建的 `libkcl` 动态库。
- **kcl-go 是 Go 生态的唯一集成点。** kpm、`kcl` CLI 以及 kcl-operator 等第三方工具都依赖它，因此在 kcl-go 中的 SDK 级修复会随下一次发布传播到所有下游工具。
- **版本号同步演进。** 各 Go module（`kcl-lang.io/kcl-go`、`kcl-lang.io/kpm` 等）的发布版本与 KCL 编译器版本保持一致，因此 `kcl-go v0.12.x` 搭配 `v0.12.x` 的编译器核心及 kcl-lang/lib 中对应的 `libkcl` 二进制。
- **不同改动应该提到哪里：**
  - 语言特性、求值器、LSP、fmt/vet 规则 → [kcl-lang/kcl](https://github.com/kcl-lang/kcl/blob/main/docs/dev_guide/1.about_this_guide.md)（语言变更需走 KEP 流程）。
  - Go API 形态、Go 程序看到的 `kcl run` 行为 → [kcl-lang/kcl-go](https://github.com/kcl-lang/kcl-go)。
  - `kcl mod`、OCI 打包、registry 客户端 → [kcl-lang/kpm](https://github.com/kcl-lang/kpm)。
  - CLI 参数、命令组织、`kcl` 二进制的发布打包 → [kcl-lang/cli](https://github.com/kcl-lang/cli)。

完整的工作流程参见[如何贡献代码](./contribute-code.md)。

---

*基于 [kcl-lang/kcl-lang.io#485](https://github.com/kcl-lang/kcl-lang.io/issues/485) 补充。*
