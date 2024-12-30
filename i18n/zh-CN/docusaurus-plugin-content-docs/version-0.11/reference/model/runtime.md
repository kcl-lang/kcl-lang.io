---
title: "runtime"
linkTitle: "runtime"
type: "docs"
description: 运行时函数
weight: 100
---

## catch

`catch(func: () -> any) -> str`

`catch` 函数可以执行代码块并捕获任何潜在的运行时错误。如果代码块中没有发生异常，`catch` 函数返回 `Undefined`，否则返回异常信息。

```python
import runtime

schema Person:
    name: str
    age: int

    check:
        0 <= age <= 120, "age must be in [1, 120], got ${age}"

test_person_check_error = lambda {
    assert runtime.catch(lambda {
        p = Person {name = "Alice", age: -1}
    }) == "age must be in [1, 120], got -1"
}
```
