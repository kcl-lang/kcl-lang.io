---
title: "自动化"
sidebar_position: 6
---

KCL provides many automation related capabilities, mainly including tools and multilingual APIs. Via `package_identifier : key_identifier` mode, KCL supports the indexing of any configured key value, thus completing the addition, deletion, modification and query of any key value. For example, the following figure shows that we can directly execute the following command to modify the image. The code diff before and after modification is also shown in the figure.

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

In addition, the automation capability of KCL can be realized and integrated into CI/CD.

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

KCL allows us to directly modify the values in the configuration model through the KCL CLI `-O|--overrides` parameter. The parameter contains three parts e.g., `pkg`, `identifier`, `attribute` and `override_value`.

```
kcl main.k -O override_spec
```

- `override_spec` represents a unified representation of the configuration model fields and values that need to be modified

```
override_spec: [[pkgpath] ":"] identifier ("=" value | "-")
```

- `pkgpath`: Indicates the path of the package whose identifier needs to be modified, usually in the form of `a.b.c`. For the main package, `pkgpath` is expressed as `__main__`, which can be omitted. If omitted, it means the main package.
- `identifier`: Indicates the identifier that needs to modify the configuration, usually in the form of `a.b.c`.
- `value`: Indicates the value of the configuration that needs to be modified, which can be any legal KCL expression, such as number/string literal value, list/dict/schema expression, etc.
- `=`: means to modify the value of identifier.
  - When the identifier exists, modify the value of the existing identifier to value.
  - When identifier does not exist, add the identifier attribute and set its value to value.
- `-`: means to delete the identifier attribute.
  - When the identifier exists, delete it directly.
  - When the identifier does not exist, no modification is made to the configuration.

Note: When `identifier` appears multiple times, modify/delete all `identifier` values

Besides, we provide `OverrideFile` API to achieve the same capabilities. For details, refer to [KCL APIs](/docs/reference/xlang-api/).

## Examples

### Override Update Sample

KCL code:

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

The command is

```
kcl main.k -O :person.name=\"Bob\" -O :person.age=10
```

The output is

```yaml
person:
  name: Bob
  age: 10
```

Besides, when we use KCL CLI `-d` argument, the KCL file will be modified to the following content at the same time

```
kcl main.k -O :person.name=\"Bob\" -O :person.age=10 -d
```

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Bob"
    age = 10
}
```

Another more complicated example:

```python
schema Person:
    name: str
    age: int
    ids?: [int]

person = Person {
    name = "Alice"
    age = 10
}
```

The command is

```
kcl main.k -O :person.ids=\[1,2\]
```

The output is

```yaml
person:
  name: Alice
  age: 10
  ids:
  - 1
  - 2
```

### Override Delete Sample

KCL code:

```python
schema Config:
    x?: int = 1
    y?: str = "s"
    
config = Config {
    x = 2
}
```

The command is

```
kcl main.k -O config.x-
```

The output is

```yaml
config:
  x: 1
  y: s
```
