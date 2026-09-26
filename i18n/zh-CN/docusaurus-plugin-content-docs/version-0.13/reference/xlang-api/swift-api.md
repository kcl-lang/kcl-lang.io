---
sidebar_position: 9
---

# Swift API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，其中包含 `callNative`、`"ERROR:"` 前缀、缓冲区大小、`CKclLib`（包裹 `libkcl_lib` 的 `systemLibrary`）以及导出的 Rust 符号。下方 `API` 上的 20 个类型化方法都是围绕该单一分发器构建的薄封装。

官方 Swift 包位于
[`kcl-lang/lib/tree/main/swift`](https://github.com/kcl-lang/lib/tree/main/swift)，
通过 [`swift-protobuf`](https://github.com/apple/swift-protobuf) 从 `spec/spec.proto`
生成，将完整的 `KclService` 和 `BuiltinService` 接口面暴露为强类型的 Swift 方法。该包以两个库产品的形式发布——
`KclLib`（FFI + RPC 客户端）和 `KclLibAST`（一个纯 Foundation 的解析器，用于解析由 `ParseFileResult`
和 `ParseProgramResult` 发出的 `astJson` 字符串）。

## 安装

将包添加到 `Package.swift`：

```swift
// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "MyApp",
    products: [.executable(name: "MyApp", targets: ["MyApp"])],
    dependencies: [
        .package(url: "https://github.com/kcl-lang/lib.git", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "MyApp",
            dependencies: [
                .product(name: "KclLib", package: "lib"),
                // optional: typed AST parser for `ParseFileResult.astJson`
                .product(name: "KclLibAST", package: "lib"),
            ]
        ),
    ]
)
```

该包会间接引入 `swift-protobuf >= 1.27.0` 以及一个 `CKclLib` `systemLibrary`，
后者链接到 `Sources/CKclLib/lib/` 下随包分发的预编译共享对象 `libkcl_lib.{dylib,so,dll}`。
若链接器无法自动找到 `libkcl_lib`，请设置 `KCL_LIB_HOME`（或将共享库放入加载器搜索路径）。

## 快速开始

对于一个 `schema.k` 文件：

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

```swift
import Foundation
import KclLib

let api = API()
var args = ExecProgramArgs()
args.kFilenameList = ["schema.k"]
let result = try api.execProgram(args)
print(result.yamlResult)        // "app:\n  replicas: 2\n"
```

分发器抛出的错误会以 `KclError.runtime(...)` 的形式呈现——
Rust 分发器添加的 `"ERROR:"` 前缀会在消息到达 Swift 之前被剥离。

## API 参考

`API` 遵循 `Service` 协议（在
[`Sources/KclLib/Service.swift`](https://github.com/kcl-lang/lib/blob/main/swift/Sources/KclLib/Service.swift) 中声明）。
每个方法接收对应的 `*Args` 结构体（由 `spec.proto` 生成）并返回匹配的 `*Result` 结构体。
`ExecProgramArgs` 继承自 `spec.proto` 中 v0.13.0 新增的字段——
`errorFormat`、`format` 和 `sourcemapOutput` 均可通过 `args.errorFormat = "sarif"`、
`args.format = "json"`、`args.sourcemapOutput = "./out.json"` 等方式设置。

### `ping(_:)`

通过分发器对一个值进行往返。常用于健全性检查，验证原生库可被加载。

```swift
let result = try api.ping(PingArgs.with { $0.value = "hello" })
assert(result.value == "hello")
```

### `getVersion(_:)`

返回底层 `kcl` 运行时的版本元数据。

```swift
let v = try api.getVersion(GetVersionArgs())
print(v.version, v.gitSha, v.checksum)
```

### `parseProgram(_:)` / `parseFile(_:)`

解析 KCL 源码并以 JSON 字符串形式返回 AST。

```swift
let parsed = try api.parseFile(ParseFileArgs.with {
    $0.path = "schema.k"
})
print(parsed.astJson)
print(parsed.errors)
```

### `loadPackage(_:)`

解析并解析一个 KCL 包，返回 AST、符号、作用域和类型表。属于重量级方法——
若仅需要符号索引，可设置 `loadSettings.resolveAst = false`。

### `execProgram(_:)`

运行一个或多个 KCL 文件，并同时返回 `yamlResult` 和 `jsonResult`。

```swift
var exec = ExecProgramArgs()
exec.kFilenameList = ["schema.k"]
exec.format = "yaml"                         // skip the JSON encoder
exec.errorFormat = "sarif"                   // machine-readable diagnostics
let r = try api.execProgram(exec)
```

### `overrideFile(_:)`

将 `*-override` 规范应用到 `.k` 文件。会就地修改磁盘上的文件。

### `listVariables(_:)` / `listOptions(_:)`

由 `KclService.ListVariables` 和 `KclService.ListOptions` 驱动的内省辅助方法。
`listOptions` 接收 `ParseProgramArgs`（规范在此处复用了 `ParseProgram`），而不是专用的 args 结构体。

### `getSchemaTypeMapping(_:)` / `getSchemaTypeMappingUnderPath(_:)`

`getSchemaTypeMapping` 将 `__main__` 下的所有 schema 展平；
`getSchemaTypeMappingUnderPath`（v0.13.0 新增，参见
[kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546)）则将每个 `kcl.mod`
依赖项保留在其各自的包名之下。

### `formatCode(_:)` / `formatPath(_:)`

`formatCode` 在内存中对源代码字符串进行格式化；`formatPath` 重写磁盘上的文件
（设置 `dryRun = true` 即可仅报告将会发生的变化而不实际修改文件）。

### `lintPath(_:)`

在给定路径上运行 `kcl lint`，并将警告/错误以字符串列表形式返回。

### `validateCode(_:)`

对照 KCL 源字符串中声明的 schema 验证 YAML/JSON 数据字符串。
`format` 为 `data` 参数选择 YAML 或 JSON 格式。

### `loadSettingsFiles(_:)`

将 `kcl.yaml`（或其别名）加载到 `LoadSettingsFilesResult` 中。

### `rename(_:)` / `renameCode(_:)`

`rename` 重写磁盘上的文件；`renameCode` 以 map 形式返回修改后的源码，不接触文件系统。

### `test(_:)`

跨所列出的 KCL 包运行 `_test.*` 函数，并按用例返回结果，其中包含 v0.13.0
新增的行覆盖率数据。

### `updateDependencies(_:)`

下载 `kcl.mod` 依赖图，并返回已解析的外部包，可直接回传给 `execProgram.execArgs.externalPkgs`。

### `listMethod()`

返回运行时实现的全限定 RPC 名称列表
（例如 `["KclService.ExecProgram", "KclService.ParseFile", …]`）。

## `KclLibAST`

`KclLibAST` 是同一包内的同级 SwiftPM 产品，它将 `ParseFileResult.astJson` /
`ParseProgramResult.astJson` 解析为强类型的 Foundation 结构体（`Module`、`Stmt`、`Decorator`、
`FunctionType`、`IndexSignature` 等），而无需经过 SwiftProtobuf。

```swift
import KclLibAST

let parsed = try api.parseFile(ParseFileArgs.with { $0.path = "schema.k" })
let module = try KclLibAST.parse(astJson: parsed.astJson)
for stmt in module.body {
    print(strictTypeName(of: stmt))   // "Schema", "Assign", …
}
```

## 缓冲区约定

`API` 每次调用 `callNative` 时分配一个 4 MiB 的结果缓冲区（`2048 * 2048` 个 `UInt8`），
并将响应拷贝到其中。若你调用的方法返回的负载超过 4 MiB（尤其是开启了 `resolveAst = true`
的 `loadPackage`），请自带缓冲区：

```swift
// Future: when `API.callNative` is exposed publicly, callers can
// override the buffer size. Today the 4 MiB default is hard-coded.
```

请关注 [kcl-lang/lib issue tracker](https://github.com/kcl-lang/lib/issues)
以获取缓冲区大小协商相关补丁的进展。

## 错误

| 错误                     | 触发时机                                                          |
| ------------------------ | ----------------------------------------------------------------- |
| `KclError.runtime("…")`  | Rust 端返回 `"ERROR:<message>"` 形式的回复。前缀会被剥离。             |
| `SwiftProtobuf.Error`    | args 结构体编码失败，或响应解码失败。                                  |

`API` 未暴露任何 `PluginAgent` 回调；目前从 Swift 端不支持导入 `kcl_plugin.*` 的 KCL 程序。

## 示例

仓库在 [`swift/examples/`](https://github.com/kcl-lang/lib/tree/main/swift/examples)
下提供了可运行的示例，涵盖 `execProgram`、`parseProgram`、`formatCode` 以及 AST 解析器。