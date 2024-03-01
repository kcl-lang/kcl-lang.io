---
title: "Automation"
sidebar_position: 6
---

KCL provides many automation related capabilities, mainly including tools and multilingual APIs. Via `package_identifier : key_identifier` mode, KCL supports the indexing of any configured key value, thus completing the addition, deletion, modification and query of any key value. For example, the following figure shows that we can directly execute the following command to modify the image. The code diff before and after modification is also shown in the figure.

![](/img/blog/2022-09-15-declarative-config-overview/14-kcl-image-update.png)

In addition, the automation capability of KCL can be realized and integrated into CI/CD.

![](/img/blog/2022-09-15-declarative-config-overview/15-kcl-automation.png)

KCL allows us to directly modify the values in the configuration model through the KCL CLI `-O|--overrides` parameter. The parameter contains three parts e.g., `pkg`, `identifier`, `attribute` and `override_value`.

```bash
kcl main.k -O override_spec
```

- `override_spec` represents a unified representation of the configuration model fields and values that need to be modified

```bash
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

```bash
kcl main.k -O :person.name=\"Bob\" -O :person.age=10
```

The output is

```yaml
person:
  name: Bob
  age: 10
```

Besides, when we use KCL CLI `-d` argument, the KCL file will be modified to the following content at the same time

```bash
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

```bash
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

```bash
kcl main.k -O config.x-
```

The output is

```yaml
config:
  x: 1
  y: s
```

### API

In addition, we can automatically modify the configuration attributes through the [multilingual API](/docs/reference/xlang-api/overview).

Take the following KCL code fragment (main.k) and RestAPI as an example.

```python
import regex

schema AppConfig:
    image: str

    check:
        regex.match(image, r"^([a-z0-9\.\:]+)\.([a-z]+)\:([a-z0-9]+)\/([a-z0-9\.]+)\/([a-z0-9-_.:]+)$"), "image name should satisfy the \`REPOSITORY:TAG\` form"

appConfig = AppConfig {
    image = "nginx:1.13.9"
}
```

The RestAPI service can be started in the following way:

```bash
kclvm -m gunicorn "kclvm.program.rpc-server.__main__:create_app()" -t 120 -w 4 -k uvicorn.workers.UvicornWorker -b :2021
```

The service can then be requested via the POST protocol:

```bash
curl -X POST http://127.0.0.1:2021/api:protorpc/KclvmService.OverrideFile -H 'content-type: accept/json' -d '{
    "file": "main.k",
    "specs": ["appConfig.image=\"nginx:1.14.0\""]
}'
```

After the service call is completed, main.k will be modified as follows:

```python
import regex

schema AppConfig:
    image: str

    check:
        regex.match(image, r"^([a-z0-9\.\:]+)\.([a-z]+)\:([a-z0-9]+)\/([a-z0-9\.]+)\/([a-z0-9-_.:]+)$"), "image name should satisfy the \`REPOSITORY:TAG\` form"

appConfig = AppConfig {
    image = "nginx:1.14.0"
}
```
