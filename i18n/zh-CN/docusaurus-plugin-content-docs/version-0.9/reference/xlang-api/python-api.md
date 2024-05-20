---
sidebar_position: 4
---

# Python API

## 添加依赖

```shell
python3 -m pip install kcl-lib
```

## 快速开始

```typescript
import kcl_lib.api as api

args = api.ExecProgram_Args(k_filename_list=["path/to/kcl.k"])
api = api.API()
result = api.exec_program(args)
print(result.yaml_result)
```
