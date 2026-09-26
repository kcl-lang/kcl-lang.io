---
sidebar_position: 13
---

# Zig API

> **想了解跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，其中包含 `call_native`、以 `"ERROR:"` 为前缀的错误、4 MiB 结果缓冲区、`KCL_LIB_HOME` 环境变量以及导出的 Rust 符号。Zig 绑定是对该派发器的 `extern "c"` 声明封装。

官方 Zig 绑定位于
[`kcl-lang/lib/tree/main/zig`](https://github.com/kcl-lang/lib/tree/main/zig)，
以 [`build.zig.zon`](https://ziglang.org/documentation/master/#Zon)
包的形式发布。`spec` 中的 Protobuf 类型（`spec.PingArgs`、
`spec.ExecProgramArgs` 等）每次构建时由 `protoc-gen-zig` 根据
`../spec/spec.proto` 生成，因此绑定会自动跟随线协议演进。

## 环境要求

- Zig **0.16+**
- `PATH` 中存在 `protoc`（在构建时用于从 `../spec/spec.proto` 派生类型化包装）

```bash
zig build test
```

## 安装

在项目的 `build.zig.zon` 中：

```zig
.{
    .name = .my_app,
    .version = "0.1.0",
    .fingerprint = 0x…,            // 任意 8 字节标签
    .paths = .{"", "", ""},
    .dependencies = .{
        .kcl = .{
            .url = "https://github.com/kcl-lang/lib/archive/refs/heads/main.tar.gz",
            .hash = "…",
        },
    },
}
```

在 `build.zig` 中：

```zig
const kcl = b.dependency("kcl", .{
    .target = target,
    .optimize = optimize,
}).module("kcl");
exe.root_module.addImport("kcl", kcl);
```

绑定链接到 `libkcl_lib`（由 `kcl-api` crate 产出的 Rust `cdylib`）。请将
`libkcl_lib.{so,dylib,dll}` 放到加载器路径上，或将 `KCL_LIB_HOME`
指向其所在目录。

## 快速开始

```zig
const std = @import("std");
const kcl = @import("kcl");
const spec = @import("kcl").spec;

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var code: std.ArrayList([]const u8) = .empty;
    defer code.deinit(alloc);
    try code.append(alloc, "alice = {age = 18}");

    var result = try kcl.execProgram(alloc, .{
        .k_code_list = code,
    });
    defer result.deinit(alloc);

    std.debug.print("yaml: {s}\n", .{result.yaml_result});
    std.debug.print("errors: {s}\n", .{result.err_message});
}
```

## API 参考

绑定暴露一个通用派发器和三个类型化包装。三个类型化包装均基于
`call` 构建；如果需要尚未提供类型化包装的方法，可直接通过 `call`
调用并自行构造 protobuf 负载。

### `call(allocator, name, args) → []u8`

```zig
pub fn call(
    allocator: std.mem.Allocator,
    name: []const u8,            // 例如 "KclService.ExecProgram"
    args: []const u8,            // protobuf 编码的请求字节
) Error![]u8                     // protobuf 编码的响应字节
```

返回原始响应字节；调用方需要自行使用 `spec.<Method>Result.decode(...)`
解码。派发器始终将响应复制到一个 4 MiB 的临时缓冲区
（`call_buffer_size`）；随后 `call` 会按实际长度返回 `dupe`，调用方
可以放心释放切片而无需关心分配过量。若响应超过 4 MiB，则返回被截断
的前缀——需要自行提供更大的缓冲区（参见下文“缓冲区”一节）。

### `ping(allocator, value) → spec.PingResult`

通过派发器往返传 `value`。

```zig
const r = try kcl.ping(alloc, "hello-kcl");
defer r.deinit(alloc);
try std.testing.expectEqualStrings("hello-kcl", r.value);
```

### `getVersion(allocator) → spec.GetVersionResult`

返回运行时版本元数据（`version`、`checksum`、`gitSha`）。

### `execProgram(allocator, args) → spec.ExecProgramResult`

运行 KCL 文件和/或内联代码。`args` 是一个完整类型化的
`spec.ExecProgramArgs`；v0.13.0 新增的 `error_format`、`format` 以及
`sourcemap_output`（与 proto 字段名对应，但 Zig 中的字段命名通常为
下划线小写）都可以通过结构体字段直接设置。

```zig
var result = try kcl.execProgram(alloc, .{
    .k_filename_list = &.{"schema.k"},
    .format = "yaml",
    .error_format = "sarif",
});
defer result.deinit(alloc);
std.debug.print("{s}\n", .{result.yaml_result});
```

注意：`execProgram` **不是线程安全的**，这与 Rust 派发器一致。如果
需要在多个线程上并发执行，请自行加锁同步，或启动多个 `kcl-api` 进程。

### 调用未提供类型化包装的方法

`spec` 模块每次构建时都根据 `spec/spec.proto` 重新生成，因此 spec 中
的每个 `*Args` 和 `*Result` 消息都以 Zig 结构体的形式提供。例如要调用
`KclService.FormatCode`，可自行构造 `spec.FormatCodeArgs` 并通过
`call` 路由：

```zig
var writer: std.Io.Writer.Allocating = .init(alloc);
defer writer.deinit();
try writer.writer.print(alloc, "{{\"source\":\"a=1\"}}", .{});   // JSON
const response_bytes = try kcl.call(alloc, "KclService.FormatCode", writer.written());
defer alloc.free(response_bytes);
```

（为简洁起见，上述代码片段使用 JSON；如果追求性能，请改用基于
protobuf 生成的 `spec.FormatCodeArgs` 上的 `encode` 方法进行编码。）

## 错误集合

```zig
pub const Error = std.mem.Allocator.Error || std.Io.Writer.Error || error{
    KclRpc,             // 派发器返回了以 "ERROR:" 为前缀的负载
    MalformedResponse,  // 响应无法被解码为合法的 protobuf 消息
};
```

[`abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md) 中定义
的 `"ERROR:"` 前缀会按字面匹配。如果遇到 `error.KclRpc`，底层消息会
丢失——目前 `KclRpc` 抛出时不附带负载。如需访问错误负载，可自行修改
绑定以暴露该字段。

## 缓冲区大小

`call` 每次调用分配 **4 MiB** 的结果缓冲区。对于更大的响应（例如带
`resolve_ast = true` 的 `load_package`，或大批量 `exec_program` 输出），
请自行编写派发器，提供更大的缓冲区——`call_native` 的 `extern "c"`
声明属于公共面的一部分：

```zig
const call_buffer_size: usize = 32 * 1024 * 1024;     // 32 MiB
var buf = try alloc.alloc(u8, call_buffer_size);
defer alloc.free(buf);
const written = call_native(name.ptr, name.len, args.ptr, args.len, buf.ptr);
const response = buf[0..written];
```

## 示例

仓库在 [`zig/examples/`](https://github.com/kcl-lang/lib/tree/main/zig/examples)
下提供可运行示例；上文中的 `zig build test` 目标会端到端地对真实原生库
运行 `ping`、`getVersion` 与 `execProgram`。