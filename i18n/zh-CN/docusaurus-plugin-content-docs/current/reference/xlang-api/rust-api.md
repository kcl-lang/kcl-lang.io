---
sidebar_position: 7
---

# Rust API

## 添加依赖

```shell
cargo add --git https://github.com/kcl-lang/lib
```

## 快速开始

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


更多 Rust API 可以在[这里](https://github.com/kcl-lang/kcl)找到. 如果您想使用KCL Rust API 的子 crate，可以运行以下命令 (以 kclvm-runtime 为例)。

```shell
# Take the kclvm-runtime as an example.
cargo add --git https://github.com/kcl-lang/kcl kclvm-runtime
```
