---
title: "KCL 之旅"
sidebar_position: 1
---

本文展示了如何使用 KCL 的核心特性，包含变量、运算符、schema 和库，前提是您有使用其他语言编程的经验。KCL 主要受 Python 启发，了解 Python 对学习 KCL 非常有帮助。

### 重要概念

在学习 KCL 语言时，请牢记以下事实和概念：

- KCL 是一种配置策略语言。它为编写配置和策略提供了简单且自洽的语言设计和库支持。它不能用于应用程序开发或其他通用编程语言（GPL）支持的场景。
- KCL 吸收了经典 **OOP** 的元素，并且提供了**类型**、**复用**和**合并**等简单、开发人员友好、可靠且利于传播的配置编写实践。
- KCL 更倾向于**不可变性**，建议使用**合并**来添加增量的变更。不可变性降低了副作用，例如不可预测的问题。
- KCL 的 **schema** 结构体定义了严格的属性和静态类型，并且支持表达式验证。**schema** 结构体主要由带类型的属性、schema 上下文和检查块构成。
- KCL 的 **config** 是一个类 **JSON** 表达式，通过它我们可以复用 schema 的完整定义。KCL 通过分离 schema 和 config 来提供定义和配置的能力。
- KCL 的 **rule** 是一个书写规则约束表达式的结构，可用于数据校验和策略编写。
- KCL 的代码文件以包（目录）和模块（文件）的形式进行管理。同一包中的 schema 彼此可见；跨包的数据需要通过 **import 语句**导入。包级变量虽然可以导出，但是它们不能被其他包修改。
- KCL 语法定义主要使用声明式表达式，并且只提供少量必要的声明式语句，例如 import、 if...else、assert、assignment 以及 schema。
- 没有主函数，每个 `.k` 文件可以作为单独的配置文件执行。
- 支持**内置函数**和**插件**以简化编写。

### 关键字

下表列出了 KCL 语言的关键字。

```txt
True       False      None        Undefined   import
and        or         in          is          not
as         if         else        elif        for
schema     mixin      protocol    check       assert
all        any        map         filter      lambda
rule
```

### 标识符

在 KCL 中, 标识符是标识一个值的名称，可以带有选择器。

- 标识符由字母、数字、下划线或前缀 `$` 组成。
- 标识符不能与关键字重复，除非它们有 `$` 前缀。
- 标识符不得包含任何嵌入的空格或符号。
- 可以在标识符中的任何位置使用字母和下划线。
- 数字不能放在标识符的第一位。
- `$` 字符只能放在标识符的第一个位置。

示例：

```python
x
a
b1
b_2
_c
$if
```

为了简化限定标识符（例如 `pkg.type`）的定义，我们还定义了 `qualified identifier`：

示例：

```python
pkg.a
```

在 `qualified identifier` 中的包名必须通过 `import` 关键字导入。

#### 标识符前缀

使用 `$` 前缀符号定义关键字标识符。

```python
$if = 1
$else = "s"
```

请注意，非关键字标识符是否有 `$` 符号都是同样的效果。

```python
_a = 1
$_a = 2  # equal to `_a = 2`
```

### 变量

以下是如何创建并实例化变量的例子：

```python
name = "Foo"  # Declare a variable named `name` and its value is a string literal "Foo"
```

它对应了如下 YAML 输出：

```yaml
name: Foo
```

在 KCL 中，我们可以通过定义包级变量将变量导出为配置数据。使其直接、清晰、可维护。导出的变量是不可变的。因此一旦声明它，就无法对其进行修改，例如，假设我们有一个名为 `example.k` 的配置文件，变量 `name` 在声明后就禁止修改，就像标准的命令式语言一样。

```python
name = "Foo"  # exported

...

name = "Bar"  # error: a exported declaration variable can only be set once.
```

作为补充，我们可以在模块级别定义一个非导出变量，这个变量是可变的，不会显示在 YAML 输出当中。

```python
_name = "Foo"  # _ variables are not output to YAML and are mutable
_name = "Bar"
```

请注意，变量的名称不能为 `True`、`False`、`None` 或者 `Undefined`，因为它们与 KCL 内置的名称常量之间存在二义性。

```python
False = 1  # Error
True = False  # Error
None = Undefined  # Error
Undefined = None  # Error
```

### 内置类型

KCL 支持以下类型：

- 数字
- 字符串
- 布尔
- 列表
- 字典

#### 数字

KCL 的数字类型有两种形式：

- 64 位有符号整数。值的范围为 -9223372036854775808~9223372036854775807.
- 64 位浮点数，遵循 IEEE 754 标准。我们不建议在配置中使用 float 类型，我们可以使用字符串代替并在运行时进行解析。

整数和浮点数都支持基本运算符，例如 `+`，`-`，`/` 和 `*`，而复杂的运算，例如 `abs()`, `ceil()` 和 `floor()`，都是通过内置的数学库来支持。

整数是不带小数点的数字。以下是一些定义整数的例子：

```python
a = 1
b = -1
c = 0x10 # hexadecimal literal
d = 0o10 # octal literal
e = 010  # octal literal
f = 0b10 # binary literal
g = int("10") # int constructor
```

如果一个数字包含小数点，则它是浮点数。以下是一些浮点数的示例：

```python
a = 1.10
b = 1.0
c = -35.59
d = 32.3e+18
f = -90.
h = 70.2E-12
i = float("112") # float constructor
```

内置数学库可用于数字类型：

```python
import math

assert abs(-40) == 40
assert round(70.23456) == 70
assert min(80, 100, 1000) == 80
assert max(80, 100, 1000) == 1000
assert sum([0,1,2]) == 3
assert math.ceil(100.12) == 101.0
assert math.floor(100.12) == 100.0
assert math.pow(100, 2) == 10000.0
```

KCL 默认使用 64 位数字类型。我们可以在 KCL 命令行使用 `-r` 参数执行严格的 32 位范围检查。

```bash
kcl main.k -r -d
```

请注意，为了性能考虑该功能只能在 `debug` 模式中使用。

##### 单位字面值

在 KCL 中，我们可以给一个整数添加如下的单位后缀，这不影响它的真实值。

- 通用整形和定点数: `P`, `T`, `G`, `M`, `K`, `k`, `m`, `u`, `n`
- 2 的幂: `Pi`, `Ti`, `Gi`, `Mi`, `Ki`

```python
# SI
n = 1n  # 1e-09
u = 1u  # 1e-06
m = 1m  # 1e-03
k = 1k  # 1000
K = 1K  # 1000
M = 1M  # 1000000
G = 1G  # 1000000000
T = 1T  # 100000000000
P = 1P  # 1000000000000000
# IEC
Ki = 1Ki  # 1024
Mi = 1Mi  # 1024 ** 2
Gi = 1Gi  # 1024 ** 3
Ti = 1Ti  # 1024 ** 4
Pi = 1Pi  # 1024 ** 5
```

此外，我们还可以使用定义在 `units` 模块中的单位常量：

```python
import units

n = 1 * units.n  # 1e-09
u = 1 * units.u  # 1e-06
m = 1 * units.m  # 1e-03
k = 1 * units.k  # 1000
K = 1 * units.K  # 1000
M = 1 * units.M  # 1000000
G = 1 * units.G  # 1000000000
T = 1 * units.T  # 1000000000000
P = 1 * units.P  # 1000000000000000
# IEC
Ki = 1 * units.Ki  # 1024
Mi = 1 * units.Mi  # 1024 ** 2
Gi = 1 * units.Gi  # 1024 ** 3
Ti = 1 * units.Ti  # 1024 ** 4
Pi = 1 * units.Pi  # 1024 ** 5
```

我们还可以使用定义在 `units` 模块内的整数和单位字符串之间的转换函数

```python
import units
# SI
K = units.to_K(1000)   # "1K"
M = units.to_M(1000000)   # "1M"
G = units.to_G(1000000000)   # "1G"
T = units.to_T(1000000000000)   # "1T"
P = units.to_P(1000000000000000)  # "1P"
# IEC
Ki = units.to_Ki(1024)  # "1Ki"
Mi = units.to_Mi(1024 ** 2)  # "1Mi"
Gi = units.to_Gi(1024 ** 3)  # "1Gi"
Ti = units.to_Ti(1024 ** 4)  # "1Ti"
Pi = units.to_Pi(1024 ** 5)  # "1Pi"
```

```python
import units
# SI
K = units.to_K(int("1M"))   # "1000K"
M = units.to_M(int("1G"))   # "1000M"
G = units.to_G(int("1T"))   # "1000G"
T = units.to_T(int("1P"))   # "1000T"
P = units.to_P(int("10P"))  # "10P"
# IEC
Ki = units.to_Ki(int("1Mi"))   # "1024Ki"
Mi = units.to_Mi(int("1Gi"))   # "1024Mi"
Gi = units.to_Gi(int("1Ti"))   # "1024Gi"
Ti = units.to_Ti(int("1Pi"))   # "1024Ti"
Pi = units.to_Pi(int("10Pi"))  # "10Pi"
```

单位类型定义在 `units` 模块中，单位类型的值不能进行任何四则运算。

```python
import units

type NumberMultiplier = units.NumberMultiplier

x0: NumberMultiplier = 1M  # Ok
x1: NumberMultiplier = x0  # Ok
x2 = x0 + x1  # Error: unsupported operand type(s) for +: 'number_multiplier(1M)' and 'number_multiplier(1M)'
```

我们可以使用 `int()`、`float()` 和 `str()` 函数将数值单位类型转换为数字类型或字符串类型。

```python
a: int = int(1Ki)  # 1024
b: float = float(1Ki)  # 1024.0
c: str = str(1Mi)  # "1Mi"
```

#### 字符串

字符串是一个不可变的 Unicode 字符序列。我们可以使用单引号或双引号创建字符串：

```python
'allows embedded "double" quotes'  # Single quotes
"allows embedded 'single' quotes"  # Double quotes
'''Three single quotes''', """Three double quotes"""  # Triple quoted
```

三引号用于定义多行字符串。

```python
"""This is a long triple quoted string
may span multiple lines.
"""
```

请注意，KCL 的单引号和双引号字符串的使用几乎没有区别。唯一可以简化的是，我们不需要在单引号字符串中转义双引号，也不需要在双引号中转义单引号。

```python
'This is my book named "foo"'  # don't need to escape double quotes in single quoted strings.
"This is my book named 'foo'"  # don't need to escape single quotes in double quoted strings.
```

我们可以使用 `+` 操作符连接字符串：

