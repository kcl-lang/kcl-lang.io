---
sidebar_position: 8
---

# Kotlin API

The official [Kotlin KCL package](https://github.com/kcl-lang/lib/tree/main/kotlin) has not been released yet. Issues and PRs are welcome!

Of course, you can use the KCL Java package to call the KCL API in Kotlin.

## Quick Start

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs

val args = execProgramArgs { kFilenameList += "schema.k" }
val api = API()
val result = api.execProgram(args)
```
