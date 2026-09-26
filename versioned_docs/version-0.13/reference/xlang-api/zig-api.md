---
sidebar_position: 13
---

# Zig API

> **Looking for the cross-language FFI contract?**
> See [`./ffi-abi.md`](./ffi-abi.md) for `call_native`, the `"ERROR:"`
> prefix, the 4 MiB result buffer, `KCL_LIB_HOME`, and the exported Rust
> symbols. The Zig binding is a thin `extern "c"` declaration over that
> dispatcher.

The official Zig binding lives at
[`kcl-lang/lib/tree/main/zig`](https://github.com/kcl-lang/lib/tree/main/zig)
and is published as a [`build.zig.zon`](https://ziglang.org/documentation/master/#Zon)
package. The Protobuf types in `spec` (`spec.PingArgs`, `spec.ExecProgramArgs`,
…) are generated from `../spec/spec.proto` on every build by `protoc-gen-zig`,
so the binding tracks the wire schema automatically.

## Prerequisites

- Zig **0.16+**
- `protoc` on `PATH` (used to derive the typed wrappers from
  `../spec/spec.proto` at build time)

```bash
zig build test
```

## Installation

In your project's `build.zig.zon`:

```zig
.{
    .name = .my_app,
    .version = "0.1.0",
    .fingerprint = 0x…,            // arbitrary 8-byte tag
    .paths = .{"", "", ""},
    .dependencies = .{
        .kcl = .{
            .url = "https://github.com/kcl-lang/lib/archive/refs/heads/main.tar.gz",
            .hash = "…",
        },
    },
}
```

In `build.zig`:

```zig
const kcl = b.dependency("kcl", .{
    .target = target,
    .optimize = optimize,
}).module("kcl");
exe.root_module.addImport("kcl", kcl);
```

The binding links against `libkcl_lib` (the Rust `cdylib` produced by the
`kcl-api` crate). Put `libkcl_lib.{so,dylib,dll}` on your loader path or set
`KCL_LIB_HOME` to its directory.

## Quick Start

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

## API Reference

The binding exposes one universal dispatcher and three typed wrappers.
All three typed wrappers are built on top of `call`; if you need a
method that has no typed wrapper yet, you can call it via `call`
directly with a hand-built protobuf payload.

### `call(allocator, name, args) → []u8`

```zig
pub fn call(
    allocator: std.mem.Allocator,
    name: []const u8,            // e.g. "KclService.ExecProgram"
    args: []const u8,            // protobuf-encoded request bytes
) Error![]u8                     // protobuf-encoded response bytes
```

Returns the raw response bytes; you decode them yourself with
`spec.<Method>Result.decode(...)`. The dispatcher always copies the
response into a 4 MiB scratch buffer (`call_buffer_size`); `call` then
returns a right-sized `dupe` so the caller can free the slice without
worrying about oversize allocations. If the response exceeds 4 MiB the
truncated prefix is returned — bring your own buffer (see "Buffer"
section below).

### `ping(allocator, value) → spec.PingResult`

Round-trip `value` through the dispatcher.

```zig
const r = try kcl.ping(alloc, "hello-kcl");
defer r.deinit(alloc);
try std.testing.expectEqualStrings("hello-kcl", r.value);
```

### `getVersion(allocator) → spec.GetVersionResult`

Returns the runtime version metadata (`version`, `checksum`, `gitSha`).

### `execProgram(allocator, args) → spec.ExecProgramResult`

Run KCL files and/or inline code. `args` is a fully-typed
`spec.ExecProgramArgs`; v0.13.0 additions such as `error_format`,
`format`, and `sourcemap_output` (mirroring the proto field names, but
see the protobuf-derived Zig names — usually lower_snake_case) are
all settable as struct fields.

```zig
var result = try kcl.execProgram(alloc, .{
    .k_filename_list = &.{"schema.k"},
    .format = "yaml",
    .error_format = "sarif",
});
defer result.deinit(alloc);
std.debug.print("{s}\n", .{result.yaml_result});
```

Note: `execProgram` is **not thread-safe**, mirroring the Rust
dispatcher. If you need concurrent executions from multiple threads,
synchronize around it yourself or run multiple `kcl-api` processes.

### Calling methods without a typed wrapper

The `spec` module is regenerated from `spec/spec.proto` every build,
so every `*Args` and `*Result` message in the spec is available as a
Zig struct. To call, for example, `KclService.FormatCode`, build a
`spec.FormatCodeArgs` yourself and route through `call`:

```zig
var writer: std.Io.Writer.Allocating = .init(alloc);
defer writer.deinit();
try writer.writer.print(alloc, "{{\"source\":\"a=1\"}}", .{});   // JSON
const response_bytes = try kcl.call(alloc, "KclService.FormatCode", writer.written());
defer alloc.free(response_bytes);
```

(The snippet above uses JSON for brevity; for performance, encode via
the protobuf-generated `encode` method on `spec.FormatCodeArgs`.)

## Error set

```zig
pub const Error = std.mem.Allocator.Error || std.Io.Writer.Error || error{
    KclRpc,             // dispatcher returned an "ERROR:"-prefixed payload
    MalformedResponse,  // response was not a decodable protobuf message
};
```

The `"ERROR:"` prefix (see [`abi.md`](https://github.com/kcl-lang/lib/blob/main/docs/abi.md))
is matched verbatim. If you ever hit `error.KclRpc`, the underlying message
is lost — `KclRpc` is currently thrown without the payload. Patch the
binding to surface it if you need it.

## Buffer size

`call` allocates a **4 MiB** result buffer per invocation. For larger
responses (`load_package` with `resolve_ast = true`, or bulk
`exec_program` outputs), write your own dispatcher that supplies a
bigger buffer — the `extern "c"` declaration of `call_native` is part of
the public surface:

```zig
const call_buffer_size: usize = 32 * 1024 * 1024;     // 32 MiB
var buf = try alloc.alloc(u8, call_buffer_size);
defer alloc.free(buf);
const written = call_native(name.ptr, name.len, args.ptr, args.len, buf.ptr);
const response = buf[0..written];
```

## Examples

The repo ships runnable examples under
[`zig/examples/`](https://github.com/kcl-lang/lib/tree/main/zig/examples);
the `zig build test` target above exercises `ping`, `getVersion`, and
`execProgram` end-to-end against the real native library.