```python
x = 'The + operator ' + 'works, as well.'
```

我们可以使用 `str` 内置函数将 int 或 float 转为字符串：

```python
x = str(3.5) # "3.5"
```

可以使用很多内置的字符串函数：

```python
x = "length"
assert len(x) == 6 # True
assert x.capitalize() == "Length"
assert x.count("gt") == 1
assert x.endswith("th") == True
assert x.find("gth") == 3
assert "{} {}".format("hello", "world") == 'hello world'
assert x.index("gth") == 3
assert x.isalnum() == True
assert x.isalpha() == True
assert "123456".isdigit() == True
assert x.islower() == True
assert "       ".isspace() == True
assert "This Is Title Example".istitle() == True
assert x.isupper() == False
assert "|".join(["a", "b", "c"]) == "a|b|c"
assert "LENGTH".lower() == "length"
assert '   spacious   '.lstrip() == 'spacious   '
assert x.replace("th", "ht") == "lenght"
assert "lengthlength".rfind("le") == 6
assert "lengthlength".rindex("le") == 6
assert "length length".rsplit() == ["length", "length"]
assert "length   ".rstrip() == "length"
assert "length length".split() == ["length", "length"]
assert 'ab c\n\nde fg\rkl\r\n'.splitlines() == ['ab c', '', 'de fg', 'kl']
assert "length".startswith('len') == True
assert "***length***".strip('*') == "length"
assert "length length".title() == "Length Length"
assert x.upper() == "LENGTH"
```

格式化字符串有两种使用方法： 使用 `"{}".format()` 内置函数, 或者使用花括号指定变量并使用 `$` 标记取变量值。在 KCL 中叫做**插值字符串**。在下面的例子中，`a` 和 `b` 的值都是 `"hello world"`。

此外，要序列化的变量可以以特殊的数据格式提取，例如 YAML 或 JSON。在这种情况中，`#yaml` 或 `#json` 可以包含在花括号中。

注意，如果不想 `${...}` 表示字符串插值 ，我们可以在 `$` 之前添加`\` 字符表示直接以字符串的形式输出 `${...}`。

```python
world = "world"
a = "hello {}".format(world)        # "hello world"
b = "hello ${world}"                # "hello world"
c1 = "$hello ${world}$"             # "$hello world$"
c2 = "$" + "hello ${world}" + "$"   # "$hello world$"
c3 = "$" + "hello \${world}" + "$"  # "$hello ${world}$"

myDict = {
    "key1" = "value1"
    "key2" = "value2"
}
myList = [1, 2, 3]

d = "here is myDict in json: ${myDict: #json}"
# d: 'here is myDict in json: {"key1": "value1", "key2": "value2"}'

e = "here is myDict in yaml:\n${myDict: #yaml}"
# e: |
#  here is myDict in yaml:
#  key1: value1
#  key2: value2

f = "here is myList in json: ${myList: #json}"
# f: 'here is myList in json: [1, 2, 3]'
g = "here is myList in yaml: ${myList: #yaml}"
# g: |
#  here is myList in yaml: - 1
#  - 2
#  - 3
```

此外，我们可以在上面的示例代码输出 **YAML 字符串** 中看到一些符号，例如 `|`、`>`、`+`、`-`。

- `|` 表示 **块文字样式**，指示块内换行符的行为方式。
- `>` 表示块标量中的**块折叠样式**，换行符将被空格替换。
- `+` 和 `-` 是 **block chomping 指示符**，用于控制字符串末尾的换行符。 默认值 **clip** 在字符串的末尾放置一个换行符。 要删除所有换行符，请通过在样式指示符 `|` 或 `>` 后面添加 `-` 来**删除**它们。 clip 和 strip 都忽略块末尾实际有多少换行符； 在样式指示符后面添加一个 `+` 来**保留**它们。

例如，**strip 块文字样式** yaml 字符串是

```yaml
example: |-
  Several lines of text,
  with some "quotes" of various 'types',
  and also a blank line:

  plus another line at the end.
```

结果为：

```plain
Several lines of text,
with some "quotes" of various 'types',
and also a blank line:

plus another line at the end.
```

更多信息可见 [Yaml Multiline String](https://yaml-multiline.info/) 和 [YAML Specification v1.2](https://yaml.org/spec/1.2.1/) 。

##### 原始字符串

KCL 原始字符串是通过在字符串字面值前加上 `'r'` 或 `'R'` 来创建的。 KCL 原始字符串将反斜杠 (`\`) 和字符串插值 (`${}`) 视为普通的非字符。当我们想要一个包含反斜杠、字符串插值的字符串并且不希望它们被视为转义字符时，原始字符串是很有用的。

- 对于包含反斜杠（`\`）的原始字符串，KCL 代码和输出 YAML 如下：

```python
s = "Hi\nHello"
raw_s = r"Hi\nHello"  # This is a KCL raw string with the `r` prefix.
```

```yaml
s: |-
  Hi
  Hello
raw_s: Hi\nHello
```

- 对于包含字符串插值（`${}`）的原始字符串，KCL 代码和输出 YAML 如下：

```python
worldString = "world"
s = "Hello ${worldString}"
raw_s = r"Hello ${worldString}"  # This is a KCL raw string with the `r` prefix.
```

```yaml
worldString: world
s: Hello world
raw_s: Hello ${worldString}
```

此外，原始字符串最常用的场景是在正则表达式中使用:

```python
import regex

key = "key"
result = regex.match(key, r"[A-Za-z0-9_.-]*")  # True
```

#### 布尔值

布尔值有两个常量对象：`False` 和 `True`.

```python
a = True
b = False
```

#### List

List 是一个序列，通常用于存储同质项的集合。下面是一个简单的 KCL 列表的例子：

```python
list = [1, 2, 3]
assert len(list) == 3  # True
assert list[0] == 1  # True
```

我们可以使用列表推导式构建列表：

```python
list = [ _x for _x in range(20) if _x % 2 == 0]
assert list == [0, 2, 4, 6, 8, 10, 12, 14, 16, 18] # True
```

并且还可以使用嵌套的列表推导式：

```python
matrix = [[1, 2], [3,4], [5,6], [7,8]]
transpose = [[row[_i] for row in matrix] for _i in range(2)]
assert transpose == [[1, 3, 5, 7], [2, 4, 6, 8]] # True
```

此外，我们可以在列表推导式中使用两个变量。第一个变量表示列表中的索引，第二个变量表示列表中的项。

```python
data = [1000, 2000, 3000]
# Single variable loop
dataLoop1 = [i * 2 for i in data]  # [2000, 4000, 6000]
dataLoop2 = [i for i in data if i == 2000]  # [2000]
dataLoop3 = [i if i > 2 else i + 1 for i in data]  # [1000, 2000, 3000]
# Double variable loop
dataLoop4 = [i + v for i, v in data]  # [1000, 2001, 3002]
dataLoop5 = [v for i, v in data if v == 2000]  # [2000]
# Use `_` to ignore loop variables
dataLoop6 = [v if v > 2000 else v + i for i, v in data]  # [1000, 2001, 3000]
dataLoop7 = [i for i, _ in data]  # [0, 1, 2]
dataLoop8 = [v for _, v in data if v == 2000]  # [2000]
```

我们可以通过 `+` 连接列表：

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
joined_list = _list0 + _list1  # [1, 2, 3, 4, 5, 6]
```

我们可以使用解包操作符 `*` 合并多个列表：

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
union_list = [*_list0, *_list1]  # [1, 2, 3, 4, 5, 6]
```

我们可以使用 `if` 表达式动态的将元素添加到列表，符合条件的元素会被添加到列表，不符合条件的元素会被忽略。

```python
a = 1  # 1
data = [
    1
    if a == 1: 2
    if a > 0: 3
    if a < 0: 4
]  # [1, 2, 3]
```

```python
a = 1  # 1
data1 = [
    1
    if a == 1:
        2
    elif a == 2:
        3
    else:
        3
]  # [1, 2]
data2 = [
    1
    if a == 1: 2
    elif a == 2: 2
    else: 3
]  # [1, 2]
```

我们可以合并(union)列表:

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
union_list = _list0 | _list1  # [4, 5, 6]
```

我们可以使用 `for k in list_var` 表达式遍历列表：

```python
data = [1, 2, 3]
dataAnother = [val * 2 for val in data]  # [2, 4, 6]
```

#### Dict

Dict 是将可哈希的值映射到任意对象的映射对象。字典是有序的。键的顺序遵循其声明的顺序：

这里有几个简单的 KCL 字典：

```python
a = {"one" = 1, "two" = 2, "three" = 3}
b = {'one' = 1, 'two' = 2, 'three' = 3}
assert a == b # True
assert len(a) == 3 # True
```

在写多行的键-值时，可以省略每个键-值对行尾的逗号 `,`:

```python
data = {
    "key1" = "value1"  # Ignore the comma ',' at the end of line
    "key2" = "value2"
}  # {"key1": "value1", "key2": "value2"}
```

在 Dict 键上使用简单的字面值时可以省略引号：

```python
data = {
    key1 = "value1"  # Ignore key quotation '"'
    key2 = "value2"
}  # {"key1": "value1", "key2": "value2"}
```

请注意，当属性中存在 `-` 和 `.` 等其他连字符时，我们必须使用引号。

```python
data = {
    "config.dot.attr" = "value1"  # Note we use `"config.dot.attr"` instead of `config.dot.attr` here.
    "config-hyphen-attr" = "value2"  # Note we use `"config-hyphen-attr"` instead of `config-hyphen-attr` here.
}
```

此外，**选择表达式**可以用于定义包含嵌套键 dict 实例。

```python
person = {
    base.count = 2
    base.value = "value"
    labels.key = "value"
}  # {"base": {"count": 2, "value": "value"}, "labels": {"key": "value"}}
```

输出 YAML 为：

```yaml
person:
  base:
    count: 2
    value: value
  labels:
    key: value
```

在 KCL 中，dict 中的不同的字段可以直接引用，比如如下的例子

```python
config = {
    name = "me"
    metadata.name = name  # Reference `name` with the value `"me"` in `config` directly.
}
```

输出 YAML 为：

```yaml
config:
  name: me
  metadata:
    name: me
```

我们可以使用字典推导式构建字典：

```python
x = {str(i): 2 * i for i in range(3)}
assert x == {"0" = 0, "1" = 2, "2" = 4}
```

此外，我们可以在字典推导式中使用两个变量。第一个变量表示字典的键，第二个变量表示字典中键对应的值。

