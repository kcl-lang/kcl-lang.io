---
sidebar_position: 5
---

# .NET API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md) 了解 `call_native`、
> `call_native_with_plugin_agent`、`"ERROR:"` 前缀、
> **4 MiB** 的 `BUFFER_SIZE` 以及 `kcl_lib_dotnet` cdylib。
> 下面的 `KclLib.API.API` 类是该单一调度器的轻量级 C# 包装层，
> 每个类型化方法都通过 `Call(name, args)` 汇集。

[.NET 绑定](https://github.com/kcl-lang/lib/tree/main/dotnet)以 NuGet 包
[`KclLib`](https://www.nuget.org/packages/KclLib) 的形式发布。
它捆绑了预构建的 `kcl_lib_dotnet` 原生共享库以及自动生成的 C# protobuf 类
（`KclLib.API.Spec`）。分为两层：

- **`KclLib.API.API`** — 实现 `IService` 的类，将所有 21 个类型化 RPC 方法
  作为普通 C# 类的实例方法公开。每个方法都会将其 `*Args` proto 进行序列化，
  调用 `Call(name, bytes)`，解析返回的 proto，并将调度器的 `"ERROR:..."`
  应答作为抛出的 `Exception` 暴露给调用方。
- **原生 cdylib** — `libkcl_lib_dotnet.so` / `.dylib` / `.dll`，
  由 `csbindgen` 从为每个绑定提供支持的同一个 `kcl_api` Rust crate 生成。

## 安装

```shell
dotnet add package KclLib
```

该包捆绑了 `linux-x64`、`linux-arm64`、`osx-x64`、`osx-arm64` 以及
`win-x64` 的原生运行时。构建时无需 `protoc` 或 Rust 工具链。

## 快速上手

```csharp
using KclLib.API;

var api = new API();
var execArgs = new ExecProgramArgs();
var path = Path.Combine("test_data", "schema.k");
execArgs.KFilenameList.Add(path);
var result = api.ExecProgram(execArgs);
Console.WriteLine(result.YamlResult);
```

## API 参考

### ExecProgram

使用参数执行 KCL 文件，并返回 JSON/YAML 结果。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var execArgs = new ExecProgramArgs();
var path = "schema.k"
execArgs.KFilenameList.Add(path);
var result = new API().ExecProgram(execArgs);
```

</p>
</details>

### ParseFile

将单个 KCL 文件解析为包含导入依赖和解析错误的 Module AST JSON 字符串。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var path = "schema.k"
var args = new ParseFileArgs { Path = path };
var result = new API().ParseFile(args);
```

</p>
</details>

### ParseProgram

使用入口文件解析 KCL 程序，并返回 AST JSON 字符串。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var path = "schema.k";
var args = new ParseProgramArgs();
args.Paths.Add(path);
var result = new API().ListOptions(args);
```

</p>
</details>

### LoadPackage

LoadPackage 为用户提供了解析 KCL 程序以及语义模型信息（包括符号、类型、定义等）的能力。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var path = "schema.k";
var args = new LoadPackageArgs();
args.ResolveAst = true;
args.ParseArgs = new ParseProgramArgs();
args.ParseArgs.Paths.Add(path);
var result = new API().LoadPackage(args);
```

</p>
</details>

### ListVariables

ListVariables 为用户提供了解析 KCL 程序并按规格获取所有变量的能力。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var api = new API();
var args = new ListVariablesArgs();
var path = "schema.k";
args.Files.Add(path);
var result = api.ListVariables(args);
```

</p>
</details>

### ListOptions

ListOptions 为用户提供了解析 KCL 程序并获取所有 option 信息的能力。

<details><summary>示例</summary>
<p>

`options.k` 的内容为

```kcl
a = option("key1")
b = option("key2", required=True)
c = {
    metadata.key = option("metadata-key")
}
```

C# 代码

```csharp
using KclLib.API;

var path = "options.k";
var args = new ParseProgramArgs();
args.Paths.Add(path);
var result = new API().ListOptions(args);
```

</p>
</details>

### GetSchemaTypeMapping

获取程序中定义的 schema 类型映射。

<details><summary>示例</summary>
<p>

`schema.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# 代码

```csharp
using KclLib.API;

var path = "schema.k";
var execArgs = new ExecProgramArgs();
execArgs.KFilenameList.Add(path);
var args = new GetSchemaTypeMappingArgs();
args.ExecArgs = execArgs;
var result = new API().GetSchemaTypeMapping(args);
```

</p>
</details>

### GetSchemaTypeMappingUnderPath

获取程序及其依赖包中定义的 schema 类型映射，按包名作为键。与
`GetSchemaTypeMapping` 不同的是，从外部依赖包导入的 schema 会以自身的
包名作为键，而不是被扁平化到 `__main__` 之下。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

var root = Path.GetFullPath("test_data/get_schema_ty_under_path");
var execArgs = new ExecProgramArgs();
execArgs.KFilenameList.Add(Path.Combine(root, "aaa"));
execArgs.ExternalPkgs.Add(new ExternalPkg { PkgName = "bbb", PkgPath = Path.Combine(root, "bbb") });
var args = new GetSchemaTypeMappingArgs();
args.ExecArgs = execArgs;
var result = new API().GetSchemaTypeMappingUnderPath(args);
var bbbSchemas = result.SchemaTypeMapping["bbb"].SchemaType.ToDictionary(s => s.SchemaName);
```

</p>
</details>

### OverrideFile

使用参数覆盖 KCL 文件。有关更多覆盖规范的指南，请参阅
[https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation)。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
a = 1

b = {
    "a": 1
    "b": 2
}
```

C# 代码

```csharp
using KclLib.API;

var args = new OverrideFileArgs
{
    File = "main.k",
};
args.Specs.Add("b.a=2");
var result = new API().OverrideFile(args);
```

</p>
</details>

### FormatCode

格式化代码源码。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

string sourceCode = "schema Person:\n" + "    name:   str\n" + "    age:    int\n" + "    check:\n"
    + "        0 <   age <   120\n";
string expectedFormattedCode = "schema Person:\n" + "    name: str\n" + "    age: int\n\n" + "    check:\n"
    + "        0 < age < 120\n\n";
var api = new API();
var args = new FormatCodeArgs();
args.Source = sourceCode;
var result = api.FormatCode(args);
```

</p>
</details>

### FormatPath

格式化 KCL 文件或包含 KCL 文件的目录路径，并返回发生变更的文件路径。

<details><summary>示例</summary>
<p>

`format_path.k` 的内容为

```kcl
schema Person:
    name:   str
    age:    int

    check:
        0 <   age <   120
```

C# 代码

```csharp
using KclLib.API;

var api = new API();
var args = new FormatPathArgs();
var path = "format_path.k";
args.Path = path;
var result = api.FormatPath(args);
```

</p>
</details>

### LintPath

对文件执行 lint，并返回包括错误和警告在内的错误信息。

<details><summary>示例</summary>
<p>

`lint_path.k` 的内容为

```kcl
import math

a = 1
```

C# 代码

```csharp
using KclLib.API;

var path = "lint_path.k"
var args = new LintPathArgs();
args.Paths.Add(path);
var result = new API().LintPath(args);
bool foundWarning = result.Results.Any(warning => warning.Contains("Module 'math' imported but unused"));
```

</p>
</details>

### ValidateCode

使用 schema 和 JSON/YAML 数据字符串校验代码。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

string code = @"
schema Person:
    name: str
    age: int
    check:
        0 < age < 120
";
string data = "{\"name\": \"Alice\", \"age\": 10}";
var args = new ValidateCodeArgs
{
    Code = code,
    Data = data,
    Format = "json"
};
var result = new API().ValidateCode(args);
```

</p>
</details>

### Rename

重命名文件中目标符号的所有出现位置。如果文件中包含待重命名的符号，
该 API 将重写这些文件，并返回发生变更的文件路径。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
a = 1
b = a
```

C# 代码

```csharp
using KclLib.API;

RenameArgs args = RenameArgs.newBuilder().setPackageRoot(".").setSymbolPath("a")
        .addFilePaths("main.k").setNewName("a2").build();
API apiInstance = new API();
RenameResult result = apiInstance.rename(args);
```

</p>
</details>

### RenameCode

重命名目标符号的所有出现位置，并在有任何代码被修改时返回修改后的代码。
该 API 不会重写文件，而是返回变更后的代码。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

var args = new RenameCodeArgs
{
    PackageRoot = "/mock/path",
    SymbolPath = "a",
    SourceCodes = { { "/mock/path/main.k", "a = 1\nb = a" } },
    NewName = "a2"
};
var result = new API().RenameCode(args);
```

</p>
</details>

### Test

使用测试参数对 KCL 包进行测试。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

var pkg = Path.Combine(parentDirectory, "test_data", "testing");
var args = new TestArgs();
args.PkgList.Add(pkg + "/...");
var result = new API().Test(args);
```

</p>
</details>

### LoadSettingsFiles

加载在 `kcl.yaml` 中定义的配置文件配置。

<details><summary>示例</summary>
<p>

`kcl.yaml` 的内容为

```yaml
kcl_cli_configs:
  strict_range_check: true
kcl_options:
  - key: key
    value: value
```

C# 代码

```csharp
using KclLib.API;

var workDir = ".";
var settingsFile = "kcl.yaml";
var args = new LoadSettingsFilesArgs
{
    WorkDir = workDir,
};
args.Files.Add(settingsFile);
var result = new API().LoadSettingsFiles(args);
```

</p>
</details>

### UpdateDependencies

下载并更新 `kcl.mod` 文件中定义的依赖，并返回外部包的名称及位置列表。

<details><summary>示例</summary>
<p>

`module/kcl.mod` 的内容为

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

C# 代码

```csharp
using KclLib.API;

var manifestPath = "module";
var args = new UpdateDependenciesArgs { ManifestPath = manifestPath };
var result = new API().UpdateDependencies(args);
```

</p>
</details>

使用外部依赖调用 `ExecProgram`

<details><summary>示例</summary>
<p>

`module/kcl.mod` 的内容为

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

`module/main.k` 的内容为

```kcl
import helloworld
import flask

a = helloworld.The_first_kcl_program
```

C# 代码

```csharp
using KclLib.API;

API api = new API();

var manifestPath = "module";
var testFile = Path.Combine(manifestPath, "main.k");
var updateArgs = new UpdateDependenciesArgs { ManifestPath = manifestPath };
var depResult = new API().UpdateDependencies(updateArgs);
var execArgs = new ExecProgramArgs();
execArgs.KFilenameList.Add(testFile);
execArgs.ExternalPkgs.AddRange(depResult.ExternalPkgs);
var execResult = new API().ExecProgram(execArgs);
```

</p>
</details>

### GetVersion

返回 KCL 服务的版本信息。

<details><summary>示例</summary>
<p>

C# 代码

```csharp
using KclLib.API;

var result = new API().GetVersion(new GetVersionArgs());
```

（具体的 `version` / `checksum` / `git_sha` 值会因发布版本而异，
请仅断言它们非空。）

</p>
</details>

### Ping

通过调度器往返传递一个值。

<details><summary>示例</summary>
<p>

```csharp
using KclLib.API;

var result = new API().Ping(new PingArgs { Value = "hello" });
Console.WriteLine(result.Value);   // -> "hello"
```

</p>
</details>

### ListMethod

列出底层运行时支持的 KCL 服务方法名称。

<details><summary>示例</summary>
<p>

```csharp
using KclLib.API;

foreach (var name in new API().ListMethod().MethodNameList)
{
    Console.WriteLine(name);
}
```

</p>
</details>

## 注意事项

旧版的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 中从 `spec/spec.proto`
中移除（参见
[lib 提交 `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；
它们不再被 `KclLib.API.API` 调度器识别。如果你之前调用过
`api.BuildProgram(...)` 或 `api.ExecArtifact(...)`，请改用 `api.ExecProgram(...)`。