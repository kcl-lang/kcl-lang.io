---
sidebar_position: 8
---

# Kotlin API

> **正在寻找跨语言 FFI 契约?**
> 请参阅 [`./ffi-abi.md`](./ffi-abi.md),了解 `call`、`call_with_plugin_agent`、`"ERROR:"` 前缀、**4 MiB** 的 `BUFFER_SIZE`,以及 `kcl_lib_jni` 共享库。下面的 `com.kcl.api.API` 类与 [Java API](./java-api.md) 使用相同的 Java 绑定;Kotlin 在此基础上为每个 `*Args` 类型(例如 `execProgramArgs { … }`)添加了一个 DSL builder,该 DSL 是从 `spec/spec.proto` 生成的。

[Kotlin 绑定](https://github.com/kcl-lang/lib/tree/main/kotlin) 以 Maven 制品 `kcl-lib-kotlin` 的形式发布,并复用了底层的 Java 实现(`com.kcl.api.API`)。它在 protobuf `Spec` 包的基础上,增加了符合 Kotlin 语言习惯的 DSL builder(例如 `execProgramArgs { kFilenameList += "x.k" }`)。

## 安装

参考 [这里](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry#authenticating-to-github-packages) 配置你的 Maven;在 `settings.xml` 中设置你的 GitHub 账号和 Token。

### Maven

在项目的 `pom.xml` 中,按下述方式配置我们的仓库:

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

这样,你就可以引入上面的依赖来使用该 SDK 了。

```xml
<dependency>
    <groupId>com.kcl</groupId>
    <artifactId>kcl-lib-kotlin</artifactId>
    <version>0.13.0</version>
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

## API 参考

### execProgram

执行 KCL 文件并传入参数,返回 JSON/YAML 结果。

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

Kotlin 代码

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

解析单个 KCL 文件,返回包含导入依赖与解析错误的 Module AST JSON 字符串。

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

Kotlin 代码

```kotlin
import com.kcl.api.API
import com.kcl.api.parseFileArgs

val args = parseFileArgs { path = "schema.k" }
val api = API()
val result = api.parseFile(args)
```

</p>
</details>

### parseProgram

使用入口文件解析 KCL 程序,并返回 AST JSON 字符串。

<details><summary>示例</summary>
<p>

Kotlin 代码

```kotlin
import com.kcl.api.API
import com.kcl.api.parseProgramArgs

val args = parseProgramArgs { paths += "schema.k" }
val api = API()
val result = api.parseProgram(args)
assert(result.paths.size == 1)
assert(result.errors.isEmpty())
```

</p>
</details>

### loadPackage

`loadPackage` 为用户提供了解析 KCL 程序以及获取符号、类型、定义等语义模型信息的能力。

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

Kotlin 代码

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

`listVariables` 为用户提供了解析 KCL 程序并按规范获取所有变量的能力。

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

Kotlin 代码

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

Kotlin 代码

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

Kotlin 代码

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

### getSchemaTypeMappingUnderPath

获取程序及其依赖包中定义的 schema 类型映射,以包名作为 key。与 `getSchemaTypeMapping` 不同,从外部依赖包中导入的 schema 会以各自的包名作为 key,而不会被合并到 `__main__` 下。

<details><summary>示例</summary>
<p>

Kotlin 代码

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs
import com.kcl.api.externalPkg
import com.kcl.api.getSchemaTypeMappingArgs

val root = "test_data/get_schema_ty_under_path"
val execArgs = execProgramArgs {
    kFilenameList += "$root/aaa"
    externalPkgs += externalPkg { pkgName = "bbb"; pkgPath = "$root/bbb" }
}
val args = getSchemaTypeMappingArgs { this.execArgs = execArgs }
val api = API()
val result = api.getSchemaTypeMappingUnderPath(args)
val bbbSchemas = result.schemaTypeMappingMap["bbb"]?.schemaTypeList
    ?.associateBy { it.schemaName }
    ?: emptyMap()
check(bbbSchemas["B"]?.baseSchema?.schemaName == "Base")
```

</p>
</details>

### overrideFile

使用参数覆盖 KCL 文件。更多覆盖规范指南请参阅 [https://www.kcl-lang.io/docs/user_docs/guides/automation](https://www.kcl-lang.io/docs/user_docs/guides/automation)。

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

Kotlin 代码

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

格式化代码源码。

<details><summary>示例</summary>
<p>

Kotlin 代码

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

格式化 KCL 文件或包含 KCL 文件的目录路径,并返回被修改的文件路径列表。

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

Kotlin 代码

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

对文件进行 lint 检查,并返回包含错误与警告的错误信息。

<details><summary>示例</summary>
<p>

`lint_path.k` 的内容为

```kcl
import math

a = 1
```

Kotlin 代码

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

使用 schema 与 JSON/YAML 数据字符串对代码进行校验。

<details><summary>示例</summary>
<p>

Kotlin 代码

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

重命名文件中目标符号的所有出现位置。如果文件中包含待重命名的符号,该 API 将重写文件。返回被修改的文件路径列表。

<details><summary>示例</summary>
<p>

`main.k` 的内容为

```kcl
a = 1
b = a
```

Kotlin 代码

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

重命名目标符号的所有出现位置,如果有代码发生变化则返回修改后的代码。该 API 不会重写文件,而是直接返回修改后的代码。

<details><summary>示例</summary>
<p>

Kotlin 代码

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

使用测试参数对 KCL 包进行测试。

<details><summary>示例</summary>
<p>

Kotlin 代码

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

Kotlin 代码

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

下载并更新 `kcl.mod` 文件中定义的依赖,并返回外部包的名称与位置列表。

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

Kotlin 代码

```kotlin
import com.kcl.api.API
import com.kcl.api.updateDependenciesArgs

val api = API()
val args = updateDependenciesArgs { manifestPath = "module" }
val result = api.updateDependencies(args)
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

Kotlin 代码

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

返回 KCL 服务的版本信息。

<details><summary>示例</summary>
<p>

Kotlin 代码

```kotlin
import com.kcl.api.API
import com.kcl.api.getVersionArgs

val api = API()
val args = getVersionArgs {}
val result = api.getVersion(args)
```

(`version` / `checksum` / `gitSha` 的具体值会因发布版本而异;仅断言其为非空即可。)

</p>
</details>

### ping

通过调度器往返传递一个值。

<details><summary>示例</summary>
<p>

```kotlin
import com.kcl.api.API
import com.kcl.api.pingArgs

val api = API()
val args = pingArgs { value = "hello" }
val result = api.ping(args)
check(result.value == "hello")
```

</p>
</details>

### listMethod

列出底层运行时所支持的 KCL 服务方法名。

<details><summary>示例</summary>
<p>

```kotlin
import com.kcl.api.API

val api = API()
for (name in api.listMethod().methodNameList) {
    println(name)
}
```

</p>
</details>

## 注意事项

旧版的 `BuildProgram` 和 `ExecArtifact` RPC 已于 v0.13.0 中从 `spec/spec.proto` 中移除(参见 [lib commit `815acac`](https://github.com/kcl-lang/lib/commit/815acac));`com.kcl.api.API` 调度器将不再识别它们。如果你之前调用过 `api.buildProgram(...)` 或 `api.execArtifact(...)`,请改为调用 `api.execProgram(...)`。