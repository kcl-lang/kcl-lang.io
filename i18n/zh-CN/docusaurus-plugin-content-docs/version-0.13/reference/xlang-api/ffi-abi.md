---
sidebar_position: 2
---

# FFI ABI

本技术栈中的所有多语言绑定——Python、Go、Java、Kotlin、Node.js、
C#、Swift、Lua、WASM、Zig，以及 C/C++ 包装——最终都会汇聚到同一个
由 `kcl-api` Rust crate 导出的通用派发器。本页面是跨语言 FFI 契约的
快速导览。唯一权威契约位于 `kcl-lang/lib` 仓库：

- [`docs/abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md)
  —— 权威契约。任何变更都必须与 `kcl-api` 发布同步。
- [`spec/spec.proto`](https://github.com/kcl-lang/lib/blob/main/spec/spec.proto)
  —— 驱动每个绑定的 Protobuf 服务与消息定义。

如果你正从一门新的语言集成 KCL，请在提 issue 之前通读一遍 `abi.md`。

## 1. 通用入口点：`call_native`

```c
size_t call_native(const char* name_ptr, size_t name_len,
                   const char* args_ptr, size_t args_len,
                   char*       result_ptr);
```

| 方向     | 缓冲区         | 长度字段                  |
| -------- | -------------- | ------------------------- |
| 请求     | `name_ptr`     | `name_len`（UTF-8 字节）  |
| 请求     | `args_ptr`     | `args_len`（protobuf）    |
| 响应     | `result_ptr`   | 返回的 `size_t`（字节）   |

服务名是一个完全限定的 RPC 名，例如 `"KclService.ExecProgram"` 或
`"BuiltinService.ListMethod"`。派发器会解析名称，将 `args` 解码为对应
的 `<Method>Args` 消息，运行类型化 handler，将 protobuf 编码后的
`<Method>Result` 写入 `result_ptr`，并返回字节数。

C/C++/Lua 还暴露一个等价的入口点：

```c
size_t kcl_service_call_with_length(kcl_service_t* serv,
                                    const char* name,
                                    const char* args, size_t args_len,
                                    size_t* result_len);
```

每个绑定的 wrapper 见
[`abi.md` §1](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#1-universal-entry-point-call_native)
（Go：`kcl.go::Call`；.NET：`API.cs::Call`；Python：`service.py::call`；
Swift：`API.swift::callNative`；等）。

## 2. 插件代理变体

调用插件代码（`import kcl_plugin.foo as foo`，然后 `foo.add(1, 2)`）
的程序必须在派发器调用时一并传入一个*插件代理*的函数指针：

```c
const char* plugin_method_agent(const char* method,
                                const char* args_json,
                                const char* kwargs_json);
```

每当运行的 KCL 程序命中 `kcl_plugin.*` 调用点时，派发器就会调用该
代理。`method` 是完全限定的调用点（例如 `"kcl_plugin.foo.add"`）；
`args_json` 与 `kwargs_json` 是 JSON 编码；返回的 `*c_char` 是 JSON
编码的结果。该缓冲区必须至少在派发器完成拷贝前保持有效。

提供插件代理 wrapper 的绑定：

- C / C++ —— 暂无 wrapper。
- Java / Kotlin —— 基于 JNI/`FunctionPointer` 的桥接。
- Node.js —— `plugin.rs::plugin_method_agent`，缓存在 `thread_local!` 中。
- Python —— `plugin.py::plugin_method_agent`，每次调用都新建一个
  `create_string_buffer`。
- .NET —— `API.cs::PluginAgentCallback`。v0.13.0 版本修复了一个并发
  调用竞态：在派发器仍在读取共享的 `pluginAgentBuffer` 时，它可能被
  重新分配（见
  [`abi.md` §3](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#3-net-plugin-agent-race-fix)）。
- Swift、Lua、Zig —— 当前未暴露。
- WASM —— `wasm/src/index.ts::load` 接受名为
  `kcl_plugin_invoke_json_wasm` 的宿主 `imports` 回调。

## 3. `"ERROR:"` 前缀

当派发器返回错误（service handler 显式返回的 `Err(anyhow::Error)`，
或 `kcl_service_call_with_length` 中 `catch_unwind` 捕获的 panic）时，
会向结果缓冲区写入一段形如 `"ERROR:<message>"` 的 UTF-8 字符串，并
返回字节数。各绑定必须为该前缀定义一个具名常量并全程复用：

| 绑定     | 常量名             | 文件                                    |
| -------- | ------------------ | --------------------------------------- |
| C        | `ERROR_PREFIX`     | `c/include/kcl_lib.h`                   |
| .NET     | `ERROR_PREFIX`     | `dotnet/KclLib/api/API.cs`              |
| Python   | `_ERROR_PREFIX`    | `python/kcl_lib/api/service.py`         |
| Swift    | `ERROR_PREFIX`     | `swift/Sources/KclLib/API.swift`        |
| Zig      | `ERROR_PREFIX`     | `zig/src/root.zig`                      |
| Lua      | 未使用（Rust 类型化） | `lua/kcl_lib/raw_api.lua`            |
| Node.js  | 未使用（Rust 类型化） | `nodejs/src/lib.rs`                 |
| WASM     | `"ERROR:"` 字面量  | `wasm/src/index.ts`                     |

该前缀自 v0.13.0 起保持稳定。如果 Rust 源码中发生变更，所有绑定必须在
同一次发布中同步更新。

## 4. 缓冲区大小约定

两个缓冲区大小在各绑定中反复出现：

- **默认结果缓冲区 —— 4 MiB**（`4 * 1024 * 1024`）。用于调用方传入
  给 `call_native` 的 `result_ptr`。派发器会无条件地将响应复制到该
  缓冲区，因此缓冲区必须至少与期望收到的最大 `<Method>Result` 同等
  大小。Zig（`call_buffer_size`）、C/C++/Node.js/Swift/.NET 都分配
  4 MiB。WASM 绑定默认为 **16 MiB**
  （`DEFAULT_CALL_NATIVE_RESULT_BUFFER_SIZE`），因为 WASM 调用方通常
  会解码包含完整 AST 索引的较大 `LoadPackage` 负载。
- **WASM 运行时错误缓冲区 —— 4 KiB**（`4 * 1024`）。当 WASM 模块
  触发 trap（panic=abort）时，JS wrapper 会分配该大小的缓冲区，并通过
  `kcl_runtime_err` 导出要求 wasm guest 将 panic 消息写入其中。原先
  的 1024 字节不足以容纳任何错误消息超过 1 KiB 的 KCL 程序，导致
  静默截断。v0.13.0 已上调到 4096 字节（参见 `wasm/src/index.ts`）。

当前没有协商协议。绑定选择固定缓冲区大小，需要更大的缓冲区由调用方
自行分配（例如 WASM 绑定中 `invokeKCLCallNative` 的 `resultBufferSize`
选项）。

## 5. 加载与 `KCL_LIB_HOME`

加载原生共享库的绑定遵循 `KCL_LIB_HOME` 环境变量，作为平台相关查找
位置的覆盖。实现细节：

- C / C++ —— 标准 `dlopen`/`LoadLibrary` 查找；绑定可在搜索路径前
  拼接 `getenv("KCL_LIB_HOME")`。
- Node.js —— 根据 `process.platform` / `process.arch` 挑选匹配的
  `kcl-lib.<platform>-<arch>.node` 预构建产物；当前未遵循
  `KCL_LIB_HOME`。
- Python —— 查找 `kcl_lib._kcl_lib`（由 `python/Cargo.toml` 产出的
  `cdylib`）；当前未遵循 `KCL_LIB_HOME`。
- .NET —— 对 `kcl_lib_dotnet` 进行 P/Invoke；NuGet 包将 `cdylib` 部署
  到托管程序集旁边。当前未遵循 `KCL_LIB_HOME`。
- Swift —— 通过 SwiftPM 依赖 `CKclLib`；底层的 `kcl_lib` 共享库由 C
  target 加载。
- Zig —— 通过 `build.zig` 链接到 `libkcl_lib`。
- Lua —— `lua/kcl_lib/raw_api.lua` 调用 `require("kcl_lib")`；C 模块
  按标准 Lua 加载器语义解析 `libkcl_lib`。
- WASM —— `wasm/src/index.ts::load` 读取相对于包的磁盘上的 `kcl.wasm`，
  或使用 `options.data` 提供预加载字节。

## 6. 导出的 Rust 符号

`kcl-api` crate 的 `cdylib` 导出符号（由 `cbindgen` 和
`crates/api/src/service/capi.rs`、`crates/api/src/lib.rs` 中
`#[unsafe(no_mangle)]` 的 `extern "C-unwind"` 函数生成）：

- `call_native(name_ptr, name_len, args_ptr, args_len, result_ptr) -> usize`
  —— 通用派发器（§1）。
- `kcl_service_new(plugin_agent: u64) -> *mut kcl_service` —— 构造一个
  记录插件代理指针的服务句柄。
- `kcl_service_delete(serv: *mut kcl_service)` —— 释放服务句柄。
- `kcl_service_call(serv, name, args, args_len) -> *const c_char` —— 返回
  字符串的服务调用。
- `kcl_service_call_with_length(serv, name, args, args_len, &result_len)`
  —— 同时返回长度与指针的服务调用。
- `kcl_service_free_string(res: *mut c_char)` —— 释放先前由
  `kcl_service_call` 返回的字符串。

WASM 专用导出（定义于 `kcl` crate 的 wasm 绑定中，而非 `kcl-api`）：

- `kcl_run`、`kcl_run_with_log_message`、`kcl_fmt`、`kcl_version`、
  `kcl_call`、`call_native`、`kcl_runtime_err` —— 由 `wasm/src/index.ts`
  消费的高级入口点。
- `kcl_malloc`、`kcl_free` —— 用于在 WASM 线性内存中搬运字符串的
  bump allocator 包装。

## 7. ABI 兼容性规则

摘自 [`abi.md` §8](https://github.com/kcl-lang/lib/blob/main/docs/abi.md#8-adding-new-symbols)：

- 添加新符号在任意发布中都是允许的。
- 重命名、删除或修改已有符号的签名需要 `kcl-api` 主版本号 bump，并
  在 monorepo 内同步更新所有绑定。

## 8. 下一步查阅

- [`docs/abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md)
  —— 完整契约。
- [`spec/spec.proto`](https://github.com/kcl-lang/lib/blob/main/spec/spec.proto)
  —— 每个 service、method 与 message。
- [`docs/reference/xlang-api/rest-api.md`](./rest-api.md) —— 以
  Markdown 渲染的线协议 Protobuf schema。
- 侧边栏链接的每种语言 `*-api.md` 页面 —— 语言特定的 wrapper、惯用法
  与安装步骤。