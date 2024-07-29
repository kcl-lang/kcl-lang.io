---
sidebar_position: 12
---

# WASM API

KCL 核心用 Rust 编写，可以使用 cargo 等工具链编译到 `wasm-wasi` 目标。在 WASM 的帮助下，也可以轻松实现多语言和浏览器集成。以下是在 Node.js 环境, Go 和 Rust 中使用 KCL WASM 模块的方法。

## 快速开始

可以从[这里](https://github.com/kcl-lang/lib/tree/main/wasm)找到 KCL WASM 模块。

## Node.js

安装依赖：

```shell
npm install @kcl-lang/wasm-lib
```

编写代码：

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

输出结果为：

```yaml
p:
  name: Alice
```

## Rust

在 Rust 中，我们以 `wasmtime` 为例，当然你也可以使用其他支持 WASI 的运行时来完成这一任务。

安装依赖：

```shell
cargo add kcl-wasm-lib --git https://github.com/kcl-lang/lib
cargo add anyhow
```

编写代码：

```rust
use anyhow::Result;
use kcl_wasm_lib::{KCLModule, RunOptions};

fn main() -> Result<()> {
    let opts = RunOptions {
        filename: "test.k".to_string(),
        source: "a = 1".to_string(),
    };
    // 注意修改路径为你的 kcl.wasm 路径
    let mut module = KCLModule::from_path("path/to/kcl.wasm")?;
    let result = module.run(&opts)?;
    println!("{}", result);
    Ok(())
}
```

输出结果为：

```yaml
a: 1
```

## Go

在 Go 中，我们以 `wasmtime` 为例，当然你也可以使用其他支持 WASI 的运行时来完成这一任务。

编写代码，关于包 `github.com/kcl-lang/wasm-lib/pkg/module` 的代码可以在[这里](https://github.com/kcl-lang/lib/blob/main/wasm/examples/go/pkg/module/module.go)找到。

```rust
package main

import (
	"fmt"

	"github.com/kcl-lang/wasm-lib/pkg/module"
)

func main() {
	m, err := module.New("path/to/kcl.wasm")
	if err != nil {
		panic(err)
	}
	result, err := m.Run(&module.RunOptions{
		Filename: "test.k",
		Source:   "a = 1",
	})
	if err != nil {
		panic(err)
	}
	fmt.Println(result)
}
```

输出结果为：

```yaml
a: 1
```
