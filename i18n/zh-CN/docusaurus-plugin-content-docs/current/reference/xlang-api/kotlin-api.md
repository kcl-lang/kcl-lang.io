---
sidebar_position: 8
---

# Kotlin API

[Kotlin KCL API](https://github.com/kcl-lang/lib/tree/main/kotlin) 正在开发当中，尚未正式发布。欢迎提交 Issues 或者 PRs 参与共建!

当然，您也可以在 Kotlin 中直接调用 KCL Java API。

## 快速开始

```kotlin
import com.kcl.api.API
import com.kcl.api.execProgramArgs

val args = execProgramArgs { kFilenameList += "schema.k" }
val api = API()
val result = api.execProgram(args)
```
