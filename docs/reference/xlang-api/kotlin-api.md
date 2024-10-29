---
sidebar_position: 8
---

# Kotlin API

## Installation

Refer to [this](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry#authenticating-to-github-packages) to configure your Maven; set up your GitHub account and Token in the `settings.xml`.

### Maven

In your project's pom.xml, configure our repository as follows:

```xml
<repositories>
    <repository>
        <id>github</id>
        <url>https://maven.pkg.github.com/kcl-lang/*</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
</repositories>
```

This way you'll be able to import the above dependency to use the SDK.

```xml
<dependency>
    <groupId>com.kcl</groupId>
    <artifactId>kcl-lib-kotlin</artifactId>
    <version>0.10.7-SNAPSHOT</version>
</dependency>
```

## Quick Start

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs

val args = execProgramArgs { kFilenameList += "schema.k" }
val api = API()
val result = api.execProgram(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs

val args = execProgramArgs { kFilenameList += "schema.k" }
val api = API()
val result = api.execProgram(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.parseFileArgs

val args = parseFileArgs { path = "schema.k" }
val api = API()
val result = api.parseFile(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.loadPackageArgs
import com.kcl.api.parseProgramArgs

val args = loadPackageArgs { parseArgs = parseProgramArgs { paths += "schema.k" }; resolveAst = true }
val api = API()
val result = api.loadPackage(args)
```

</p>
</details>

### listVariables

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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.listVariablesArgs

val args = listVariablesArgs { files += "./src/test_data/schema.k" }
val api = API()
val result = api.listVariables(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.parseProgramArgs

val args = parseProgramArgs { paths += "options.k" }
val api = API()
val result = api.listOptions(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs
import com.kcl.api.getSchemaTypeMappingArgs

val args = getSchemaTypeMappingArgs { execArgs = execProgramArgs { kFilenameList += "schema.k" } }
val api = API()
val result = api.getSchemaTypeMapping(args)
val appSchemaType = result.schemaTypeMappingMap["app"] ?: throw AssertionError("App schema type not found")
val replicasAttr = appSchemaType.properties["replicas"] ?: throw AssertionError("App schema type of `replicas` not found")
```

</p>
</details>

### overrideFile

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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.overrideFileArgs

val api = API()
val result = api.overrideFile(
    overrideFileArgs {
        file = "main.k";
        specs += spec
    }
)
```

</p>
</details>

### formatCode

Format the code source.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.formatCodeArgs

val sourceCode = "schema Person:\n" +
        "    name:   str\n" +
        "    age:    int\n" +
        "    check:\n" +
        "        0 <   age <   120\n"
val args = formatCodeArgs { source = sourceCode }
val api = API()
val result = api.formatCode(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.formatPathArgs

val args = formatPathArgs { path = "format_path.k" }
val api = API()
val result = api.formatPath(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.lintPathArgs

val args = lintPathArgs { paths += "lint_path.k" }
val api = API()
val result = api.lintPath(args)
```

</p>
</details>

### validateCode

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.validateCodeArgs

val args = validateCodeArgs {
    code =  "schema Person:\n" + "    name: str\n" + "    age: int\n" + "    check:\n" + "        0 < age < 120\n"
    data = "{\"name\": \"Alice\", \"age\": 10}"
}
val api = API();
val result = api.validateCode(args);
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.renameArgs

val args = renameArgs {
    packageRoot = "."
    filePaths += "./main.k"
    symbolPath = "a"
    newName = "a2"
}
val api = API()
val result = api.rename(args)
```

</p>
</details>

### renameCode

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.renameCodeArgs

val api = API()
val args = renameCodeArgs {
    packageRoot = "/mock/path"
    sourceCodes.put("/mock/path/main.k", "a = 1\nb = a")
    symbolPath = "a"
    newName = "a2"
}
val result = api.renameCode(args)
```

</p>
</details>

### test

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.testArgs

val args = testArgs {
    pkgList += "/path/to/test/package"
}
val api = API()
val result = api.test(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.loadSettingsFilesArgs

val args = loadSettingsFilesArgs { files += "kcl.yaml" }
val api = API()
val result = api.loadSettingsFiles(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.updateDependenciesArgs

val api = API()
val args = updateDependenciesArgs { manifestPath = "module" }
val result = api.updateDependencies(args)
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

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs
import com.kcl.api.updateDependenciesArgs

val api = API()
val args = updateDependenciesArgs { manifestPath = "module" }
val result = api.updateDependencies(args)
val execArgs = execProgramArgs {
    kFilenameList += "module/main.k"
    externalPkgs.addAll(result.externalPkgsList)
}
val execResult = api.execProgram(execArgs)
```

</p>
</details>

### getVersion

Return the KCL service version information.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
import com.kcl.api.API
import com.kcl.api.getVersionArgs

val api = API()
val args = getVersionArgs {}
val result = api.getVersion(args)
```

</p>
</details>
