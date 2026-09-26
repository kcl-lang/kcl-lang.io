---
sidebar_position: 7
---

# Rust API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md) 以了解 `call`、`"ERROR:"` 前缀、
> **4 MiB** 的 `BUFFER_SIZE`，以及 `kcl_api` crate。Rust 绑定
> 位于主 `kcl-lang/kcl` 仓库中（不在 `kcl-lang/lib` monorepo 中），
> 并且是唯一**进程内（in-process）**运行的绑定——它不会经过 cdylib 跳转。

[Rust 绑定](https://github.com/kcl-lang/kcl/tree/main/kclvm/compiler/sema/service)
以 `kcl-api` crate 的形式发布（通过 `kcl-lang` 重新导出），来自主仓库
[`kcl-lang/kcl`](https://github.com/kcl-lang/kcl)，
而**不是**来自 [`kcl-lang/lib`](https://github.com/kcl-lang/lib) monorepo。
后者仅包含进程外的 cdylib 绑定。因此，本页面仅作**信息参考**——
权威的 Rust API 参考文档请参阅 kcl-lang/kcl 文档。

该绑定暴露了两层 API：

- **`kclvm_parser`** / **`kclvm_runner`** —— 围绕解析器和求值器的子 crate。
  如果你需要更底层的控制，请使用这些。
- **`kcl_lang::*`** —— 高级外观层，镜像 Python 的
  `kcl_lib.kcl` SDK。提供 `API::default()`，以及从 `spec/spec.proto` 生成的
  类型化 `*Args` / `*Result` 结构体。

## 安装

```shell
cargo add kcl-lang --git https://github.com/kcl-lang/kcl
```

（不要从 `kcl-lang/lib` 执行 `cargo add`——Rust 绑定位于
`kcl-lang/kcl`。`lib` monorepo 仅发布供其他语言使用的 cdylib 绑定。）

若要使用 KCL Rust 核心的某个子 crate：

```shell
# 以 kcl-runtime crate 为例。
cargo add --git https://github.com/kcl-lang/kcl kcl-runtime
```

## 快速上手

```rust
use kcl_lang::*;
use anyhow::Result;

fn main() -> Result<()> {
    let api = API::default();
    let args = &ExecProgramArgs {
        k_filename_list: vec!["main.k".to_string()],
        k_code_list: vec!["a = 1".to_string()],
        ..Default::default()
    };
    let exec_result = api.exec_program(args)?;
    println!("{}", exec_result.yaml_result);
    Ok(())
}
```

## API 参考

### exec_program

使用给定参数执行 KCL 文件。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;
use std::path::Path;
// 文件用例
let serv = API::default();
let args = &ExecProgramArgs {
    work_dir: Path::new(".").join("src").join("testdata").canonicalize().unwrap().display().to_string(),
    k_filename_list: vec!["test.k".to_string()],
    ..Default::default()
};
let exec_result = serv.exec_program(args).unwrap();
assert_eq!(exec_result.yaml_result, "alice:\n  age: 18");

// 代码用例
let args = &ExecProgramArgs {
    k_filename_list: vec!["file.k".to_string()],
    k_code_list: vec!["alice = {age = 18}".to_string()],
    ..Default::default()
};
let exec_result = serv.exec_program(args).unwrap();
assert_eq!(exec_result.yaml_result, "alice:\n  age: 18");

// 错误用例
let args = &ExecProgramArgs {
    k_filename_list: vec!["invalid_file.k".to_string()],
    ..Default::default()
};
let error = serv.exec_program(args).unwrap_err();
assert!(error.to_string().contains("Cannot find the kcl file"), "{error}");

let args = &ExecProgramArgs {
    k_filename_list: vec![],
    ..Default::default()
};
let error = serv.exec_program(args).unwrap_err();
assert!(error.to_string().contains("No input KCL files or paths"), "{error}");
```

</p>
</details>

### format_code

格式化代码源的服务，返回格式化后的源码以及源码是否被修改。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let source = r#"schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}

"#.to_string();
let result = serv.format_code(&FormatCodeArgs {
    source: source.clone(),
    ..Default::default()
}).unwrap();
assert_eq!(result.formatted, source.as_bytes().to_vec());
```

</p>
</details>

### format_path

格式化 KCL 文件或包含 KCL 文件的目录路径的服务，并返回被修改的文件路径。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.format_path(&FormatPathArgs {
    path: "./src/testdata/test.k".to_string(),
    ..Default::default()
}).unwrap();
assert!(result.changed_paths.is_empty());
```

</p>
</details>

### lint_path

KCL Lint API 服务，检查一组文件，跳过执行，返回包含错误和警告的错误信息。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.lint_path(&LintPathArgs {
    paths: vec!["./src/testdata/test-lint.k".to_string()],
    ..Default::default()
}).unwrap();
assert_eq!(result.results, vec!["Module 'math' imported but unused".to_string()]);
```

</p>
</details>

### validate_code

使用 schema 代码字符串验证数据字符串的服务。当省略 schema 参数时，
使用 KCL 代码中出现的第一个 schema。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let code = r#"
schema Person:
    name: str
    age: int

    check:
        0 < age < 120
"#.to_string();
let data = r#"
{
    "name": "Alice",
    "age": 10
}
"#.to_string();
let result = serv.validate_code(&ValidateCodeArgs {
    code,
    data,
    ..Default::default()
}).unwrap();
assert_eq!(result.success, true);
```

</p>
</details>

### load_settings_files

从参数构建配置文件（settings file）配置的服务。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.load_settings_files(&LoadSettingsFilesArgs {
    files: vec!["./src/testdata/settings/kcl.yaml".to_string()],
    work_dir: "./src/testdata/settings".to_string(),
    ..Default::default()
}).unwrap();
assert_eq!(result.kcl_options.len(), 1);
```

</p>
</details>

### rename

重命名文件中所有目标符号出现位置的服务。如果文件中包含需要重命名的符号，
此 API 会重写文件。返回被修改的文件路径。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let result = serv.rename(&RenameArgs {
    package_root: "./src/testdata/rename_doc".to_string(),
    symbol_path: "a".to_string(),
    file_paths: vec!["./src/testdata/rename_doc/main.k".to_string()],
    new_name: "a2".to_string(),
}).unwrap();
assert_eq!(result.changed_files.len(), 1);
```

</p>
</details>

### rename_code

重命名所有目标符号出现位置并对其进行重命名的服务。此 API 不会重写文件，
但如果代码有变更，会返回修改后的代码。返回被修改的代码。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.rename_code(&RenameCodeArgs {
    package_root: "/mock/path".to_string(),
    symbol_path: "a".to_string(),
    source_codes: vec![("/mock/path/main.k".to_string(), "a = 1\nb = a".to_string())].into_iter().collect(),
    new_name: "a2".to_string(),
}).unwrap();
assert_eq!(result.changed_codes.len(), 1);
assert_eq!(result.changed_codes.get("/mock/path/main.k").unwrap(), "a2 = 1\nb = a2");
```

</p>
</details>

### test

测试工具的服务。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.test(&TestArgs {
    pkg_list: vec!["./src/testdata/testing/module/...".to_string()],
    ..TestArgs::default()
}).unwrap();
assert_eq!(result.info.len(), 2);
// 通过的用例
assert!(result.info[0].error.is_empty());
// 失败的用例
assert!(result.info[1].error.is_empty());
```

</p>
</details>

### update_dependencies

`update_dependencies` 为用户提供更新 KCL 模块依赖的能力。

<details><summary>示例</summary>
<p>

```rust
use kcl_lang::*;
use std::path::Path;
use std::fs::remove_dir_all;

let serv = API::default();
let result = serv.update_dependencies(&UpdateDependenciesArgs {
    manifest_path: "./src/testdata/update_dependencies".to_string(),
    ..Default::default()
}).unwrap();
assert_eq!(result.external_pkgs.len(), 1);

let result = serv.update_dependencies(&UpdateDependenciesArgs {
    manifest_path: "./src/testdata/update_dependencies".to_string(),
    vendor: true,
}).unwrap();
assert_eq!(result.external_pkgs.len(), 1);
let vendor_path = Path::new("./src/testdata/update_dependencies/vendor");
remove_dir_all(vendor_path);
```

</p>
</details>

### get_version

返回 KCL 服务的版本信息。

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.get_version().unwrap();
assert!(!result.version.is_empty());
assert!(!result.git_sha.is_empty());
assert!(!result.checksum.is_empty());
```

### ping

通过调度器对一个值进行往返（round-trip）。

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.ping(&PingArgs { value: "hello".into() }).unwrap();
assert_eq!(result.value, "hello");
```

### list_method

列出底层运行时支持的 KCL 服务方法名。

```rust
use kcl_lang::*;

let serv = API::default();
for name in serv.list_method().unwrap().method_name_list {
    println!("{}", name);
}
```

## 注意事项

旧的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 中从
`spec/spec.proto` 中移除（参见
[lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；
调度器已不再识别它们。如果你之前调用过 `serv.build_program(...)`
或 `serv.exec_artifact(...)`，请改用 `serv.exec_program(...)`。

其余的 `*_program`、`parse_*`、`list_*`、`get_schema_type_*`、
`format_*`、`lint_path`、`validate_code`、`load_settings_files`、
`rename*`、`test`、`override_file` 方法的文档见上文或
kcl-lang/kcl 中的相关示例——请参阅本文件中每个方法对应章节了解使用方式。

</details>