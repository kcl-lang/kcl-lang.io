---
sidebar_position: 6
---

# 测试工具

## 简介

KCL 支持通过内置的 `kcl test` 命令行工具提供了简易的测试框架。每个目录下的全部 KCL 文件是一个测试整体，每个 `_test.k` 中 `test_` 开头的 lambda 函数是一个测试用例。

## 使用方式

假设有 hello.k 文件，代码如下:

```python
schema Person:
    name: str = "kcl"
    age: int = 1

    check:
        0 <= age <= 120, "age must be in [0, 120]"

hello = Person {
    name = "hello kcl"
    age = 102
}
```

构造 hello_test.k 测试文件，内容如下：

```python
test_person = lambda {
    a = Person{}
    assert a.name == 'kcl'
}
test_person_age = lambda {
    a = Person{}
    assert a.age == 1
}
test_person_ok = lambda {
    a = Person{}
    assert a.name == "kcl"
    assert a.age == 1
}
```

然后再目录下执行 `kcl test` 命令:

```shell
kcl test
```

输出为:

```shell
test_person: PASS (2ms)
test_person_age: PASS (1ms)
test_person_ok: PASS (1ms)
--------------------------------------------------------------------------------
PASS: 3/3
```

## 失败的测试

将 hello_test.k 测试代码修改如下，构造失败的测试：

```python
test_person = lambda {
    a = Person{}
    assert a.name == 'kcl2'
}
test_person_age = lambda {
    a = Person{}
    assert a.age == 123
}
test_person_ok = lambda {
    a = Person{}
    assert a.name == "kcl2"
    assert a.age == 1
}
```

执行命令

```shell
kcl test
```

测试输出的错误如下：

```shell
test_person: FAIL (6ms)
EvaluationError
 --> hello_test.k:3:1
  |
3 |     assert a.name == 'kcl2'
  |
  |


test_person_age: FAIL (3ms)
EvaluationError
 --> hello_test.k:7:1
  |
7 |     assert a.age == 123
  |
  |


test_person_ok: FAIL (2ms)
EvaluationError
  --> hello_test.k:11:1
   |
11 |     assert a.name == "kcl2"
   |
   |


--------------------------------------------------------------------------------
FAIL: 3/3
```

如果我们想要正确测试错误情况并检查错误消息，我们可以使用 `runtime.catch` 函数。

```python
import runtime

test_person_age_check_error_message = lambda {
    msg = runtime.catch(lambda {
        a = Person {age = 123}
    }) 
    assert msg == "age must be in [0, 120]"
}
```

运行命令

```shell
kcl test
```

输出:

```shell
test_person_age_check_error_message: PASS (2ms)
--------------------------------------------------------------------------------
PASS: 1/1
```

## 参数说明

- `kcl test path` 执行指定目录的测试, 当前目录可以省略该参数
- `kcl test --run=regexp` 可以执行匹配模式的测试
- `kcl test ./...` 递归执行子目录的单元测试

```shell
This command automates testing the packages named by the import paths.

'KCL test' re-compiles each package along with any files with names matching
the file pattern "*_test.k". These additional files can contain test functions
that starts with "test_*".

Usage:
  kcl test [flags]

Aliases:
  test, t

Examples:
  # Test whole current package recursively
  kcl test ./...

  # Test package named 'pkg'
  kcl test pkg

  # Test with the fail fast mode.
  kcl test ./... --fail-fast

  # Test with the regex expression filter 'test_func'
  kcl test ./... --run test_func


Flags:
      --fail-fast    Exist when meet the first fail test case in the test process.
  -h, --help         help for test
      --run string   If specified, only run tests containing this string in their names.
```
