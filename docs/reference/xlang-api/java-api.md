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
    <version>0.9.0-SNAPSHOT</version>
</dependency>
```

## Quick Start

```java
import com.kcl.api.API;
import com.kcl.api.Spec.ExecProgram_Args;
import com.kcl.api.Spec.ExecProgram_Result;

public class ExecProgramTest {
    public static void main(String[] args) throws Exception {
        API api = new API();
        ExecProgram_Result result = api
                .execProgram(ExecProgram_Args.newBuilder().addKFilenameList("path/to/kcl.k").build());
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

ExecProgram_Args args = ExecProgram_Args.newBuilder().addKFilenameList("schema.k").build();
API apiInstance = new API();
ExecProgram_Result result = apiInstance.execProgram(args);
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
ParseProgram_Result result = api.parseProgram(
   ParseProgram_Args.newBuilder().addPaths("schema.k").build()
);
System.out.println(result.getAstJson());
Program program = JsonUtil.deserializeProgram(result.getAstJson());
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

ParseFile_Args args = ParseFile_Args.newBuilder().setPath("schema.k").build();
API apiInstance = new API();
ParseFile_Result result = apiInstance.parseFile(args);
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
ParseProgram_Result result = api.parseProgram(
   ParseProgram_Args.newBuilder().addPaths("path/to/kcl.k").build()
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
LoadPackage_Result result = api.loadPackage(LoadPackage_Args.newBuilder().setResolveAst(true)
    .setWithAstIndex(true)
    .setParseArgs(ParseProgram_Args.newBuilder().addPaths("schema.k").build()).build());
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
ListVariables_Result result = api.listVariables(
    ListVariables_Args.newBuilder().setResolveAst(true).setParseArgs(
    ParseProgram_Args.newBuilder().addPaths("/path/to/kcl.k").build())
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

ParseProgram_Args args = ParseProgram_Args.newBuilder().addPaths("./src/test_data/option/main.k").build();
API apiInstance = new API();
ListOptions_Result result = apiInstance.listOptions(args);
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

ExecProgram_Args execArgs = ExecProgram_Args.newBuilder().addKFilenameList("schema.k").build();
GetSchemaTypeMapping_Args args = GetSchemaTypeMapping_Args.newBuilder().setExecArgs(execArgs).build();
API apiInstance = new API();
GetSchemaTypeMapping_Result result = apiInstance.getSchemaTypeMapping(args);
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
OverrideFile_Result result = api.overrideFile(OverrideFile_Args.newBuilder()
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
FormatCode_Args args = FormatCode_Args.newBuilder().setSource(sourceCode).build();
API apiInstance = new API();
FormatCode_Result result = apiInstance.formatCode(args);
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

FormatPath_Args args = FormatPath_Args.newBuilder().setPath("format_path.k").build();
API apiInstance = new API();
FormatPath_Result result = apiInstance.formatPath(args);
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

LintPath_Args args = LintPath_Args.newBuilder().addPaths("lint_path.k").build();
API apiInstance = new API();
LintPath_Result result = apiInstance.lintPath(args);
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
ValidateCode_Args args = ValidateCode_Args.newBuilder().setCode(code).setData(data).setFormat("json").build();
API apiInstance = new API();
ValidateCode_Result result = apiInstance.validateCode(args);
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

Rename_Args args = Rename_Args.newBuilder().setPackageRoot(".").setSymbolPath("a")
        .addFilePaths("main.k").setNewName("a2").build();
API apiInstance = new API();
Rename_Result result = apiInstance.rename(args);
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
RenameCode_Args args = RenameCode_Args.newBuilder().setPackageRoot("/mock/path").setSymbolPath("a")
        .putSourceCodes("/mock/path/main.k", "a = 1\nb = a").setNewName("a2").build();
RenameCode_Result result = api.renameCode(args);
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
Test_Args args = Test_Args.newBuilder().addPkgList("/path/to/test/package").build();
Test_Result result = apiInstance.test(args);
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
LoadSettingsFiles_Args args = LoadSettingsFiles_Args.newBuilder().addFiles("kcl.yaml")
        .build();
LoadSettingsFiles_Result result = api.loadSettingsFiles(args);
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

UpdateDependencies_Result result = api.updateDependencies(
    UpdateDependencies_Args.newBuilder().setManifestPath("module").build());
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

UpdateDependencies_Result result = api.updateDependencies(
        UpdateDependencies_Args.newBuilder().setManifestPath("./src/test_data/update_dependencies").build());

ExecProgram_Args execArgs = ExecProgram_Args.newBuilder().  addAllExternalPkgs(result.getExternalPkgsList())
    .addKFilenameList("./src/test_data/update_dependencies/main.k").build();

ExecProgram_Result execResult = api.execProgram(execArgs);
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
GetVersion_Args version_args = GetVersion_Args.newBuilder().build();
GetVersion_Result result = api.getVersion(version_args);
```

</p>
</details>
