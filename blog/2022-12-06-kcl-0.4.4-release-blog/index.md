---
slug: 2022-kcl-0.4.4-release-blog
title: KCL v0.4.4 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

The KCL team is pleased to announce that v0.4.4 is now available! This release mainly adds the ability to customize YAML manifests output for KCL. Users can customize the style of YAML output by writing code and calling system functions without understanding the complex schema settings semantics. In addition, this release provides the latest [KCL Python SDK](https://github.com/kcl-lang/kclvm-py), which can be used for Python users to directly integrate KCL. At the same time, we have greatly reduced the size of the KCL installation package. The average installation package size has been reduced to one-fifth of that of the previous version. It also includes a number of compiler error message optimization and bug fix. You can visit the [KCL release page](https://github.com/kcl-lang/kcl/releases/tag/v0.4.4-alpha.2) to get more detailed release information and KCL binary download link.

## Background

KCL is an open-source constraint-based record and functional language. KCL improves the writing of a large number of complex configurations through mature programming language technology and practice, and is committed to building better modularity, scalability and stability around configuration, simpler logic writing, fast automation and good ecological extensionality.

This blog will introduce the recent developments of KCL community to readers.

## Features

### Customize YAML Manifest Output

In previous KCL versions, the style of YAML output is hard coded in the KCL compiler, and users can set the `__settings__` meta attribute with different values to determine the YAML output style, which brings high complexity. Therefore, in version 0.4.4, we provide a system module function for developers to easily customize the YAML output style. The signature of this function is as follows:

```python
manifests.yaml_stream(values: [any], opts: {str:} = {
    sort_keys = False
    ignore_private = True
    ignore_none = False
    sep = "---"
})
```

This function is used to serialize the KCL object list into YAML output with the `---` separator. It has two parameters:

- `values` - A list of KCL objects
- `opts` - The YAML serialization options
  - `sort_keys`: Whether to sort the serialized results in the dictionary order of attribute names (the default is `False`).
  - `ignore_private`: Whether to ignore the attribute output whose name starts with the character `_` (the default value is `True`).
  - `ignore_none`: Whether to ignore the attribute with the value of' None '(the default value is `False`).
  - `sep`: Set the separator between multiple YAML documents (the default value is `"---"`).

Here's an example:

```python
import manifests

schema Deployment:
    apiVersion: str = "v1"
    kind: str = "Deployment"
    metadata: {str:} = {
        name = "deploy"
    }
    spec: {str:} = {
        replica = 2
    }

schema Service:
    apiVersion: str = "v1"
    kind: str = "Service"
    metadata: {str:} = {
         name = "svc"
    }
    spec: {str:} = {}

deployments = [Deployment {}, Deployment {}]
services = [Service {}, Service {}]

manifests.yaml_stream(deployments + services)
```

First, we use the `import` keyword to import the `manifests` module and define two deployment resources and two service resources. When we want to output these four resources in YAML stream format with `---` as the separator, we can put them into a KCL list and use the `manifests.yaml_stream` function pass it to the `values` parameter (if there is no special requirement, the `opts` parameter can generally use the default value). Finally, the YAML output is:

```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Service
metadata:
  name: svc
---
apiVersion: v1
kind: Service
metadata:
  name: svc
```

> Note: The feature of schema `__settings__` meta attribute setting YAML output style can still be used in v0.4.4. We will remove this feature in KCL v0.4.6 after the next two minor versions are released.

For more information, see [https://github.com/kcl-lang/kcl/issues/94](https://github.com/kcl-lang/kcl/issues/94).

### Python SDK

In addition to the existing [KCL Go SDK](https://github.com/kcl-lang/kcl-go), this release also adds the KCL Python SDK. Using the Python SDK requires that you have a local Python version higher than 3.7.3 and a local pip package management tool. You can use the following command to install and obtain helpful information.

```bash
python3 -m pip install kclvm --user && python3 -m kclvm --help
```

#### Command Line Tool

Prepare a KCL file named `main.k`

```python
name = "kcl"
age = 1

schema Person:
    name: str = "kcl"
    age: int = 1

x0 = Person {}
x1 = Person {
    age = 101
}
```

Execute the following command and get the output:

```shell
python3 -m kclvm hello.k
```

The expect output is

```yaml
name: kcl
age: 1
x0:
  name: kcl
  age: 1
x1:
  name: kcl
  age: 101
```

#### API

In addition, we can also execute KCL files through Python code.

Prepare a KCL file named `main.py`

```python
import kclvm.program.exec as kclvm_exec
import kclvm.vm.planner as planner

print(planner.plan(kclvm_exec.Run(["hello.k"]).filter_by_path_selector()))
```

Execute the following command and get the output:

```shell
python3 main.py
```

The expect output is

```yaml
name: kcl
age: 1
x0:
  name: kcl
  age: 1
x1:
  name: kcl
  age: 101
```

You can see that the same output can be obtained through command line tools and APIs.

At present, the KCL Python SDK is still in the early preview version. The KCL team will continue to update and provide more functions in the future. For more information, see [https://github.com/kcl-lang/kclvm-py](https://github.com/kcl-lang/kclvm-py)

## Installation Size Optimization

In the new KCL version, we split the built-in Python 3 of KCL, reducing the average size of the KCL binary compression package from 200M to 35M. Users can download and use KCL faster, and the Python plugin becomes an option. If you want to enable the KCL Python plugin, an additional requirement is that you have Python and pip package management tools that are higher than 3.7.3. For more details, please see [https://github.com/kcl-lang/kcl-plugin](https://github.com/kcl-lang/kcl-plugin)

## Bugfix

### Function Call Error Information Optimization

In version 0.4.4, KCL optimizes the output of error messages when the number of function arguments does not match, and supports the display of function names and the number of argument mismatches

```python
schema Foo[x: int]:
    bar?: int = x

f = lambda x {
    x + 1
}

foo = Foo(1,2,3)  # Error: "Foo" takes 1 positional argument but 3 were given
f(1,2)  # Error: "f" takes 1 positional argument but 2 were given
```

For more information, see [https://github.com/kcl-lang/kcl/issues/299](https://github.com/kcl-lang/kcl/issues/299)

### Formatting Error of Interpolated Three Quote String

In previous KCL versions, formatting the following code would incorrectly convert the three quotation marks with string interpolation into single quotation marks and cause compilation errors. In version 0.4.4, we have fixed the issue.

```python
# Before KCL v0.4.4, variable "bar" will be formatted as:
#
# foo = 1
# bar = "
# ${foo}
# "
foo = 1
bar = """
${foo}
"""
```

For more information, see [https://github.com/kcl-lang/kcl/issues/294](https://github.com/kcl-lang/kcl/issues/294)

### Formatting Error of Config If Block

In previous KCL versions, formatting the following code would lead to incorrect indent levels. In version 0.4.4, we have fixed the issue.

```python
# Before KCL v0.4.4, variable "foo" will be formatted as:
#
# foo = [
#     if True:
#         {key = "value"}
#     {key = "value"}
# ]
foo = [
    if True:
        {key = "value"}
        {key = "value"}
]
```

### String Literal Type Check Error

In previous KCL versions, formatting the following code would lead to incorrect indent levels. In version 0.4.4, we have fixed the issue.

```python
# Before KCL v0.4.4, we will get a unexpected type mismatch error.
foo: {"A"|"B": int} = {A = 1}
```

### Other Issues

For more issues, see [https://github.com/kcl-lang/kcl/milestone/2?closed=1](https://github.com/kcl-lang/kcl/milestone/2?closed=1)

## Documents

[KCL website](https://kcl-lang.github.io/) preliminary establishment and improvement of Kubernetes scenarios [related documents](https://kcl-lang.github.io/docs/user_docs/guides/working-with-k8s/).

For more information, see [https://kcl-lang.github.io/](https://kcl-lang.github.io/)

## Community

Three external contributors @my-vegetable-has-exploded, @possible-fqz, @orangebees have participated in the KCL community, thank them for their enthusiasm and active participation in contributing.

## Next

It is estimated that by the end of January 2023, we will release KCL v0.4.5, and the key evolution is expected to include

- Continuous optimization of the KCL user interface, improvement of experience and user pain points.
- More scenarios and ecology integration, such as Kubernetes and CI/CD Pipeline scenarios.
- KCL Windows version support.
- KCL package management tool `kpm` release.
- The new version of KCL playground.

For more information, see [KCL v0.4.5 Milestone](https://github.com/kcl-lang/kcl/milestone/3).

## FAQ

For more information, see [https://kcl-lang.github.io/docs/user_docs/support/](https://kcl-lang.github.io/docs/user_docs/support/).

## Additional Resources

- [KCL Website](https://kcl-lang.io/)
- [Kusion Website](https://kusionstack.io/)
- [KCL Repo](https://github.com/kcl-lang/kcl)
- [Kusion Repo](https://github.com/KusionStack/kusion)
- [Konfig Repo](https://github.com/KusionStack/konfig)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏
