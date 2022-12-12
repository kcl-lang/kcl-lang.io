# KCL OpenAPI 规范

[OpenAPI](https://www.openapis.org/) 允许 API 提供方规范地描述 API 操作和模型，并基于它生成自动化工具和特定语言的客户端。

## KCL OpenAPI 文件结构

依据 OpenAPI 3.0 规范，OpenAPI 文件中应至少包含 openapi、components、 info、paths 四种根节点对象，KCL OpenAPI 聚焦于其中模型定义的部分，即 OpenAPI 文件中的 `definitions`，而描述操作的 Restful API 部分（即 OpenAPI 文件中的 `paths`）则不属于 KCL OpenAPI 定义的范畴。
​

注：除以上列出的节点外，OpenAPI 官方规范还支持 servers、security、tags、externalDocs 四种可选的根节点，但都不是 KCL OpenAPI 所关心的，因此用户无需填写这部分内容，即使填写了也不会产生任何影响。
​

| OpenAPI 顶层对象 | 类型              | 含义                                                            | KCL OpenAPI 工具支持情况                                                                        |
| ---------------- | ----------------- | --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ |
| swagger          | string            | openapi 版本信息                                                | 必填项，目前支持 openapi 2.0，即合法取值为 "2.0"                                                 |
| definitions      | Definition Object | 模型定义                                                        | 必填项                                                                                           |
| info             | Info Object       | 当前 API 文件的元数据信息，例如标题、描述信息、版本、开源协议等 | 必填项，定义当前 OpenAPI 文件的基本信息，不会输出到 KCL 代码，但可用于 Swagger-UI 工具可视化展示 |

为方便初学者快速理解，下面给出一个典型的 KCL OpenAPI 文件（截取自 swagger example [Petstore](https://petstore.swagger.io/)）应包含的节点图示。KCL OpenAPI 工具重点关注其中的 definitions 节点，可以看到文件中定义了两个模型（Pet 和 Category），并且 Pet 模型中包含三个属性（name、id、category）

## KCL schema

KCL 中使用 schema 结构来定义配置数据的“类型”，关于 KCL schema，可参考文档：传送门
在 definitions 节点下新增 definition 元素，即可定义 KCL schema.
示例：
下例在 KCL 代码中定义了 Pet、Category 两个 schema，同样地，其对应的 OpenAPI 也在 definitions 节点下包含这两个模型的描述。

```python
# KCL schema：
schema Pet:
    name:      str
    id?:       int
    category?: Category

schema Category:
    name?: str

# 对应的 OpenAPI 描述
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

### schema 名称

在 KCL 中，schema 名称紧跟在 schema 关键字后声明，在 OpenAPI 中，模型的名称通过 definition 元素的 key 来定义。

### schema 类型

KCL schema 在 OpenAPI 中的类型为 "object". 例如上例中 "Pet" 的 "type" 值应为 "object".

### schema 属性

KCL schema 中可以定义若干属性，属性的声明一般包含如下几部分：

- 属性注解：可选，以 @ 开头，例如 @deprecated 注解表示属性被废弃
- 属性访问修饰符（final）：可选，声明当前属性的值不可被修改
- 属性名称：必须
- 属性 optional 修饰符（?）：可选，带问号表示当前属性为可选属性，可以不被赋值。反之，不带问号表示必填属性
- 属性类型：必须，可以是基本数据类型，也可以是 schema 类型， 或者是前述两种类型的并集
- 属性默认值：非必须

它们与 OpenAPI 规范的对应关系如下：

| KCL schema 属性元素                                      | OpenAPI 元素                                                                                                                                                                                      |
| -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 属性注解                                                 | 暂不支持，计划扩展一个 deprecate 字段用于描述 deprecated 注解                                                                                                                                     |                                                                                                                                 |
| 属性名称                                                 | properties 节点下，每个属性的 key 即为属性名称                                                                                                                                                    |
| 属性 optional 修饰符（？）                               | 模型节点下，通过 required 字段列出该模型的所有必填属性的名称，未被列出的属性即为 optional                                                                                                         |
| 属性类型                                                 | 属性节点下，设置 type + format 可以标识属性的基本类型，如果是 schema 类型则用 $ref 字段表示，类型 union 则由扩展字段 x-kcl-types 来标识，此外，属性节点的 enum、pattern 也可以用于表示 KCL 类型。 |
| KCL-OpenAPI 关于类型的对照关系，详见“基本数据类型”小节 |                                                                                                                                                                                                   |
| 属性默认值                                               | 属性节点下，设置 default 字段即可为属性设置默认值                                                                                                                                                 |

示例：
下例中 Pet 模型包含了 2 个属性：name（string 类型，必填属性，无注解，无默认值）、id（int64 类型，无注解，非必填，默认值为 -1）

```python
# KCL schema Pet，包含两个属性 name 和 id
schema Pet:
    name: str
    id?:  int = -1

# 对应的 OpenAPI 文档
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

### schema 索引签名

KCL schema 允许定义索引签名，用于定义属性名不固定的 dict，起到静态模板的作用。具体来说，KCL schema 索引签名包含如下几个元素：

- 索引签名中 key 的类型：在方括号中声明，必须是基础类型
- 索引签名中 value 的类型：在冒号后声明，可以是任意合法的 KCL 类型
- 索引签名中的省略符：在方括号中，key 类型之前声明，使用"..."表示。如果带有该符号，表示该索引签名只用于约束未在 schema 中定义的属性；否则，表示 schema 中所有已定义和未定义属性都收到该索引签名的约束。
- 索引签名中 key 的别名：在方括号中，紧随左方括号之后声明，使用名称 + 冒号表示，该别名可用于按名称引用索引签名
- 索引签名的默认值：可以为索引签名设置默认值

在 OpenAPI 中，可以借助在模型节点的 `additionalProperties` 字段描述某些 key 为 string 的索引签名。但对于 KCL 索引签名中非 string 类型的 dict key、索引签名 key 的 check 校验，在 OpenAPI 规范没有对等的描述。它们与 OpenAPI 规范的对应关系如下：

| KCL 索引签名元素        | OpenAPI 元素                                                           |
| ----------------------- | ---------------------------------------------------------------------- |
| 索引签名中 key 的类型   | OpenAPI 仅支持 key 为 string 类型，无法自定义                          |
| 索引签名中 value 的类型 | 模型节点的下 additionalProperties 下的 "type" 字段                     |
| 索引签名中的省略符      | OpenAPI 中表示索引签名时，只能表示 KCL 中带有省略符的情况              |
| 索引签名中 key 的别名   | OpenAPI 中不支持为索引签名定义 key 别名，（预计通过扩展支持：x-alias） |
| 索引签名的默认值        | 目前不支持                                                             |

示例：下例中的 KCL schema Pet，包含两个预定义的属性 name 和 id，除此之外，还允许使用该 schema 的配置额外地赋值其他 key 为 string 类型，value 为 bool 类型的属性：

```python
# KCL schema Pet，包含两个预定义的属性 name 和 id，允许额外给 key 为 string、value 为 bool 的属性赋值
schema Pet:
    name:     str
    id?:      int
    [...str]: bool

# 对应的 OpenAPI 描述
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

### schema 继承关系

### 内联 schema

OpenAPI 支持嵌套地定义 schema，但 KCL 目前暂不支持 schema 的内联。OpenAPI 中内联定义的 schema 将被转换为 KCL 中带名称的 schema，其名称的命名规则为：在该内联 schema 的上层 schema 名称的基础上，增加相应的后缀。在拼接后缀时，根据定义了该内联 schema 的外层 OpenAPI 元素类型，后缀内容如下：

| OpenAPI 文档中定义内联 schema 的元素 | KCL schema 名称拼接规则        |
| ------------------------------------ | ------------------------------ |
| 某属性节点                           | 增加该属性节点的名称为后缀     |
| AdditionalProperties 节点            | 增加"AdditionalProperties"后缀 |

注：KCL 未来也可能会支持内联 schema，届时再更新这部分转换规则
示例 1：下例中的模型 Deployment 包含有 kind、spec 两个属性，其中 deploymentSpec 属性的 schema 通过内联的方式定义：

```python
# OpenAPI 文档
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

# 转换为 KCL Schema 如下：
schema Deployment:
    kind: str
    spec: DeploymentSpec

schema DeploymentSpec:
    replicas?: int
```

示例 2：下例中的模型 Person 中除固定属性 name 外，还允许包含额外的属性（additionalProperties），并且这部分额外属性的属性值的 schema 通过内联的方式定义：

```python
# OpenAPI 文档
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

# 转换为 KCL Schema 如下：
schema Person:
    name: str
    [...str]: [PersonAdditionalProperties]

schema PersonAdditionalProperties:
    name:         str
    description?: str
```

## KCL 文档

KCL doc 规范请参考：[传送门](../kcl/docgen.md)
KCL 文档包含 module 文档、schema 文档两类，其中 schema 文档可以由 OpenAPI 转换得到。KCL schema 文档包含：

- schema 描述信息：位于 schema 声明之后、schema 属性声明之前，是对 schema 的总体介绍
- schema 属性信息：位于 shcema 描述信息之后，以 Attributes + 分割线分隔
- schema 附加信息：位于 schema 属性信息之后，以 See Also + 分割线分隔
- schema 示例信息：位于 schema 附加信息之后，以 Examples + 分割线分隔

它们与 OpenAPI 规范的对应关系如下：

| KCL 文档元素    | OpenAPI 元素                                         |
| --------------- | ---------------------------------------------------- |
| schema 描述信息 | definitions 节点下，每个模型节点的 description 字段  |
| schema 属性信息 | properties 节点下，每个属性节点的 description 字段   |
| schema 附加信息 | definitions 节点下，每个模型节点的 example 字段      |
| schema 示例信息 | definitions 节点下，每个模型节点的 externalDocs 字段 |

示例：
下例中为 Pet 模型定义了其 schema 描述文档 "The schema Pet definition"；Pet 的两个属性 "name" 和 "id" 也分别定义了其属性文档 "The name of the pet" 及 "The id of the pet"；Pet 的附加信息为 "Find more info here. [https://petstore.swagger.io/](https://petstore.swagger.io/)"；此外，Pet 模型还提供了模型实例的示例写法。

```python
# KCL schema Pet，采用规范的 KCL 文档格式
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
        
# 对应的 OpenAPI 文档
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

​

## 基本数据类型

| JSON Schema type | swagger type                | KCL type        | comment                                                                                               |
| ---------------- | --------------------------- | --------------- | ----------------------------------------------------------------------------------------------------- |
| boolean          | boolean                     | bool            |                                                                                                       |
| number           | number                      | float           |                                                                                                       |
|                  | number format double        | **unsupported** |                                                                                                       |
|                  | number format float         | float           |                                                                                                       |
| integer          | integer                     | int (32)        |                                                                                                       |
|                  | integer format int64        | **unsupported** |                                                                                                       |
|                  | integer format int32        | int (32)        |                                                                                                       |
| string           | string                      | str             |                                                                                                       |
|                  | string format byte          | str             |                                                                                                       |
|                  | string format int-or-string | int             | str                                                                                                   |
|                  | string format binay         | str             |                                                                                                       |
|                  | string format date          | unsupported     | As defined by full-date - [RFC3339](http://xml2rfc.ietf.org/public/rfc/html/rfc3339.html#anchor14) |
|                  | string format date-time     | unsupported     | As defined by date-time - [RFC3339](http://xml2rfc.ietf.org/public/rfc/html/rfc3339.html#anchor14) |
|                  | string format password     | unsupported     | for swagger: A hint to UIs to obscure input.                                                         |
|                  | datetime                    | datetime        |                                                                                                       |

## Reference

- openapi spec 2.0：[https://swagger.io/specification/v2/](https://swagger.io/specification/v2/)
- openapi spec 3.0：[https://spec.openapis.org/oas/v3.1.0](https://spec.openapis.org/oas/v3.1.0)
- openapi spec 3.0（swagger 版本）：[https://swagger.io/specification/](https://swagger.io/specification/)
- openapi spec 2.0 #SchemaObject：[https://swagger.io/specification/v2/#schemaObject](https://swagger.io/specification/v2/#schemaObject)
- go swagger：[https://goswagger.io/use/models/schemas.html](https://goswagger.io/use/models/schemas.html)
- swagger data models：[https://swagger.io/docs/specification/data-models/](https://swagger.io/docs/specification/data-models/)
