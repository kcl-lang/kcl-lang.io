---
sidebar_position: 9
---

# Swift API

[Swift KCL API](https://github.com/kcl-lang/lib/tree/main/swift) 正在开发当中，尚未正式发布。欢迎提交 Issues 或者 PRs 参与共建!

## 快速开始

```swift
import KclLib

let api = API()
var execArgs = ExecProgram_Args()
execArgs.kFilenameList.append("schema.k")
let result = try api.execProgram(execArgs)
```
