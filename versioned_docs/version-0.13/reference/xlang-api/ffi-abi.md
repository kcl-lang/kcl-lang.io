---
sidebar_position: 2
---

# FFI ABI

Every multi-language binding in this stack — Python, Go, Java, Kotlin, Node.js,
C#, Swift, Lua, WASM, Zig, and the C/C++ wrappers — eventually funnels into the
same universal dispatcher exported by the `kcl-api` Rust crate. This page is a
landing summary of the cross-language FFI contract. The single source of truth
lives in the `kcl-lang/lib` repository:

- [`docs/abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md) — the
  authoritative contract. Any change here must be coordinated with a `kcl-api`
  release.
- [`spec/spec.proto`](https://github.com/kcl-lang/lib/blob/main/spec/spec.proto)
  — the Protobuf service and message definitions that drive every binding.

If you are integrating KCL from a new language, read `abi.md` end-to-end before
opening an issue.

## 1. Universal entry point: `call_native`

```c
size_t call_native(const char* name_ptr, size_t name_len,
                   const char* args_ptr, size_t args_len,
                   char*       result_ptr);
```

| Direction | Buffer        | Length field                |
| --------- | ------------- | --------------------------- |
| Request   | `name_ptr`    | `name_len`  (UTF-8 bytes)   |
| Request   | `args_ptr`    | `args_len`  (protobuf)      |
| Response  | `result_ptr`  | returned `size_t` (bytes)   |

The service name is a fully qualified RPC name such as
`"KclService.ExecProgram"` or `"BuiltinService.ListMethod"`. The dispatcher
parses the name, decodes `args` into the matching `<Method>Args` message, runs
the typed handler, writes the protobuf-encoded `<Method>Result` into
`result_ptr`, and returns the byte count.

C/C++/Lua also expose an equivalent entry point:

```c
size_t kcl_service_call_with_length(kcl_service_t* serv,
                                    const char* name,
                                    const char* args, size_t args_len,
                                    size_t* result_len);
```

See [`abi.md` §1](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#1-universal-entry-point-call_native)
for the per-binding wrappers (Go: `kcl.go::Call`; .NET: `API.cs::Call`;
Python: `service.py::call`; Swift: `API.swift::callNative`; etc.).

## 2. Plugin-agent variant

Programs that call into plugin code (`import kcl_plugin.foo as foo` and then
`foo.add(1, 2)`) must pass a function pointer to a *plugin agent* alongside the
dispatcher call:

```c
const char* plugin_method_agent(const char* method,
                                const char* args_json,
                                const char* kwargs_json);
```

The dispatcher invokes the agent whenever the running KCL program reaches a
`kcl_plugin.*` call site. `method` is the fully qualified call site (e.g.
`"kcl_plugin.foo.add"`); `args_json` and `kwargs_json` are JSON-encoded; the
returned `*c_char` is a JSON-encoded result. The buffer must remain valid at
least until the dispatcher copies it.

Bindings that ship a plugin-agent wrapper:

- C / C++ — no wrapper today.
- Java / Kotlin — JNI/`FunctionPointer` bridge per binding.
- Node.js — `plugin.rs::plugin_method_agent`, cached in a `thread_local!`.
- Python — `plugin.py::plugin_method_agent`, fresh `create_string_buffer` per
  call.
- .NET — `API.cs::PluginAgentCallback`. The v0.13.0 release fixed a concurrent-
  invocation race where a shared `pluginAgentBuffer` could be resized while the
  dispatcher was still reading it (see [`abi.md` §3](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#3-net-plugin-agent-race-fix)).
- Swift, Lua, Zig — not currently exposed.
- WASM — `wasm/src/index.ts::load` accepts an `imports` callback named
  `kcl_plugin_invoke_json_wasm` from the host.

## 3. The `"ERROR:"` prefix

When the dispatcher returns an error (an explicit `Err(anyhow::Error)` from a
service handler, or a panic caught by `catch_unwind` in
`kcl_service_call_with_length`), it writes a UTF-8 string of the form
`"ERROR:<message>"` into the result buffer and returns the byte length. Bindings
must define a single named constant for the prefix and use it everywhere:

| Binding   | Constant         | File                                   |
| --------- | ---------------- | -------------------------------------- |
| C         | `ERROR_PREFIX`   | `c/include/kcl_lib.h`                  |
| .NET      | `ERROR_PREFIX`   | `dotnet/KclLib/api/API.cs`             |
| Python    | `_ERROR_PREFIX`  | `python/kcl_lib/api/service.py`        |
| Swift     | `ERROR_PREFIX`   | `swift/Sources/KclLib/API.swift`       |
| Zig       | `ERROR_PREFIX`   | `zig/src/root.zig`                     |
| Lua       | not used (Rust typed) | `lua/kcl_lib/raw_api.lua`         |
| Node.js   | not used (Rust typed) | `nodejs/src/lib.rs`              |
| WASM      | `"ERROR:"` literal | `wasm/src/index.ts`                 |

The prefix has been stable since v0.13.0. If it ever changes in the Rust
source, every binding must be updated in the same release.

## 4. Buffer size convention

Two buffer sizes appear repeatedly across bindings:

- **Default result buffer — 4 MiB** (`4 * 1024 * 1024`). Used for the caller-
  supplied `result_ptr` passed to `call_native`. The dispatcher copies the
  response into this buffer unconditionally, so the buffer must be at least
  as large as the largest `<Method>Result` you expect to receive. Zig
  (`call_buffer_size`), C/C++/Node.js/Swift/.NET all allocate 4 MiB. The WASM
  binding defaults to **16 MiB** (`DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE`)
  because WASM callers tend to decode larger `LoadPackage` payloads with the
  full AST index.
- **WASM runtime error buffer — 4 KiB** (`4 * 1024`). When the WASM module
  traps (panic=abort), the JS wrapper allocates a buffer of this size and asks
  the wasm guest to write the panic message into it via the `kcl_runtime_err`
  export. 1024 bytes was insufficient for any KCL program whose error message
  exceeded that size, causing silent truncation. Bumped to 4096 in v0.13.0
  (see `wasm/src/index.ts`).

There is currently no negotiation protocol. Bindings pick a fixed buffer size
and the caller is expected to allocate a larger buffer if they need to (e.g.
`invokeKCLCallNative`'s `resultBufferSize` option in the WASM binding).

## 5. Loading and `KCL_LIB_HOME`

Bindings that load a native shared library honour the `KCL_LIB_HOME`
environment variable as an override for the platform-specific lookup location.
Implementations:

- C / C++ — standard `dlopen`/`LoadLibrary` lookup; bindings can prepend
  `getenv("KCL_LIB_HOME")` to the search path.
- Node.js — uses `process.platform` / `process.arch` to pick the matching
  `kcl-lib.<platform>-<arch>.node` prebuilt; `KCL_LIB_HOME` is not currently
  honoured.
- Python — looks for `kcl_lib._kcl_lib` (the `cdylib` produced by
  `python/Cargo.toml`); `KCL_LIB_HOME` is not currently honoured.
- .NET — P/Invoke on `kcl_lib_dotnet`; the NuGet package deploys the `cdylib`
  next to the managed assembly. `KCL_LIB_HOME` is not currently honoured.
- Swift — depends on `CKclLib` (SwiftPM); the underlying `kcl_lib` shared
  library is loaded by the C target.
- Zig — links against `libkcl_lib` via `build.zig`.
- Lua — `lua/kcl_lib/raw_api.lua` calls `require("kcl_lib")`; the C module
  resolves `libkcl_lib` via standard Lua loader semantics.
- WASM — `wasm/src/index.ts::load` reads `kcl.wasm` from disk relative to the
  package or from `options.data` if supplied.

## 6. Exported Rust symbols

Symbols exported by the `kcl-api` crate's `cdylib` (generated via `cbindgen` and
the `#[unsafe(no_mangle)]` `extern "C-unwind"` functions in
`crates/api/src/service/capi.rs` and `crates/api/src/lib.rs`):