```python
data = {key1 = "value1", key2 = "value2"}
# Single variable loop
dataKeys1 = {k: k for k in data}  # {"key1": "key1", "key2": "key2"}
dataValues1 = {k: data[k] for k in data}  # {"key1": "value1", "key2": "value2"}
# Double variable loop
dataKeys2 = {k: k for k, v in data}  # {"key1": "key1", "key2": "key2"}
dataValues2 = {v: v for k, v in data}  # {"value1": "value1", "value2": "value2"}
dataFilter = {k: v for k, v in data if k == "key1" and v == "value1"}  # {"key1": "value1"}
# Use `_` to ignore loop variables
dataKeys3 = {k: k for k, _ in data}  # {"key1": "key1", "key2": "key2"}
dataValues3 = {v: v for _, v in data}  # {"value1": "value1", "value2": "value2"}
```

我们可以使用解包操作符 `**` 来合并字典：

```python
_part1 = {
    a = "b"
}

_part2 = {
    c = "d"
}

a_dict = {**_part1, **_part2}  # {"a: "b", "c": "d"}
```

此外，union 操作符 `|` 也能达到同样的效果:

```python
_part1 = {
    a = "b"
}

_part2 = {
    c = "d"
}

a_dict = _part1 | _part2  # {"a: "b", "c": "d"}
```

我们可以使用 `if` 表达式动态的将元素添加到字典，符合条件的元素会被添加到字典，不符合条件的元素会被忽略。

```python
a = 1  # 1
data = {
    key1 = "value1"
    if a == 1: key2 = "value2"
    if a > 0: key3 = "value3"
    if a < 0: key4 = "value4"
}  # {"key1": "value1", "key2": "value2", "key3": "value3"}
```

```python
a = 1  # 1
data1 = {
    key1 = "value1"
    if a == 1:
        key2 = "value2"
    elif a > 0:
        key3 = "value3"
    else:
        key4 = "value4"
}  # {"key1": "value1", "key2": "value2"}
data2 = {
    key1 = "value1"
    if a == 1: key2 = "value2"
    elif a > 0: key3 = "value3"
    else: key4 = "value4"
}  # {"key1": "value1", "key2": "value2"}
```

我们可以使用 `for k in dict_var` 表达式来遍历字典, 并且可以使用 `in` 操作符来判断 dict 是否包含某个键。

```python
data = {key1 = "value1", key2 = "value2"}
dataAnother = {k: data[k] + "suffix" for k in data}  # {"key1": "value1suffix", "key2": "value2suffix"}
containsKey1 = "key1" in data  # True
containsKey2 = "key" in data  # False
```

#### None

在 KCL 中, `None` 表示对象的值为空， 这与 Go 中的 `nil` 和 Java 中的 `null` 一样，并且对应于 YAML 中的 `null`。

```python
a = None
b = [1, 2, None]
c = {key1 = "value1", key2 = None}
```

输出如下：

```yaml
a: null
b:
  - 1
  - 2
  - null
c:
  key1: value1
  key2: null
```

请注意，`None` 不能参与四则运算，但它可以参与逻辑运算和比较运算。

```python
a = 1 + None  # error
b = int(None)  # error
c = not None  # True
d = None == None  # True
e = None or 1  # 1
f = str(None)  # None
```

#### Undefined

`Undefined` 与 `None` 类似，但其语义是变量没有分配任何值，也不会输出到 YAML。

```python
a = Undefined
b = [1, 2, Undefined]
c = {key1 = "value1", key2 = Undefined}
```

输出如下：

```yaml
b:
  - 1
  - 2
c:
  key1: value1
```

请注意，`Undefined` 不能参与四则运算，但它可以参与逻辑运算和比较运算。

```python
a = 1 + Undefined  # error
b = int(Undefined)  # error
c = not Undefined  # True
d = Undefined == Undefined  # True
e = Undefined or 1  # 1
f = str(Undefined)  # Undefined
```

### 运算符

以下字符表示运算符：

```python
+       -       *       **      /       //      %
<<      >>      &       |       ^       <       >
~       <=      >=      ==      !=      @       \
```

#### 算数运算符

KCL 支持常见的算数运算符：

```python
assert 2 + 3 == 5
assert 2 - 3 == -1
assert 2 * 3 == 6
assert 5 / 2 == 2.5
assert 5 // 2 == 2
assert 5 % 2 == 1
```

#### 相等和关系运算符

KCL 支持相等和关系运算符：

```python
assert 2 == 2
assert 2 != 3
assert 3 > 2
assert 2 < 3
assert 3 >= 3
assert 2 <= 3
```

#### 逻辑运算符

我们可以使用逻辑运算符反转或组合布尔表达式，例如：`and` 和 `or`:

```python
if not done and (col == 0 or col == 3):
  # ...Do something...

```

#### 位运算符和移位运算符

以下是位运算符和移位运算符的例子：

```python
value = 0x22
bitmask = 0x0f

assert (value & bitmask) == 0x02
assert (value & ~bitmask) == 0x20
assert (value | bitmask) == 0x2f
assert (value ^ bitmask) == 0x2d
assert (value << 4) == 0x220
assert (value >> 4) == 0x02
```

`|` 运算符可用于位运算，合并基本类型和集合及结构化数据，例如**列表**、**字典**和 **schema**。

位运算示例：

```python
0x12345678 | 0xFF  # 0x123456FF
```

联合基本类型示例：

```python
schema x:
    a: int | str  # attribute a could be a int or string
```

#### 赋值运算符

以下 token 作为语法中的分隔符：

```txt
    (       )       [       ]       {       }
    ,       :       .       ;       =       ->
    +=      -=      *=      /=      //=     %=
    &=      ^=      >>=     <<=     **=
```

以下是使用赋值和参数赋值赋值运算符的例子：

```python
_a = 2
_a *= 3
_a += 1
assert _a == 7
```

#### Identity 运算符

以下关键字作为语法中的 identity 运算符：

```python
is, is not
```

Identity 运算符检查右侧和左侧是否时同一对象。它们通常用于检查某个变量是否是 `None/Undefined/True/False`。以下是一些例子：

```python
empty_String = ""
empty_String is not None # True
```

#### 成员运算符

以下关键字作为语法中的成员运算符：

```python
in, not in
```

- `in` 运算符计算了第一个操作数是否是第二个操作数的成员，第二个运算符必须是 list、dict、schema 或 string。
- `not in` 运算符与 `in` 相反。它们都返回一个布尔值。

成员的含义因第二个操作数的类型而异：列表的成员是其元素；字典的成员是其键；字符串的成员是其所有子字符串。

```python
1 in [1, 2, 3]                  # True

d = {one = 1, two = 2}
"one" in d                      # True
"three" in d                    # False
1 in d                          # False
[] in d                         # False

"nasty" in "dynasty"            # True
"a" in "banana"                 # True
"f" not in "way"                # True

d = Data {one = 1, two = 2}     # Data is a schema with attributes one and two
"one" in d                      # True
"three" in d                    # False
```

#### 推导式

一个推导表达式通过遍历一个或多个迭代项并计算表达式生成的结果来生成连续的元素，并以此构造新的列表或字典。

我们可以如下使用列表和字典的推导表达式：

```python
listVar = [_x for _x in range(20) if _x % 2 == 0] # list comprehension
dictVar = {str(_i): 2*_i for _i in range(3)} # dict comprehension
```

#### 其他运算符

- 使用 **()** 表示函数调用, 例如 `"{} {}".format("hello", world)`。
- 使用 **[]** 引用列表中指定索引处的值。
- 使用 **:** 定义类型注解。
- 使用 **.** 引用成员字段。
- 使用 **\\** 续行符编写长表达式。

```python
longString = "Too long expression " + \
             "Too long expression " + \
             "Too long expression "
```

### 表达式

#### 条件表达式

条件表达式的形式为 `a if cond else b`。它首先计算条件 `cond`。如果为真，则会计算 `a` 并生成它的值；否则，它会生成 `b` 的值。

示例:

```python
x = True if enabled else False  # If enabled is True, x is True, otherwise x is False
```

#### 索引表达式

索引表达式 `a[i]` 生成可索引类型的第 `i` 个元素，例如字符串或数组。索引 `i` 必须是 `-n` ≤ `i` < `n` 范围内的 `int` 值，其中 `n` 等于 `len(a)`。其他任何索引都会导致错误。

有效的负索引的行为类似于 `n+i`，允许方便的对序列末尾进行索引。

```python
val = "abc"
list = ["zero", "one", "two"]
str_0 = val[0]         # "a"
str_1 = val[1]         # "b"
str_n1 = val[-1]       # "c"

list_0 = list[0]       # "zero"
list_1 = list[1]       # "one"
list_n1 = list[-1]     # "two"
```

索引表达式 `d[key]` 也可以用于字典 `d`，以获取指定键对应的值。如果字典中不包含这个键则会返回 `Undefined`

出现在赋值符左侧的索引表达式会更新指定的列表或字典元素。

```python
d = {key1 = "value1", key2 = "value2"}
key1value = d["key1"]  # value1
key2value = d["key2"]  # value2
```

尝试更新不可变类型的元素值（如列表或字符串）或可变类型的不可变变量会产生错误。

#### 切片表达式

切片表达式 `a[start:stop:step]` 会生成 `a` 包含的一个子序列，其中 `a` 必须是字符串或者数组。

`start`、`stop` 和 `step` 三个操作数都是可选的。如果有的话，每个值都必须为整数。`step` 的默认值为 1。如果 `step` 未指定，它前面的冒号也可以省略。指定 `step` 为 0 会产生错误。

从概念上来说，这些操作数指定了一系列值，索引 `i` 从 `start` 开始，每次增加 `step` 直到 `i` 到达或超过 `stop`。结果由有效的 `i` 的 `a[i]` 组成。

如下所示，从三个操作数计算有效的开始和结束的索引。`n` 是序列的长度。

```python
val = "abc"
len = len(val)
a = val[1:len]         # "bc"  (remove first element)
b = val[0:-1]          # "ab"  (remove last element)
c = val[1:-1]          # "b"   (remove first and last element)
```

```python
"abc"[1:]               # "bc"  (remove first element)
"abc"[:-1]              # "ab"  (remove last element)
"abc"[1:-1]             # "b"   (remove first and last element)
"banana"[1::2]          # "aaa" (select alternate elements starting at index 1)
"banana"[4::-2]         # "nnb" (select alternate elements in reverse, starting at index 4)
```

KCL 禁止将切片表达式定义为左值。原因是列表和字符串是不可变的，重新切片可以直接操作操作数，以确保更好的性能。

