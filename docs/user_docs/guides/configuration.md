---
title: "Configuration"
sidebar_position: 1
---

## Use KCL to Write Configurations

The core features of KCL are its **modeling** and **constraint** capabilities, and the basic functions of KCL revolve around the two core features. In addition, KCL follows the user-centric configuration concept to design its basic functions, which can be understood from two aspects:

- **Domain model-centric configuration view**: With the rich features of KCL language and [KCL OpenAPI](https://kcl-lang.github.io/docs/tools/cli/openapi/quick-start) tools, we can directly integrate a wide range of well-designed models in the community into KCL (such as the K8s resource model). We can also design and implement our own KCL models or libraries according to different scenarios, forming a complete set of domain models for other configuration end users to use.
- **End user-centric configuration view**: With KCL's code encapsulation, abstraction and reuse capabilities, the model architecture can be further abstracted and simplified (for example, the K8s resource model is abstracted into an application-centered server model) to **minimize the** end user configuration input**, simplify the user's configuration interface, and facilitate manual or automatic API modification.

No matter what configuration view is centered on, for configuration code, there are requirements for configuration data constraints, such as type constraints, required/optional constraints on configuration attributes, range constraints, and immutability constraints. This is also one of the core issues KCL is committed to solving.

Thus, we can write a KCL file named `main.k`

```python
schema Person:
    gender: "Male" | "Female"
    name: Name

schema Name:
    first: str
    middle?: str  # Optional, but must be non-empty when specified
    last: str

    check:
        first != ""
        last != ""
        middle != "" if middle

alice = Person {
    # gendre: "Female" # Error: misspelled attribute
    gender: "Female"
    name.first: "Alice"
    name.last: "White"
}
```

Run

```
kcl main.k
```

We can get the output YAML

```yaml
alice:
  gender: Female
  name:
    first: Alice
    last: White
```
