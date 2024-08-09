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
    <version>0.10.0-alpha.2-SNAPSHOT</version>
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

### validateCode

Validate code using schema and JSON/YAML data strings.

<details><summary>Example</summary>
<p>

Kotlin Code

```kotlin
val args = validateCodeArgs { 
    code =  "schema Person:\n" + "    name: str\n" + "    age: int\n" + "    check:\n" + "        0 < age < 120\n"
    data = "{\"name\": \"Alice\", \"age\": 10}"
}
val apiInstance = API();
val result = apiInstance.validateCode(args);
```

</p>
</details>
