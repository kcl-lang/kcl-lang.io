---
sidebar_position: 4
---

# Python API

## Installation

```shell
python3 -m pip install kcl-lib
```

## Quick Start

```typescript
import kcl_lib.api as api

args = api.ExecProgram_Args(k_filename_list=["path/to/kcl.k"])
api = api.API()
result = api.exec_program(args)
print(result.yaml_result)
```
