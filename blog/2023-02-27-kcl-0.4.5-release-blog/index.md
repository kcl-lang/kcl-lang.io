---
slug: 2022-kcl-0.4.5-release-blog
title: KCL v0.4.5 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL, KusionStack, Kusion]
---

## Introduction

The KCL team is pleased to announce that KCL v0.4.5 is now available! This release is mainly aimed at improving the convenience and stability of KCL language writing, improving error information, and supporting more platforms including Windows version and more download methods. In KCL v0.4.5, users can eliminate more configuration templates by writing fewer KCL codes. In the new version, preliminary KCL Playground support is provided, which can be used to write and run KCL code online without installation. In addition, this release also includes many compiler error information optimization and bug fixes.

You can visit the [KCL release page](https://github.com/KusionStack/kcl/releases/tag/v0.4.5) or the [KCL website](https://kcl-lang.io/) to get KCL binary download link and more detailed release information.

[KCL](https://github.com/KusionStack/kcl) is an open-source, constraint-based record and functional language. KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

This blog will introduce the content of KCL v0.4.5 and recent developments in the KCL community to readers.

## Features

### Language Writing Convenience Improvement

#### Lazy Validation of Non-null Attributes in the KCL Schema

In previous KCL versions, we have supported the lazy evaluation and validation capabilities of schema attribute cross-reference (including inheritance) and check expressions. In this version, we have supported more schema lazy evaluation capabilities such as the schema attribute non-null lazy validation. For example, for the following KCL codes:

```python
schema Spec:
    id: int
    value: str

schema Config:
    name?: str
    spec: Spec = Spec {  
        id = 1
    } # Before KCL v0.4.5, this statement will report an attribute non-null error. After v0.4.5, the schema non-null attribute lazy validation is supported

config = Config {
    spec.value = "value"
}
```

Before KCL v0.4.5, directly executing the above code will throw an error that the `value` attribute of `spec` cannot be `None` at the `spec: Spec=Spec {` statement block of the `schema Config`, because only the `id` attribute of `spec` is assigned a value of `1`, and no value is assigned to the `value` attribute of `spec`.

After KCL v0.4.5, we will avoid throwing this error after supporting the lazy non-null validation capability of the schema attribute. That is, when the `spec.value="value"` and `spec.id=1` of the `config` attributes are merged, all the attributes of `config` will be checked recursively for non-null. At this time, all the values of the `spec` attribute are fully assigned (the value of the `id` attribute of `spec` is `1`, and the `value` attribute is `"value"`), the error that the required schema attribute is null will not be thrown.

Therefore, after KCL v0.4.5 and executing the above KCL code, we will get the complete YAML output as follows:

```yaml
config:
  spec:
    id: 1
    value: value
```

#### Mutual Reference of Configuration Block Attributes

In versions before v0.4.5, KCL has not yet supported the mutual reference of attributes within the configuration block, resulting in the need to define additional configuration variables or templates for reference in some scenarios, resulting in more configuration templates and duplicate codes, such as the KCL code shown below:

```python
name = "app-name"
data = {
    name = name
    metadata.name = name  # `metadata.name` cannot directly reference the `name` attribute inside the `data` configuration.
}
```

The `metadata.name` attribute of the `data` configuration block cannot directly reference the `name` attribute inside the `data`. We need to define an additional global variable `name` for reference.

After KCL v0.4.5, we support the feature of mutual reference of configuration block attributes, which can be used to eliminate more configuration templates, such as the KCL code shown below:

```python
data = {
    name = "app-name"
    metadata.name = name  # Directly reference the name attribute of the `data` configuration
}
```

The `metadata.name` attribute of the `data` configuration block can directly reference the `name` attribute inside the `data` without defining additional global variables.

The following YAML output can be obtained by executing the above KCL code:

```yaml
data:
  name: app-name
  metadata:
    name: app-name
```

Here is a more complex example:

```python
name = "global-name"
metadata = {
    name = "metadata-name"
    labels = {
        "app.kubernetes.io/name" = name  # Directly reference `metadata.name`
        "app.kubernetes.io/instance" = name  # Directly reference `metadata.name`
    }
}
data = {
    name = name  # Reference the global variable `name`
    metadata = metadata  # Reference global variables `metadata`
    spec.template.metadata.name = metadata.name  # Reference `metadata` variables inside `data`.
}
```

The following YAML output can be obtained by executing the above code:

```yaml
name: global-name
metadata:
  name: metadata-name
  labels:
    app.kubernetes.io/name: metadata-name
    app.kubernetes.io/instance: metadata-name
data:
  name: global-name
  metadata:
    name: metadata-name
    labels:
      app.kubernetes.io/name: metadata-name
      app.kubernetes.io/instance: metadata-name
  spec:
    template:
      metadata:
        name: metadata-name
```

> ⚠️ Note: The current KCL version does not support the backward reference of the internal attributes of the configuration block and the direct reference of global variables by skipping the internal scope. The referenced attributes need to be written in front of the configuration reference.

### New Language Features

#### Index Formatting of String Format Member function

After KCL v0.4.5, KCL supports the use of the index tag style format `<format_ele_index>[<index_or_key>]` in the `{}` format block for KCL variables of list and dictionary types similar to the Python language.

+ `<format_ele_index>` indicates the index that is needed to serialize list and dictionary-type elements.
+ `<index_or_key>` indicates the list sub-element index or dictionary sub-element key value of the corresponding list and dictionary type element.

For example, for the following KCL code

```python
# 0[0] means taking the 0th element of ["Hello", "World"]: "Hello"
# 0[1] means taking the 1th element of ["Hello", "World"]: ""World"
listIndexFormat = "{0[0]}{0[1]}".format(["Hello", "World"])
# 0[0] means taking the 0th element of ["0", "1"]: "0"
# 1[Hello] means taking {"Hello": "World"} dictionary element whose key value is Hello: "World"
dictIndexFormat = "0{0[0]}, 1{0[1]}, Hello{1[Hello]}".format(["0", "1"], {"Hello": "World"})
```

The following YAML output can be obtained by executing the above code:

```yaml
listIndexFormat: HelloWorld
dictIndexFormat: "00, 11, HelloWorld"
```

### KCL Playground

In this update, we have updated the version of the KCL playground and support the automatic compilation and formatting of KCL code. You can visit the [KCL website](https://kcl-lang.io/) and click the playground button to experience it.

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-website-playground.png)

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-playground.png)

In the subsequent KCL versions, we will continue to update the KCL playground to support more capabilities, such as KCL version selection and code sharing.

### More Platforms and Download Methods for KCL

#### Windows

KCL Windows binary version can now be downloaded from [Github](https://github.com/KusionStack/kcl/releases/) manually. After the download, add `{install_location}\kclvm\bin` to the environment variable `PATH`.

```powershell
$env:PATH += ";{install-location}\kclvm\bin;"
```

In addition, you can also install KCL through the Powershell script shown below:

```powershell
powershell -Command "iwr -useb https://kcl-lang.io/script/install.ps1 | iex"
```

We will support more Windows package management download methods in the future, such as `Scoop`.

#### More Download Methods

In this version update, we support more KCL download methods, including scripts, Python, Go, Homebrew, and Docker one-click installation. For more details, please refer to [KCL Download and Installation](https://kcl-lang.io/docs/user_docs/getting-started/install), we will support more KCL installation methods in the future.

> ⚠️ Note: For all the above operating systems and installation methods, if you want to use [KCL Python plug-in](https://kcl-lang.io/docs/reference/plugin/overview), you need to ensure that Python 3.7+ is installed and add the python3 command to your PATH environment variable.

## Bugfix

### The configuration merge order is incorrect when the right value of a non-configured expression exists

```python
schema Resource:
    cpu: int
    memory: str

schema Config:
    resource: Resource

r = Resource {
    cpu = 4
    memory = "8Gi"
}

config: Config {
    resource: Resource {
        cpu = 2
        memory = "4Gi"
    }
}

config: Config {
    resource: r
}
```

Before KCL v0.4.5, executing the above code (main.k) will get unexpected configuration values because the KCL compiler incorrectly optimized the following form of equivalent merge configuration blocks:

```python3
config: Config {
    resource: r
    resource: Resource {
        cpu = 2
        memory = "4Gi"
    }
}
```

After KCL v0.4.5, the incorrect configuration of the merge order is corrected. You can execute `main.k` and obtain the expected YAML output:

```yaml
r:
  cpu: 4
  memory: 8Gi
config:
  resource:
    cpu: 4
    memory: 8Gi
```

For more information, see [KCL Issue #422](https://github.com/KusionStack/kcl/issues/422).

### Configure if expression type mismatch error optimization

```python
config: {"A"|"B": int} = {
    if True:
        A = "2"
}
```

Before KCL v0.4.5, for the configuration if expression, executing the above code will get the expected configuration value, resulting in the type unsoundness problem, because the KCL compiler incorrectly checks that the value `"2"` of the `A` attribute does not match the declared type `int`. After the KCL v0.4.5, this problem has been corrected. You can execute the above code to obtain the expected type mismatch error:

```stderr
KCL Compile Error[E2G22] : The type got is inconsistent with the type expected
---> File main.k:1:1
1 |config: {"A"|"B": int} = {
 1 ^  -> got {str(A):str(2)}
expect {str(A)|str(B):int}, got {str(A):str(2)}
```

For more information, see [KCL Issue #389](https://github.com/KusionStack/kcl/issues/389).

### Rule statement validation does not work

In previous KCL versions, when the following rule code is used (main.k), the constraint code of `ServiceCheckRule` will not take effect.

```python
protocol KubeResourceProtocol:
    svc: Service

schema Service:
    name: str

rule ServiceCheckRule for KubeResourceProtocol:
    svc.name != "name"

svc = Service {
    name = "name"
}

ServiceCheckRule {
    svc = svc
}
```

After the improvement, we execute the above code and get an accurate validation failure error:

```stderr
KCL Runtime Error[E3B17] : Schema check is failed to check condition
---> File main.k:14
14 |ServiceCheckRule { -> Instance check failed
    ---> File main.k:8
    8 |    svc.name != "name" -> Check failed on the condition
Check failed on check conditions
```

### Configuration block attribute type inference optimization

```python
schema Id:
    id?: int = 1

schema Config:
    data?: {"A"|"B": Id}

c = Config {
    data = {
        A = Id()  # Before v0.4.5, we will get a type mismatch error here.
        B = Id()
    }
}
```

Before KCL v0.4.5, executing the above code would result in an unexpected type mismatch, because the KCL compiler incorrectly deduced the type of the `c.data.A` attribute to the `str` type, resulting in a mismatch error with the string literal union type `"A"|"B"`. After KCL v0.4.5 was updated, this problem was corrected, and the expected YAML output could be obtained by executing the above code:

```yaml
c:
  data:
    A:
      id: 1
    B:
      id: 1
```

### Assignment statement uses schema type annotation error optimization

```python
schema Foo:
    foo: int

schema Bar:
    bar: int

foo: Foo = Bar {  # Before v0.4.5, we will get a runtime type mismatch error here
    bar: 1
}
```

Before KCL v0.4.5, executing the above code will result in a runtime type mismatch error. After the version is updated, this type mismatch error will be optimized to compile time, and the error will be moved to the left to find this type of error earlier.

### Error on KCL module type with the ?. operator

```python
import math

data = math?.log(10)  # Before v0.4.5, we will get an unexpected 'math is not defined' error here
```

Before KCL v0.4.5, executing the above code will result in an unexpected undefined variable error because the KCL compiler does not correctly handle the `math` module type and the `?.` operators are used in combination. After KCL v0.4.5, such issues are fixed.

## Other Updates and Issues

For more updates and bug fixes, see [here](https://github.com/KusionStack/kcl/milestone/3)

## Documents

The versioning semantic option is added to the [KCL website](https://kcl-lang.io/). Currently, v0.4.3, v0.4.4, and v0.4.5 versions are supported.

![](/img/blog/2023-02-27-kcl-0.4.5-release-blog/kcl-website-doc-version.png)

## Community

+ Two external contributors @thinkrapido and @Rishav1707 have participated in the KCL community, thank them for their enthusiasm and active participation in contributing.
+ Thank @Rishav1707 for establishing the Rust version of [kcl-loader-rs](https://github.com/i-think-rapido/kcl-loader-rs) sub-project based on KCL, which supports the automatic generation of Rust structure according to the schema and configuration definition in the KCL file and the deserialization function from KCL value to Rust structure value.

## Next

It is expected that in the middle of April 2023, we will release **KCL v0.4.6**. The expected key evolution includes:

+ KCL language is further improved for convenience, the user interface is continuously optimized and experience is improved, user support and pain points are solved.
+ A new version of the KCL language server and [VSCode language plug-in](https://github.com/KusionStack/vscode-kcl), the performance is expected to increase by **20 times**, and it is expected to support core basic capabilities such as code warning and error wavy line prompt, jump, reference search, etc.
+ Continuously improve the language ability for the pain points of Kubernetes Manifests configuration management scenarios. For example, design and provide the [Helm](https://github.com/helm/helm) KCL Schema plug-in and provide the KCL SDK for the [kpt](https://github.com/GoogleContainerTools/kpt) tool.
+ [KCL package management tool called KPM](https://github.com/KusionStack/kpm) release. It is expected to support Git repo code dependency configuration and update, code download, and other basic capabilities.
+ [KCL Playground](https://github.com/KusionStack/kcl-playground): Support code sharing and KCL version selection.
+ [KCL Go SDK](https://github.com/KusionStack/kclvm-go): More capability support such as supporting the bidirectional conversion of the KCL schema and Go structure
+ [KCL Python SDK](https://github.com/KusionStack/kclvm-py): More capability support.

For more details, please refer to [KCL v0.4.6 Milestone](https://github.com/KusionStack/kcl/milestone/4)

## FAQ

For more information, see [KCL FAQ](https://kcl-lang.io/docs/user_docs/support/).

## Additional Resources

Thank all KCL users for their valuable feedback and suggestions during this version release. For more resources, please refer to:

+ [KCL Website](https://kcl-lang.io/)
+ [Kusion Website](https://kusionstack.io/)
+ [KCL Repo](https://github.com/KusionStack/kcl)
+ [Kusion Repo](https://github.com/KusionStack/kusion)
+ [Konfig Repo](https://github.com/KusionStack/konfig)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏
