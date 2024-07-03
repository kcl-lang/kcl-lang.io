---
sidebar_position: 10
---

# WASM API

The KCL core is written by Rust and can be compiled to the `wasm-wasi` target using toolchains such as cargo. With the help of WASM, we can also easily achieve multilingual and browser integration. Here is how we can use the KCL WASM module in node environment and rust.

## Quick Start

We can find and download KCL WASM module from [here](https://github.com/kcl-lang/lib/tree/main/wasm)

## Node.js

Install the dependency

```shell
npm install @kcl-lang/wasm-lib
```

Write the code

```typescript
import { load, invokeKCLRun } from "@kcl-lang/wasm-lib";

async function main() {
  const inst = await load();
  const result = invokeKCLRun(inst, {
    filename: "test.k",
    source: `
schema Person:
  name: str

p = Person {name = "Alice"}`,
  });
  console.log(result);
}

main();
```

The output is

```yaml
p:
  name: Alice
```

## Rust

In Rust, we use `wasmtime` as an example, and of course, you can also use other runtime that supports WASI to accomplish this.

Install the dependency

```shell
cargo add kcl-wasm-lib --git https://github.com/kcl-lang/lib
cargo add anyhow
```

Write the code

```rust
use anyhow::Result;
use kcl_wasm_lib::{KCLModule, RunOptions};

fn main() -> Result<()> {
    let opts = RunOptions {
        filename: "test.k".to_string(),
        source: "a = 1".to_string(),
    };
    // Note replace your KCL wasm module path.
    let mut module = KCLModule::from_path("path/to/kcl.wasm")?;
    let result = module.run(&opts)?;
    println!("{}", result);
    Ok(())
}
```

The output is

```yaml
a: 1
```
