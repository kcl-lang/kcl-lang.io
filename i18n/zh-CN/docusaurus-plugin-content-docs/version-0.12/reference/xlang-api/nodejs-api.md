---
sidebar_position: 6
---

# Node.js API

## Installation

```shell
npm install kcl-lib
```

## Quick Start

```typescript
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(new ExecProgramArgs(["path/to/kcl.k"]));
  console.log(result.yamlResult);
}

main();
```

## API Reference

### execProgram

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

Node.js Code

```ts
import { execProgram, ExecProgramArgs } from "kcl-lib";

const result = execProgram(new ExecProgramArgs(["schema.k"]));
```

</p>
</details>

A case with the file not found error

<details><summary>Example</summary>
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

Node.js Code

```ts
import { parseFile, ParseFileArgs } from "kcl-lib";

const result = parseFile(new ParseFileArgs("schema.k"));
```

</p>
</details>

### parseProgram

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

Node.js Code

```ts
import { parseProgram, ParseProgramArgs } from "kcl-lib";

const result = parseProgram(new ParseProgramArgs(["schema.k"]));
```

</p>
</details>

### loadPackage

loadPackage provides users with the ability to parse KCL program and semantic model information including symbols, types, definitions, etc.

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

Node.js Code

```ts
import { loadPackage, LoadPackageArgs } from "kcl-lib";

const result = loadPackage(new LoadPackageArgs(["schema.k"], [], true));
```

</p>
</details>

### listVariable

listVariables provides users with the ability to parse KCL program and get all variables by specs.

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

Node.js Code

```ts
import { listVariables, ListVariablesArgs } from "kcl-lib";

const result = listVariables(new ListVariablesArgs(["schema.k"], []));
```

</p>
</details>

### listOptions

listOptions provides users with the ability to parse KCL program and get all option information.

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

Node.js Code

```ts
import { listOptions, ListOptionsArgs } from "kcl-lib";

const result = listOptions(new ListOptionsArgs(["options.k"]));
```

</p>
</details>

### getSchemaTypeMapping

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

Node.js Code

```ts
import { getSchemaTypeMapping, GetSchemaTypeMappingArgs } from "kcl-lib";

const result = getSchemaTypeMapping(new GetSchemaTypeMappingArgs(["schema.k"]));
```

</p>
</details>

### overrideFile

Override KCL file with arguments. See [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation) for more override spec guide.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
schema AppConfig:
    replicas: int

app: AppConfig {replicas: 4}
```

Node.js Code

```ts
import { overrideFile, OverrideFileArgs } from "kcl-lib";

const result = overrideFile(
  new OverrideFileArgs("main.k", ["app.replicas=4"], []),
);
```

</p>
</details>

### formatCode

Format the code source.

<details><summary>Example</summary>
<p>

Node.js Code

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

Node.js Code

```ts
import { formatPath, FormatPathArgs } from "kcl-lib";

const result = formatPath(new FormatPathArgs("format_path.k"));
```

</p>
</details>

### lintPath

Lint files and return error messages including errors and warnings.

<details><summary>Example</summary>
<p>

The content of `lint_path.k` is

```python
import math

a = 1
```

Node.js Code

```ts
import { lintPath, LintPathArgs } from "kcl-lib";

const result = lintPath(new LintPathArgs(["lint_path.k"]));
```

</p>
</details>

### validateCode

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

Node.js Code

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

Rename all the occurrences of the target symbol in the files. This API will rewrite files if they contain symbols to be renamed. Return the file paths that got changed.

<details><summary>Example</summary>
<p>

The content of `main.k` is

```python
a = 1
b = a
```

Node.js Code

```ts
import { rename, RenameArgs } from "kcl-lib";

const args = new RenameArgs(".", "a", ["main.k"], "a2");
const result = rename(args);
```

</p>
</details>

### renameCode

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

Node.js Code

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

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

Node.js Code

```ts
import { test as kclTest, TestArgs } from "kcl-lib";

const result = kclTest(new TestArgs(["/path/to/test/module/..."]));
```

</p>
</details>

### loadSettingsFiles

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

Node.js Code

```ts
import { loadSettingsFiles, LoadSettingsFilesArgs } from "kcl-lib";

const result = loadSettingsFiles(new LoadSettingsFilesArgs(".", ["kcl.yaml"]));
```

</p>
</details>

### updateDependencies

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

Node.js Code

```ts
import { updateDependencies, UpdateDependenciesArgs } from "kcl-lib";

const result = updateDependencies(new UpdateDependenciesArgs("module", false));
```

</p>
</details>

Call `execProgram` with external dependencies

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

Node.js Code

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

Return the KCL service version information.

<details><summary>Example</summary>
<p>

Node.js Code

```ts
import { getVersion } from "../index.js";

const result = getVersion();
console.log(result.versionInfo);
```

</p>
</details>
