---
sidebar_position: 13
---

# WASM API

> **Looking for the cross-language FFI contract?**
> See [`./ffi-abi.md`](./ffi-abi.md) for `call_native`, the `"ERROR:"`
> prefix, the **16 MiB** `DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE`, and
> the 4 KiB `RUNTIME_ERR_BUFFER_SIZE`. The `@kcl-lib/wasm` package is a
> TypeScript wrapper around that wasm guest.

The official WASM module ships as the npm package
[`@kcl-lib/wasm`](https://www.npmjs.com/package/@kcl-lib/wasm)
(`@kcl-lang/wasm-lib` was the v0.12.x name; the v0.13.0 package is
`@kcl-lib/wasm`). It bundles the prebuilt `kcl.wasm` artifact plus a
TypeScript loader and the full typed RPC surface generated from
`spec/spec.proto`.

## Installation

```shell
npm install @kcl-lib/wasm
```

That's the only runtime dependency. The package bundles both the
`kcl.wasm` artifact (`files: ["kcl.wasm", "dist/"]`) and the compiled
`dist/index.js` / `dist/index.d.ts` — no `protoc`, no Rust toolchain
required.

## Quick Start (Node.js)

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

## Loading

```typescript
export async function load(opts?: KCLWasmLoadOptions): Promise<WebAssembly.Instance>
```

`KCLWasmLoadOptions`:

| Field      | Type                          | Default                          | Purpose                                                                  |
| ---------- | ----------------------------- | -------------------------------- | ----------------------------------------------------------------------- |
| `imports`  | `Record<string, any>`         | `{ wasi_snapshot_preview1: … }`  | Extra host imports passed to the WASI instance.                         |
| `preopens` | `Record<string, string>`      | `{ ".": "/" }`                   | Maps guest paths to host filesystem paths (only relevant with `fs`).   |
| `env`      | `Record<string, string>`       | `{}`                             | Extra env vars for the WASI instance.                                    |
| `fs`       | `MemFS` (wasmer/wasi)         | `node:fs`-backed `MemFS`         | Filesystem backing the WASI sandbox.                                     |
| `data`     | `BufferSource`                | read `kcl.wasm` from disk        | Pre-loaded wasm bytes (skips the disk read).                            |
| `log`      | `(...args) => void`           | noop                             | Logger used for diagnostic messages.                                     |

```typescript
const inst = await load({
  preopens: { "/sandbox": process.cwd() },
  env: { KCL_FOO: "bar" },
});
```

## High-level helpers (for one-shot `kcl run`-style invocations)

These wrappers build an in-memory source file and call
`execProgram`/`formatCode`/etc. internally. Useful when you just want
to evaluate a snippet.

```typescript
export function invokeKCLRun(inst, opts: RunOptions): ExecProgramResult
export function invokeKCLRunWithLogMessage(inst, opts: RunWithLogMessageOptions): …
export function invokeKCLFmt(inst, opts: FmtOptions): FormatCodeResult
export function invokeKCLVersion(inst): string
export function invokeKCLCall(inst, opts: CallOptions): string
export function invokeKCLCallNative(inst, opts: CallNativeOptions): Uint8Array
```

The simplest end-to-end call:

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

## Typed RPC surface (`api.ts`)

Every service method from `spec/spec.proto` has a typed wrapper in
`api.ts`. All wrappers take a `WebAssembly.Instance` returned from
`load()` plus a typed args object, and return a typed result.

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

Parse KCL source and return the AST as a JSON string.

```typescript
const parsed = parseFile(inst, { path: "schema.k" });
console.log(parsed.astJson, parsed.errors);
```

### `loadPackage(inst, args)`

Parse + resolve + return AST + symbol + scope + type tables. Heavy
method; pass `resolveAst: false` if you only want symbols.

### `execProgram(inst, args)`

```typescript
const result = execProgram(inst, {
  kFilenameList: ["schema.k"],
  format: "yaml",              // skip the JSON encoder
  errorFormat: "sarif",        // machine-readable diagnostics
  sourcemapOutput: "./out.json",  // v0.13.0 Source Map v3 emit
});
console.log(result.yamlResult);
console.log(result.sourcemap);   // v0.13.0
```

### `overrideFile(inst, args)`

Apply `*-override` specifications; mutates the file on disk.

### `listVariables(inst, args)` / `listOptions(inst, args)`

Introspection helpers. `listOptions` accepts `ParseProgramArgs`
because the spec reuses `ParseProgram` for this RPC.

### `getSchemaTypeMapping(inst, args)`

Flattens all schemas under `__main__`.

### `getSchemaTypeMappingUnderPath(inst, args)`

Added in v0.13.0 (fixes
[kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546));
keeps each `kcl.mod` dependency under its own package name.

### `formatPath(inst, args)` / `lintPath(inst, args)` / `validateCode(inst, args)` / `loadSettingsFiles(inst, args)`

Standard `KclService` methods. `formatPath` and `lintPath` take paths
on the WASI filesystem (see `preopens`); `validateCode` validates a
YAML/JSON data string against a schema declared in KCL source.

### `rename(inst, args)` / `renameCode(inst, args)`

`rename` rewrites files on disk; `renameCode` returns the modified
sources as a map without touching the filesystem.

### `test(inst, args)`

Runs `_test.*` functions across the listed packages. v0.13.0 adds
per-case line coverage info to `TestCaseInfo`.

### `updateDependencies(inst, args)`

Downloads the `kcl.mod` dependency graph and returns the resolved
external packages. Feed `external_pkgs` straight into a follow-up
`execProgram` call.

## Buffer sizes

```typescript
const DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE = 16 * 1024 * 1024;   // 16 MiB
const RUNTIME_ERR_BUFFER_SIZE                = 4  * 1024;          // 4 KiB
```

`invokeKCLCallNative` allocates `DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE`
bytes for the response. The dispatcher returns its length; `invokeKcl`
returns a right-sized `Uint8Array` view. If your payload exceeds 16 MiB,
use `CallNativeOptions.resultBuffer` to supply a larger buffer:

```typescript
const out = invokeKCLCallNative(inst, {
  name: "KclService.ExecProgram",
  args: encode(args),
  resultBuffer: new Uint8Array(64 * 1024 * 1024),   // 64 MiB
});
```

`RUNTIME_ERR_BUFFER_SIZE` is the buffer the JS wrapper allocates when
the WASM module traps (panic=abort), so it can ask the wasm guest to
write the panic message into it via the `kcl_runtime_err` export. The
old value of 1024 silently truncated any error longer than 1 KiB; the
v0.13.0 binding uses 4096 to match every other binding — see
[`abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md).

## Plugin-agent callback

If your KCL program imports `kcl_plugin.*`, pass an `imports` callback
to `load()`:

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

See [`abi.md` §2](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#2-plugin-agent-variant)
for the wire format.

## Browser bundlers

The package targets `@wasmer/wasi` for the WASI polyfill. For
Webpack/Vite, configure your bundler to ship `Buffer` (Webpack's
`ProvidePlugin`) and add the `@wasmer/wasi` externals. A complete
working example lives at
[`wasm/examples/browser`](https://github.com/kcl-lang/lib/tree/main/wasm/examples/browser).
The legacy `@kcl-lang/wasm-lib` npm name (now `@kcl-lib/wasm`) used the
same approach; the migration is package-name only.