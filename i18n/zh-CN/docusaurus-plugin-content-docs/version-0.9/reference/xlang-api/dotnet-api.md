---
sidebar_position: 5
---

# .NET API

## 添加依赖

```shell
dotnet add package KclLib
```

## 快速开始

```typescript
using KclLib.API;

var api = new API();
var execArgs = new ExecProgram_Args();
var path = Path.Combine("test_data", "schema.k");
execArgs.KFilenameList.Add(path);
var result = api.ExecProgram(execArgs);
Console.WriteLine(result.YamlResult);
```