- `call_native(name_ptr, name_len, args_ptr, args_len, result_ptr) -> usize` —
  universal dispatcher (§1).
- `kcl_service_new(plugin_agent: u64) -> *mut kcl_service` — constructs a
  service handle that remembers the plugin-agent pointer.
- `kcl_service_delete(serv: *mut kcl_service)` — frees the service handle.
- `kcl_service_call(serv, name, args, args_len) -> *const c_char` — string-
  returning service call.
- `kcl_service_call_with_length(serv, name, args, args_len, &result_len)` —
  service call that returns the length alongside the pointer.
- `kcl_service_free_string(res: *mut c_char)` — frees a string previously
  returned by `kcl_service_call`.

WASM-specific exports (defined in the `kcl` crate's wasm bindings, not in
`kcl-api`):

- `kcl_run`, `kcl_run_with_log_message`, `kcl_fmt`, `kcl_version`, `kcl_call`,
  `call_native`, `kcl_runtime_err` — high-level entry points consumed by
  `wasm/src/index.ts`.
- `kcl_malloc`, `kcl_free` — bump allocator wrappers used to ferry strings
  into and out of WASM linear memory.

## 7. ABI compatibility rules

From [`abi.md` §8](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#8-adding-new-symbols):

- Adding new symbols is allowed in any release.
- Renaming, removing, or changing the signature of an existing symbol requires
  a major version bump of `kcl-api` and a coordinated update of every binding
  in the monorepo.

## 8. Where to look next

- [`docs/abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md) — the
  full contract.
- [`spec/spec.proto`](https://github.com/kcl-lang/lib/blob/main/spec/spec.proto)
  — every service, method, and message.
- [`docs/reference/xlang-api/rest-api.md`](./rest-api.md) — the wire-level
  Protobuf schema rendered as Markdown.
- Per-language `*-api.md` pages linked in the sidebar — language-specific
  wrappers, idioms, and installation steps.