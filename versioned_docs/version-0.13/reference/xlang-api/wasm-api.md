---
sidebar_position: 13
---

# WASM API

The KCL core is written by Rust and can be compiled to the `wasm-wasi` target using toolchains such as cargo. With the help of WASM, we can also easily achieve multilingual and browser integration. Here is how we can use the KCL WASM module in Browser, Node.js, Go and Rust.

## Quick Start

We can find and download KCL WASM module from [here](https://github.com/kcl-lang/lib/tree/main/wasm)

## Browser

Install the dependency

```shell
npm install buffer @wasmer/wasi @kcl-lang/wasm-lib
```

> **NOTE:**
> Buffer is required by @wasmer/wasi.

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

Here, we use `webpack` to bundle the website, the `webpack.config.js` config as follows.

> **NOTE:**:
> This configuration includes necessary settings for @wasmer/wasi and other required plugins.

```js
const HtmlWebpackPlugin = require("html-webpack-plugin");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require("path");
const webpack = require("webpack");

const dist = path.resolve("./dist");
const isProduction = process.argv.some((x) => x === "--mode=production");
const hash = isProduction ? ".[contenthash]" : "";

module.exports = {
  mode: "development",
  entry: {
    main: "./src/main.ts",
  },
  target: "web",
  output: {
    path: dist,
    filename: `[name]${hash}.js`,
    clean: true,
  },
  devServer: {
    hot: true,
    port: 9000,
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, "css-loader"],
      },
      {
        test: /\.m?js$/,
        resourceQuery: { not: [/(raw|wasm)/] },
      },
      {
        resourceQuery: /raw/,
        type: "asset/source",
      },
      {
        resourceQuery: /wasm/,
        type: "asset/resource",
        generator: {
          filename: "wasm/[name][ext]",
        },
      },
    ],
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, "./src/index.html"),
    }),
    new webpack.IgnorePlugin({
      resourceRegExp: /^(path|ws|crypto|fs|os|util|node-fetch)$/,
    }),
    // needed by @wasmer/wasi
    new webpack.ProvidePlugin({
      Buffer: ["buffer", "Buffer"],
    }),
  ],
  externals: {
    // needed by @wasmer/wasi
    "wasmer_wasi_js_bg.wasm": true,
  },
  resolve: {
    fallback: {
      // needed by @wasmer/wasi
      buffer: require.resolve("buffer/"),
    },
  },
};
```

For a complete working example, refer to [here](https://github.com/kcl-lang/lib/tree/main/wasm/examples/browser).

### Troubleshooting

If you encounter any issues, make sure:

- All dependencies are correctly installed.
- Your `webpack.config.js` is properly set up.
- You're using a modern browser that supports WebAssembly.
- The KCL WASM module is correctly loaded and accessible.

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

The code example can be found [here](https://github.com/kcl-lang/lib/tree/main/wasm/examples/node).

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

The code example can be found [here](https://github.com/kcl-lang/lib/tree/main/wasm/examples/rust).

## Go

In Go, we use `wasmtime` as an example, and of course, you can also use other runtime that supports WASI to accomplish this.

Write the code, and the code of package `github.com/kcl-lang/wasm-lib/pkg/module` can be found [here](https://github.com/kcl-lang/lib/blob/main/wasm/examples/go/pkg/module/module.go)

```go
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

The output is

```yaml
a: 1
```

The code example can be found [here](https://github.com/kcl-lang/lib/tree/main/wasm/examples/go).