#### 函数调用

KCL 允许调用内置函数，或者调用内置和系统模块中的函数。

调用函数的基本方法如下所示：

```python
import math

a = math.pow(2, 3)  # 2 powers 3 is 8.
b = len([1, 2, 3])  # the length of [1, 2, 3] is 3
```

参数以 `,` 分隔，并且 KCL 还支持位置参数和键-值对形式的参数。

```python
print("hello world", end="")
```

请注意：

- 有些函数参数具有默认值。
- 一些函数接受可变参数。

如果没有为没有默认值的参数提供参数，则会抛出错误。

#### 选择表达式

选择表达式选择值的属性或方法。KCL 提供了许多识别或过滤属性的方法：

`x.y`

- dict: 表示字典 `x` 中键 `y` 对应的值。
- schema: 表示 schema `x` 中 `y` 属性的值。
- package: 表示 package `x` 中 `y` 标示的标识符。

示例：

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
name = person.name  # "Alice"
age = person.age  # 18

myDict = {
    key = "value"
}
result = myDict.key # "value"
```

`x?.y`

`x` 可以是 schema 实例或 dict。当 `x` 可能为 `None` 或者键 `y` 不在 `x` 中时这非常有用。

```python
# Example of dict:
data = {"key" = "value"}
a = data?.key     # "value"
b = data?.name    # Undefined

# example of schema instance:
schema Company:
    name: str
    address: str

schema Person:
    name: str
    job?: Company

alice = Person {
    name = "alice"
}

if alice?.job?.name == "Group":
    print("work in Group")
```

#### Quantifier 表达式

Quantifier 表达式用于集合：列表或字典。通常用于在处理集合后获得某个结果，主要有以下四种形式：

- **all**
  - 用于检测集合中所有元素都满足给定的逻辑表达式，并且返回一个布尔值作为结果。
  - 只有集合中所有元素都满足表达式为 true 时，`all` 表达式为 true，否则为 false。
  - 如果集合为空，返回 true。
  - 支持表达式执行期间逻辑表达式的短路。
- **any**
  - 用于检测集合中至少一个元素都满足给定的逻辑表达式，并且返回一个布尔值作为结果。
  - 当集合中至少一个元素都满足表达式为 true 时，`any` 表达式为 true，否则 false。
  - 如果集合为空，返回 false。
  - 支持表达式执行期间逻辑表达式的短路。
- **map**
  - 映射集合中的元素生成新的列表。
  - 新列表的长度严格等于原列表的长度。
- **filter**
  - 通过逻辑判断筛选原集合中的元素，返回一个经过筛选的子集合。
  - 当表达式为 true 时才将元素添加到子集合。
  - 产生的新集合的类型(list, dict 和 schema)与原集合的类型完全一致，并且长度为 `[0, len(original-collection)]`。

**all** 和 **any** 表达式的示例代码：

```python
schema Config:
    volumes: [{str:}]
    services: [{str:}]

    check:
        all service in services {
            service.clusterIP == "NONE" if service.type == "ClusterIP"
        }, "invalid cluster ip"

        any volume in volumes {
            volume.mountPath in ["/home/admin", "/home/myapp"]
        }
```

**map** 和 **filter** 表达式的示例代码：

```python
a = map e in [{name = "1", value = 1}, {name = "2", value = 2}] {
    {name = e.name, value = int(e.value) ** 2}
}  # [{"name": "1", value: 1}, {"name": "2", "value": 4}]

b = map k, v in {a = "foo", b = "bar"} { v }  # ["foo", "bar"]

c = filter e in [{name = "1", value = 1}, {name = "2", value = 2}] {
    int(e.value) > 1
}  # [{"name": "2", "value": 2}]

d = filter _, v in {a = "foo", b = "bar"} {
    v == "foo"
}  # {"a": "foo"}
```

请注意，区分 any 表达式和 any 类型的区别。当 `any` 在类型注解中使用，意味着变量的值是任意的，而 any 表达式意味着集合中的至少一个元素满足条件。

### 流程控制表达式

#### If 和 Else

KCL 支持 `if` 表达式和可选的 `elif` 和 `else` 表达式, 示例如下：

```python
a = 10
if a == 0:
    print("a is zero")
elif a < 100:
    print("a < 100")
    print("maybe a is negative")
else:
    print("a >= 100")
```

`elif` 的例子：

```python
_result = 0
if condition == "one":
    _result = 1
elif condition == "two":
    _result = 2
elif condition == "three":
    _result = 3
else:
    _result = 4
```

`if-elif-else` 表达式可以嵌套，示例如下：

```python
a = 10
if a == 0:
    print("a is zero")
elif a < 100:
    print("a < 100")
    if a < 0:
        print("a is negative")
    print("No matter a is negative or positive, this message is printed")
else:
    print("a >= 100")
```

此外，对于简单的 `if` 表达式如下：

```python
if success:
    _result = "success"
else:
    _result = "failed"
```

我们可以使用 `<expr> if <condition> else <expr>` 的形式将它们写在一行：

```python
_result = "success" if success else "failed"
```

`if` 或 `elif` 语句计算一个给定的表达式。当表达式的计算结果为 `True`, `:` 之后的语句将被计算，而当表达式为 `False` ，后面的语句不会被计算。

请注意，常量 `False`, `None`, 数字 `0`, 空列表 `[]`, 空字典 `{}` 和空字符串 `""` 都被视为 `False` 。

```python
_emptyStr = ""
_emptyList = []
_emptyDict = {}
isEmptyStr = False if _emptyStr else True
isEmptyList = False if _emptyList else True
isEmptyDict = False if _emptyDict else True
```

结果为：

```yaml
isEmptyStr: true
isEmptyList: true
isEmptyDict: true
```

### 断言语句

当发生错误时，开发人员应该能够检测到错误并终止执行。因此，KCL 引入了 `assert` 语法，示例如下：

```python
a = 1
b = 3
# a != b evaluates to True, therefore no error should happen.
assert a != b
# a == b is False, in the reported error message, the message "SOS" should be printed.
assert a == b, "SOS"
```

此外，我们可以为 assert 语声明一个条件，当条件满足时，才进行 assert 断言

- 使用 if 语句书写条件断言

```python
a = None
if a:
    assert a > 2:
