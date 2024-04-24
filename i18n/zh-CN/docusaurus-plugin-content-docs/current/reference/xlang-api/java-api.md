---
sidebar_position: 5
---

# Java API

## 添加依赖

```shell
npm install kcl-lib
```

### Maven

## 快速开始

```typescript
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(new ExecProgramArgs(["path/to/kcl.k"]));
  console.log(result.yamlResult);
}

main();
```
