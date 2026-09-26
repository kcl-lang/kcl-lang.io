---
sidebar_position: 9
---

# Swift API

> **Looking for the cross-language FFI contract?**
> See [`./ffi-abi.md`](./ffi-abi.md) for `callNative`, the `"ERROR:"`
> prefix, buffer sizes, `CKclLib` (the `systemLibrary` wrapping
> `libkcl_lib`), and the exported Rust symbols. The 20 typed methods on
> `API` below are thin wrappers around that single dispatcher.

The official Swift package lives at
[`kcl-lang/lib/tree/main/swift`](https://github.com/kcl-lang/lib/tree/main/swift)
and exposes the entire `KclService` and `BuiltinService` surface area as
strongly-typed Swift methods generated from `spec/spec.proto` via
[`swift-protobuf`](https://github.com/apple/swift-protobuf). The package is
published as two library products — `KclLib` (the FFI + RPC client) and
`KclLibAST` (a pure-Foundation parser for the `astJson` strings emitted by
`ParseFileResult` and `ParseProgramResult`).

## Installation

Add the package to `Package.swift`:

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

The package transitively pulls `swift-protobuf >= 1.27.0` and a
`CKclLib` `systemLibrary` that links against the prebuilt
`libkcl_lib.{dylib,so,dll}` shared object shipped under
`Sources/CKclLib/lib/`. Set `KCL_LIB_HOME` (or drop the shared library on
your loader path) if the linker cannot find `libkcl_lib` automatically.

## Quick Start

With a `schema.k` file:

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

Errors thrown by the dispatcher are surfaced as `KclError.runtime(...)` —
the underlying `"ERROR:"` prefix the Rust dispatcher prepends is stripped
before the message reaches Swift.

## API Reference

`API` conforms to `Service` (declared in
[`Sources/KclLib/Service.swift`](https://github.com/kcl-lang/lib/blob/main/swift/Sources/KclLib/Service.swift)).
Every method takes the corresponding `*Args` struct (generated from
`spec.proto`) and returns the matching `*Result` struct. `ExecProgramArgs`
inherits the v0.13.0 additions from `spec.proto` — `errorFormat`, `format`,
and `sourcemapOutput` are all settable as `args.errorFormat = "sarif"`,
`args.format = "json"`, `args.sourcemapOutput = "./out.json"` etc.

### `ping(_:)`

Round-trip a value through the dispatcher. Useful for sanity-checking the
native library is loadable.

```swift
let result = try api.ping(PingArgs.with { $0.value = "hello" })
assert(result.value == "hello")
```

### `getVersion(_:)`

Returns the underlying `kcl` runtime version metadata.

```swift
let v = try api.getVersion(GetVersionArgs())
print(v.version, v.gitSha, v.checksum)
```

### `parseProgram(_:)` / `parseFile(_:)`

Parse KCL source and return the AST as a JSON string.

```swift
let parsed = try api.parseFile(ParseFileArgs.with {
    $0.path = "schema.k"
})
print(parsed.astJson)
print(parsed.errors)
```

### `loadPackage(_:)`

Parse and resolve a KCL package, returning AST + symbol + scope +
type tables. Heavy method — set `loadSettings.resolveAst = false` if
you only want the symbol index.

### `execProgram(_:)`

Run one or more KCL files and return both `yamlResult` and `jsonResult`.

```swift
var exec = ExecProgramArgs()
exec.kFilenameList = ["schema.k"]
exec.format = "yaml"                         // skip the JSON encoder
exec.errorFormat = "sarif"                   // machine-readable diagnostics
let r = try api.execProgram(exec)
```

### `overrideFile(_:)`

Apply `*-override` specifications to a `.k` file. Mutates the file on disk.

### `listVariables(_:)` / `listOptions(_:)`

Introspection helpers driven by `KclService.ListVariables` and
`KclService.ListOptions`. `listOptions` takes a `ParseProgramArgs` (the
spec reuses `ParseProgram` here), not a dedicated args struct.

### `getSchemaTypeMapping(_:)` / `getSchemaTypeMappingUnderPath(_:)`

`getSchemaTypeMapping` flattens all schemas under `__main__`;
`getSchemaTypeMappingUnderPath` (added in v0.13.0, see
[kcl-lang/kcl#1546](https://github.com/kcl-lang/kcl/issues/1546)) keeps
each `kcl.mod` dependency under its own package name.

### `formatCode(_:)` / `formatPath(_:)`

`formatCode` formats a source string in memory; `formatPath` rewrites
files (set `dryRun = true` to only report what would change).

### `lintPath(_:)`

Runs `kcl lint` over the given paths and returns the warnings/errors as
a list of strings.

### `validateCode(_:)`

Validate a YAML/JSON data string against a schema declared in a KCL
source string. `format` selects YAML or JSON for the `data` argument.

### `loadSettingsFiles(_:)`

Loads `kcl.yaml` (or its aliases) into a `LoadSettingsFilesResult`.

### `rename(_:)` / `renameCode(_:)`

`rename` rewrites files on disk; `renameCode` returns the modified
sources as a map without touching the filesystem.

### `test(_:)`

Runs `_test.*` functions across the listed KCL packages and returns
per-case results, including line coverage data added in v0.13.0.

### `updateDependencies(_:)`

Downloads the `kcl.mod` dependency graph and returns the resolved
external packages, ready to feed back into `execProgram.execArgs.externalPkgs`.

### `listMethod()`

Returns the list of fully-qualified RPC names the runtime implements
(`["KclService.ExecProgram", "KclService.ParseFile", …]`).

## `KclLibAST`

`KclLibAST` is a sibling SwiftPM product in the same package that
parses `ParseFileResult.astJson` / `ParseProgramResult.astJson` into
typed Foundation structs (`Module`, `Stmt`, `Decorator`, `FunctionType`,
`IndexSignature`, …) without going through SwiftProtobuf.

```swift
import KclLibAST

let parsed = try api.parseFile(ParseFileArgs.with { $0.path = "schema.k" })
let module = try KclLibAST.parse(astJson: parsed.astJson)
for stmt in module.body {
    print(strictTypeName(of: stmt))   // "Schema", "Assign", …
}
```

## Buffer convention

`API` allocates a 4 MiB result buffer (`2048 * 2048` `UInt8`s) per
`callNative` invocation and copies the response into it. If you call a
method that returns a payload larger than 4 MiB (notably `loadPackage`
with `resolveAst = true`), bring your own buffer:

```swift
// Future: when `API.callNative` is exposed publicly, callers can
// override the buffer size. Today the 4 MiB default is hard-coded.
```

Track [kcl-lang/lib issue tracker](https://github.com/kcl-lang/lib/issues)
for the buffer-size negotiation patch.

## Errors

| Error                    | When                                                              |
| ------------------------ | ----------------------------------------------------------------- |
| `KclError.runtime("…")`  | The Rust side returned an `"ERROR:<message>"` reply. The prefix is stripped. |
| `SwiftProtobuf.Error`    | The args struct failed to encode, or the response failed to decode.  |

There is no `PluginAgent` callback exposed by `API`; KCL programs that
import `kcl_plugin.*` are not supported from Swift today.

## Examples

The repo ships runnable examples under
[`swift/examples/`](https://github.com/kcl-lang/lib/tree/main/swift/examples)
covering `execProgram`, `parseProgram`, `formatCode`, and the AST
parser.