---
sidebar_position: 5
---

# Test Tool

## Intro

The KCL Test tool and `testing` package provide a simple testing framework to test KCL code. All KCL files in each directory are a set of tests, and each schema starts with `Test` in each `test.k` is a test case.

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
schema TestPerson:
    a = Person{}
    assert a.name == 'kcl'

schema TestPerson_age:
    a = Person{}
    assert a.age == 1

schema TestPerson_ok:
    a = Person{}
    assert a.name == "kcl"
    assert a.age == 1
```

Execute the following command:

```
$ kcl-test
ok   /pkg/to/app [365.154142ms]
$
```

## Failed Test Case

Modify `hello_test.k` to the following code to build failed test case:

```python
# Copyright 2021 The KCL Authors. All rights reserved.

import testing

schema TestPerson:
    a = Person{}
    assert a.name == 'kcl2'

schema TestPerson_age:
    a = Person{}
    assert a.age == 123

schema TestPerson_ok:
    a = Person{}
    assert a.name == "kcl2"
    assert a.age == 1
```

Output:

```
$ kcl-test
FAIL /pkg/to/app [354.153775ms]
---- <TestPerson> failed [48.817552ms]
     KCL Runtime Error: File /pkg/to/app/hello_test.k:7:
             assert a.name == 'kcl2'
     Assertion failure
---- <TestPerson_age> failed [47.515009ms]
     KCL Runtime Error: File /pkg/to/app/hello_test.k:11:
             assert a.age == 123
     Assertion failure
---- <TestPerson_ok> failed [47.26677ms]
     KCL Runtime Error: File /pkg/to/app/hello_test.k:15:
             assert a.name == "kcl2"
     Assertion failure
$
```

## Option Args

Literal type command line arguments can be specified via the testing package:

```python
schema TestOptions:
    testing.arguments("name", "ktest")
    testing.arguments("age", "123")
    testing.arguments("int0", 0)
    testing.arguments("float0", 0.0)
    testing.arguments("bool-true", True)
    testing.arguments("bool-false", False)

    name = option("name")
    assert name == "ktest"

    age = option("age")
    assert age == 123

    assert option("int0") == 0
    assert option("float0") == 0.0
    assert option("bool-true") == True
    assert option("bool-false") == False
```

`testing.arguments` defines a set of key-value arguments, valid only in the current test.

The option arguments can also be loaded from the `settings.yaml`. There is a file `settings.yaml`:

```yaml
- key: app-name
  value: app
- key: env-type
  value: prod
- key: image
  value: reg.docker.inc.com/test-image
```

Parameters can then be configured via `testing.setting_file("./settings.yaml")`. At the same time, `testing.arguments()` is still supported to override the parameters in the configuration file:

```py
schema TestOptions_setting:
    testing.setting_file("./settings.yaml")
    testing.arguments("file", "settings.yaml")

    assert option("app-name") == "app"
    assert option("file") == "settings.yaml"
```

## Plugin Test

Automatically switch to plugin mode if the directory to be tested contains `plugin.py` and test files. Then set the environment variable `KCL_PLUGINS_ROOT` before the test (plugins in other directories can no longer be accessed) to test the current plugin, and restore the previous `KCL_PLUGINS_ROOT` after the test is completed.

## Integration Test

Automatically execute integration tests when the directory contains `*.k`. If there is `stdout.golden` then verify the output. If there is `stderr.golden` then verify the error. Supports the `settings.yaml` file to define command line arguments.

## Batch Test

- `kcl-test path` Execute the test of the specified directory. It can be omitted if it's the same directory that the command is executed
- `kcl-test -run=regexp` Execute the test which matches patterns
- `kcl-test ./...` Execute unit tests recursively

## Args

```
$ kcl-test -h
NAME:
   kcl-go test - test packages

USAGE:
   kcl-go test [command options] [packages]

OPTIONS:
   --run value    Run only those tests matching the regular expression.
   --quiet, -q    Set quiet mode (default: false)
   --verbose, -v  Log all tests as they are run (default: false)
   --debug, -d    Run in debug mode (for developers only) (default: false)
   --help, -h     show help (default: false)
```
