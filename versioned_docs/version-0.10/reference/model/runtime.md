---
title: "runtime"
linkTitle: "runtime"
type: "docs"
description: runtime functions
weight: 100
---

## catch

`catch(func: () -> any) -> str`

Executes the provided function and catches any potential runtime errors. Returns undefined if execution is successful, otherwise returns an error message in case of a runtime panic.

```python3
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
