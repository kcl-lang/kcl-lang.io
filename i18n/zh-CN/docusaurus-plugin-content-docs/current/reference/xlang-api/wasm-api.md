---
sidebar_position: 13
---

# WASM API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，其中包含 `call_native`、`"ERROR:"` 前缀、**16 MiB** 的 `DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE` 以及 4 KiB 的 `RUNTIME_ERR_BUFFER_SIZE`。`@kcl-lib/wasm` 包是该 wasm guest 的 TypeScript 封装层。

官方 WASM 模块以 npm 包
[`@kcl-lib/wasm`](https://www.npmjs.com/package/@kcl-lib/wasm) 形式发布
（`@kcl-lang/wasm-lib` 是 v0.12.x 时期的名称；v0.13.0 版本已更名为
`@kcl-lib/wasm`）。该包内置了预构建的 `kcl.wasm` 工件、TypeScript 加载器，
以及根据 `spec/spec.proto` 自动生成的完整类型化 RPC 接口。

## 安装

```shell
npm install @kcl-lib/wasm
```

这是唯一的运行时依赖。该包同时内置了 `kcl.wasm` 工件（`files: ["kcl.wasm", "dist/"]`）
以及编译产物 `dist/index.js` / `dist/index.d.ts`——无需 `protoc`，也无需 Rust 工具链。

## 快速开始（Node.js）

```typescript
import { load, execProgram } from "@kcl-lib/wasm";

async function main() {
  const inst = await load();
  const result = execProgram(inst, {
    kFilenameList: ["schema.k"],
  });
  console.log(result.yamlResult);
}

main();
```

## 加载

```typescript
export async function load(opts?: KCLWasmLoadOptions): Promise<WebAssembly.Instance>
```

`KCLWasmLoadOptions`：

| 字段         | 类型                           | 默认值                            | 用途                                                                       |
| ---------- | ----------------------------- | -------------------------------- | ----------------------------------------------------------------------- |
| `imports`  | `Record<string, any>`         | `{ wasi_snapshot_preview1: … }`  | 传递给 WASI 实例的额外宿主导入。                                                     |
| `preopens` | `Record<string, string>`      | `{ ".": "/" }`                   | 将 guest 路径映射到宿主文件系统路径（仅在使用 `fs` 时有效）。                                |
| `env`      | `Record<string, string>`       | `{}`                             | 为 WASI 实例提供的额外环境变量。                                                     |
| `fs`       | `MemFS`（wasmer/wasi）         | 基于 `node:fs` 的 `MemFS`         | 为 WASI 沙箱提供文件系统支持。                                                       |
| `data`     | `BufferSource`                | 从磁盘读取 `kcl.wasm`                | 预加载的 wasm 字节（可跳过磁盘读取步骤）。                                                |
| `log`      | `(...args) => void`           | noop                             | 用于输出诊断信息的日志记录器。                                                         |

```typescript
const inst = await load({
  preopens: { "/sandbox": process.cwd() },
  env: { KCL_FOO: "bar" },
});
```

## 高级辅助函数（用于一次性 `kcl run` 风格的调用）

这些封装函数会在内存中构建源文件，并在内部调用
`execProgram` / `formatCode` 等方法。当你只想执行一段代码片段时，这些函数非常实用。

```typescript
export function invokeKCLRun(inst, opts: RunOptions): ExecProgramResult
export function invokeKCLRunWithLogMessage(inst, opts: RunWithLogMessageOptions): …
export function invokeKCLFmt(inst, opts: FmtOptions): FormatCodeResult
export function invokeKCLVersion(inst): string
export function invokeKCLCall(inst, opts: CallOptions): string
export function invokeKCLCallNative(inst, opts: CallNativeOptions): Uint8Array
```

最简单的端到端调用示例：

```typescript
import { load, invokeKCLRun } from "@kcl-lib/wasm";

const inst = await load();
const out = invokeKCLRun(inst, {
  filename: "test.k",
  source: `
schema Person:
  name: str

p = Person {name = "Alice"}
  `,
});
console.log(out.yamlResult);
// p:
//   name: Alice
```

## 类型化 RPC 接口（`api.ts`）

`spec/spec.proto` 中的每个服务方法都在 `api.ts` 中提供了类型化封装。
所有封装函数都接收一个由 `load()` 返回的 `WebAssembly.Instance` 以及一个类型化的参数对象，
并返回一个类型化的结果。

### `ping(inst, args?)`

```typescript
const r = ping(inst, { value: "hello" });
assert(r.value === "hello");
```

### `getVersion(inst)`

```typescript
const v = getVersion(inst);
console.log(v.version, v.gitSha, v.checksum);
```

### `parseProgram(inst, args)` / `parseFile(inst, args)`

解析 KCL 源码，并以 JSON 字符串的形式返回 AST。

```typescript
const parsed = parseFile(inst, { path: "schema.k" });
console.log(parsed.astJson, parsed.errors);
```

### `loadPackage(inst, args)`

执行「解析 + 解析」，返回 AST、符号、作用域以及类型表。该方法开销较大；
如果你只需要符号信息，请传入 `resolveAst: false`。

### `execProgram(inst, args)`

```typescript
const result = execProgram(inst, {
  kFilenameList: ["schema.k"],
  format: "yaml",              // 跳过 JSON 编码器
  errorFormat: "sarif",        // 输出机器可读的诊断信息
  sourcemapOutput: "./out.json",  // v0.13.0 Source Map v3 输出
});
console.log(result.yamlResult);
console.log(result.sourcemap);   // v0.13.0
```

### `overrideFile(inst, args)`

应用 `*-override` 规约；该方法会直接修改磁盘上的文件。

### `listVariables(inst, args)` / `listOptions(inst, args)`

内省辅助函数。`listOptions` 接受 `ParseProgramArgs` 参数，因为该规约复用了
`ParseProgram` 来处理此 RPC。

### `getSchemaTypeMapping(inst, args)`

将 `__main__` 下的所有 schema 展平。

### `getSchemaTypeMappingUnderPath(inst, args)`

v0.13.0 新增（修复了
[kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546)）；
让每个 `kcl.mod` 依赖都保留各自的包名。

### `formatPath(inst, args)` / `lintPath(inst, args)` / `validateCode(inst, args)` / `loadSettingsFiles(inst, args)`

标准的 `KclService` 方法。`formatPath` 和 `lintPath` 接收 WASI 文件系统上的路径
（参见 `preopens`）；`validateCode` 用于根据 KCL 源码中声明的 schema 校验 YAML/JSON 数据字符串。

### `rename(inst, args)` / `renameCode(inst, args)`

`rename` 会重写磁盘上的文件；`renameCode` 则以 Map 的形式返回修改后的源码，而不会触碰文件系统。

### `test(inst, args)`

跨指定包运行 `_test.*` 函数。v0.13.0 在 `TestCaseInfo` 中新增了逐用例的行覆盖率信息。

### `updateDependencies(inst, args)`

下载 `kcl.mod` 的依赖图，并返回已解析的外部包。可以将 `external_pkgs` 直接传入后续的
`execProgram` 调用中使用。

## 缓冲区大小

```typescript
const DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE = 16 * 1024 * 1024;   // 16 MiB
const RUNTIME_ERR_BUFFER_SIZE                = 4  * 1024;          // 4 KiB
```

`invokeKCLCallNative` 会分配 `DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE` 字节
用于存放响应。分派器返回其长度；`invokeKcl` 则返回一个大小合适的 `Uint8Array` 视图。
如果你的负载超过 16 MiB，可通过 `CallNativeOptions.resultBuffer` 提供更大的缓冲区：

```typescript
const out = invokeKCLCallNative(inst, {
  name: "KclService.ExecProgram",
  args: encode(args),
  resultBuffer: new Uint8Array(64 * 1024 * 1024),   // 64 MiB
});
```

`RUNTIME_ERR_BUFFER_SIZE` 是当 WASM 模块陷入 trap（panic=abort）时 JS 封装层
所分配的缓冲区，以便通过 `kcl_runtime_err` 导出函数让 wasm guest 将 panic 信息写入其中。
原先的 1024 字节会静默截断任何超过 1 KiB 的错误信息；v0.13.0 绑定将其改为 4096 字节，
以与其他绑定保持一致——详见
[`abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md)。

## 插件代理回调

如果你的 KCL 程序导入了 `kcl_plugin.*`，请向 `load()` 传入一个 `imports` 回调：

```typescript
const inst = await load({
  imports: {
    kcl_plugin_invoke_json_wasm: (methodPtr, argsPtr, kwargsPtr) => {
      const method = readString(methodPtr);
      const args = JSON.parse(readString(argsPtr));
      const kwargs = JSON.parse(readString(kwargsPtr));
      const result = myPlugin[method](args, kwargs);
      return writeString(JSON.stringify(result));
    },
  },
});
```

有关线缆格式，请参见 [`abi.md` §2](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#2-plugin-agent-variant)。

## 浏览器打包器

该包以 `@wasmer/wasi` 作为 WASI polyfill 目标。对于 Webpack/Vite，
请配置打包器以注入 `Buffer`（Webpack 的 `ProvidePlugin`），并将 `@wasmer/wasi` 添加到 externals 中。
一个完整的可运行示例位于
[`wasm/examples/browser`](https://github.com/kcl-lang/lib/tree/main/wasm/examples/browser)。
旧的 npm 包名 `@kcl-lang/wasm-lib`（现已更名为 `@kcl-lib/wasm`）采用了相同的方式；
迁移只需更换包名即可。