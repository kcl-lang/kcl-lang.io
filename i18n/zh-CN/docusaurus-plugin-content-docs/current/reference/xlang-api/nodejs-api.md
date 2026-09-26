---
sidebar_position: 6
---

# Node.js API

> **正在寻找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，了解 `call`、`"ERROR:"` 前缀、
> **4 MiB** 的 `BUFFER_SIZE`，以及 `kcl_lib_napi` 的 napi-rs 插件。
> `kcl-lib` 包是覆盖在该单一调度器之上的一个轻量 TypeScript 封装层；
> 每个有类型的函数都会经由
> `napi_call(name, nameLength, args, argsLength, resultPtr)` 进行分发。

[Node.js 绑定](https://github.com/kcl-lang/lib/tree/main/nodejs)
以 npm 包的形式发布：
[`kcl-lib`](https://www.npmjs.com/package/kcl-lib)。它使用
[napi-rs](https://napi.rs/) 构建，并对外暴露完整的 `KclService` +
`BuiltinService` 接口，以及根据 `spec/spec.proto` 自动生成的 TypeScript 类型。
每个平台（`linux-x64-gnu`、`darwin-arm64`、`win32-x64-msvc` 等）
对应一个原生插件，在安装时通过 `optionalDependencies` 进行选择。

## 安装

```shell
npm install kcl-lib
```

## 快速上手

```typescript
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(new ExecProgramArgs(["path/to/kcl.k"]));
  console.log(result.yamlResult);
}

main();
```

## API 参考

### execProgram

执行 KCL 文件并传入参数，返回 JSON/YAML 结果。

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

Node.js 代码

```ts
import { execProgram, ExecProgramArgs } from "kcl-lib";

const result = execProgram(new ExecProgramArgs(["schema.k"]));
```

</p>
</details>

文件未找到错误的示例

<details><summary>示例</summary>
<p>

```ts
import { execProgram, ExecProgramArgs } from "kcl-lib";

try {
  const result = execProgram(new ExecProgramArgs(["file_not_found.k"]));
} catch (error) {
  console.log(error.message);
}
```

</p>
</details>

### parseFile

解析单个 KCL 文件为包含导入依赖与解析错误的 Module AST JSON 字符串。

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

Node.js 代码

```ts
import { parseFile, ParseFileArgs } from "kcl-lib";

const result = parseFile(new ParseFileArgs("schema.k"));
```

</p>
</details>

### parseProgram

通过入口文件解析 KCL 程序，并返回 AST JSON 字符串。

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

Node.js 代码

```ts
import { parseProgram, ParseProgramArgs } from "kcl-lib";

const result = parseProgram(new ParseProgramArgs(["schema.k"]));
```

</p>
</details>

### loadPackage

`loadPackage` 为用户提供了解析 KCL 程序以及获取包含符号、类型、定义等信息的语义模型的能力。

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

Node.js 代码

```ts
import { loadPackage, LoadPackageArgs } from "kcl-lib";

const result = loadPackage(new LoadPackageArgs(["schema.k"], [], true));
```

</p>
</details>

### listVariable

`listVariables` 为用户提供了解析 KCL 程序并按规范获取全部变量的能力。

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

Node.js 代码

```ts
import { listVariables, ListVariablesArgs } from "kcl-lib";

const result = listVariables(new ListVariablesArgs(["schema.k"], []));
```

</p>
</details>

### listOptions

`listOptions` 为用户提供了解析 KCL 程序并获取全部 option 信息的能力。

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

Node.js 代码

```ts
import { listOptions, ListOptionsArgs } from "kcl-lib";

const result = listOptions(new ListOptionsArgs(["options.k"]));
```

</p>
</details>

### getSchemaTypeMapping

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

Node.js 代码

```ts
import { getSchemaTypeMapping, GetSchemaTypeMappingArgs } from "kcl-lib";

const result = getSchemaTypeMapping(new GetSchemaTypeMappingArgs(["schema.k"]));
```

</p>
</details>

### getSchemaTypeMappingUnderPath

获取程序及其依赖包中定义的 schema 类型映射，以包名作为键。与 `getSchemaTypeMapping` 不同的是，从外部依赖包导入的 schema 会以其所属的包名作为键，而不会被扁平化到 `__main__` 下。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import path from 'node:path'
import { getSchemaTypeMappingUnderPath, GetSchemaTypeMappingArgs } from "kcl-lib";

const result = getSchemaTypeMappingUnderPath(
    new GetSchemaTypeMappingArgs([path.join("test_data", "get_schema_ty_under_path", "aaa")], null, null, [
        { pkgName: "bbb", pkgPath: path.join("test_data", "get_schema_ty_under_path", "bbb") },
    ]),
);
console.log(result.schemaTypeMapping["bbb"]);  // ["B", "Base"]
```

</p>
</details>

### overrideFile

使用参数覆盖 KCL 文件。更多覆盖规范说明，请参阅 [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation)。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
schema AppConfig:
    replicas: int

app: AppConfig {replicas: 4}
```

Node.js 代码

```ts
import { overrideFile, OverrideFileArgs } from "kcl-lib";

const result = overrideFile(
  new OverrideFileArgs("main.k", ["app.replicas=4"], []),
);
```

</p>
</details>

### formatCode

格式化源代码。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import { formatCode, FormatCodeArgs } from "kcl-lib";

const schemaCode = `
schema Person:
    name:   str
    age:    int

    check:
        0 <   age <   120
`;
const result = formatCode(new FormatCodeArgs(schemaCode));
console.log(result.formatted);
```

</p>
</details>

### formatPath

格式化 KCL 文件或包含 KCL 文件的目录路径，并返回被改动的文件路径列表。

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

Node.js 代码

```ts
import { formatPath, FormatPathArgs } from "kcl-lib";

const result = formatPath(new FormatPathArgs("format_path.k"));
```

</p>
</details>

### lintPath

对文件进行 lint 检查，并返回包含错误与警告在内的错误信息。

<details><summary>示例</summary>
<p>

`lint_path.k` 的内容为

```kcl
import math

a = 1
```

Node.js 代码

```ts
import { lintPath, LintPathArgs } from "kcl-lib";

const result = lintPath(new LintPathArgs(["lint_path.k"]));
```

</p>
</details>

### validateCode

使用 schema 与 JSON/YAML 数据字符串对代码进行校验。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import { validateCode, ValidateCodeArgs } from "kcl-lib";

const code = `
schema Person:
    name: str
    age: int

    check:
        0 < age < 120
`;
const data = '{"name": "Alice", "age": 10}';
const result = validateCode(
  new ValidateCodeArgs(undefined, data, undefined, code),
);
```

</p>
</details>

### rename

将文件中目标符号的所有出现全部重命名。若文件包含需要重命名的符号，本 API 会改写文件。返回发生变更的文件路径。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
a = 1
b = a
```

Node.js 代码

```ts
import { rename, RenameArgs } from "kcl-lib";

const args = new RenameArgs(".", "a", ["main.k"], "a2");
const result = rename(args);
```

</p>
</details>

### renameCode

将目标符号的所有出现全部重命名，并在代码发生变化时返回修改后的代码。本 API 不会改写文件，而是返回变更后的代码。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import { renameCode, RenameCodeArgs } from "kcl-lib";

const args = RenameCodeArgs(
  "/mock/path",
  "a",
  { "/mock/path/main.k": "a = 1\nb = a" },
  "a2",
);
const result = renameCode(args);
```

</p>
</details>

### test

使用测试参数测试 KCL 包。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import { test as kclTest, TestArgs } from "kcl-lib";

const result = kclTest(new TestArgs(["/path/to/test/module/..."]));
```

</p>
</details>

### loadSettingsFiles

加载在 `kcl.yaml` 中定义的配置文件。

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

Node.js 代码

```ts
import { loadSettingsFiles, LoadSettingsFilesArgs } from "kcl-lib";

const result = loadSettingsFiles(new LoadSettingsFilesArgs(".", ["kcl.yaml"]));
```

</p>
</details>

### updateDependencies

下载并更新在 `kcl.mod` 文件中定义的依赖，并返回外部包的名称与位置列表。

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

Node.js 代码

```ts
import { updateDependencies, UpdateDependenciesArgs } from "kcl-lib";

const result = updateDependencies(new UpdateDependenciesArgs("module", false));
```

</p>
</details>

使用外部依赖调用 `execProgram`

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

Node.js 代码

```ts
import {
  execProgram,
  ExecProgramArgs,
  updateDependencies,
  UpdateDependenciesArgs,
} from "../index.js";

const result = updateDependencies(new UpdateDependenciesArgs("module", false));
const execResult = execProgram(
  new ExecProgramArgs(
    ["module/main.k"],
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    undefined,
    result.externalPkgs,
  ),
);
```

</p>
</details>

### getVersion

返回 KCL 服务的版本信息。

<details><summary>示例</summary>
<p>

Node.js 代码

```ts
import { getVersion } from "../index.js";

const result = getVersion();
console.log(result.versionInfo);
```

（具体的 `version` / `checksum` / `gitSha` 值随版本而变化；
只需断言其非空即可。）

</p>
</details>

### ping

通过调度器对一个值进行往返回显。

<details><summary>示例</summary>
<p>

```ts
import { ping, PingArgs } from "kcl-lib";

const result = ping(new PingArgs("hello"));
console.log(result.value);   // -> "hello"
```

</p>
</details>

### listMethod

列出底层运行时所支持的 KCL 服务方法名。

<details><summary>示例</summary>
<p>

```ts
import { listMethod } from "kcl-lib";

for (const name of listMethod().methodNameList) {
  console.log(name);
}
```

</p>
</details>

## 插件支持

如果你的 KCL 程序导入了 `kcl_plugin.*`，请在调用任何 RPC 之前先注册插件：

```ts
import { registerPlugin, execProgram, ExecProgramArgs } from "kcl-lib";

registerPlugin("my_plugin", {
  echo(args, kwargs) { return { ...args, ...kwargs }; },
});

const result = execProgram(new ExecProgramArgs(["schema.k"]));
```

## 注意事项

旧版的 `BuildProgram` 与 `ExecArtifact` RPC 已于 v0.13.0 从
`spec/spec.proto` 中移除（参见
[lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；
调度器已不再识别它们。若你之前曾导入过 `buildProgram` 或 `execArtifact` 符号，
请改用 `execProgram`。