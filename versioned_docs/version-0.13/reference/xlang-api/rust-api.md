---
sidebar_position: 7
---

# Rust API

> **Looking for the cross-language FFI contract?**
> See [`./ffi-abi.md`](./ffi-abi.md) for `call`, the `"ERROR:"` prefix,
> the **4 MiB** `BUFFER_SIZE`, and the `kcl_api` crate. The Rust binding
> lives in the main `kcl-lang/kcl` repo (not in the `kcl-lang/lib`
> monorepo), and is the only binding that runs **in-process** — there is
> no cdylib hop.

The [Rust binding](https://github.com/kcl-lang/kcl/tree/main/kclvm/compiler/sema/service)
ships as the `kcl-api` crate (re-exported through `kcl-lang`) from the
main [`kcl-lang/kcl`](https://github.com/kcl-lang/kcl) repository,
**not** from the [`kcl-lang/lib`](https://github.com/kcl-lang/lib)
monorepo. The latter only holds the out-of-process cdylib bindings. As
a result, this page is **informational** — see the kcl-lang/kcl docs
for canonical Rust API references.

Two layers are exposed:

- **`kclvm_parser`** / **`kclvm_runner`** — sub-crates around the parser
  and evaluator. Use these if you want lower-level control.
- **`kcl_lang::*`** — high-level façade mirroring the Python
  `kcl_lib.kcl` SDK. Provides `API::default()` plus typed `*Args` /
  `*Result` structs generated from `spec/spec.proto`.

## Installation

```shell
cargo add kcl-lang --git https://github.com/kcl-lang/kcl
```

(Don't `cargo add` from `kcl-lang/lib` — the Rust binding lives in
`kcl-lang/kcl`. The `lib` monorepo only ships cdylib bindings for
other languages.)

To use a sub-crate of the KCL Rust core:

```shell
# Take the kcl-runtime crate as an example.
cargo add --git https://github.com/kcl-lang/kcl kcl-runtime
```

## Quick Start

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

## API Reference

### exec_program

Execute KCL file with args.

<details><summary>Example</summary>
<p>

```rust
use kcl_lang::*;
use std::path::Path;
// File case
let serv = API::default();
let args = &ExecProgramArgs {
    work_dir: Path::new(".").join("src").join("testdata").canonicalize().unwrap().display().to_string(),
    k_filename_list: vec!["test.k".to_string()],
    ..Default::default()
};
let exec_result = serv.exec_program(args).unwrap();
assert_eq!(exec_result.yaml_result, "alice:\n  age: 18");

// Code case
let args = &ExecProgramArgs {
    k_filename_list: vec!["file.k".to_string()],
    k_code_list: vec!["alice = {age = 18}".to_string()],
    ..Default::default()
};
let exec_result = serv.exec_program(args).unwrap();
assert_eq!(exec_result.yaml_result, "alice:\n  age: 18");

// Error case
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

Service for formatting a code source and returns the formatted source and whether the source is changed.

<details><summary>Example</summary>
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

Service for formatting kcl file or directory path contains kcl files and returns the changed file paths.

<details><summary>Example</summary>
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

Service for KCL Lint API, check a set of files, skips execute, returns error message including errors and warnings.

<details><summary>Example</summary>
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

Service for validating the data string using the schema code string, when the parameter schema is omitted, use the first schema appeared in the kcl code.

<details><summary>Example</summary>
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

Service for building setting file config from args.

<details><summary>Example</summary>
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

Service for renaming all the occurrences of the target symbol in the files. This API will rewrite files if they contain symbols to be renamed. return the file paths got changed.

<details><summary>Example</summary>
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

Service for renaming all the occurrences of the target symbol and rename them. This API won’t rewrite files but return the modified code if any code has been changed. return the changed code.

<details><summary>Example</summary>
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

Service for the testing tool.

<details><summary>Example</summary>
<p>

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.test(&TestArgs {
    pkg_list: vec!["./src/testdata/testing/module/...".to_string()],
    ..TestArgs::default()
}).unwrap();
assert_eq!(result.info.len(), 2);
// Passed case
assert!(result.info[0].error.is_empty());
// Failed case
assert!(result.info[1].error.is_empty());
```

</p>
</details>

### update_dependencies

update_dependencies provides users with the ability to update kcl module dependencies.

<details><summary>Example</summary>
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

Return the KCL service version information.

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.get_version().unwrap();
assert!(!result.version.is_empty());
assert!(!result.git_sha.is_empty());
assert!(!result.checksum.is_empty());
```

### ping

Round-trip a value through the dispatcher.

```rust
use kcl_lang::*;

let serv = API::default();
let result = serv.ping(&PingArgs { value: "hello".into() }).unwrap();
assert_eq!(result.value, "hello");
```

### list_method

List the KCL service method names supported by the underlying runtime.

```rust
use kcl_lang::*;

let serv = API::default();
for name in serv.list_method().unwrap().method_name_list {
    println!("{}", name);
}
```

## Notes

The legacy `BuildProgram` and `ExecArtifact` RPCs were removed from
`spec/spec.proto` in v0.13.0 (see
[lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac));
they are no longer recognised by the dispatcher. If you previously
called `serv.build_program(...)` or `serv.exec_artifact(...)`, switch to
`serv.exec_program(...)`.

The remaining `*_program`, `parse_*`, `list_*`, `get_schema_type_*`,
`format_*`, `lint_path`, `validate_code`, `load_settings_files`,
`rename*`, `test`, `override_file` methods are documented above or in
the linked kcl-lang/kcl examples — see the per-method sections in this
file for usage patterns.
