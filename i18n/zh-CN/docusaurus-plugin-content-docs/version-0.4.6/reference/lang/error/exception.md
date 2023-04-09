---
title: "KCL 错误与警告"
linkTitle: "KCL 错误与警告"
type: "docs"
weight: 2
description: KCL 错误与警告
---
# KCL 错误与警告

文档的此部分中的文章介绍了由 KCL 生成的诊断错误和警告消息。

**注意:**
**KCL 可以报告多种错误和警告。找到错误或警告后，KCL 可能会对代码意向作出假设并尝试继续，以便可以同时报告更多问题。 如果工具做出错误假设，则后续错误或警告可能不适应与当前 KCL 程序。 因此，纠正项目中的问题时，请先纠正第一个错误或警告，然后重新运行获取新的错误信息。 一个修补程序可能会导致后续错误消失。**

此部分文档的主要内容包括：

[KCL 语法错误 (E1xxx)](#11-kcl-%E8%AF%AD%E6%B3%95%E9%94%99%E8%AF%AF-e1xxx) : 如果 KCL 在当前 KCL 程序中发现了非法的 KCL 语法，KCL 就会停止运行并输出 KCL 程序语法错误的提示信息.

[KCL 编译错误 (E2xxx)](#12-kcl-%E7%BC%96%E8%AF%91%E9%94%99%E8%AF%AF-e2xxx) : 如果 KCL 在一个不包含语法错误的 KCL 程序中发现了与 KCL 语义不符的代码，KCL 就会停止运行并输出编译错误的提示信息。

[KCL 运行时错误 (E3xxx)](#13-kcl-%E8%BF%90%E8%A1%8C%E6%97%B6%E9%94%99%E8%AF%AF-e3xxx) : KCL 程序通过编译后会生成 KCL 字节码，如果 KCL 在执行 KCL 字节码过程中出现错误，KCL 就会停止运行并输出运行时错误的提示信息.

[KCL 编译警告 (W2xxx)](#14-kcl-%E7%BC%96%E8%AF%91%E8%AD%A6%E5%91%8A-w2xxx) : 当 KCL 发现可能导致运行失败的 KCL 代码，KCL 不会立即停止运行，但是会输出潜在错误的警告提示。

## 1.1 KCL 语法错误 (E1xxx)

KCL 会出现的语法错误信息如下表所示:

| ewcode | KCL exception                                                       | messages                |
| ------ | ------------------------------------------------------------------- | ----------------------- |
| E1001  | [InvalidSyntaxError](#111-invalidsyntaxerror-e1001)                 | Invalid syntax          |
| E1002  | [KCLTabError](#112-kcltaberror-e1002)                               | Tab Error               |
| E1003  | [KCLIndentationError](#113-kclindentationerror-e1003)               | Indentation Error       |
| E1I37  | [IllegalArgumentSyntaxError](#114-illegalargumentsyntaxerror-e1i37) | Illegal argument syntax |

### 1.1.1 InvalidSyntaxError [E1001]

如果在运行 KCL 时遇到错误:

- `InvalidSyntaxError`, 对应的 encode 为 `E1001`

那么此时 KCL 程序中出现了

- 非法的 KCL 语法。

可能出现错误的 KCL 程序片段如下:

```
a, b = 1, 2 # 通过 “=” 赋值多个变量在KCL中是非法的。
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Syntax Error[E1001] : Invalid syntax
---> File /syntax_error/general/multiple_assign/case0/main.k:1:6
1 |a = 1, 2
      6 ^  -> Expected one of ['newline']
Invalid syntax
```

### 1.1.2 KCLTabError [E1002]

如果在运行 KCL 时遇到错误:

- `KCLTabError`, 对应的 encode 为 `E1002`

那么此时 KCL 程序中出现了

- Tab 与空格混用的问题。KCL 中禁止在代码缩进中混用 Tab 和空格。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    name: str # 通过tab表示缩进
    age: int # 通过四个空格标识缩进, 
             # 在当前运行环境中的四个空格与tab不同
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Syntax Error[E1002] : Tab Error
---> File /syntax_error/tab/tab_error_0/main.k:2:14
2 |    name: str
             14 ^  -> Failure
Inconsistent use of tabs and spaces in indentation
```

可以尝试以下步骤来修复这个错误：

- 在 KCL 程序中全部使用 Tab 或者全部使用四个空格，不要混用。

### 1.1.3 KCLIndentationError [E1003]

如果在运行 KCL 时遇到错误:

- `KCLIndentationError`, 对应的 encode 为 `E1003`

那么此时 KCL 程序中出现了

- 程序缩进错误。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    name: str # 使用一个tab或者四个空格表示缩进
   age: int # KCL不支持使用三个空格表示缩进
  info: str # KCL不支持使用两个空格表示缩进
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Syntax Error[E1003] : Indentation Error
---> File /syntax_error/indent/indent_error_0/main.k:2:14
2 |    name: str
             14 ^  -> Failure
Unindent 3 does not match any outer indentation level
```

可以尝试以下步骤来修复这个错误：

- 在 KCL 程序中全部使用 Tab 或者全部使用四个空格来表示缩进。

### 1.1.4 IllegalArgumentSyntaxError [E1I37]

如果在运行 KCL 时遇到错误:

- `IllegalArgumentSyntaxError`, 对应的 encode 为 `E1I37`

那么此时 KCL 程序中出现了

- 参数语法错误

可能出现错误的 KCL 程序片段如下:

```
# KCL中带有keyword的参数必须出现在不带有keyword参数后面
# 带有keyword的参数: type="list", default={"key": "value"}
# 不带有keyword的参数: "key1"
a = option(type="list", default={"key": "value"}, "key1")
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Syntax Error[E1I37] : Illegal argument syntax
---> File /option/type_convert_fail_2/main.k:1:51
1 |a = option(type="list", default={"key": "value"}, "key1")
                                                  51 ^^^^^^  -> Failure
positional argument follows keyword argument
```

可以尝试以下步骤来修复这个错误：

- KCL 中带有 keyword 的参数必须出现在不带有 keyword 参数后面, 参数正常顺序:

```
func(input_1, ..., input_n, 
    param_with_key_1 = input_with_key_1, ..., param_with_key_n = input_with_key_n)
```

## 1.2 KCL 编译错误 (E2xxx)

KCL 会出现的编译错误信息如下表所示:

| ewcode | KCL exception                                                           | messages                                            |
| ------ | ----------------------------------------------------------------------- | --------------------------------------------------- |
| E2F04  | [CannotFindModule](#121-cannotfindmodule-e2f04)                         | Cannot find the module                              |
| E2F05  | [FailedLoadModule](#122-failedloadmodule-e2f05)                         | Failed to load module                               |
| E2H13  | [UnKnownDecoratorError](#123-unknowndecoratorerror-e2h13)               | UnKnown decorator                                   |
| E2H14  | [InvalidDecoratorTargetError](#124-invaliddecoratortargeterror-e2h14)   | Invalid Decorator Target                            |
| E2C15  | [MixinNamingError](#125-mixinnamingerror-e2c15)                         | Illegal mixin naming                                |
| E2C16  | [MixinStructureIllegal](#126-mixinstructureillegal-e2c16)               | Illegal mixin structure                             |
| E2B17  | [CannotAddMembersComplieError](#127-cannotaddmemberscomplieerror-e2b17) | Cannot add members to a schema                      |
| E2B20  | [IndexSignatureError](#128-indexsignatureerror-e2b20)                   | Invalid index signature                             |
| E2G22  | [TypeComplieError](#129-typecomplieerror-e2g22)                         | The type got is inconsistent with the type expected |
| E2L23  | [CompileError](#1210-compileerror-e2l23)                                | A complie error occurs during compiling             |
| E2L25  | [KCLNameError](#1211-kclnameerror-e2l25)                                | Name Error                                          |
| E2L26  | [KCLValueError](#1212-kclvalueerror-e2l26)                              | Value Error                                         |
| E2L27  | [KCLKeyError](#1213-kclkeyerror-e2l27)                                  | Key Error                                           |
| E2L28  | [UniqueKeyError](#1214-uniquekeyerror-e2l28)                            | Unique key error                                    |
| E2A29  | [KCLAttributeComplieError](#1215-kclattributecomplieerror-e2a29)        | Attribute error occurs during compiling             |
| E2D32  | [MultiInheritError](#1216-multiinheriterror-e2d32)                      | Multiple inheritance is illegal                     |
| E2D34  | [IllegalInheritError](#1217-illegalinheriterror-e2d34)                  | Illegal inheritance                                 |
| E2I36  | [IllegalArgumentComplieError](#1218-illegalargumentcomplieerror-e2i36)  | Illegal argument during compiling                   |
| E3L41  | [ImmutableCompileError](#1219-immutablecompileerror-e3l41)              | Immutable variable is modified                      |

### 1.2.1 CannotFindModule [E2F04]

如果在运行 KCL 时遇到错误:

- `CannotFindModule`, 对应的 encode 为 `E2F04`

那么此时 KCL 程序中出现了

- 无法找到导入模块错误

可能出现错误的 KCL 程序片段如下:

```
import .some0.pkg1 as some00  # some0 not found in package

Name1 = some00.Name  # some0.pkg1.name
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2F04] : Cannot find the module
---> File import_abs_fail_0/app-main/main.k:1:1
1 |import .some0.pkg1 as some00  # some0 not found in app-main package
 1 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^  -> Failure
Cannot find the module .some0.pkg1 from import_abs_fail_0/app-main/some0/pkg1
```

可以尝试以下步骤来修复这个错误：

- 在 imoprt 路径下添加导入模块文件。

### 1.2.2 FailedLoadModule [E2F05]

如果在运行 KCL 时遇到错误:

- `FailedLoadModule`, 对应的 encode 为 `E2F05`

那么此时 KCL 程序中出现了

- 导入模块加载错误

可以尝试以下步骤来修复这个错误：

- 查看文件是否可读
- 查看文件是否为 kcl 文件

### 1.2.3 UnKnownDecoratorError [E2H13]

如果在运行 KCL 时遇到错误:

- `UnKnownDecoratorError`, 对应的 encode 为 `E2H13`

那么此时 KCL 程序中出现了

- 未知的装饰器错误

可能出现错误的 KCL 程序片段如下:

```
@err_deprecated # 这是一个非法的装饰器
schema Person:
    firstName: str = "John"
    lastName: str
    name: str

JohnDoe = Person {
    name: "deprecated"
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2H13] : UnKnown decorator
---> File deprecated/unknown_fail_1/main.k:1:2
1 |@err_deprecated
  2 ^  -> Failure
UnKnown decorator err_deprecated
```

可以尝试以下步骤来修复这个错误：

- 检查装饰器是否存在。

### 1.2.4 InvalidDecoratorTargetError [E2H14]

如果在运行 KCL 时遇到错误:

- `InvalidDecoratorTargetError`, 对应的 encode 为 `E2H14`

那么此时 KCL 程序中出现了

- 无效的装饰器目标错误。

可以尝试以下步骤来修复这个错误：

- 检查使用装饰器的 KCL 代码是否出现异常。

### 1.2.5 MixinNamingError [E2C15]

如果在运行 KCL 时遇到错误:

- `MixinNamingError`, 对应的 encode 为 `E2C15`

那么此时 KCL 程序中出现了

- Mixin 命名错误。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    firstName: str
    lastName: str
    fullName: str

schema Fullname: # Mixin的名称应该以Mixin结尾
    fullName = "{} {}".format(firstName, lastName)

schema Scholar(Person):
    mixin [Fullname]
    school: str

JohnDoe = Scholar {
    "firstName": "John",
    "lastName": "Doe",
    "fullName": "Doe Jon"
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2C15] : Illegal mixin naming
---> File mixin/invalid_name_failure/main.k:10:12
10 |    mixin [Fullname]
            12 ^  -> Failure
a valid mixin name should end with 'Mixin', got 'Fullname'
```

可以尝试以下步骤来修复这个错误：

- 如果 schema 是一个 mixin，那么这个 schema 的名称应该以 Mixin 结尾。

### 1.2.6 MixinStructureIllegal [E2C16]

如果在运行 KCL 时遇到错误:

- `MixinStructureIllegal`, 对应的 encode 为 `E2C16`

那么此时 KCL 程序中出现了

- Mixin 结构错误。

可以尝试以下步骤来修复这个错误：

- 检查作为 Mixin 的 Schema 的结构。

### 1.2.7 CannotAddMembersComplieError [E2B17]

如果在运行 KCL 时遇到错误:

- `CannotAddMembersComplieError`, 对应的 encode 为 `E2B17`

那么此时 KCL 程序中出现了

- 使用 Schema 中不存在的成员。

可能出现错误的 KCL 程序片段如下:

```
schema Girl:
    gender: str = "female"

alice = Girl {
    "first": "alice", # Schema中没有成员“first”
    "last": " Green", # Schema中没有成员“last”
    "age": 10  # Schema中没有成员“age”
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2B18] : Cannot add members to a schema
---> File /invalid/add_attribute/main.k:9:9
9 |alice = Girl {
         9 ^  -> Failure
first,last,age: No such member in the schema
```

可以尝试以下步骤来修复这个错误：

- 为 Schema 添加缺少的成员。
- 不要使用 Schema 中不存在的成员。

### 1.2.8 IndexSignatureError [E2B20]

如果在运行 KCL 时遇到错误:

- `IndexSignatureError`, 对应的 encode 为 `E2B20`

那么此时 KCL 程序中出现了

1. 在一个 schema 中使用多个索引签名。

可能出现错误的 KCL 程序片段如下:

```
schema Data:
    [str]: str
    [str]: int # 在同一个schema中使用了多个索引签名

data = Data {
    name: "test"
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2B20] : Invalid index signature
---> File index_signature/fail_1/main.k:3:5
3 |    [str]: int
     5 ^^^^^^^^^^  -> Failure
only one index signature is allowed in the schema
```

可以尝试以下步骤来修复这个错误：

- - 删除多余的索引签名。

2. schema 中索引签名的名称与 schema 中其他属性的名称存在同名冲突。

可能出现错误的 KCL 程序片段如下:

```
schema Data:
    name: str  # name
    [name: str]: str # 已有名称为name的schema属性

data = Data {
    name: "test"
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2B20] : Invalid index signature
---> File index_signature/fail_2/main.k:3:5
3 |    [name: str]: str
     5 ^  -> Failure
index signature attribute name 'name' cannot have the same name as schema attributes
```

可以尝试以下步骤来修复这个错误：

- - 删除 schema 中出现同名冲突的属性或者索引签名，或者为它们更换不同的名称。

3. schema 索引签名的类型与 schema 实例化的属性类型冲突。

可能出现错误的 KCL 程序片段如下:

```
schema Data:
    [str]: int

data = Data {
    name: "test" # 索引签名为 [str]:int, "test"的类型不是int.
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File index_signature/fail_3/main.k:4:8
4 |data = Data {
        8 ^  -> Failure
expected schema index signature value type int, got str(test) of the key 'name'
```

可以尝试以下步骤来修复这个错误：

- - 检查 schema 索引签名的类型与 schema 实例中的属性类型是否一致。

4. Schema 中的属性与索引签名冲突

可能出现错误的 KCL 程序片段如下:

```
schema Data:
    count: int # int 和 str 冲突
    [str]: str

data = Data {
    count: 1 
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2B20] : Invalid index signature
---> File index_signature/fail_4/main.k:2:5
2 |    count: int
     5 ^  -> Failure
the type 'int' of schema attribute 'count' does not meet the index signature definition [str]: str
```

可以尝试以下步骤来修复这个错误：

- - 调整 Schema 属性或者调整索引签名。

### 1.2.9 TypeComplieError [E2G22]

如果在运行 KCL 时遇到错误:

- `TypeComplieError`, 对应的 encode 为 `E2G22`

那么此时 KCL 程序中出现了

- 静态类型检查错误。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    firstName: str
    lastName: int

JohnDoe = Person {
    "firstName": "John",
    "lastName": "Doe" # Schema中定义lastName: int
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2G22] : The type got is inconsistent with the type expected
---> File type/type_fail_0/main.k:7:5
7 |    "lastName": "Doe"
     5 ^  -> Failure
expect int, got str(Doe)
```

可以尝试以下步骤来修复这个错误：

- 检查赋给某个变量的值的类型与这个变量的类型是否一致。

### 1.2.10 CompileError [E2L23]

如果在运行 KCL 时遇到错误:

- `CompileError`, 对应的 encode 为 `E2L23`

那么此时 KCL 程序中出现了

1. 不支持的类型合并

可能出现错误的 KCL 程序片段如下:

```
_data = [1, 2, 3]
_data |= "value"
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File union/fail/fail_1/main.k:2
2 |_data |= "value" -> Failure
unsupported operand type(s) for |=: '[int]' and 'str(value)'
```

1. 不支持的操作符类型

可能出现错误的 KCL 程序片段如下:

```
a = None
b = 1 + None # KCL中不支持None和int之间进行+操作
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File operator/operator_fail_0/main.k:2
2 |b = 1 + None -> Failure
unsupported operand type(s) for +: 'int(1)' and 'NoneType'
```

可以尝试以下步骤来修复这个错误：

- - 调整操作符号，使其同时支持两个操作数的类型。
- - 调整操作数，使其同时符合操作符号的约束。

1. 没有定义的变量

可能出现错误的 KCL 程序片段如下:

```
a = 1
b = "${c + 1}" # 'c' 没有定义
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File var_not_define_fail_0/main.k:2:8
2 |b = "${c + 1}"
        8 ^  -> Failure
name 'c' is not defined
```

可以尝试以下步骤来修复这个错误：

- - 对未定义的变量进行定义。
- - 在表达式中去掉对未定义变量的操作。

4. 无效的赋值表达式

可能出现错误的 KCL 程序片段如下:

```
# pkg.k
a = 1

# main.k
import pkg
pkg.a |= 2
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File pkg_inplace_modify_1/main.k:3:1
3 |pkg.a |= 2
 1 ^^^^^  -> Failure
module 'pkg' can't be assigned
```

可以尝试以下步骤来修复这个错误：

- - 检查赋值表达式的内容。

1. 无效的字符串表达式

可能出现错误的 KCL 程序片段如下:

```
a = 1
b = "${b = a + 1}" # Invalid string interpolation expression
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File invalid_format_value_fail_0/main.k:2:5
2 |b = "${b = a + 1}"
     5 ^^^^^^^^^^^^^^  -> Failure
invalid string interpolation expression 'b = a + 1'
```

可以尝试以下步骤来修复这个错误：

- - 检查字符串表达式的内容。

1. 无效的循环变量

可能出现错误的 KCL 程序片段如下:

```
data = {"key1": "value1", "key2": "value2"}
dataLoop = [i for i, j, k in data]  # the number of loop variables can only be 1 or 2
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L23] : A complie error occurs during compiling
---> File dict/invalid_loop_var_fail_0/main.k:2:19
2 |dataLoop = [i for i, j, k in data]  # error
                  19 ^^^^^^^  -> Failure
the number of loop variables is 3, which can only be 1 or 2
```

### 1.2.11 KCLNameError [E2L25]

如果在运行 KCL 时遇到错误:

- `KCLNameError`, 对应的 encode 为 `E2L25`

那么此时 KCL 程序中出现了

- 试图访问的变量名不存在

可以尝试以下步骤来修复这个错误：

- 检查报错信息中出现的变量是否存在。

### 1.2.12 KCLValueError [E2L26]

如果在运行 KCL 时遇到错误:

- `KCLValueError`, 对应的 encode 为 `E2L26`

那么此时 KCL 程序中出现了

- 值错误，传给参数的类型不正确

可以尝试以下步骤来修复这个错误：

- 检查参数的具体类型。

### 1.2.13 KCLKeyError [E2L27]

如果在运行 KCL 时遇到错误:

- `KCLKeyError`, 对应的 encode 为 `E2L27`

那么此时 KCL 程序中出现了

- 使用了 dict 中不存在的 key 时引发的 key 错误

可以尝试以下步骤来修复这个错误：

- 检查字典中是否存在 key。

### 1.2.14 UniqueKeyError [E2L28]

如果在运行 KCL 时遇到错误:

- `UniqueKeyError`, 对应的 encode 为 `E2L28`

那么此时 KCL 程序中出现了

- 变量同名或重复定义。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    name: str = "kcl"
    age: int = 1

schema Person:
    aa: int

x0 = Person{}
x1 = Person{age:101}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2L28] : Unique key error
---> File /schema/same_name/main.k:5:1
5 |schema Person:
 1 ^  -> Failure
Variable name 'Person' must be unique in package context
```

可以尝试以下步骤来修复这个错误：

- 检查出现错误的名称是否已经被使用。

### 1.2.15 KCLAttributeComplieError [E2A29]

如果在运行 KCL 时遇到错误:

- `KCLAttributeComplieError`, 对应的 encode 为 `E2A29`

那么此时 KCL 程序中出现了

- Schema 的属性错误。

可能出现错误的 KCL 程序片段如下:

```
# pkg
schema A:
    field_A: str

# main
import pkg as p

a = p.D + 1
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2A29] : Attribute error occurs during compiling
---> File /import/module/no_module_attr_fail_0/main.k:3:5
3 |a = p.D + 1
     5 ^  -> Failure
module 'pkg' has no attribute 'D'
```

可以尝试以下步骤来修复这个错误：

- 在使用 Schema 属性时检查这个属性是否存在。

### 1.2.16 MultiInheritError [E2D32]

如果在运行 KCL 时遇到错误:

- `MultiInheritError`, 对应的 encode 为 `E2D32`

那么此时 KCL 程序中出现了

- 多继承错误。

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    firstName: str
    lastName: str

schema KnowledgeMixin:
    firstName: int
    subject: str

schema Scholar(KnowledgeMixin, Person): # KCL中不支持多继承
    school: str
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2D32] : Multiple inheritance is illegal
---> File /schema/inherit/multi_inherit_fail_1/main.k:9:16
9 |schema Scholar(KnowledgeMixin, Person):
               16 ^^^^^^^^^^^^^^^^^^^^^^  -> Failure
Multiple inheritance of Scholar is prohibited
```

可以尝试以下步骤来修复这个错误：

- 检查程序的继承结构，KCL 中不支持多继承。

### 1.2.17 IllegalInheritError [E2D34]

如果在运行 KCL 时遇到错误:

- `IllegalInheritError`, 对应的 encode 为 `E2D34`

那么此时 KCL 程序中出现了

- 不合法的继承结构

可能出现错误的 KCL 程序片段如下:

```
schema FullnameMixin:
    fullName = "{} {}".format(firstName, lastName)

schema Scholar(FullnameMixin): # KCL中不支持Schema继承Mixin
    school: str
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2D34] : Illegal inheritance
---> File /schema/inherit/inherit_mixin_fail/main.k:8:1
8 |schema Scholar(FullnameMixin):
 1 ^  -> Failure
mixin inheritance FullnameMixin is prohibited
```

可以尝试以下步骤来修复这个错误：

- KCL 中 Schema 支持单继承 Schema。

### 1.2.18 IllegalArgumentComplieError [E2I36]

如果在运行 KCL 时遇到错误:

- `IllegalArgumentComplieError`, 对应的 encode 为 `E2I36`

那么此时 KCL 程序中出现了

- 参数错误

可能出现错误的 KCL 程序片段如下:

```
a = option("key")

# kcl main.k -D key=value= 
# key=value= is an illegal expression
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2I36] : Illegal argument during compiling
'key=value='
```

可以尝试以下步骤来修复这个错误：

- 检查通过命令设置的 KCL option 参数是否为合法参数。

### 1.2.19 ImmutableCompileError [E3L41]

如果在运行 KCL 时遇到错误:

- `ImmutableCompileError`, 对应的 encode 为 `E3L41`

那么此时 KCL 程序中出现了

- 不可变量的值发生改变

可能出现错误的 KCL 程序片段如下:

```
a = 2147483646
a += 1
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Compile Error[E2L41] : Immutable variable is modified
---> File /range_check_int/augment_assign/main.k:2:1
2 |a += 1
 1 ^  -> Failure
Immutable variable is modified
```

可以尝试以下步骤来修复这个错误：

- 将被改变的不可变量设置为私有或者去掉对不可变量值的改动。

## 1.3 KCL 运行时错误 (E3xxx)

KCL 会出现的运行时错误信息如下表所示:

| ewcode | KCL exception                                                           | messages                                            |
| ------ | ----------------------------------------------------------------------- | --------------------------------------------------- |
| E3F06  | [RecursiveLoad](#131-recursiveload-e3f06)                               | Recursively loading module                          |
| E3K04  | [FloatOverflow](#132-floatoverflow-e3k04)                               | Float overflow                                      |
| E3K09  | [IntOverflow](#133-intoverflow-e3k09)                                   | Integer overflow                                    |
| E3N11  | [DeprecatedError](#134-deprecatederror-e3n11)                           | Deprecated error                                    |
| E3A30  | [KCLAttributeRuntimeError](#135-kclattributeruntimeerror-e3a30)         | Attribute error occurs at runtime                   |
| E3G21  | [TypeRuntimeError](#136-typeruntimeerror-e3g21)                         | The type got is inconsistent with the type expected |
| E3B17  | [SchemaCheckFailure](#137-schemacheckfailure-e3b17)                     | Schema check is failed to check condition           |
| E3B19  | [CannotAddMembersRuntimeError](#138-cannotaddmembersruntimeerror-e3b19) | Cannot add members to a schema                      |
| E3M38  | [EvaluationError](#139-evaluationerror-e3m38)                           | Evaluation failure                                  |
| E3M39  | [InvalidFormatSpec](#1310-invalidformatspec-e3m39)                      | Invalid format specification                        |
| E3M40  | [KCLAssertionError](#1311-kclassertionerror-e3m40)                      | Assertion failure                                   |
| E3M44  | [ImmutableRuntimeError](#1312-immutableruntimeerror-e3m44)              | Immutable variable is modified                      |
| E2D33  | [CycleInheritError](#1313-cycleinheriterror-e2d33)                      | Cycle Inheritance is illegal                        |
| E3M42  | [KCLRecursionError](#1314-kclrecursionerror-e3m42)                      | Recursively reference                               |

### 1.3.1 RecursiveLoad [E3F06]

如果在运行 KCL 时遇到错误:

- `RecursiveLoad`, 对应的 encode 为 `E3F06`

那么此时 KCL 程序中出现了

- 循环导入错误

可能出现错误的 KCL 程序片段如下:

```
# module.k 
import main # module.k 导入了 main.k

print('module')

# main.k
import module # main.k 导入了 module.k

print('main')
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3F06] : Recursively loading module
---> File /import/recursive_import_fail/main.k:4
4 | -> Failure
In module module, recursively loading modules: module, main
```

可以尝试以下步骤来修复这个错误：

- 检查包的导入部分是否存在循环导入的问题。

### 1.3.2 FloatOverflow [E3K04]

如果在运行 KCL 时遇到错误:

- `FloatOverflow`, 对应的 encode 为 `E3K04`

那么此时 KCL 程序中出现了

- 浮点数溢出

可能出现错误的 KCL 程序片段如下:

```
uplimit = 3.402823466e+38
epsilon = 2.220446049250313e-16
a = uplimit * (1 + epsilon)

# kcl main.k -r -d
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3K07] : Float overflow
---> File /range_check_float/overflow/number_0/main.k:6
6 |a = uplimit * (1 + epsilon) -> Failure
3.402823466000001e+38: A 32-bit floating point number overflow
```

可以尝试以下步骤来修复这个错误：

- 检查浮点数的值是否在 KCL 支持的数字范围内。

### 1.3.3 IntOverflow [E3K09]

如果在运行 KCL 时遇到错误:

- `IntOverflow`, 对应的 encode 为 `E3K09`

那么此时 KCL 程序中出现了

- 整数溢出

可能出现错误的 KCL 程序片段如下:

```
_a = 9223372036854775807
_a += 1

# kcl test.k -d
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3K09] : Integer overflow
---> File /range_check_int/augment_assign_fail_1/main.k:2
2 |_a += 1 -> Failure
9223372036854775808: A 64 bit integer overflow
```

可以尝试以下步骤来修复这个错误：

- 检查整数的值是否在 KCL 支持的数字范围内。

### 1.3.4 DeprecatedError [E3N11]

如果在运行 KCL 时遇到错误:

- `DeprecatedError`, 对应的 encode 为 `E3N11`

那么此时 KCL 程序中出现了

- 使用废弃代码

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    firstName: str = "John"
    lastName: str
    @deprecated(version="1.16", reason="use firstName and lastName instead", strict=True)
    name: str

JohnDoe = Person {
    name: "deprecated" # name已经被过时，并且strict设置为True
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3N11] : Deprecated error
---> File /schema/deprecated/member_standard_1/main.k:7
7 |JohnDoe = Person { -> Failure
name was deprecated since version 1.16, use firstName and lastName instead
```

可以尝试以下步骤来修复这个错误：

- strict 设置为 True 时无法使用过时的代码，可以将 strict 设置为 False，将不会出现错误，而是输出一个警告。
- 调整代码，不使用已经过时的代码。

### 1.3.5 KCLAttributeRuntimeError [E3A30]

如果在运行 KCL 时遇到错误:

- `KCLAttributeRuntimeError`, 对应的 encode 为 `E3A30`

那么此时 KCL 程序中出现了

- 属性错误。

可能出现错误的 KCL 程序片段如下:

```
import math

a = math.err_func(1) # err_func is not found in math
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3A30] : Attribute error occurs at runtime
---> File /import/module/no_module_attr_fail_2/main.k:3
3 |a = math.err_func(1) -> Failure
module 'math' has no attribute 'err_func'
```

可以尝试以下步骤来修复这个错误：

- 检查属性调用是否正确。

### 1.3.6 TypeRuntimeError [E3G21]

如果在运行 KCL 时遇到错误:

- `TypeRuntimeError`, 对应的 encode 为 `E3G21`

那么此时 KCL 程序中出现了

- 类型检查错误

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    name: str = "Alice"

_personA = Person {}
_personA |= {"name": 123.0} # name: str = "Alice"
personA = _personA
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3G21] : The type got is inconsistent with the type expected
---> File /fail/fail_4/main.k:5
5 |_personA |= {"name": 123.0} -> Failure
expect str, got float
```

可以尝试以下步骤来修复这个错误：

- 停止错误的类型合并或者将类型调整为 KCL 支持的类型合并。

### 1.3.7 SchemaCheckFailure [E3B17]

如果在运行 KCL 时遇到错误:

- `SchemaCheckFailure`, 对应的 encode 为 `E3B17`

那么此时 KCL 程序中出现了

- Schema 中的 check 条件冲突

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    lastName: str
    age: int
    check:
        age < 140, "age is too large"

JohnDoe = Person {
    "lastName": "Doe",
    "age": 1000 # Schema中的check条件为: age < 140
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3B17] : Schema check is failed to check condition
---> File /check_block/check_block_fail_1/main.k:9:11
9 |JohnDoe = Person {
          11 ^  -> Check failed in the schema
---> File /check_block/check_block_fail_1/main.k:7
7 |        age < 140, "age is too large" -> Check failed on the condition
age is too large
```

可以尝试以下步骤来修复这个错误：

- 检查 Schema 的属性与 check 中的条件是否符合

### 1.3.8 CannotAddMembersRuntimeError [E3B19]

如果在运行 KCL 时遇到错误:

- `CannotAddMembersRuntimeError`, 对应的 encode 为 `E3B19`

那么此时 KCL 程序中出现了

- 访问 Schema 中不存在的成员

可能出现错误的 KCL 程序片段如下:

```
schema Name:
    name: str

schema Person:
    name: Name
    
person = Person {
    name.err_name: "Alice" # err_name is not found in schema Name
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3B19] : Cannot add members to a schema
---> File /nest_var/nest_var_fail_1/main.k:8:5
8 |    name.err_name: "Alice"
     5 ^  -> Failure
err_name: No such member in the schema
```

可以尝试以下步骤来修复这个错误：

- 为 Schema 添加不存在的成员。
- 访问 Schema 中存在的成员。

### 1.3.9 EvaluationError [E3M38]

如果在运行 KCL 时遇到错误:

- `EvaluationError`, 对应的 encode 为 `E3M38`

那么此时 KCL 程序中出现了

- 当 KCL 中数值计算过程出现了错误。

可能出现错误的 KCL 程序片段如下:

```
_list1 = [1, 2, 3] # _list1 is a variable, and its type can only be known at runtime
_list2 = None # _list1 is a variable, and its type can only be known at runtime

result2 = _list1 + _list2 # list + NoneType is illegal
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3M38] : Evaluation failure
---> File /datatype/list/add_None_fail/main.k:4
4 |result2 = _list1 + _list2 -> Failure
can only concatenate list (not "NoneType") to list
```

可以尝试以下步骤来修复这个错误：

- 检查表达式中是否存在变量为 None，或者非法的计算过程。

### 1.3.10 InvalidFormatSpec [E3M39]

如果在运行 KCL 时遇到错误:

- `InvalidFormatSpec`, 对应的 encode 为 `E3M39`

那么此时 KCL 程序中出现了

- 非法的字符串格式

可能出现错误的 KCL 程序片段如下:

```
a = 1
b = 1
data = "${a: #js}" + " $$ " #  KCL插值字符串中，#js是非法的
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3M39] : Invalid format specification
---> File /datatype/str_interpolation/invalid_format_spec_fail_0/main.k:3
3 |data = "${a: #js}" + " $$ " -> Failure
#js is invalid format spec
```

可以尝试以下步骤来修复这个错误：

- 将非法 String 调整为 KCL 标准支持的 String。

### 1.3.11 KCLAssertionError [E3M40]

如果在运行 KCL 时遇到错误:

- `KCLAssertionError`, 对应的 encode 为 `E3M40`

那么此时 KCL 程序中出现了

- Assert False

可能出现错误的 KCL 程序片段如下:

```
assert False
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3M40] : Assertion failure
---> File /assert/invalid/fail_0/main.k:1
1 |assert False -> Failure
Assertion failure
```

可以尝试以下步骤来修复这个错误：

- 检查 Assert 的条件，Assert 条件为 False 时，就会出现此类错误，去掉 Assert 语句或改变条件为 True。

### 1.3.12 ImmutableRuntimeError [E3M44]

如果在运行 KCL 时遇到错误:

- `ImmutableRuntimeError`, 对应的 encode 为 `E3M44`

那么此时 KCL 程序中出现了

- 不可变量的值发生改变

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    final firstName : str
    lastName : str


schema Scholar(Person):
    firstName = "CBA"


scholar = Scholar {
    "firstName": "ABC" # firstName in schema Person is final.
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3M41] : Immutable variable is modified
---> File /final/fail_lazy_init_0/main.k:12:5
12 |    "firstName": "ABC"
      5 ^  -> Failure
final schema field 'firstName'
```

可以尝试以下步骤来修复这个错误：

- 检查 final 修饰的不可变量是否出现了赋值等改变值的操作。

### 1.3.13 CycleInheritError [E2D33]

如果在运行 KCL 时遇到错误:

- `CycleInheritError`, 对应的 encode 为 `E2D33`

那么此时 KCL 程序中出现了

- 循环继承

可能出现错误的 KCL 程序片段如下:

```
schema Parent(Son):
    parent_field: str

schema Son(GrandSon):
    son_field: str

schema GrandSon(Parent):
    grandson_field: str

parent = Parent {
    parent_field: ""
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Error[E2D33] : Cycle Inheritance is illegal
---> File /inherit/cycle_inherit_fail_1/main.k:7:1
7 |schema GrandSon(Parent):
 1 ^  -> Failure
GrandSon and Parent
```

可以尝试以下步骤来修复这个错误：

- 检查 Schema 的继承关系，避免出现 A 继承 B，B 继承 A 的情况。

### 1.3.14 KCLRecursionError [E3M42]

如果在运行 KCL 时遇到错误:

- `KCLRecursionError`, 对应的 encode 为 `E3M42`

那么此时 KCL 程序中出现了

- 循环引用

可能出现错误的 KCL 程序片段如下:

```
schema Parent(Son):
    parent_field: str
    son: Son = Son {  # Parent has attribute Son
        parent: Parent {
            parent_field: "123"
        }
    }

schema Son:
    son_field: str
    parent: Parent = Parent { # Son has attribute Parent
        son: Son {
            son_field: "123"
        }
    }

parent = Parent {
    parent_field: "",
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Runtime Error[E3M42] : Recursively reference
---> File /init/init_cycle_fail_0/main.k:10
10 |    son_field: str -> Failure
maximum recursion depth exceeded in __instancecheck__
```

可以尝试以下步骤来修复这个错误：

- 检查 Schema 中的属性成员，避免出现循环引用的问题。

## 1.4 KCL 编译警告 (W2xxx)

KCL 中的编译警告如下表所示：

| ewcode | KCL exception                                     | messages           |
| ------ | ------------------------------------------------- | ------------------ |
| W2K04  | [FloatUnderflow](#141-floatunderflow-w2k08)       | Float underflow    |
| W2P10  | [InvalidDocstring](#142-invaliddocstring-w2p10)   | Invalid docstring  |
| W2N12  | [DeprecatedWarning](#143-deprecatedwarning-w2n12) | Deprecated warning |

### 1.4.1 FloatUnderflow [W2K08]

如果在运行 KCL 时遇到错误:

- `FloatUnderflow`, 对应的 encode 为 `W2K08`

那么此时 KCL 程序中出现了

- 看看 python 里面是怎么说的

可能出现错误的 KCL 程序片段如下:

```
downlimit = 1.175494351e-38
uplimit = 3.402823466e+38

epsilon = 2.220446049250313e-16

a = uplimit / (1 + epsilon)
b = downlimit / (1 + epsilon)

# kcl main.k -r -d
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Complier Warning[W2K08] : Float underflow
---> File /range_check_float/underflow/number_0/main.k:7
7 |b = downlimit / (1 + epsilon) -> Failure
1.1754943509999997e-38: A 32-bit floating point number underflow
```

可以尝试以下步骤来修复这个错误：

- 检查浮点数的值是否在 KCL 支持的数字范围内。

### 1.4.2 InvalidDocstring [W2P10]

如果在运行 KCL 时遇到错误:

- `InvalidDocstring`, 对应的 encode 为 `W2P10`

那么此时 KCL 程序中出现了

- 无效的 doc 内容

可以尝试以下步骤来修复这个错误：

- 请按照 KCL 标准编写 doc。

### 1.4.3 DeprecatedWarning [W2N12]

如果在运行 KCL 时遇到错误:

- `DeprecatedWarning`, 对应的 encode 为 `W2N12`

那么此时 KCL 程序中出现了

- 过时的代码警告

可能出现错误的 KCL 程序片段如下:

```
schema Person:
    firstName?: str = "John"
    lastName?: str
    @deprecated(version="1.16", reason="use firstName and lastName instead", strict=False)
    name?: str

JohnDoe = Person {
    name: "deprecated" # name is deprecated and strict is False
}
```

KCL 在运行上述 KCL 程序片段时的输出信息如下.

```
KCL Compile Warning[W2N12] : Deprecated warning
name was deprecated since version 1.16, use firstName and lastName instead
```

可以尝试以下步骤来修复这个错误：

- 尽量不要使用已经过时的代码。如果将 strict 设置为 True，KCL 将会输出错误，并停止运行。
