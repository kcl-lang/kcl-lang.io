---
sidebar_position: 9
---

# Swift API

The official [Swift KCL package](https://github.com/kcl-lang/lib/tree/main/swift) has not been released yet. Issues and PRs are welcome!

## Quick Start

```swift
import KclLib

let api = API()
var execArgs = ExecProgramArgs()
execArgs.kFilenameList.append("schema.k")
let result = try api.execProgram(execArgs)
```
