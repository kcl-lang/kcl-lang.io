---
sidebar_position: 6
---

# Test

## Introduction

The KCL Test tool provides a simple testing framework to test KCL code. All KCL files in each directory are a set of tests, and each lambda starts with `test_` in each `*_test.k` is a test case.

## How to use

There is a KCL file `hello.k`:

```python
schema Person:
    name: str = "kcl"
    age: int = 1

hello = Person {
    name = "hello kcl"
    age = 102
}
```

Build a test file `hello_test.k`:

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

Execute the following command:

```shell
kcl test
```

The output is

```shell
test_person: PASS (2ms)
test_person_age: PASS (1ms)
test_person_ok: PASS (1ms)
--------------------------------------------------------------------------------
PASS: 3/3
```

## Failed Test Case

Modify `hello_test.k` to the following code to build failed test case:

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

Run the command

```shell
kcl test
```

Output:

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

## Args

- `kcl test path` Execute the test of the specified directory. It can be omitted if it's the same directory that the command is executed
- `kcl test --run=regexp` Execute the test which matches patterns
- `kcl test ./...` Execute unit tests recursively

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
