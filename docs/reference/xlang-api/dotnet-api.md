---
sidebar_position: 5
---

# .NET API

## Installation

```shell
dotnet add package KclLib
```

## Quick Start

```typescript
using KclLib.API;

var api = new API();
var execArgs = new ExecProgram_Args();
var path = Path.Combine("test_data", "schema.k");
execArgs.KFilenameList.Add(path);
var result = api.ExecProgram(execArgs);
Console.WriteLine(result.YamlResult);
```

## API Reference

### ExecProgram

Execute KCL file with arguments and return the JSON/YAML result.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var execArgs = new ExecProgram_Args();
var path = "schema.k"
execArgs.KFilenameList.Add(path);
var result = new API().ExecProgram(execArgs);
```

</p>
</details>

### ParseProgram

Parse KCL program with entry files and return the AST JSON string.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var path = "schema.k"
var args = new ParseProgram_Args();
args.Paths.Add(path);
var result = new API().ParseProgram(args);
```

</p>
</details>

### ParseFile

Parse KCL single file to Module AST JSON string with import dependencies and parse errors.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var path = "schema.k"
var args = new ParseFile_Args { Path = path };
var result = new API().ParseFile(args);
```

</p>
</details>

### ParseProgram

Parse KCL program with entry files and return the AST JSON string.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var path = "schema.k";
var args = new ParseProgram_Args();
args.Paths.Add(path);
var result = new API().ListOptions(args);
```

</p>
</details>

### LoadPackage

LoadPackage provides users with the ability to parse KCL program and semantic model information including symbols, types, definitions, etc.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var path = "schema.k";
var args = new LoadPackage_Args();
args.ResolveAst = true;
args.ParseArgs = new ParseProgram_Args();
args.ParseArgs.Paths.Add(path);
var result = new API().LoadPackage(args);
```

</p>
</details>

### ListVariables

ListVariables provides users with the ability to parse KCL program and get all variables by specs.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var api = new API();
var args = new ListVariables_Args();
var path = "schema.k";
args.Files.Add(path);
var result = api.ListVariables(args);
```

</p>
</details>

### ListOptions

ListOptions provides users with the ability to parse KCL program and get all option information.

<details><summary>Example</summary>
<p>

The content of `options.k` is

```python
a = option("key1")
b = option("key2", required=True)
c = {
    metadata.key = option("metadata-key")
}
```

C# Code

```csharp
using KclLib.API;

var path = "options.k";
var args = new ParseProgram_Args();
args.Paths.Add(path);
var result = new API().ListOptions(args);
```

</p>
</details>

### GetSchemaTypeMapping

Get schema type mapping defined in the program.

<details><summary>Example</summary>
<p>

The content of `schema.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {
    replicas: 2
}
```

C# Code

```csharp
using KclLib.API;

var path = "schema.k";
var execArgs = new ExecProgram_Args();
execArgs.KFilenameList.Add(path);
var args = new GetSchemaTypeMapping_Args();
args.ExecArgs = execArgs;
var result = new API().GetSchemaTypeMapping(args);
```

</p>
</details>

### OverrideFile

Override KCL file with arguments. See [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation) for more override spec guide.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
a = 1

b = {
    "a": 1
    "b": 2
}
```

C# Code

```csharp
using KclLib.API;

var args = new OverrideFile_Args
{
    File = "main.k",
};
args.Specs.Add("b.a=2");
var result = new API().OverrideFile(args);
```

</p>
</details>

### FormatCode

Format the code source.

<details><summary>Example</summary>
<p>

C# Code

```csharp
using KclLib.API;

string sourceCode = "schema Person:\n" + "    name:   str\n" + "    age:    int\n" + "    check:\n"
    + "        0 <   age <   120\n";
string expectedFormattedCode = "schema Person:\n" + "    name: str\n" + "    age: int\n\n" + "    check:\n"
    + "        0 < age < 120\n\n";
