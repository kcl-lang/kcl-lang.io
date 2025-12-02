---
sidebar_position: 5
---

# Java API

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
    <artifactId>kcl-lib</artifactId>
    <version>0.12.1</version>
</dependency>
```

## Quick Start

```java
import com.kcl.api.API;
import com.kcl.api.Spec.ExecProgramArgs;
import com.kcl.api.Spec.ExecProgramResult;

public class ExecProgramTest {
    public static void main(String[] args) throws Exception {
        API api = new API();
        ExecProgramResult result = api
                .execProgram(ExecProgramArgs.newBuilder().addKFilenameList("path/to/kcl.k").build());
        System.out.println(result.getYamlResult());
    }
}
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

Java Code

```java
import com.kcl.api.*;

ExecProgramArgs args = ExecProgramArgs.newBuilder().addKFilenameList("schema.k").build();
API apiInstance = new API();
ExecProgramResult result = apiInstance.execProgram(args);
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

Java Code

```java
import com.kcl.api.*;

ParseFileArgs args = ParseFileArgs.newBuilder().setPath("schema.k").build();
API apiInstance = new API();
ParseFileResult result = apiInstance.parseFile(args);
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

Java Code

```java
import com.kcl.api.*;
import com.kcl.ast.*;
import com.kcl.util.JsonUtil;

API api = new API();
ParseProgramResult result = api.parseProgram(
   ParseProgramArgs.newBuilder().addPaths("path/to/kcl.k").build()
);
System.out.println(result.getAstJson());
Program program = JsonUtil.deserializeProgram(result.getAstJson());
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

Java Code

```java
import com.kcl.api.*;

API api = new API();
LoadPackageResult result = api.loadPackage(LoadPackageArgs.newBuilder().setResolveAst(true)
    .setWithAstIndex(true)
    .setParseArgs(ParseProgramArgs.newBuilder().addPaths("schema.k").build()).build());
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

Java Code

```java
import com.kcl.api.*;

API api = new API();
ListVariablesResult result = api.listVariables(
    ListVariablesArgs.newBuilder().setResolveAst(true).setParseArgs(
    ParseProgramArgs.newBuilder().addPaths("/path/to/kcl.k").build())
    .build());
result.getSymbolsMap().values().forEach(s -> System.out.println(s));
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

Java Code

```java
import com.kcl.api.*;

ParseProgramArgs args = ParseProgramArgs.newBuilder().addPaths("./src/test_data/option/main.k").build();
API apiInstance = new API();
ListOptionsResult result = apiInstance.listOptions(args);
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

Java Code

```java
import com.kcl.api.*;

ExecProgramArgs execArgs = ExecProgramArgs.newBuilder().addKFilenameList("schema.k").build();
GetSchemaTypeMappingArgs args = GetSchemaTypeMappingArgs.newBuilder().setExecArgs(execArgs).build();
API apiInstance = new API();
GetSchemaTypeMappingResult result = apiInstance.getSchemaTypeMapping(args);
KclType appSchemaType = result.getSchemaTypeMappingMap().get("app");
String replicasType = appSchemaType.getPropertiesOrThrow("replicas").getType();
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

Java Code

```java
import com.kcl.api.*;

API api = new API();
String spec = "a=2";
OverrideFileResult result = api.overrideFile(OverrideFileArgs.newBuilder()
    .setFile("./src/test_data/override_file/main.k").addSpecs(spec).build());
```

</p>
</details>

### formatCode

Format the code source.

<details><summary>Example</summary>
<p>

Java Code

```java
import com.kcl.api.*;

String sourceCode = "schema Person:\n" + "    name:   str\n" + "    age:    int\n" + "    check:\n"
        + "        0 <   age <   120\n";
