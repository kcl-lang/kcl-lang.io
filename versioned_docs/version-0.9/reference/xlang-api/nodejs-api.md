---
sidebar_position: 6
---

# Node.js API

## Installation

```shell
npm install kcl-lib
```

## Quick Start

```typescript
import { execProgram, ExecProgramArgs } from "kcl-lib";

function main() {
  const result = execProgram(new ExecProgramArgs(["path/to/kcl.k"]));
  console.log(result.yamlResult);
}

main();
```