```

- 使用 if 表达式书写条件断言

```python
a = None
assert a > 2 if a
```

### 函数

KCL 支持使用 lambda 关键字定义一个函数

```python
func = lambda x: int, y: int -> int {
    x + y
}
a = func(1, 1)  # 2
```

lambda 函数具有如下特性：

- lambda 函数将最后一个表达式的值作为函数的返回值，空函数体返回 None
- 返回值类型注解可以省略，返回值类型为最后一个表达式值的类型
- 函数体中没有与顺序无关的特性，所有的表达式都是按顺序执行的

```python
_func = lambda x: int, y: int -> int {
    x + y
}  # Define a function using the lambda expression
_func = lambda x: int, y: int -> int {
    x - y
}  # Ok
_func = lambda x: int, y: int -> str {
    str(x + y)
}  # Error (int, int) -> str can't be assigned to (int, int) -> int
```

lambda 函数对象不能参与任何计算，只能在赋值语句和调用语句中使用。

```python
func = lambda x: int, y: int -> int {
    x + y
}
x = func + 1  # Error: unsupported operand type(s) for +: 'function' and 'int(1)'
```

lambda 函数支持捕获其外部作用域的变量，并且可以作为其他函数的参数进行传递

```python
a = 1
func = lambda x: int {
    x + a
}
funcOther = lambda f, para: int {
    f(para)
}
r0 = funcOther(func, 1)  # 2
r1 = funcOther(lambda x: int {
    x + a
}, 1)  # 2
```

输出为:

```yaml
a: 1
r: 2
```

此外，可以定义一个匿名函数并直接调用。

```python
result = (lambda x, y {
    z = 2 * x
    z + y
})(1, 1)  # 3
```

并且还可以在 for 循环使用使用匿名函数

```python
result = [(lambda x, y {
    x + y
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 3, 3, 4]
```

请注意，KCL 中定义的函数的均为纯函数：

- 函数的返回结果只依赖于它的参数。
- 函数执行过程里面没有副作用。

因此，KCL 函数不能修改外部的变量，只能引用外部的变量，比如如下代码会发生错误：

```python
globalVar = 1
func = lambda {
    x = globalVar  # Ok
    globalVar = 1  # Error
}
```

### 类型系统

#### 类型注解

类型注解可用于包级变量，schema 属性和参数。

- 属性可以是基本类型，例如字符串(`string`)，浮点数(`float`)，定点数(`int`) 或布尔值(`bool`)。
- 属性可以是字面值类型，例如字符串文本(`"TCP"` 和 `"UDP"`)，数字文本 (`"1"` 和 `"1.2"`)，布尔值文本(`True` 和 `False`)。
- 属性也可以是列表或字典：
  - 未指定元素类型的列表为 `[]`。
  - 元素类型为 `t` 的列表为 `[t]`。这里 `t` 是另一种类型。
  - 键的类型为 `kt` 且值的类型为 `vt` 的字典为 `{kt:vt}`。
  - `kt`， `vt` 或两者都可以为空, 就像列表未指定元素类型一样。
- 属性可以是由 `|` 定义的 **联合类型** ，例如 `a | b`, 意为类型可以是 a 或 b。
  - 联合类型可以包含 `int`, `str`, `float`, `bool`, `list`, `dict`, 字面值类型和 schema 类型，并且支持类型的嵌套，例如： `{str:str|int}`、`[[int|str]|str|float]` 和 `2 | 4 | 6` 等。
- 属性可以是 schema 类型。在这种情况下，使用包名 + schema 名称作为类型名。
- 属性可以声明为任意类型，例如 `any`。

示例

- 基本类型

```python
"""Top level variable type annotation"""
a: int = 1  # Declare a variable `a` that has the type `int` and the value `1`
b: str = "s"  # Declare a variable `b` that has the type `str` and the value `"s"`
c: float = 1.0  # Declare a variable `c` that has the type `float` and the value `1.0`
d: bool = True  # Declare a variable `d` that has the type `bool` and the value `True`
```

- List/Dict/Schema 类型

```python
schema Person:
    name: str = "Alice"
    age: int = 10

a: [int] = [1, 2, 3]  # Declare a variable `a` that has the list type `[int]` and the value `[1, 2, 3]`
b: {str:str} = {k1 = "v1", k2 = "v2"}  # Declare a variable `b` that has the dict type `{str:str}` and the value `{k1 = "v1", k2 = "v2"}`
c: Person = Person {}  # Declare a variable `c` that has the schema type `Person` and the value `Person {}`
```

- 联合类型

```python
# Basic union types
schema x[argc: int]:  # Schema argument type annotation
    p: int | str  # Schema attribute type annotation
```

```python
# Literal union types
schema LiteralType:
    # String literal union types, x_01 can be one of "TCP" and "UDP"
    x_01: "TCP" | "UDP"
    # Number literal union types, x_02 can be one of 2, 4, and 6
    x_02: 2 | 4 | 6
    # Unit union types, x_03 can be one of 1Gi, 2Gi and 4Gi
    x_03: 1Gi | 2Gi | 4Gi

x = LiteralType {
    x_01 = "TCP"
    x_02 = 2
    x_03 = 1Gi
}
```

当属性的值不符合联合类型定义时，编译器会抛出错误：

```python
# Literal union types
schema LiteralType:
    # String literal union types, x_01 can be one of "TCP" and "UDP"
    x_01: "TCP" | "UDP"

x = LiteralType {
    x_01 = "HTTP"  # Error: the type got is inconsistent with the type expected, expect str(TCP)|str(UDP), got str(HTTP)
}
```

- Any 类型

```python
# Any type
schema Config:
    literalConf: any = 1
    dictConf: {str:any} = {key = "value"}
    listConf: [any] = [1, "2", True]

config = Config {}
```

请注意，一般在配置编写中不提倡使用 `float` 和 `any` 类型，因为它们都存在一定的不稳定因素，比如精度丢失，无法进行静态类型检查等。

此外在 KCL 中，不允许修改一个变量的类型。如果在重新分配值时不满足类型，将引发类型错误。

```python
_a = 1  # The type of `_a` is `int`
_a = "s"  # Error: expect int, got str(s)
```

变量可以赋值给其上界类型，但不能赋值给它的特化类型。

`None` 和 `Undefined` 可以赋值给任何类型:

- 任何类型都可以赋值给 `any` 类型, `None` 和 `Undefined` 可以赋值给 `any` 类型。

```python
a: int = None
b: str = Undefined
c: any = 1
d: any = "s"
e: any = None
```

- `int` 类型可以赋值给 `float` 类型, `float` 类型不能赋值给 `int` 类型.

```python
a: float = 1
b: int = 1.0  # Error: expect int, got float(1.0)
```

- `int` 类型可以赋值给 `int|str` 类型, `int|str` 不能赋值给 `int` 类型.

```python
a: int | str = 1
b: int = 1 if a else "s"  # Error: expect int, got int(1)|str(s)
```

请注意，在 KCL 中虽然提供了 any 类型，但是它仍然是静态类型，所有变量的类型在编译期间不可变。

#### 类型推导

如果顶层或 schema 中的变量或常量声明没有使用显式的类型注解，则会从初始值推断类型。

- 整形数值被推断为 `int`。

```python
a = 1  # The variable `a` has the type `int`
```

- 浮点数被推断为 `float`。

```python
a = 1.0  # The variable `a` has the type `float`
```

- 字符串被推断为 `str`。

```python
a = "s"  # The variable `a` has the type `str`
```

- 布尔值被推断为 `bool`。

```python
a = True  # The variable `a` has the type `bool`
b = False  # The variable `b` has the type `bool`
```

- `None` 和 `Undefined` 被推断为 `any`。

```python
a = None  # The variable `a` has the type `any`
b = Undefined  # The variable `b` has the type `any`
```

- 列表的类型根据元素类型推断，并且是可变大小的。

```python
a = [1, 2, 3]  # The variable `a` has the type `[int]`
b = [1, 2, True]  # The variable `b` has the list union type `[int|bool]`
c = ["s", 1]  # The variable `c` has the list union type `[int|str]`
```

请注意，空列表将被推导为 `[any]` 类型。

```python
a = []  # The variable `a` has the type `[any]`
```

- 字典的类型是根据元素的键和值推断的，并且是可变大小的。

```python
a = {key = "value"}  # The variable `a` has the type `{str:str}`
b = {key = 1}  # The variable `b` has the type `{str:int}`
c = {key1 = 1, key2 = "s"}  # The variable `c` has the type `{str:int|str}`
```

请注意，空字典将被推导为 `{any:any}` 类型。

```python
a = {}  # The variable `a` has the type `{any:any}`
```

- 携带运行时值的 if 条件表达式的类型将被静态推断为所有可能结果的联合类型。

```python
a: bool = True  # The variable `a` has the type `bool`
b = 1 if a else "s"  # The variable `b` has the type `int|str`
```

当变量被推导为某个类型时，它的类型不能再改变。

```python
_a = 1
_a = "s"  # Error: expect int, got str(1)
```

#### 类型别名

在 KCL 中，我们可以使用 `type` 关键字为所有类型声明一个类型别名简化复杂类型的书写。

```python
type Int = int
type String = str
type StringOrInt = String | Int
type IntList = [int]
type StringAnyDict = {str:}
```

我们可以从一个包中导入一个类型并为它定义一个别名。

```py
import pkg

type Data = pkg.Data
```

此外，我们还可以使用类型别名和字面值联合类型充当近似枚举的效果。

```python
# A type alias of string literal union types
type Color = "Red" | "Yellow" | "Blue"

schema Config:
    color: Color = "Red"  # The type of color is `"Red" | "Yellow" | "Blue"`, and it has an alias `Color`, whose default value is `"Red"`

config = Config {
    color = "Blue"
}
```

上述代码执行的输出结果为：

```yaml
config:
  color: Blue
```

请注意，类型别名不能与已有的内置类型 `any`、`int`、`float`、`bool` 和 `str` 等相同

```python
type any = int | str  # Error
type int = str  # Error
type float = int  # Error
type bool = True  # Error
type str = "A" | "B" | "C"  # Error
```

#### 类型守卫

KCL 支持在程序中使用 `typeof` 函数对任意值求得其运行时的类型。

```python
import sub as pkg

_a = 1

t1 = typeof(_a)
t2 = typeof("abc")

schema Person:
    name?: any

_x1 = Person {}
t3 = typeof(_x1)

_x2 = pkg.Person {}
t4 = typeof(_x2)
t5 = typeof(_x2, full_name=True)

t6 = typeof(_x1, full_name=True)

# Output
# t1: int
# t2: str
# t3: Person
# t4: Person
# t5: sub.Person
# t6: __main__.Person
```

除此之外，我们可以使用 `as` 关键字在运行时作类型转换。`as` 关键字的一般用法如下：

- 具有偏序关系的基础类型，比如 `float -> int`
- 具有偏序关系的联合类型，比如 `int | str -> str`
- 对类型上界 `any` 的转换，比如 `any -> int`
- 具有偏序关系的结构类型，比如 `base-schema -> sub-schema`

```python
schema Data1:
    id?: int

schema Data2:
    name?: str

data: Data1 | Data2 = Data1 {}

if typeof(data) == "Data1":
    data1 = data as Data1  # The type of `data` is `Data1`
elif typeof(data) == "Data2":
    data2 = data as Data2  # The type of `data` is `Data2`
```

当类型转换失败时，一个运行时错误将被抛出。

```python
a: any = "s"
b: int = a as int  # Error: The `str` type cannot be converted to the `int` type
```

如果不想要运行时类型转换失败，我们可以添加 `if` 防御式代码进行检查。

```python
a: any = "s"
b = a as int if typeof(a) == "int" else None  # The type of b is `int`
```

请注意，`as` 转换的目标类型不能是字面值类型或者联合类型，因为它们在运行时不具有一个完全确定的类型。

### Schema

#### 概述

Schema 是定义复杂配置的语言元素。我们可以定义带类型的属性，初始值和验证规则。此外，KCL 支持 schema 单继承、mixin 和 protocol 实现复杂配置的复用。

#### 基础部分

##### 属性

以下是 schema 基础定义的示例：

```python
# A person has a first name, a last name and an age.
schema Person:
    firstName: str
    lastName: str
    # The default value of age is 0
    age: int = 0
```

在 KCL 中, 我们可以使用类型注解在 schema 中定义一些属性，每个属性都可以设置一个可选的默认值（比如上述代码中的 `age` 属性，它的默认值是 `0`），没有设置默认值的属性的初始值为 `Undefined`, 它们不会在 YAML 当中进行输出。

###### 不可变性

schema 中属性的不可变性遵循和全局变量不可变性一样的规则，只有 schema 中的可变属性可以在 schema 中修改。此外，schema 的属性默认值可被 schema 配置值修改：

```python
schema Person:
    age: int = 1  # Immutable attribute
    _name: str = "Alice"  # Mutable attribute

    age = 10  # Error, can't change the default value of the attribute `age` in the schema context.
    _name = "Bob"  # Ok

person = Person {
    age = 3  # Ok, can change the default value of the attribute `age` in the schema config.
}
```

###### 可选属性

schema 实例中每个属性 **必须** 赋值一个非 `None`/`Undefined` 的值，否则编译器会抛出错误，除非它被 `?` 符号标记为可选属性。

示例：

```python
schema Employee:
    bankCard: int  # bankCard is a required attribute, and it can NOT be None or Undefined
    nationality?: str  # nationality is an optional attribute, and it can be None or Undefined

employee = Employee {
    bankCard = None  # Error, attribute 'bankCard' of Employee is required and can't be None or Undefined
    nationality = None  # Ok
}
```

##### 顺序无关计算

schema 中顺序无关计算表示 schema 内部属性之间的引用关系。例如，当我们声明一个形式为 `a = b + 1` 的表达式时，`a` 值的计算依赖于 `b` 值的计算。当编译器计算 `a` 的值并且 `a` 的值取决于 `b` 的值时，编译器会选择先计算 `b` 的值，然后根据 `b` 的值计算 a 的值表达式 `a = b + 1`，这与传统过程语言的计算方法略有不同。

由于 schema 中值的计算是基于依赖关系的，就像有向无环图按照拓扑排序的顺序遍历图中的每个节点一样， schema 中属性的声明顺序并不那么重要，因此特征称为顺序无关计算。

请注意，不同 schema 属性值之间不能有循环引用。

我们可以通过下面的例子看到这个特性。

```python
schema Fib:
    n1: int = n - 1  # Refers to the attribute `n` declared after `n1`
    n2: int = n1 - 1
    n: int
    value: int = 1 if n <= 2 else Fib {n = n1}.value + Fib {n = n2}.value

fib8 = Fib {n = 8}.value
```

结果为：

```yaml
fib8: 21
```

在 schema 中，我们只需要简单的指定属性之间的依赖关系，编译器就会根据依赖关系自动计算出值，这样可以帮助我们节省大量的样板代码，减少配置编写难度。

##### Schema 上下文

我们可以定义 schema 的上下文来管理 schema 的属性，可以直接在 schema 中编写 schema 参数、临时变量和表达式等：

```python
schema Person[_name: str]:  # define a schema argument
    name: str = _name     # define a schema attribute
    age: int = 10         # define a schema attribute with default value
    hands: [int] = [i for i in [1, 2, 3]] # define a for statement
```

然后，我们可以通过如下代码实例化一个 `Person` 并将其赋值给 `alice` 变量：

```python
alice = Person("alice")
```

可以得到如下 YAML 输出：

```yaml
alice:
  name: alice
  age: 10
  hands:
    - 1
    - 2
    - 3
```

##### 校验

KCL 中为了确保代码稳定性，除了使用 **静态类型** (类型注解) 和 **不可变性**，还支持在 **check** 块中定义验证规则 (KCL 几乎原生支持所有 [OpenAPI](https://www.openapis.org/) 的验证能力)：

```python
import regex

schema Sample:
    foo: str
    bar: int
    fooList: [str]

    check:
        bar > 0  # Minimum, also support the exclusive case
        bar < 100  # Maximum, also support the exclusive case
        len(fooList) > 0  # Min length, also support exclusive case
        len(fooList) < 100  # Max length, also support exclusive case
        regex.match(foo, "^The.*Foo$")  # Regex match
        isunique(fooList)  # Unique
        bar in range(100)  # Range
        bar in [2, 4, 6, 8]  # Enum
        multiplyof(bar, 2)  # MultipleOf
```

使用 schema, 所有的实例将在编译时验证：

```python
# Ok
goodSample = Sample {
    foo = "The Foo"
    bar = 2
    fooList = ["foo0", "foo1"]
}

# Error: validation failure: Check failed on check conditions: bar < 100.
badSample = Sample {
    foo = "The Foo"
    bar = 123
    fooList = ["foo0", "foo1"]
}
```

此外，我们可以使用 **and**, **or**, **if** 来构建更复杂的检查逻辑：

```python
schema Sample:
    bar: int
    foo: str
    doCheck: bool

    check:
        regex.match(foo, "^The.*Foo$") and bar in [2, 4, 6, 8] if doCheck
```

为了确保所有检查规则都能很好地发挥其相应的作用，我们可以通过编写 KCL 测试用例来测试不同数据组合的合理性和正确性，并通过 kcl test tool 运行所有测试用例。

##### 文档

通常在我们写好 schema 模型之后，我们会为 schema 写文档注释，可以用一个三引号字符串来完成，如下所示：

```python
schema Server:
    """Server is the common user interface for long-running
    services adopting the best practice of Kubernetes.

    Attributes
    ----------
    workloadType : str, default is Deployment
        Use this attribute to specify which kind of long-running service you want.
        Valid values: Deployment, CafeDeployment.
        See also: k8s/core/v1/workload_metadata.k.
    name : str, default is None
        A Server-level attribute.
        The name of the long-running service.
        See also: k8s/core/v1/metadata.k.
    labels : {str:str}, optional, default is None
        A Server-level attribute.
        The labels of the long-running service.
        See also: k8s/core/v1/metadata.k.

    Examples
    ----------------------
    myCustomApp = AppConfiguration {
        name = "componentName"
    }
    """
    workloadType: str = "Deployment"
    name: str
    labels?: {str:str}
```

更多详细内容可见 Doc tools。

##### 配置

假设我们有如下 schema 定义：

```python
schema Person:
    firstName: str
    lastName: str
    labels?: {str:str}
```

可以用类 JSON 的表达式定义配置：

```python
person = Person {
    firstName = "firstName"
    lastName = "lastName"
}
```

schema 遵循严格的属性定义，配置未定义的属性将触发编译错误：

```python
person = Person {
    firstName = "firstName"
    lastName = "lastName"
    fullName = "fullName"  # Error: Cannot add member 'fullName' to schema 'Person', 'fullName' is not defined in schema 'Person'
}
```

此外，我们可以使用 `if` 表达式将元素动态的添加到 schema 实例中，将满足条件的元素添加到 schema 实例并忽略不满足条件的元素。并且除了使用一个 schema 类型实例化一个 schema，我们也可以通过 schema 实例得到一个新的实例。

```python
env = "prod"
person = Person {
    firstName = "firstName"
    lastName = "lastName"
    if env == "prod":
        labels.env = env
    else:
        labels.env = "other"
}
# We can use the person instance to get a new instance named `personx` directly.
personx = person {
    firstName = "NewFirstName"
}
```

输出为：

```yaml
env: prod
person:
  firstName: firstName
  lastName: lastName
  labels:
    env: prod
personx:
  firstName: NewFirstName
  lastName: lastName
  labels:
    env: prod
```

#### 高级功能

##### Protocol & Mixin

除了 schema, 在 KCL 中还提供了一种额外的类型定义方式 `protocol`，它的性质如下：

- 在 protocol 中，只能定义属性及其类型，不能书写复杂的逻辑与 check 表达式，也不能使用 mixin。
- protocol 只能对非 `_` 开头的属性进行约束。
- protocol 只能继承自或者引用 protocol, 不能继承自或者引用 schema。

此外，我们可以使用可选的 **mixin** 组装复杂的 schema，并使用 **protocol** 为 **mixin** 添加可选的宿主类型, 使用 `for` 关键字为 **mixin** 定义宿主类型，并且在 mixin 内部它将从宿主类型中查询到属性的类型。

```python
schema Person:
    mixin [FullNameMixin]

    firstName: str  # Required
    lastName: str  # Required
    fullName?: str  # Optional
```

FullNameMixin 是一个产生 fullName 字段的简单例子：

```python
protocol PersonProtocol:
    firstName: str
    lastName: str
    fullName?: str

mixin FullNameMixin for PersonProtocol:
    fullName = "{} {}".format(firstName, lastName)
```

然后我们可以通过一下方式获取 schema 实例：

```python
person = Person {
    firstName = "John"
    lastName = "Doe"
}
```

输出结果为：

```yaml
person:
  firstName: John
  lastName: Doe
  fullName: John Doe
```

请注意，宿主类型 **protocol** 只能用于 **mixin** 的定义 (后缀名为 `Mixin`), 否则将会报错。

```python
protocol DataProtocol:
    data: str

schema Data for DataProtocol:  # Error: only schema mixin can inherit from protocol
    x: str = data
```

##### 索引签名

在 KCL schema 中可以定义索引签名，这意味着索引签名的键-值约束可用于构造具有 schema 类型的字典。或者可以将其他检查添加到额外的 schema 属性中，以增强 KCL 类型和语义检查。

###### 基本用法

使用 `[{attr_alias}: {key_type}]: {value_type}` 的形式去定义 schema 的类型注解， 其中 `{attr_alias}` 可以省略。

```python
schema Map:
    """
    Map is a schema with a key of str type and a value of str type
    """
    [str]: str  # `{attr_alias}` can be omitted.

data = Map {
    key1 = "value1"
    key2 = "value2"
}
```

###### 同时定义属性和索引签名

可以在 schema 中同时定义 schema 属性和索引签名，通常用于表示 schema 中额外属性的类型约束，比如如下代码

```python
schema Person:
    name: str
    age: int
    [...str]: str  # Except for the `name` and `age` attributes, the key type of all other attributes of the schema must be `str`, and the value type must also be `str`.
```

###### 定义索引签名别名

- 可以为索引签名定义类型注解的属性别名，并将其与索引签名的默认值一起使用。

```python
schema Environment:
    [id: str]: EnvironmentSpec = {
        fullName = id
    }

schema EnvironmentSpec:
    fullName: str
    shortName: str = fullName
    accountID: int

environment = Environment {
    development: {
    	shortName:    "dev"
    	accountID: 123456
    }
    production: {
    	shortName:    "prod"
    	accountID: 456789
    }
}
```

YAML 输出为:

```yaml
environment:
  production:
    fullName: production
    shortName: prod
    accountID: 456789
  development:
    fullName: development
    shortName: dev
    accountID: 123456
```

- 可以为索引签名定义类型注解的属性别名，并将其与检查块一起使用。

```python
schema Data:
    [dataName: str]: str
    check:
        dataName in ["Alice", "Bob", "John"]  # We can use the index signature key name in the check block.

data = Data {
    Alice = "10"
    Bob = "12"
    Jonn = "8"  # Error: Jonn not in ["Alice", "Bob", "John"]
}
```

```python
import regex

schema DataMap:
    [attr: str]: str
    check:
        regex.match(attr, r'^[-_a-zA-Z0-9]+$')

data = DataMap {
    key1 = "value1"
    "foo.bar" = "value2"  # check error
}
```

##### 继承

类似于其他面向对象语言，KCL 提供了基础且有限的面向对象支持，例如 **属性复用**，**私有和公有变量**和**单继承**。KCL 不支持多继承。

以下是单继承的例子：

```python
# A person has a first name, a last name and an age.
schema Person:
    firstName: str
    lastName: str
    # The default value of age is 0
    age: int = 0

# An employee **is** a person, and has some additional information.
schema Employee(Person):
    bankCard: int
    nationality?: str

employee = Employee {
    firstName = "Bob"
    lastName = "Green"
    age = 18
    bankCard = 123456
}
```

结果为：

```yaml
employee:
  firstName: Bob
  lastName: Green
  age: 18
  bankCard: 123456
  nationality: null
```

请注意，KCL 只支持 schema 的 **单继承**。

此外，当 schema 存在继承关系时，可选属性的性质如下：

- 如果该属性在基类 schema 中是可选的，则它在子类 schema 中是可选的，也可以是子类 schema 中必选的。
- 如果该属性在基类 schema 中是必选的，则它在子类 schema 中也是必选的。

```python
schema Person:
    bankCard?: int
    nationality: str

schema Employee(Person):
    bankCard: int  # Valid, both `bankCard: int` and `bankCard?: int` are allowed
    nationality?: str  # Error, only `nationality: str` is allowed
```

##### Schema 函数

schema 映射到函数上非常好用；它可以有任意数量的输入和输出参数。 例如，Fibonacci 函数可以使用递归 schema 如下编写：

```python
schema Fib[n: int]:
    n1 = n - 1
    n2 = n - 2
    if n == 0:
        value = 0
    elif n == 1:
        value = 1
    else:
        value = Fib(n1).value + Fib(n2).value

fib8 = Fib(8).value  # 21
```

##### 装饰器

像 Python 一样, KCL 支持在 schema 上使用装饰器。KCL 装饰器动态地改变 schema 的功能，而不必直接使用子 schema 或更改被装饰的 schema 的源代码。 和函数调用一样，装饰器支持传入额外的参数。

内置的 schema 装饰器：

- `@deprecated`
  标识 schema 或 schema 属性被废弃. `@deprecated` 装饰器支持三种参数：
  - **version** - 字符串类型，表示版本信息。 默认值为空。
  - **reason** - 字符串类型，表示不推荐使用的原因。 默认值为空。
  - **strict** - bool 类型，表示是报错还是警告。 默认值是 true。 如果 `strict` 为 `True` 并且抛出错误，程序将被中断。 如果 `strict` 为 `False`，则会输出警告并且不会中断程序。

示例：

```python
@deprecated
schema ObsoleteSchema:
    attr: str

schema Person:
    firstName: str = "John"
    lastName: str
    @deprecated(version="1.16", reason="use firstName and lastName instead", strict=True)
    name: str
    attrs: ObsoleteSchema = {  # Error: ObsoleteSchema was deprecated
        attr = "value"
    }

JohnDoe = Person {  # Error: name was deprecated since version 1.16, use firstName and lastName instead
    name = "deprecated"
}
```

- `@info`
  给 schema 或 schema 属性标识额外的信息，支持任意参数，用于语言静态分析 schema 或 schema 属性的扩展标记信息

示例：

```python
@info(version="v1")
schema Person:
    @info(message="name")
    name: str
    age: int
```

请注意，当前版本的 KCL 尚不支持用户自己定义装饰器。

##### 成员函数

内置函数和 schema 成员

- instances(full_pkg: bool = False)
  返回 schema 的现有实例列表，当 `full_pkg` 设置为 `False` 时，仅返回 main 中的 schema 实例，当 `full_pkg` 设置为 `True` 时，返回整个项目对应 schema 的所有实例。

```python
schema Person:
    name: str
    age: int

alice = Person {
    name = "Alice"
    age = 18
}

bob = Person {
    name = "Bob"
    age = 10
}

aliceAndBob = Person.instances()  # Person is a schema type, instances() is its member method
```

输出为：

```yaml
alice:
  name: Alice
  age: 18
bob:
  name: Bob
  age: 10
aliceAndBob:
  - name: Alice
    age: 18
  - name: Bob
    age: 10
```

### 配置操作

#### 配置合并

##### | 运算符

在 KCL 中，我们可以使用合并运算符 `|` 来合并配置。union 运算符支持的类型包括如下：

```txt
SchemaInstance | SchemaInstance
SchemaInstance | Dict
Dict | Dict
List | List
```

合并集合和结构化数据：

- 合并 List。使用 `|` 运算符右边的列表表达式按照**索引**逐一覆盖左边列表表达式中的元素。

```python
_a = [1, 2, 3]
_b = [4, 5, 6, 7]
x = _a | _b  # [4, 5, 6, 7]  1 -> 4; 2 -> 5; 3 -> 6; Undefined -> 7
```

合并特定索引或所有元素仍在讨论中。

- 合并 Dict. 使用 `|` 运算符右边的列表表达式按照**键**逐一覆盖左边列表表达式中的元素。

```python
_a = {key1 = "value1"}
_b = {key1 = "overwrite", key2 = "value2"}
x = _a | _b  # {"key1": "overwrite", "key2": "value2"}
```

集合和 schema 的合并是一个新的集合，其属性是将 b 合并到 a，保留从左到右的操作数顺序。

- 合并 schema。Schema 的合并与 dict 相似。

Schema 的合并操作如下:

```python
schema Person:
    firstName?: str
    lastName?: str

_a = Person {
    firstName = "John"
}
_b = {lastName = "Doe"}
_c = _a | _b  # {"firstName": "John", "lastName": "Doe"}
_d = _a | None  #  {"firstName": "John"}
_e = _a | Undefined  #  {"firstName": "John"}
_f = None | _a  #  {"firstName": "John"}
_g = Undefined | _a  #  {"firstName": "John"}
```

请注意，当 union 运算符的左右操作数之一为 None 时，将立即返回另一个操作数。

```python
data1 = {key = "value"} | None  # {"key": "value"}
data2 = None | [1, 2, 3]  # [1, 2, 3]
data3 = None | None  # None
```

输出如下：

```yaml
data1:
  key: value
data2:
  - 1
  - 2
  - 3
data3: null
```

##### : 运算符

模式: `identifier : E`

表达式 `E` 的值将被合并到元素值。

示例：

```python
schema Data:
    labels: {str:} = {key1 = "value1"}

data = Data {
    # union {key2: "value2"} into the attribute labels of the schema Data.
    labels: {key2 = "value2"}
}
```

输出：

```yaml
data:
  labels:
    key1: value1
    key2: value2
```

除了在 schema 属性上使用属性运算符之外，还可以使用属性运算符对配置块执行不同的操作。

- schema 外部使用合并运算符 `:`

```python
schema Data:
    d1?: int
    d2?: int

schema Config:
    data: Data

# This is one configuration that will be merged.
config: Config {
    data.d1 = 1
}
# This is another configuration that will be merged.
config: Config {
    data.d2 = 2
}
```

与它等效的配置代码可以表示为:

```python
schema Data:
    d1?: int
    d2?: int

schema Config:
    data: Data

config: Config {
    data.d1 = 1
    data.d2 = 1
}
```

输出结果为:

```yaml
config:
  data:
    d1: 1
    d2: 1
```

- schema 内部使用合并运算符 `:`

```python
schema Data:
    d1?: int
    d2?: int

schema Config:
    # This is one configuration that will be merged.
    data: Data {
        d1 = 1
    }
    # This is another configuration that will be merged.
    data: Data {
        d2 = 1
    }

config: Config {}
```

#### 配置覆盖

##### = 运算符

模式: `identifier = E`

表达式 `E` 的值将覆盖元素值。

示例：

```python
schema Data:
    labels: {str:} = {key1 = "value1"}

data = Data {
    # override {key2: "value2"} into the attribute labels of the schema Data.
    labels = {key2 = "value2"}
}
```

输出：

```yaml
data:
  labels:
    key2: value2
```

请注意，可以使用 `Undefined` 来覆盖，来“删除”内容。例如 `{ a = Undefined }`。

#### 配置添加

##### += 运算符

模式: `identifier += E`

插入只能用于列表类型的 `identifier`.

`E` 将插入到列表 `identifier` 指定索引后，并且索引以后的属性将自动后移。

示例:

```python
schema Data:
    labels: {str:} = {key1 = [0, 1, 3]}

data = Data {
    # insert [3] after the index 1 of the attribute labels.key1 of the schema Data.
    labels: {key1[1] += [2]}
}
```

输出：

```yaml
data:
  labels:
    key1:
      - 0
      - 1
      - 2
      - 3
```

如果没有定义索引，将使用最后一个索引。

#### 注意事项

合并运算符 `:` 是一个可交换的幂等运算符，当合并的值发生值的冲突时会发生值冲突错误，因此我们需要 `=` 和 `+=` 运算符表示配置的覆盖，添加和删除操作。

```python
data0 = {id: 1} | {id: 2}  # Error：conflicting values between {'id': 2} and {'id': 1}
data1 = {id: 1} | {id = 2}  # Ok, the value of `data` is {"id": 2}
```

`:` 运算符冲突检查的规则如下:

- `None` 和 `Undefined` 不与任何值冲突

```python
data0 = None | {id: 1}  # Ok
```

- 对于 `int`、`float`、`str` 和 `bool` 类型的变量，当它们的值不相同时发生冲突错误。

```python
data0 = 1 | 1  # Ok
data1 = 1 | "s"  # Error
```

- 对于列表类型
  - 当它们的长度不相同时，它们被认为是冲突的
  - 当它们的长度相同时，当且仅当它们的任意一个子元素值冲突时，它们自身是冲突的

```python
data0 = [1] | [1]  # Ok
data1 = [1, 2] | [1]  # Error
```

- 对于 dict/schema 类型
  - 对于相同的 key，key 的值冲突时，它们自身是冲突的，否则是不冲突的

```python
data0 = {id: 1} | {id: 1}  # Ok
data1 = {id: 1} | {id: 2}  # Error
data1 = {id: 1} | {idAnother: 1}  # Ok
```

### Rule

KCL 支持使用 rule 关键字定义校验块，可用于数据校验，用法类似于 schema 中的 check 表达式。

```python
rule SomeRule:
    age > 0, "rule check failure message"
```

可以像 schema 实例化那样调用一个 rule 进行校验

```python
age = 0
name = "Bob"
rule SomeRule:
    age > 0, "rule check failure message"
    name == "Alice"

rule1 = SomeRule()  # Rule call
rule2 = SomeRule {}
```

可以使用 protocol 和 for 绑定语句为 rule 增加类型约束:

```python
# Protocol definition
protocol ServiceProtocol:
    clusterIp: str
    $type: str

# Protocol definition
protocol VolumeProtocol:
    mountPath: str

# Protocol
protocol SomeProtocol:
    id: int
    env: {str: any}
    services: [ServiceProtocol]
    volumes: [VolumeProtocol]

rule SomeChecker for SomeProtocol:
    id > 0, "id must >0"

    all service in services {
        service.clusterIp == "NONE" if service.type == "ClusterIP"
    }

    any volume in volumes {
        volume.mountPath in ["/home/admin", "/home/myapp"]
    }

# Call rule to check with config parameter
SomeChecker {
    id = 1
    env = {
        MY_ENV = "MY_ENV_VALUE"
    }
    services = [
        {
            type = "ClusterIP"
            clusterIp = "NONE"
        }
    ]
    volumes = [
        {
            mountPath = "/home/admin"
        }
        {
            mountPath = "/home/myapp"
        }
    ]
}
```

请注意，`protocol` 和 `rule` 的组合方式可以使属性和其约束定义进行分离，我们可以在不同的包中定义不同的 `rule` 和 `protocol` 按需进行组合，这与 schema 中的 check 表达式只能与 schema 属性定义在一起是不同的。

此外，有两种复用不同 rule 的方式

- 直接调用

```python
weather = "sunny"
day = "wednesday"

rule IsSunny:
    weather == "sunny"

rule IsWednesday:
    day == "wednesday"

rule Main:
    IsSunny()  # Rule inline call
    IsWednesday()  # Rule inline call

Main()  # Rule call
```

使用 rule 的继承 (rule 不同于 schema, 可以多继承混用)

```python
weather = "sunny"
day = "wednesday"

rule IsSunny:
    weather == "sunny"

rule IsWednesday:
    day == "wednesday"

rule Main(IsSunny, IsWednesday):
    id == 1

Main()
```

可以使用 option 函数与命令行 `-D` 参数获得外部数据进行校验

- 一个简单例子

```python
schema Day:
    day: str
    homework: str

days: [Day] = option("days")

rule Main:
    filter d in days {
        d.day not in ["saturday", "sunday"] and d.homework
    }

Main()
```

- 一个复杂例子

```python
data = option("data")
input = option("input")

rule Allow:
    UserIsAdmin()
    any grant in UserIsGranted() {
        input.action == grant.action and input.type == grant.type
    }

rule UserIsAdmin:
    any user in data.user_roles[input.user] {
        user == "admin"
    }

rule UserIsGranted:
    [
        grant
        for role in data.user_roles[input.user]
        for grant in data.role_grants[role]
    ]

allow = Allow() or False
```

### 模块

KCL 配置文件以 **模块 (module)** 形式组织。 单个 KCL 文件被认为是一个模块，一个目录被认为是一个包。

同一个包内的模块是可见的，跨包引用需要通过导入可见。

```bash
.
└── root
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   └── service1.k
    └── mixin
        └── mixin1.k
```

model1.k:

```python
# schema CatalogItem in model1.k

schema CatalogItem:
    id: int
    image: CatalogItemImage  # CatalogItemImage is defined in the module of the same package e.g., model2.k in package model
    title: str
```

service1.k:

```python
import ..model as model  # cross-package references

schema ImageService:
    image: model.CatalogItemImage  # CatalogItemImage is imported from another package e.g., model2.k in package model
    name: str
```

#### 相对路径引用

我们可以使用 `.` 运算符来实现 KCL 入口文件的相对路径导入。

main.k:

```python
import .model1  # Current directory module
import ..service  # Parent directory
import ...root  # Parent of parent directory

s = service.ImageService {}
m = root.Schema {}
```

#### 绝对路径引用

`import a.b.c.d` 的语义为：

1. 如果 `kcl.mod` 文件不存在，将当前目录作为包的根路径，并从当前目前查找 `a/b/c/d` 路径
2. 如果 `kcl.mod` 文件存在，从 `ROOT_PATH/a/b/c/d` 查找，否则抛出一个导入错误

根路径 `ROOT_PATH` 的定义为：

从当前目录或者父级目录中查找 `kcl.mod` 文件对应的目录。

```bash
.
└── root
    ├── kcl.mod
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   └── service1.k
    └── mixin
        └── mixin1.k
```

main.k:

```python
import service  # `root package` and `kcl.mod` are in the same directory
import mixin  # `root package` and `kcl.mod` are in the same directory

myModel = model.CatalogItem {}
```

请注意，对于 KCL 入口文件 `main.k`，不能导入所在文件夹，否则会出现递归导入错误：

```python
import model  # Error: recursively loading
```

### 动态参数

假设某些字段需要像用户输入一样动态传入，我们可以在模块中定义一个动态参数：

```python
bankCard = option("bankCard")  # Get bankCard through the option function.
```

我们可以如下使用 module：

```bash
kcl employee.k -D bankCard=123
```

目前，支持顶级参数的类型有数字、字符串、布尔、列表和字典。

```bash
kcl main.k -D list_key='[1,2,3]' -D dict_key='{"key":"value"}'
```

请注意，命令行中引号 `"` 等符号需要使用 `\` 进行转义

#### Setting 文件形式的参数

此外，它还支持输入一个 YAML 文件作为顶级参数。

```yaml
kcl_options:
  - key: key_number
    value: 1
  - key: key_dict
    value:
      innerDictKey: innerDictValue
  - key: key_list
    value:
      - 1
      - 2
      - 3
  - key: bankCard
    value: 123
```

```bash
kcl -Y setting.yaml employee.k
```

此外，setting 文件还支持配置命令行编译参数如下：

```yaml
kcl_cli_configs:
  files:
    - file1.k
    - file2.k
  disable_none: true
  strict_range_check: true
  debug: 1
  verbose: 1
  sort_keys: true
  output: ./stdout.golden
  overrides:
    - app.image=new_image
  path_selector:
    - config
  package_maps:
    k8s: /Users/.kcl/kpm/k8s_1.24
kcl_options:
  - key: image
    value: docker.io/kcllang/kcl:latest
```

KCL CLI -Y 参数还支持多文件配置，并支持编译参数和顶级参数的单独写入与合并。

```bash
kcl -Y compile_setting.yaml option_setting.yaml
```

- `compile_setting.yaml`

```yaml
kcl_cli_configs:
  files:
    - file1.k
    - file2.k
  disable_none: true
  strict_range_check: true
  debug: 1
  verbose: 1
  output: ./stdout.golden
```

- `option_setting.yaml`

```yaml
kcl_options:
  - key: image
    value: docker.io/kcllang/kcl:latest
```

我们可以使用以下指令获取每个参数的含义

```bash
kcl --help
```

#### Option Functions

我们可以在 KCL 代码中使用 `option` 获取顶级参数。

```python
value = option(key="key", type='str', default="default_value", required=True, help="Set key value")
```

参数

- **key**: 参数的键。
- **type**: 要转换的参数类型。
- **default**: 参数默认值。
- **required**: 当未提供参数和缺省值，且参数的 required 为 True 时报告错误。
- **help**: 帮助信息。

### 多文件编译

除了上面的 KCL 单文件执行之外，我们还可以使用以下命令同时编译多个 KCL 入口文件：

```bash
kcl main_1.k main_2.k ... main_n.k
```

main_1.k

```python
a = 1
b = 2
```

main_2.k

```python
c = 3
d = 4
```

输出结果为：

```yaml
a: 1
b: 2
c: 3
d: 4
```

利用**多文件编译**，我们可以组合多个 KCL 文件，而无需使用 import 管理文件。 我们来看一个结合**多文件编译**和 **schema 实例**的例子。

model.k

```python
schema Model:
    name: str
    labels?: {str:}
    annotations?: {str:}
    replicas: int

_model1 = Model {
    name = "model1"
    labels.key1 = "value1"
    labels.key2 = "value2"
    annotations.key = "value"
    replicas = 2
}

_model2 = Model {
    name = "model2"
    replicas = 3
}
```

backend.k

```python
import manifests

schema Backend:
    apiVersion: str = "v1"
    kind: str = "Deployment"
    metadata: {str:}
    spec: {str:} = {
        minReadySeconds = 0
        paused = False
        progressDeadlineSeconds = 600
        replicas = 1
        revisionHistoryLimit = 10
        selector = {}
    }

_backends = [Backend {
    metadata.name = model.name
    metadata.labels = model.labels
    metadata.annotations = model.annotations
    spec.selector.matchLabels: model.labels
    spec.replicas = model.replicas
} for model in Model.instances()]  # Schema Model is defined in model.k

manifests.yaml_stream(_backends)
```

命令为：

```bash
kcl model.k backend.k
```

输出为：

```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: model1
  labels:
    key1: value1
    key2: value2
  annotations:
    key: value
spec:
  minReadySeconds: 0
  paused: false
  progressDeadlineSeconds: 600
  replicas: 2
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      key1: value1
      key2: value2
---
apiVersion: v1
kind: Deployment
metadata:
  name: model2
spec:
  minReadySeconds: 0
  paused: false
  progressDeadlineSeconds: 600
  replicas: 3
  revisionHistoryLimit: 10
  selector: {}
```

### KCL 变量查询

我们可以在 KCL CLI 使用 `-S|--path-selector` 参数从 KCL 模型中查询一个或多个值。

变量查询形式如下：

`var.name`

#### 示例

Code structure:

```bash
.
├── kcl.mod
└── main.k
    └── pkg
        └── model.k
```

pkg/model.k:

```python
schema Person:
    name: str
    age: int

var = Person {
    name = "Alice"
    age = 18
}
```

main.k

```python
import pkg

var = pkg.Person {
    name = "Bob"
    age = 10
}
```

命令为：

```bash
kcl main.k -S var
```

输出结果为：

```yaml
var:
  name: Bob
---
var:
  name: Alice
  age: 18
```

### KCL 变量修改

除了变量查询，KCL 还允许我们通过 KCL CLI 的 `-O|--overrides` 参数直接修改配置模型中的值。

变量修改参数的使用与变量查询类似，参数包含三部分，如 `pkg`、`identifier`、`attribute` 和 `override_value` .

```bash
kcl main.k -O override_spec
```

- `override_spec`: 表示需要修改的配置模型字段和值的统一表示

```bash
override_spec: identifier (("=" | ":" | "+=") value | "-")
```

- `identifier`: 表示需要修改配置的标识符，通常为 `a.b.c` 或者 `a["dot.key"].c` 的形式
- `value`: 表示需要修改配置的值，可以是任意合法的 KCL 表达式，比如数字/字符串字面值，list/dict/schema 表达式等
- `=`, `-` 和 `+=`: 表示用对应的属性运算符修改 identifier 的值
  - 当 identifier 存在时，修改已有 identifier的值为 value
  - 当 identifier 不存在时，添加 identifier属性，并将其值设置为 value
- `-`: 表示删除 identifier属性
  - 当 identifier 存在时，直接进行删除
  - 当 identifier 不存在时，对配置不作任何修改

请注意，当 `identifier` 出现多次时，修改/删除全部 `identifier` 的值

此外，在 KCL 中还提供了 API 用于变量查询和修改，详见 [API 文档](../xlang-api/go-api.md)

#### 示例

##### 修改示例

KCL 代码：

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

命令为：

```bash
kcl main.k -O :person.name=Bob -O :person.age=10
```

输出结果为：

```yaml
person:
  name: Bob
  age: 10
```

此外，当我们使用 KCL CLI `-d` 参数时，KCL 文件将同时修改为以下内容

```bash
kcl main.k -O :person.name=Bob -O :person.age=10 -d
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

##### 删除示例

KCL 代码：

```python
schema Config:
    x?: int = 1
    y?: str = "s"

config = Config {
    x = 2
}
```

命令为：

```bash
kcl main.k -O config.x-
```

输出结果为：

```yaml
config:
  y: s
```

### 总结

本页总结了 KCL 语言中的常用功能。 KCL 作为一种新的语言，会根据配置场景的需求，逐步增加功能特性。