FormatCodeArgs args = FormatCodeArgs.newBuilder().setSource(sourceCode).build();
API apiInstance = new API();
FormatCodeResult result = apiInstance.formatCode(args);
String expectedFormattedCode = "schema Person:\n" + "    name: str\n" + "    age: int\n\n" + "    check:\n"
        + "        0 < age < 120\n\n";
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

Java Code

```java
import com.kcl.api.*;

FormatPathArgs args = FormatPathArgs.newBuilder().setPath("format_path.k").build();
API apiInstance = new API();
FormatPathResult result = apiInstance.formatPath(args);
Assert.assertTrue(result.getChangedPathsList().isEmpty());
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

Java Code

```java
import com.kcl.api.*;

LintPathArgs args = LintPathArgs.newBuilder().addPaths("lint_path.k").build();
API apiInstance = new API();
LintPathResult result = apiInstance.lintPath(args);
boolean foundWarning = result.getResultsList().stream()
        .anyMatch(warning -> warning.contains("Module 'math' imported but unused"));
```

</p>
</details>

### validateCode

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

Java Code

```java
import com.kcl.api.*;

String code = "schema Person:\n" + "    name: str\n" + "    age: int\n" + "    check:\n"
        + "        0 < age < 120\n";
String data = "{\"name\": \"Alice\", \"age\": 10}";
ValidateCodeArgs args = ValidateCodeArgs.newBuilder().setCode(code).setData(data).setFormat("json").build();
API apiInstance = new API();
ValidateCodeResult result = apiInstance.validateCode(args);
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

Java Code

```java
import com.kcl.api.*;

RenameArgs args = RenameArgs.newBuilder().setPackageRoot(".").setSymbolPath("a")
        .addFilePaths("main.k").setNewName("a2").build();
API apiInstance = new API();
RenameResult result = apiInstance.rename(args);
```

</p>
</details>

### renameCode

Rename all the occurrences of the target symbol and return the modified code if any code has been changed. This API won't rewrite files but return the changed code.

<details><summary>Example</summary>
<p>

Java Code

```java
import com.kcl.api.*;

API api = new API();
RenameCodeArgs args = RenameCodeArgs.newBuilder().setPackageRoot("/mock/path").setSymbolPath("a")
        .putSourceCodes("/mock/path/main.k", "a = 1\nb = a").setNewName("a2").build();
RenameCodeResult result = api.renameCode(args);
```

</p>
</details>

### test

Test KCL packages with test arguments.

<details><summary>Example</summary>
<p>

Java Code

```java
import com.kcl.api.*;

API apiInstance = new API();
TestArgs args = TestArgs.newBuilder().addPkgList("/path/to/test/package").build();
TestResult result = apiInstance.test(args);
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

Java Code

```java
import com.kcl.api.*;

API api = new API();
LoadSettingsFilesArgs args = LoadSettingsFilesArgs.newBuilder().addFiles("kcl.yaml")
        .build();
LoadSettingsFilesResult result = api.loadSettingsFiles(args);
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

Java Code

```java
import com.kcl.api.*;

API api = new API();

UpdateDependenciesResult result = api.updateDependencies(
    UpdateDependenciesArgs.newBuilder().setManifestPath("module").build());
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

Java Code

```java
import com.kcl.api.*;

API api = new API();

UpdateDependenciesResult result = api.updateDependencies(
        UpdateDependenciesArgs.newBuilder().setManifestPath("./src/test_data/update_dependencies").build());

ExecProgramArgs execArgs = ExecProgramArgs.newBuilder().  addAllExternalPkgs(result.getExternalPkgsList())
    .addKFilenameList("./src/test_data/update_dependencies/main.k").build();

ExecProgramResult execResult = api.execProgram(execArgs);
```

</p>
</details>

### getVersion

Return the KCL service version information.

<details><summary>Example</summary>
<p>

Java Code

```java
import com.kcl.api.*;

API api = new API();
GetVersionArgs version_args = GetVersionArgs.newBuilder().build();
GetVersionResult result = api.getVersion(version_args);
```

</p>
</details>
