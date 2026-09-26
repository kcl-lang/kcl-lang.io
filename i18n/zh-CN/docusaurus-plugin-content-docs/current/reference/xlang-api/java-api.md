---
sidebar_position: 5
---

# Java API

> **正在查找跨语言 FFI 契约？**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md)，了解 `call`、`call_with_plugin_agent`、
> `"ERROR:"` 前缀、**4 MiB** 的 `BUFFER_SIZE` 以及 `kcl_lib_jni` 共享库。
> 下面的 `com.kcl.api.API` 类是上述单一调度器的轻量 JNI 包装器；
> 每个类型化方法都通过 `call(args)` 进行分发。

[Java 绑定](https://github.com/kcl-lang/lib/tree/main/java) 通过 GitHub Packages
发布为 Maven 工件，分为两层：

- **`com.kcl.api.API`** — 实现类型化 RPC 表面的 Java 类。每个方法都会
  序列化其 `Spec.*Args` proto，通过 JNI 调用原生 `call(args)`，解析结果 proto，
  并将调度器的 `"ERROR:..."` 应答作为抛出的 `Exception` 暴露给调用方。
- **`com.kcl.api.Spec`** — 由 `spec/spec.proto` 自动生成的 protobuf 类。

## 安装

请参考[这里](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry#authenticating-to-github-packages)配置 Maven；在 `settings.xml` 中设置您的 GitHub 账号和 Token。

### Maven

在您项目的 `pom.xml` 中，按如下方式配置我们的仓库：

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

通过这种方式，您即可引入上述依赖以使用 SDK。

```xml
<dependency>
    <groupId>com.kcl</groupId>
    <artifactId>kcl-lib</artifactId>
    <version>0.13.0</version>
</dependency>
```

## 快速开始

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

## API 参考

### execProgram

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

Java 代码

```java
import com.kcl.api.*;

ExecProgramArgs args = ExecProgramArgs.newBuilder().addKFilenameList("schema.k").build();
API apiInstance = new API();
ExecProgramResult result = apiInstance.execProgram(args);
```

</p>
</details>

### parseFile

将 KCL 单个文件解析为 Module AST JSON 字符串，包含导入依赖与解析错误。

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

Java 代码

```java
import com.kcl.api.*;

ParseFileArgs args = ParseFileArgs.newBuilder().setPath("schema.k").build();
API apiInstance = new API();
ParseFileResult result = apiInstance.parseFile(args);
```

</p>
</details>

### parseProgram

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

Java 代码

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

`loadPackage` 为用户提供了解析 KCL 程序以及语义模型信息（包括符号、类型、定义等）的能力。

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

Java 代码

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

`listVariables` 为用户提供了解析 KCL 程序并按 specs 获取所有变量的能力。

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

Java 代码

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

`listOptions` 为用户提供了解析 KCL 程序并获取所有 option 信息的能力。

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

Java 代码

```java
import com.kcl.api.*;

ParseProgramArgs args = ParseProgramArgs.newBuilder().addPaths("./src/test_data/option/main.k").build();
API apiInstance = new API();
ListOptionsResult result = apiInstance.listOptions(args);
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

Java 代码

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

### getSchemaTypeMappingUnderPath

获取程序及其依赖包中定义的 schema 类型映射，以包名作为键。
与 `getSchemaTypeMapping` 不同，从外部依赖包导入的 schema 会以其自身的包名作为键，
而不是被扁平化到 `__main__` 下。

<details><summary>示例</summary>
<p>

Java 代码

```java
import com.kcl.api.*;
import java.nio.file.Path;
import java.nio.file.Paths;

Path root = Paths.get("test_data/get_schema_ty_under_path").toAbsolutePath();
ExecProgramArgs execArgs = ExecProgramArgs.newBuilder()
        .addKFilenameList(root.resolve("aaa").toString())
        .addExternalPkgs(ExternalPkg.newBuilder().setPkgName("bbb")
                .setPkgPath(root.resolve("bbb").toString()).build())
        .build();
GetSchemaTypeMappingArgs args = GetSchemaTypeMappingArgs.newBuilder().setExecArgs(execArgs).build();
API apiInstance = new API();
GetSchemaTypeMappingUnderPathResult result = apiInstance.getSchemaTypeMappingUnderPath(args);
KclType base = result.getSchemaTypeMappingOrThrow("bbb").getSchemaTypeList().stream()
        .filter(s -> s.getSchemaName().equals("Base")).findFirst().orElseThrow();
```

</p>
</details>

### overrideFile

使用参数覆盖 KCL 文件。有关更多覆盖 spec 指南，请参阅
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

Java 代码

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

格式化代码源码。

<details><summary>示例</summary>
<p>

Java 代码

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

Java 代码

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

对文件执行 lint，并返回包含错误与警告在内的错误信息。

<details><summary>示例</summary>
<p>

`lint_path.k` 的内容为

```kcl
import math

a = 1
```

Java 代码

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

使用 schema 以及 JSON/YAML 数据字符串对代码进行校验。

<details><summary>示例</summary>
<p>

Java 代码

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

重命名文件中目标符号的所有出现位置。如果文件中包含待重命名的符号，
该 API 会重写文件，并返回发生变更的文件路径。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
a = 1
b = a
```

Java 代码

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

重命名目标符号的所有出现位置，并在代码发生变更时返回修改后的代码。
该 API 不会重写文件，而是返回修改后的代码。

<details><summary>示例</summary>
<p>

Java 代码

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

使用测试参数对 KCL 包执行测试。

<details><summary>示例</summary>
<p>

Java 代码

```java
import com.kcl.api.*;

API apiInstance = new API();
TestArgs args = TestArgs.newBuilder().addPkgList("/path/to/test/package").build();
TestResult result = apiInstance.test(args);
```

</p>
</details>

### loadSettingsFiles

加载 `kcl.yaml` 中定义的配置文件设置。

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

Java 代码

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

下载并更新 `kcl.mod` 文件中定义的依赖项，并返回外部包的名称与位置列表。

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

Java 代码

```java
import com.kcl.api.*;

API api = new API();

UpdateDependenciesResult result = api.updateDependencies(
    UpdateDependenciesArgs.newBuilder().setManifestPath("module").build());
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

Java 代码

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

返回 KCL 服务的版本信息。

<details><summary>示例</summary>
<p>

Java 代码

```java
import com.kcl.api.*;

API api = new API();
GetVersionArgs version_args = GetVersionArgs.newBuilder().build();
GetVersionResult result = api.getVersion(version_args);
```

（具体的 `version` / `checksum` / `git_sha` 值因发布版本而异；
仅需断言其非空即可。）

</p>
</details>

### ping

通过调度器对一个值进行往返传输（round-trip）。

<details><summary>示例</summary>
<p>

```java
import com.kcl.api.*;

API api = new API();
PingResult result = api.ping(PingArgs.newBuilder().setValue("hello").build());
assert result.getValue().equals("hello");
```

</p>
</details>

### listMethod

列出底层运行时所支持的 KCL 服务方法名。

<details><summary>示例</summary>
<p>

```java
import com.kcl.api.*;

API api = new API();
for (String name : api.listMethod().getMethodNameList()) {
    System.out.println(name);
}
```

</p>
</details>

## 注意事项

旧的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 中从 `spec/spec.proto` 中移除
（参见 [lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac)）；
它们不再被 `com.kcl.api.API` 调度器识别。如果您之前调用的是
`api.buildProgram(...)` 或 `api.execArtifact(...)`，请改用 `api.execProgram(...)`。