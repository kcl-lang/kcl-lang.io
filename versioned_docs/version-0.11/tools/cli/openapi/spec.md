# KCL OpenAPI Spec

[OpenAPI](https://www.openapis.org/) defines the API Specification for API providers to describe their operations and models in a normative way and provides generating tools to automatically convert to client codes in specific languages.

The KCL OpenAPI Spec describes the rules about how the OpenAPI definitions are translated to the KCL schemas.

## The File Structure of the KCL OpenAPI

According to the OpenAPI 3.0 specification, an OpenAPI file should at least contains four root objects: `openapi`, `components`, `info`, `paths`. The KCL OpenAPI focuses on the part in which the models are defined in the `definitions` object. Yet the `paths` part which describes the Restful API operations is not considered by the KCL OpenAPI Spec.

:::info
Note: In addition to the objects listed above, the OpenAPI spec also supports `servers`, `security`, `tags`, and `externalDocs` as optional root objects, but none of them are concerned by KCL OpenAPI when generating model codes, so we do not need to fill in this section. Yet it won't make any difference if you do.
:::

To put it more comprehensible for beginners, let's take a quick look at the root objects that forms the typical KCL OpenAPI file (snippets from swagger example [Petstore](https://petstore.swagger.io/). The KCL OpenAPI tool only focuses on the `definitions` object which describes two data models (`Pet` and `Category`), and the model `Pet` contains three attributes: `name`, `id`, and `category`)

## KCL schema

The KCL schema structure defines the "type" of configuration data.

:::info
More information about KCL schema, see [KCL Language Tour#Schema](../../../reference/lang/tour.md)
:::

In the OpenAPI spec, a KCL schema can be defined by adding a `definition` element within the `definitions` object.

Example:
The following example defines two schemas in KCL: `Pet` and `Category`, followed by the corresponding data models defined in OpenAPI:

```python
# KCL schema
schema Pet:
    name:      str
    id?:       int
    category?: Category

schema Category:
    name?: str

# The corresponding OpenAPI spec
{
    "definitions": {
        "Pet": {
            "type": "object",
            "properties": {
                "name": {
                    "type": "string"
                },
                "id": {
                    "type": "integer",
                    "format": "int64"
                },
                "category": {
                    "$ref": "#/definitions/Category"
                }
            },
            "required": [
                "name"
            ]
        },
        "Category": {
            "type": "object",
            "properties": {
                "name": {
                    "type": "string"
                }
            }
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}
```

### Schema Name

In KCL, the schema name is declared immediately after the schema keyword, and in OpenAPI, the name of the model is defined by the key of the definition element.

### Schema Type

The type of KCL schema in OpenAPI is always "object". As in the previous example, the value of the `type` object in `Pet` should be `object`.

### Schema Attribute

Zero or more attributes can be defined in the KCL schema. The declaration of attributes generally includes the following parts:

- Attribute annotation: Optional, starting with `@`, such as `@deprecated` to indicate a deprecated attribute
- Attribute name: Required
- Attribute optional modifiers(`?`): Optional. A question mark indicates that the current attribute is optional and may not be assigned. Conversely, the absence of a question mark indicates a required attribute
- Attribute type: Required. The attribute can be a primitive data type, a schema type, or a combination of the two preceding types
- Attribute default value: Optional

The mapping between them and the OpenAPI spec is as follows:

| Elements of KCL Schema Attribute  | Corresponding Elements in OpenAPI                                                                                                                                                                                                                                                                                                                                            |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| attribute annotation              | Not supported. We are planning to add an extension `deprecate` field to the KCL-OpenAPI                                                                                                                                                                                                                                                                                      |
| attribute name                    | The key of the property under the `property` object                                                                                                                                                                                                                                                                                                                          |
| attribute optional modifiers(`?`) | In each element in the `definition` object, here's an optional `required` field which lists the all the required attributes of that model, and the attributes not listed are optional                                                                                                                                                                                        |
| attribute type                    | The basic types can be declared by a combination of `type` and `format`, and the schema type is declared by a `$ref` to the schema definition. KCL-OpenAPI spec adds a `x-kcl-types` extension to indicate a type union. `enum` indicates a union of several literal types. For the type declaration in KCL-OpenAPI, see the chapter - [basic data types](#basic-data-types) |
| attribute default value           | The value of the `default` field is used to set the default value for the attribute                                                                                                                                                                                                                                                                                          |

Example:

The following KCL code defines a Pet model which contains two attributes: name (`string` type, `required`, with no attribute annotation and no default value) and id (`int64` type, optional, with no attribute annotation, and the default value is -1).

```python
# the KCL schema Pet defines two attributes: name, id
schema Pet:
    name: str
    id?:  int = -1

# The corresponding OpenAPI spec
{
    "definitions": {
        "Pet": {
            "type": "object",
            "properties": {
                "name": {
                    "type": "string",
                },
                "id": {
                    "type": "integer",
                    "format": "int64",
                    "default": -1
                }
            },
            "required": [
                "name"
            ],
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}
```

### Schema Index Signature

In the KCL schema, the index signatures can be used to define attributes with undefined attribute names. The KCL schema index signature contains the following elements:

- Type of the key in the index signature: Declared in square brackets. It must be the basic type
- Type of value in the index signature: Declared after the colon in the square brackets. It can be any valid KCL type
- Ellipses(`...`) in the index signature: In the square brackets, before the type declaration of the key. It indicates that the index signature is only used to constrain attributes not defined in the schema. The assentation of the symbol indicates that all defined and undefined attributes in the schema are constrained by the index signature.
- Alias for key in index signature: Declared in square brackets, immediately after the left square bracket and takes the form of `<name>:`. The alias can then be used to reference the index signature by name
- The default value of the index signature: Assign a value to the index signature as the default value

The index signature with its key in `string` type can be described based on the field `additionalProperties`. Other index signatures with a key in types besides `string`, and the `check` expressions used to validate the index signature are not supported by the KCL OpenAPI spec.

The mapping between them and the OpenAPI spec is as follows:

| Elements of KCL Index Signature              | Corresponding Elements in OpenAPI                                                               |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| Type of the key in the KCL index signature   | Only string type is allowed in OpenAPI                                                          |
| Type of the value in the KCL index signature | Declared by the `type` in the `additionalProperties` field                                      |
| Ellipses(`...`) in the index signature       | Only the corresponding meaning of the attendance of the `...` symbol is allowed in OpenAPI      |
| Alias for key in index signature             | Not supported in KCL-OpenAPI yet. We are planning to add an `x-alias` extension to support that |
| Default value of the index signature         | Not supported in KCL-OpenAPI                                                                    |

Example:

The following KCL code defines a Pet model which contains two pre-declared attributes(`name` and `id`) and allows users to add attributes with `string` type keys and `bool` type values.

```python
# the KCL schema Pet. Besides the pre-declared attributes name and id, it allows to add attributes with key in string type and value in bool type
schema Pet:
    name:     str
    id?:      int
    [...str]: bool

# The corresponding OpenAPI spec
{
    "definitions": {
        "Pet": {
            "type": "object",
            "properties": {
                "name": {
                    "type": "string",
                },
                "id": {
                    "type": "integer",
                    "format": "int64",
                }
            },
            "additionalProperties": {
                "type": "bool"
            },
            "required": [
                "name"
            ],
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}
```

### Schema Inherit

working in progress

### Inline schema

OpenAPI supports models to be declared inline. But KCL currently does not support that. The model defined inline in OpenAPI will be converted to a schema with a name in KCL. And the naming convention will be:

| element to define an inline schema in OpenAPI | the name of the corresponding KCL schema                       |
| --------------------------------------------- | -------------------------------------------------------------- |
| inline Property                               | add the Property name at the end of the outer schema Name      |
| AdditionalProperties                          | add "AdditionalProperties" at the end of the outer schema Name |

We are planning to support inline schema in KCL, and when supported, the naming convention will be updated then.

Example-1:

The following KCL code defines a `Deployment` model which contains two attributes(`kind` and `spec`). And the schema of the `spec` attribute is defined inline.

```python
# The OpenAPI spec
{
    "definitions": {
        "Deployment": {
            "type": "object",
            "properties": {
                "kind": {
                    "type": "string",
                },
                "spec": {
                    "type": "object",
                    "properties": {
                        "replicas": {
                            "type": "integer",
                            "format": "int64"
                        }
                    }
                }
            },
            "required": [
                "kind",
                "spec"
            ],
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}

# The corresponding KCL schemas
schema Deployment:
    kind: str
    spec: DeploymentSpec

schema DeploymentSpec:
    replicas?: int
```

Example-2:

The following KCL code defines a Person model which contains a pre-declared attribute(`name`) and allows some `additionalProperties` to be assigned by user. And the type of the values in the `additionalProperties` is defined inline.

```python
# The OpenAPI spec
{
    "definitions": {
        "Person": {
            "type": "object",
            "properties": {
                "name": {
                    "type": "string",
                },
            },
            "required": [
                "name",
                "spec"
            ],
            "additionalProperties": {
                "type": "object",
                "properties": {
                    "name": {
                        "type": "string"
                    },
                    "description": {
                        "type": "string"
                    }
                },
                "required": [
                    "name"
                ]
            },
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}

# The corresponding KCL schemas
schema Person:
    name: str
    [...str]: [PersonAdditionalProperties]

schema PersonAdditionalProperties:
    name:         str
    description?: str
```

## KCL Doc

:::info
More information about KCL doc specification, please refer to the [KCL Document Specification](../kcl/docgen.md)
:::

KCL documents consist of module documents and schema documents. And only the schema documents can be extracted from OpenAPI. The KCL schema document contains four parts:

- Schema Description: Declared right after the schema declaration and before the schema attribute declaration. It provides an overview of schemas
- Schema Attribute Doc: Declared right after the schema Description and separated by `Attributes` + `---` delimiters. It describes the attribute
- Additional information about the schema: Declared right after the schema attribute doc and separated by `See Also` + `---` delimiters
- Example information about the schema: Declared right after the schema additional information and separated by `Examples` + `---` delimiters

The mapping between them and the OpenAPI spec is as follows:

| Elements of KCL Schema Document         | Corresponding Elements in OpenAPI                       |
| --------------------------------------- | ------------------------------------------------------- |
| Schema Description                      | The value of the `description` field of the data model  |
| Schema Attribute Doc                    | The value of the `description` field of the property    |
| Additional information about the schema | The value of the `externalDocs` field of the data model |
| Example information about the schema    | The value of the `example` field of the data model      |

Example:

The following KCL code defines a Pet model with a schema description `The schema Pet definition`, and two attributes `name` and `id` with their attribute doc `The name of the pet` and `The id of the pet`; The additional information about the Pet schema is [here](https://petstore.swagger.io/) and the example to use the Pet schema are provided, too.

```python
# The KCL schema Pet, with doc following the KCL Document Specification
schema Pet:
    """The schema Pet definition

    Attributes
    ----------
    name : str, default is Undefined, required
        The name of the pet
    id : int, default is -1, optional
        The age of the pet

    See Also
    --------
    Find more info here. https://petstore.swagger.io/

    Examples
    --------
    pet = Pet {
        name = "doggie"
        id   = 123
    }
    """
    name: str
    id?:  int = -1

# The corresponding OpenAPI Spec
{
    "definitions": {
        "Pet": {
            "description": "The schema Pet definition",
            "type": "object",
            "properties": {
                "name": {
                    "type": "string",
                    "description": "The name of the pet"
                },
                "id": {
                    "type": "integer",
                    "format": "int64",
                    "default": -1,
                    "description": "The age of the pet"
                }
            },
            "required": [
                "name"
            ],
            "externalDocs": {
                "description": "Find more info here",
                "url": "https://petstore.swagger.io/"
            },
            "example": {
                "name": "doggie",
                "id": 123
            }
        }
    },
    "swagger": "2.0",
    "info": {
        "title": "demo",
        "version": "v1"
    }
}
```

## Basic Data Types

| JSON Schema type | swagger type                | KCL type        | comment                                                                     |
| ---------------- | --------------------------- | --------------- | --------------------------------------------------------------------------- |
| boolean          | boolean                     | bool            |                                                                             |
| number           | number                      | float           |                                                                             |
|                  | number format double        | **unsupported** |                                                                             |
|                  | number format float         | float           |                                                                             |
| integer          | integer                     | int (32)        |                                                                             |
|                  | integer format int64        | **unsupported** |                                                                             |
|                  | integer format int32        | int (32)        |                                                                             |
| string           | string                      | str             |                                                                             |
|                  | string format byte          | str             |                                                                             |
|                  | string format int-or-string | int \| str      |                                                                             |
|                  | string format binary        | str             |                                                                             |
|                  | string format date          | unsupported     | As defined by full-date - [RFC3339](https://www.rfc-editor.org/rfc/rfc3339) |
|                  | string format date-time     | unsupported     | As defined by date-time - [RFC3339](https://www.rfc-editor.org/rfc/rfc3339) |
|                  | string format password      | unsupported     | for swagger: A hint to UIs to obscure input                                 |
|                  | datetime                    | datetime        |                                                                             |

## Reference

- OpenAPI spec 2.0: [https://swagger.io/specification/v2/](https://swagger.io/specification/v2/)
- OpenAPI spec 3.0: [https://spec.openapis.org/oas/v3.1.0](https://spec.openapis.org/oas/v3.1.0)
- OpenAPI spec 3.0: [https://swagger.io/specification/](https://swagger.io/specification/)
- OpenAPI spec 2.0: [https://swagger.io/specification/v2/#schemaObject](https://swagger.io/specification/v2/#schemaObject)
- Go swagger: [https://goswagger.io/use/models/schemas.html](https://goswagger.io/use/models/schemas.html)
- Swagger data models: [https://swagger.io/docs/specification/data-models/](https://swagger.io/docs/specification/data-models/)
