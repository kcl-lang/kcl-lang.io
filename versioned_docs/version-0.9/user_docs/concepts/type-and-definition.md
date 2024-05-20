# Type and Definition

This section mainly covers the concepts related to types and definitions.

## Type

KCL features a **gradual static type system**, initially designed to consider scalability. Its aim is to significantly reduce the configuration writing difficulties for users while maintaining stability. Static typing enhances code quality, acts as documentation, and helps detect errors at an early stage when needed. For instance, defining a complete static type for data like JSON/YAML can be challenging, similar to how TypeScript adds complexity in handling type gymnastics due to the lack of runtime type checks for Javascript. In contrast, KCL incorporates a similar TypeScript type system while still retaining runtime type checks. Thus, type errors will always appear at runtime. Consequently, KCL has types, but they can be selectively used when necessary, and it handles interactions between typed and untyped code elegantly and securely.

The configuration of attributes and types in KCL usually follows a simple pattern:

$$
k = (T) v
$$

where $k$ is the attribute name, $v$ is the attributes value, and $T$ is the type annotation. Since KCL has the ability of the type inference, $T$ is usually omitted.

By default, KCL does not require type annotations and performs type checks at runtime.

```python
name = "nginx"  # The type of `name` is `str`
port = 80  # The type of `port` is `int`
```

As long as we operate on basic types such as integers and strings, it is generally sufficient to annotate the default type and directly write the configuration. KCL can infer the type of basic data. We recommend writing types for complex structures and function definitions, which will clearly provide a good input prompt for other users who use structures and functions.

```python
# Types for schema
schema App:
    name: str
    domainType: "Standard" | "Customized" | "Global"
    containerPort: int
    volumes: [Volume]
    services: [Service]

    check:
        1 <= containerPort <= 65535

schema Service:
    clusterIP: str
    $type: str

    check:
        clusterIP == "None" if $type == "ClusterIP"

schema Volume:
    container: str = "*"  # The default value of `container` is "*"
    mountPath: str

    check:
        mountPath not in ["/", "/boot", "/home", "dev", "/etc", "/root"]

# Types for lambda
appFilterFunc = lambda apps: [App], name: str -> [App] {
    [a for a in apps if a.name == name]
}
```

More formal definitions and usage of types are at the [type specification document](/docs/reference/lang/types/) and the [tour document of the type system](/docs/reference/lang/tour#type-system)

**Schema** is the core type in KCL, just like a database schema, which defines the organization of configuration data. This includes logical constraints such as schema names, fields, data types, and the relationships between these entities. Patterns typically use visual representations to convey the architecture of a database, becoming the foundation for organizing configuration data. The process of designing schema patterns is also known as configuration modeling. KCL Schema typically serves various roles, such as application developers, DevOps platform administrators, and SRE, and provides them with a unified configuration interaction interface.

In addition, the ability to enforce constraints from top to bottom is crucial for any large-scale configuration setting. Therefore, KCL not only provides the ability to define static types but also provides the rich ability to define constraints, which is to some extent equivalent to assertion statements in programming languages. To prevent assertions from constantly expanding, we place structural constraints together with structural type definitions and support custom error messages.

In KCL, we can use schema to organize the configuration data to meet the requirements of model definition, abstraction, and templating. Schema is the core feature of KCL, which defines attributes, operations, and check-blocks. Usually, a formal form of KCL Schema can be written in the following form:

$$
S = \Sigma_{i = 1}^{N} \{s_i, T_i, \mathcal{T}[s_i]\},
$$

where $N$ is the total number of attributes, $\mathcal{T}$ is the attribute constraint, $s_i$ and $T_i$ denotes the $i$-th attribute name and type. Simultaneously, to improve the reusability of the code and meet the needs of hierarchical definition, KCL draws on the experience of OOP and uses single inheritance to reuse and extend the schema. Schema inheritance can be regarded as a special type of partial order relationship, and satisfies

$$
unionof(T_1, T_2) = T_2 \Leftrightarrow T_1 \subseteq T_2,
$$

where $T_1$ and $T_2$ are both schema types. When the above equation is not satisfied, the KCL will throw a type check error.

A typical schema with constraints is defined as follows:

```python
import regex

schema Secret:
    name: str
    # Data defines the keys and data that will be used by secret.
    data?: {str:str}

    check:
        all k in data {
            regex.match(k, r"[A-Za-z0-9_.-]*")
        } if data, "a valid secret data key must consist of alphanumeric characters, '-', '_' or '.'"
```

More specifications and usage of KCL schema and constraint is [here](/docs/reference/lang/spec/schema).