var api = new API();
var args = new FormatCode_Args();
args.Source = sourceCode;
var result = api.FormatCode(args);
```

</p>
</details>

### FormatPath

Format KCL file or directory path contains KCL files and returns the changed file paths.

<details><summary>Example</summary>
<p>

The content of `format_path.k` is

```python
schema Person:
    name:   str
    age:    int

    check:
        0 <   age <   120
```

C# Code

```csharp
using KclLib.API;

var api = new API();
var args = new FormatPath_Args();
var path = "format_path.k";
args.Path = path;
var result = api.FormatPath(args);
```

</p>
</details>

### LintPath

Lint files and return error messages including errors and warnings.

<details><summary>Example</summary>
<p>

The content of `lint_path.k` is

```python
import math

a = 1
```

C# Code

```csharp
using KclLib.API;

var path = "lint_path.k"
var args = new LintPath_Args();
args.Paths.Add(path);
var result = new API().LintPath(args);
bool foundWarning = result.Results.Any(warning => warning.Contains("Module 'math' imported but unused"));
```

</p>
</details>

### ValidateCode

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

C# Code

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
var args = new ValidateCode_Args
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

Rename all the occurrences of the target symbol in the files. This API will rewrite files if they contain symbols to be renamed. Return the file paths that got changed.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
a = 1
b = a
```

C# Code

```csharp
using KclLib.API;

Rename_Args args = Rename_Args.newBuilder().setPackageRoot(".").setSymbolPath("a")
        .addFilePaths("main.k").setNewName("a2").build();
API apiInstance = new API();
Rename_Result result = apiInstance.rename(args);
```

</p>
</details>

### RenameCode

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

C# Code

```csharp
using KclLib.API;

var args = new RenameCode_Args
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

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

C# Code

```csharp
using KclLib.API;

var pkg = Path.Combine(parentDirectory, "test_data", "testing");
var args = new Test_Args();
args.PkgList.Add(pkg + "/...");
var result = new API().Test(args);
```

</p>
</details>

### LoadSettingsFiles

Load the setting file config defined in `kcl.yaml`

<details><summary>Example</summary>
<p>

The content of `kcl.yaml` is

```yaml
kcl_cli_configs:
  strict_range_check: true
kcl_options:
  - key: key
    value: value
```

C# Code

```csharp
using KclLib.API;

var workDir = ".";
var settingsFile = "kcl.yaml";
var args = new LoadSettingsFiles_Args
{
    WorkDir = workDir,
};
args.Files.Add(settingsFile);
var result = new API().LoadSettingsFiles(args);
```

</p>
</details>

### UpdateDependencies

Download and update dependencies defined in the `kcl.mod` file and return the external package name and location list.

<details><summary>Example</summary>
<p>

The content of `module/kcl.mod` is

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

C# Code

```csharp
using KclLib.API;

var manifestPath = "module";
var args = new UpdateDependencies_Args { ManifestPath = manifestPath };
var result = new API().UpdateDependencies(args);
```

</p>
</details>

Call `ExecProgram` with external dependencies

<details><summary>Example</summary>
<p>

The content of `module/kcl.mod` is

```yaml
[package]
name = "mod_update"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
flask = { git = "https://github.com/kcl-lang/flask-demo-kcl-manifests", commit = "ade147b" }
```

The content of `module/main.k` is

```python
import helloworld
import flask

a = helloworld.The_first_kcl_program
```

C# Code

```csharp
using KclLib.API;

API api = new API();

var manifestPath = "module";
var testFile = Path.Combine(manifestPath, "main.k");
var updateArgs = new UpdateDependencies_Args { ManifestPath = manifestPath };
var depResult = new API().UpdateDependencies(updateArgs);
var execArgs = new ExecProgram_Args();
execArgs.KFilenameList.Add(testFile);
execArgs.ExternalPkgs.AddRange(depResult.ExternalPkgs);
var execResult = new API().ExecProgram(execArgs);
```

</p>
</details>

### GetVersion

Return the KCL service version information.

<details><summary>Example</summary>
<p>

C# Code

```csharp
using KclLib.API;

var result = new API().GetVersion(new GetVersion_Args());
```

</p>
</details>
