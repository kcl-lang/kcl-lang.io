---
sidebar_position: 5
---

# Java API

## Installation

Refer to [this](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry#authenticating-to-github-packages
) to configure your Maven; set up your GitHub account and Token in the `settings.xml`.

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
    <version>0.8.5</version>
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
