---
title: "KCL Tour"
sidebar_position: 1
---

This page shows how to use major KCL features, from variables and operators to schemas and libraries, with the assumption that you have already known how to program in another language. KCL is mainly inspired by Python, and knowing Python is very helpful for learning KCL.

### Important Concepts

As we learn about the KCL language, keep these facts and concepts in mind:

- KCL is a configuration and policy language. It provides simplified and self-contained language design and library support for writing configurations and policies. It cannot be used for application development or other purposes supported by General Purpose Language (GPL).
- KCL absorbs classic **OOP** elements and provides simple, developer-friendly and reliable configuration writing practice with **type**, **reusing**, and **union**.
- KCL prefers **immutability** and recommend to add up incremental updates through the **union**. Immutability reduces side effects like unpredictable issues.
- KCL **schema** struct defines strict attributes, static types, and it also supports validation expressions. The **schema** struct is mainly composed of typed attributes, the schema context and the check block.
- KCL **config** is a **json**-like expression, by which we can reuse a full definition of the schema. KCL provides support for definition and configuration by separating schema and config.
- KCL **rule** is a structure for writing rule constraint expressions, which can be used for data verification and policy writing.
- KCL code files are managed as packages(directories) and modules(files). The schema types in the same package are visible to each other; the data cross packages need to be imported through the **import statement**. The package-level variables can be exported, but they are immutable for other packages.
- The KCL syntax definition mainly uses declarative expressions, and only provides a small number of necessary and imperative statements, such as import, if .. else, assert, assignment and schema.
- No main function, each `.k` file could be executed as a separate configuration.
- **Built-in functions** and **plugins** are supported to simplify coding.

### Keywords

The following table lists the words that the KCL language treats specially.

```txt
True       False      None        Undefined   import
and        or         in          is          not
as         if         else        elif        for
schema     mixin      protocol    check       assert
all        any        map         filter      lambda
rule
```

### Identifiers

In KCL, an identifier is a name, may with selectors, that identifies a value.

- Identifiers consist of letters, numbers, underscores or the prefix `$`.
- Identifiers cannot be repeated with keywords unless they have a `$` prefix.
- Identifiers must not contain any embedded spaces or symbols.
- Letters and underscores can be used anywhere in the identifier.
- Numbers cannot be placed in the first place of the identifier.
- The `$` character can only be placed in the first position of the identifier.

Examples:

```python
x
a
b1
b_2
_c
$if
```

To simplify the definition of the qualified identifier, such as `pkg.type`, we additionally define `qualified identifier`:

Examples:

```python
pkg.a
```

The package name in `qualified identifier` must be imported.

#### Identifier Prefix

Use the `$` character prefix to define keyword identifiers.

```python
$if = 1
$else = "s"
```

Please note: whether the non-keyword identifier is prefixed with `$` has the same effect.

```python
_a = 1
$_a = 2  # equal to `_a = 2`
```

### Variables

Here’s an example of how to create a variable and initialize it:

```python
name = "Foo"  # Declare a variable named `name` and its value is a string literal "Foo"
```

It corresponds to the following YAML output:

```yaml
name: Foo
```

In KCL, we can export variables as config data by defining package-level variables. To make it direct, clear, and maintainable. Exported variables are immutable so that once we declare it, we can't modify it. For example, assume we have a config file named `example.k`, the variable `name` can't be modified after the declaration, just like the standard imperative language.

```python
name = "Foo"  # exported

...

name = "Bar"  # error: a exported declaration variable can only be set once.
```

As a complement, we can define a non-exported variable in module level which is mutable, which won't show up in YAML output:

```python
_name = "Foo"  # _ variables are not output to YAML and are mutable
_name = "Bar"
```

Please note that the variable name cannot be one of `True`, `False`, `None`, `Undefined` because of ambiguity.

```python
False = 1  # Error
True = False  # Error
None = Undefined  # Error
Undefined = None  # Error
```

### Built-in Types

The KCL language has special support for the following types:

- number
- string
- boolean
- list
- dict

#### Number

KCL number comes into two flavors:

- **Int**: 64 bits signed integer values. Values can be from -9223372036854775808~9223372036854775807.
- **Float**: 64-bit floating-point numbers, as specified by the IEEE 754 standard. We do not recommend using the float type in the configuration, we can use a string instead and parse it during runtime processing.

Both int and float support basic operators such as `+`, `-`, `/`, and `*`, while complex operations, such as `abs()`, `ceil()`, and `floor()`, are supported through the built-in math library.

Integers are numbers without a decimal point. Here are some examples of defining integer literals:

```python
a = 1
b = -1
c = 0x10 # hexadecimal literal
d = 0o10 # octal literal
e = 010  # octal literal
f = 0b10 # binary literal
g = int("10") # int constructor
```

If a number includes a decimal point, it is a float number. Here are some examples of defining float literals:

```python
a = 1.10
b = 1.0
c = -35.59
d = 32.3e+18
f = -90.
h = 70.2E-12
i = float("112") # float constructor
```

Built-in math libraries can be used with numbers:

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

In addition, please note that the KCL number is 64-bit by default. We can perform a stricter 32-bit range check by adding the `-r` parameter to the KCL command-line tool.

```bash
kcl main.k -r -d
```

Please note that the value range check is only enabled in `debug` mode

##### Units

In KCL, we can add a unit suffix to an integer denomination to indicate that it does not affect its true value as follows.

- General integer or fixed-point number form: `P`, `T`, `G`, `M`, `K`, `k`, `m`, `u`, `n`
- Corresponding power of 2: `Pi`, `Ti`, `Gi`, `Mi`, `Ki`

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

Besides, And we can also use the unit constants defined in the `units` module as follows:

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

We can also use the methods in the `units` module to convert between integers and unit strings.

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

The unit value type is defined in the units module, and the unit value type does not allow any four calculations.

```python
import units

type NumberMultiplier = units.NumberMultiplier

x0: NumberMultiplier = 1M  # Ok
x1: NumberMultiplier = x0  # Ok
x2 = x0 + x1  # Error: unsupported operand type(s) for +: 'number_multiplier(1M)' and 'number_multiplier(1M)'
```

We can use the `int()`, `float()` function and `str()` function to convert the numeric unit type to the normal integer type and string type.

```python
a: int = int(1Ki)  # 1024
b: float = float(1Ki)  # 1024.0
c: str = str(1Mi)  # "1Mi"
```

#### String

The string is an immutable sequence of Unicode characters. We can use either single or double quotes to create a string:

```python
'allows embedded "double" quotes'  # Single quotes
"allows embedded 'single' quotes"  # Double quotes
'''Three single quotes''', """Three double quotes"""  # Triple quoted
```

Triple quoted strings may span multiple lines.

```python
"""This is a long triple quoted string
may span multiple lines.
"""
```

Please note that there is almost no difference in the use of KCL single-quoted and double-quoted strings. The only thing that can be simplified is that we don’t need to escape double quotes in single quoted strings, and we don’t need to escape single quotes in double quoted strings.

```python
'This is my book named "foo"'  # Don’t need to escape double quotes in single quoted strings.
"This is my book named 'foo'"  # Don’t need to escape single quotes in double quoted strings.
```

We can concatenate strings using the `+` operator:

```python
x = 'The + operator ' + 'works, as well.'
```

We can cast an int or float to a string using the built-in function `str`:

```python
x = str(3.5) # "3.5"
```

A lot of handy built-in functions and members of a string could be used:

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

There are 2 different ways to format a string: to use the `"{}".format()` built-in function, or to specify the variable between the curly braces and use a `$` mark to tell KCL to extract its value. This is called **string interpolation** in KCL. In following example, both `a` and `b` will be assigned to string `"hello world"`.

Besides, the variable to serialized can be extracted in special data format, such as YAML or JSON. In this case, a `#yaml` or `#json` can be included within the curly braces.

Specifically, when the dollar sign `$` itself is needed in a **string interpolation**, it needs to be escaped and use `$$` instead. Or in another way, `+` can be used to concat the dollar sign with the **string interpolation** to avoid that escape. In following example, both `c` and `c2` will be assigned to string `$hello world$`

```python
world = "world"
a = "hello {}".format(world)       # "hello world"
b = "hello ${world}"               # "hello world"
c = "$$hello ${world}$$"           # "$hello world$"
c2 = "$" + "hello ${world}" + "$"  # "$hello world$"

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

Besides, we can see some symbols in the example code output **YAML string** above such as `|`, `>`, `+`, `-`.

- `|` denotes the **block literal style** that indicates how newlines inside the block should behave.
- `>` denotes the **block folded style** in the block scalar that the newlines will be replaced by spaces.
- `+` and `-` are the **block chomping indicators** that control what should happen with newlines at the end of the string. The default value **clip** puts a single newline at the end of the string. To remove all newlines, **strip** them by putting a `-` after the style indicators `|` or `>`. Both clip and strip ignore how many newlines are actually at the end of the block; to **keep** them all put a `+` after the style indicator.

For example, a **strip block literal style** yaml string is

```yaml
example: |-
  Several lines of text,
  with some "quotes" of various 'types',
  and also a blank line:

  plus another line at the end.
```

The result is

```plain
Several lines of text,
with some "quotes" of various 'types',
and also a blank line:

plus another line at the end.
```

See [Yaml Multiline String](https://yaml-multiline.info/) and [YAML Specification v1.2](https://yaml.org/spec/1.2.1/) for more information.

##### Raw String

KCL raw string is created by prefixing a string literal with `'r'` or `'R'`. KCL raw string treats backslash (`\`) and string interpolation (`${}`) as a literal character. This is useful when we want to have a string that contains backslash, string interpolation and don’t want them to be treated as an escape character.

- For backslash (`\`), the KCL code and output YAML are as follows:

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

- For string interpolation (`${}`), the KCL code and output YAML are as follows:

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

In addition, the most common scenario for raw strings is to be used with regular expressions:

```python
import regex

key = "key"
result = regex.match(key, r"[A-Za-z0-9_.-]*")  # True
```

#### Boolean

Boolean values are the two constant objects `False` and `True`.

```python
a = True
b = False
```

#### List

The list is a sequence, typically used to store collections of homogeneous items. Here’s a simple KCL list:

```python
list = [1, 2, 3]
assert len(list) == 3  # True
assert list[0] == 1  # True
```

We can declare a list with list comprehension:

```python
list = [ _x for _x in range(20) if _x % 2 == 0]
assert list == [0, 2, 4, 6, 8, 10, 12, 14, 16, 18] # True
```

We can perform nested list comprehension:

```python
matrix = [[1, 2], [3,4], [5,6], [7,8]]
transpose = [[row[_i] for row in matrix] for _i in range(2)]
assert transpose == [[1, 3, 5, 7], [2, 4, 6, 8]] # True
```

Besides, we can use two variables in the list comprehension, the first variable denotes the list index and the second variable denotes the list item.

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

We can merge list like this:

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
joined_list = _list0 + _list1  # [1, 2, 3, 4, 5, 6]
```

We can also use the list unpacking operator `*` to merge multiple lists:

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
union_list = [*_list0, *_list1]  # [1, 2, 3, 4, 5, 6]
```

We can use `if expressions` to dynamically add elements to the list element, elements that meet the conditions are added to the list, and elements that do not meet the conditions are ignored.

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

Please note that in the above `if expressions`, nested use is not supported.

We can union two lists like this:

```python
_list0 = [1, 2, 3]
_list1 = [4, 5, 6]
union_list = _list0 | _list1  # [4, 5, 6]
```

We can use the expression `for k in list_var` to traverse a list.

```python
data = [1, 2, 3]
dataAnother = [val * 2 for val in data]  # [2, 4, 6]
```

#### Dict

Dict is a mapping object that maps hashable values to arbitrary objects. Dict is ordered. The order of the keys follows the order of their declaration.

Here are a couple of simple KCL dict, created using dict literals:

```python
a = {"one" = 1, "two" = 2, "three" = 3}
b = {'one' = 1, 'two' = 2, 'three' = 3}
assert a == b # True
assert len(a) == 3 # True
```

We can ignore the comma `,` at the end of the line for writing dict key-value pairs in multiple lines:

```python
data = {
    "key1" = "value1"  # Ignore the comma ',' at the end of line
    "key2" = "value2"
}  # {"key1": "value1", "key2": "value2"}
```

We can ignore the key quotation marks when we writing simple literals on the key.

```python
data = {
    key1 = "value1"  # Ignore key quotation '"'
    key2 = "value2"
}  # {"key1": "value1", "key2": "value2"}
```

In addition, the **config selector expressions** can be used to init a dict instance with nested keys.

```python
person = {
    base.count = 2
    base.value = "value"
    labels.key = "value"
}  # {"base": {"count": 2, "value": "value"}, "labels": {"key": "value"}}
```

The output YAML is

```yaml
person:
  base:
    count: 2
    value: value
  labels:
    key: value
```

In KCL, different fields in dict can be referenced, such as the following example.

```python
config = {
    name = "me"
    metadata.name = name  # Reference `name` with the value `"me"` in `config` directly.
}
```

The output YAML is

```yaml
config:
  name: me
  metadata:
    name: me
```

We can declare a dict with dict comprehension:

```python
x = {str(i): 2 * i for i in range(3)}
assert x == {"0" = 0, "1" = 2, "2" = 4}
```

Besides, we can use two variables in the dict comprehension, the first variable denotes the dict key and the second variable denotes the dict value of the key.

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

We can **merge** dict using the dict unpacking operator `**` like this:

```python
_part1 = {
    a = "b"
}

_part2 = {
    c = "d"
}

a_dict = {**_part1, **_part2}  # {"a: "b", "c": "d"}
```

In addition, the same effect can be achieved by using the union operator `|`:

```python
_part1 = {
    a = "b"
}

_part2 = {
    c = "d"
}

a_dict = _part1 | _part2  # {"a: "b", "c": "d"}
```

We can use `if expressions` to dynamically add elements to the dict element, elements that meet the conditions are added to the dict, and elements that do not meet the conditions are ignored.

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

We can use the expression `for k in dict_var` to traverse a dict, and we can use the `in` operator to determine whether a dict contains a certain key

```python
data = {key1 = "value1", key2 = "value2"}
dataAnother = {k: data[k] + "suffix" for k in data}  # {"key1": "value1suffix", "key2": "value2suffix"}
containsKey1 = "key1" in data  # True
containsKey2 = "key" in data  # False
```

#### None

In KCL, `None` can indicate that the value of the object is empty, which is similar to `nil` in Go or `null` in Java, and corresponds to `null` in YAML.

```python
a = None
b = [1, 2, None]
c = {key1 = value1, key2 = None}
```

The output is as follows:

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

Please note that `None` cannot participate in the four arithmetic operations, but it can participate logical operators and comparison operators to perform calculations.

```python
a = 1 + None  # error
b = int(None)  # error
c = not None  # True
d = None == None  # True
e = None or 1  # 1
f = str(None)  # None
```

#### Undefined

`Undefined` is similar to `None`, but its semantics is that a variable is not assigned any value and will not be output to YAML

```python
a = Undefined
b = [1, 2, Undefined]
c = {key1 = "value1", key2 = Undefined}
```

The output is as follows:

```yaml
b:
  - 1
  - 2
c:
  key1: value1
```

Please note that `Undefined` cannot participate in the four arithmetic operations, but it can participate logical operators and comparison operators to perform calculations.

```python
a = 1 + Undefined  # error
b = int(Undefined)  # error
c = not Undefined  # True
d = Undefined == Undefined  # True
e = Undefined or 1  # 1
f = str(Undefined)  # Undefined
```

### Operators

The following character sequences represent operators:

```txt
+       -       *       **      /       //      %
<<      >>      &       |       ^       <       >
~       <=      >=      ==      !=      @       \
```

#### Arithmetic Operators

KCL supports the common arithmetic operators:

```python
assert 2 + 3 == 5
assert 2 - 3 == -1
assert 2 * 3 == 6
assert 5 / 2 == 2.5
assert 5 // 2 == 2
assert 5 % 2 == 1
```

#### Equality and Relational Operators

KCL supports the meanings of equality and relational operators:

```python
assert 2 == 2
assert 2 != 3
assert 3 > 2
assert 2 < 3
assert 3 >= 3
assert 2 <= 3
```

#### Logical Operators

We can invert or combine boolean expressions using the logical operators e.g., `and` and `or`:

```python
if not done and (col == 0 or col == 3):
  # ...Do something...

```

#### Bitwise and Shift Operators

Here are examples of using bitwise and shift operators:

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

The `|` operator likewise computes bitwise, unions basic types and unions collection and schema data, such as **list**, **dict** and **schema**.

Computing bitwise examples:

```python
0x12345678 | 0xFF  # 0x123456FF
```

Unioning basic types examples:

```python
schema x:
    a: int | str  # attribute a could be a int or string
```

#### Assignment Operators

The following tokens serve as delimiters in the grammar:

```bash
    (       )       [       ]       {       }
    ,       :       .       ;       =       ->
    +=      -=      *=      /=      //=     %=
    &=      ^=      >>=     <<=     **=
```

The following examples use assignment and argument assignment operators:

```python
_a = 2
_a *= 3
_a += 1
assert _a == 7
```

#### Identity Operators

The following keywords serve as identity operators in the grammar:

```python
is, is not
```

The identity operators check whether the right hand side and the left hand side are the very same object. They are usually used to check if some variable is `None/Undefined/True/False`. Here are some examples:

```python
empty_String = ""
empty_String is not None # True
```

#### Membership Operators

The following keywords serve as membership operators in the grammar:

```python
in, not in
```

- The `in` operator reports whether its first operand is a member of its second operand, which must be a list, dict, schema, or string.
- The `not in` operator is its negation. Both return a Boolean.

The meaning of membership varies by the type of the second operand: the members of a list are its elements; the members of a dict are its keys; the members of a string are all its substrings.

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

#### Comprehension

A comprehension constructs a new list or dictionary value by looping over one or more iterables and evaluating a body expression that produces successive elements of the result.

We can declare list and dict by comprehension as:

```python
listVar = [_x for _x in range(20) if _x % 2 == 0] # list comprehension
dictVar = {str(_i): 2 * _i for _i in range(3)} # dict comprehension
```

#### Other Operators

We can:

- Represents a function call with **()**, like `"{} {}".format("hello", world)`
- Refers to the value at the specified index in the list with **[]**
- Define a type hint with **:**
- Refers to a member field with **.**
- Use the line continuation symbol `\` to write long expressions

```python
longString = "Too long expression " + \
             "Too long expression " + \
             "Too long expression "
```

### Expressions

#### Conditional Expressions

A conditional expression has the form `a if cond else b`. It first evaluates the condition `cond`. If it's true, it evaluates `a` and yields its value; otherwise, it yields the value of `b`.

Examples:

```python
x = True if enabled else False  # If enabled is True, x is True, otherwise x is False
```

#### Index Expressions

An index expression `a[i]` yields the `i` th element of an indexable type such as a string or list. The index `i` must be an `int` value in the range `-n` ≤ `i` < `n`, where `n` is `len(a)`; any other index results in an error.

A valid negative index `i` behaves like the non-negative index `n+i`, allowing for convenient indexing relative to the end of the sequence.

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

An index expression `d[key]` may also be applied to a dictionary `d`, to obtain the value associated with the specified key. It returns `Undefined` if the dictionary contains no such key.

An index expression appearing on the left side of an assignment causes the specified list or dictionary element to be updated:

```python
d = {key1 = "value1", key2 = "value2"}
key1value = d["key1"]  # value1
key2value = d["key2"]  # value2
```

It is a dynamic error to attempt to update an element of an immutable type, such as a list or string, or a frozen value of a mutable type.

#### Slice Expressions

A slice expression `a[start:stop:step]` yields a new value containing a sub-sequence of `a`, which must be a string, or list.

Each of the `start`, `stop`, and `step` operands is optional; if present, each must be an integer. The `step` value defaults to 1. If the step is not specified, the colon preceding it may be omitted too. It is an error to specify a step of zero.

Conceptually, these operands specify a sequence of values `i` starting at start and successively adding 'step' until `i` reaches or passes `stop`. The result consists of the concatenation of values of `a[i]` for which `i` is valid.

The effective start and stop indices are computed from the three operands as follows. Let `n` be the length of the sequence.

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

It's not allowed to define a slice expression as a left value in KCL. Cause list and string are immutable, re-slicing can directly operate to operand to ensure better performance.

#### Function Invocations

KCL allows calling built-in functions and functions from built-in and system modules.

To call a function, the basic way is shown as the following code excerpt:

```python
import math

a = math.pow(2, 3)  # 2 powers 3 is 8.
b = len([1, 2, 3])  # the length of [1, 2, 3] is 3
```

As you can see, arguments are separated with `,`, and KCL also supports positional arguments and key-value arguments.

```python
print("hello world", end="")
```

Note that:

- Some functions have parameters with default values.
- Some functions accept variadic arguments.

When an argument is not supplied for a parameter without a default value, an error will be reported.

#### Selector Expressions

A selector expression selects the attribute or method of the value. KCL provides a wealth of ways to identify or filter attributes.

`x.y`

- dict: it denotes the value of the key `y` in the dict `x`
- schema: it denotes the attribute value of a schema `x` identified by `y`
- package: it denotes the identifier of a package `x` identified by `y`

Examples:

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

`x` can be a schema instance or a dict. This is extremely helpful when the value of `x` might be `None` or when the key `y` might not exist in `x`.

```python
# Example of dict:
data = {key = "value"}
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

#### Quantifier Expressions

Quantifier expressions act on collection: list or dict, generally used to obtain a certain result after processing the collection, mainly in the following four forms:

- **all**
  - Used to detect that all elements in the collection satisfy the given logical expression, and return a boolean value as the result.
  - Only when all elements in the collection satisfy the expression true, the `all` expression is true, otherwise it is false.
  - If the original collection is empty, return true.
  - Supports short-circuiting of logical expressions during expression execution.
- **any**
  - Used to detect that at least one element in the collection satisfies the given logical expression, and returns a boolean value as the result.
  - When at least one element in the collection satisfies the expression true, the `any` expression is true, otherwise it is false.
  - If the original collection is empty, return false.
  - Supports short-circuiting of logical expressions during expression execution.
- **map**
  - Generate a new **list** by mapping the elements in the original collection.
  - The length of the new list is exactly the same as the original collection.
- **filter**
  - By logically judging and filtering the elements in the original collection, and returning the filtered sub-collection.
  - Only when the element judges the expression to be true, it is added to the sub-collection.
  - The type (list, dict and schema) of the new collection is exactly the same as the original collection, and the length range is `[0, len(original-collection)]`.

**all** and **any** expression sample codes:

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

**map** and **filter** expression sample codes:

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

Please pay attention to distinguish the difference between any expression and any type. When `any` is used in type annotations, it means that the value of the variable is arbitrary, while the any expression means that one of the elements in a set satisfies the condition.

### Control Flow Statements

#### If and Else

KCL supports `if` statements with optional `elif` and `else` statements, as the next sample shows.

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

The `elif` example:

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

`if-elif-else` statements can be nested. For example:

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

In addition, for simple `if` statements as follows:

```python
if success:
    _result = "success"
else:
    _result = "failed"
```

We can have it in one line using the `<expr> if <condition> else <expr>` pattern:

```python
_result = "success" if success else "failed"
```

An `if` or `elif` statement evaluates a given expression. When the expression is evaluated to `True`, a list of statements following `:` are executed and when the expression is evaluated to `False` and statements will not be executed.

Please note that the false name constant `False`, `None`, the zero number `0`, the empty list `[]`, the empty dict `{}` and the empty string `""` are all seen as `False` expressions.

```python
_emptyStr = ""
_emptyList = []
_emptyDict = {}
isEmptyStr = False if _emptyStr else True
isEmptyList = False if _emptyList else True
isEmptyDict = False if _emptyDict else True
```

The output is

```yaml
isEmptyStr: true
isEmptyList: true
isEmptyDict: true
```

### Assert

When errors happen, developers should be able to detect the error and abort execution. Thus, KCL introduce the `assert` syntax. The following is an example:

```python
a = 1
b = 3
# a != b evaluates to True, therefore no error should happen.
assert a != b
# a == b is False, in the reported error message, the message "SOS" should be printed.
assert a == b, "SOS"
```

In addition, we can declare a condition for the assert statement and make an assertion when the condition is met. The usual way of writing is

```python
a = None
if a:
    assert a > 2:
```

In KCL, it can also be simplified to the following form using the **if** expression to compose more complex conditional assert logic:

```python
a = None
assert a > 2 if a
```

### Function

KCL supports using the lambda keyword to define a function.

```python
func = lambda x: int, y: int -> int {
    x + y
}
a = func(1, 1)  # 2
```

- The value of the last expression is used as the return value of the function, and the empty function body returns `None`.
- The return value type annotation can be omitted, and the return value type is the type of the last expression value.
- There is no order-independent feature in the function body, all expressions are executed in order.

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

The function type variables cannot participate in any calculations and can only be used in assignment statements and call statements.

```python
func = lambda x: int, y: int -> int {
    x + y
}
x = func + 1  # Error: unsupported operand type(s) for +: 'function' and 'int(1)'
```

The lambda function supports the capture of external variables, which can be passed as parameters of other functions.

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

The output is

```yaml
a: 1
r: 2
```

Further, we can define an anonymous function through lambda expression and call it.

```python
result = (lambda x, y {
    z = 2 * x
    z + y
})(1, 1)  # 3
```

We can also use anonymous functions in the for loop.

```python
result = [(lambda x, y {
    x + y
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 3, 3, 4]
```

Note that the functions defined in the KCL are pure functions:

- The return result of a function depends only on its arguments.
- There are no side effects in the function execution process.

Therefore, KCL functions cannot modify external variables, but can only reference external variables. For example, the following code will cause an error:

```python
globalVar = 1
func = lambda {
    x = globalVar  # Ok
    globalVar = 1  # Error
}
```

### Type System

#### Type Annotation

Type annotations can be used on top level variables, schema attributes and arguments.

- An attribute can be of a basic type, such as a string (`str`), a floating-point number (`float`), a fixed-point number (`int`) or a boolean (`bool`).
- An attribute can be a literal type, such as a string literal (`"TCP"` and `"UDP"`), a number literal (`"1"` and `"1.2"`), a boolean literal (`True` and `False`)
- An attribute can also be a list or an ordinary dict:
  - A list with unspecified type of elements is `[]`.
  - A list with elements of type `t` is `[t]`. Here `t` is another type.
  - A dict with keys of type `kt` and values of type `vt` is `{kt:vt}`.
  - `kt`, `vt` or both of them can be missing, like a list with unspecified type of elements.
- An attribute can be a **union type** defined by `|`, such as `a | b`, which means the type of the member could be a or b.
  - A union type can include any types of `int`, `str`, `float`, `bool`, `list`, `dict`, literal and schema type, and supports type nesting e.g. `{str:str|int}`, `[[int|str]|str|float]` and `2 | 4 | 6`, etc.
- An attribute can also be of a type generated from other schema. In such a case, the name of the other schema (including the package path prefix) is used as the type name.
- An attribute can annotated an any type e.g., `any`.

Examples:

- Basic type

```python
"""Top level variable type annotation"""
a: int = 1  # Declare a variable `a` that has the type `int` and the value `1`
b: str = "s"  # Declare a variable `b` that has the type `str` and the value `"s"`
c: float = 1.0  # Declare a variable `c` that has the type `float` and the value `1.0`
d: bool = True  # Declare a variable `d` that has the type `bool` and the value `True`
```

- List/Dict/Schema Type

```python
schema Person:
    name: str = "Alice"
    age: int = 10

a: [int] = [1, 2, 3]  # Declare a variable `a` that has the list type `[int]` and the value `[1, 2, 3]`
b: {str:str} = {k1 = "v1", k2 = "v2"}  # Declare a variable `b` that has the dict type `{str:str}` and the value `{k1 = "v1", k2 = "v2"}`
c: Person = Person {}  # Declare a variable `c` that has the schema type `Person` and the value `Person {}`
```

- Union Type

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

The compiler throws an error when the value of a property does not conform to the union type definition:

```python
# Literal union types
schema LiteralType:
    # String literal union types, x_01 can be one of "TCP" and "UDP"
    x_01: "TCP" | "UDP"

x = LiteralType {
    x_01 = "HTTP"  # Error: the type got is inconsistent with the type expected, expect str(TCP)|str(UDP), got str(HTTP)
}
```

- Any Type

```python
# Any type
schema Config:
    literalConf: any = 1
    dictConf: {str:any} = {key = "value"}
    listConf: [any] = [1, "2", True]

config = Config {}
```

In KCL, changing the type of a variable is not allowed. If the type is not satisfied when reassigning the value, the type error will be raised.

```python
_a = 1  # The type of `_a` is `int`
_a = "s"  # Error: expect int, got str(s)
```

The type of a variable can be assigned to its upper bound type, but cannot be assigned to its specialized type.

`None` and `Undefined` can be assigned to any type:

- All types can be assigned to `any` type, `None` and `Undefined` can be assigned to `any` type.

```python
a: int = None
b: str = Undefined
c: any = 1
d: any = "s"
e: any = None
```

- The `int` type can be assigned to the `float` type, and the `float` type cannot be assigned to the `int` type.

```python
a: float = 1
b: int = 1.0  # Error: expect int, got float(1.0)
```

- The `int` type can be assigned to the `int|str` type, and the `int|str` type cannot be assigned to the `int` type.

```python
a: int | str = 1
b: int = 1 if a else "s"  # Error: expect int, got int(1)|str(s)
```

Note that although the any type is provided in the KCl, it is still a static type, and the types of all variables are immutable during compilation.

#### Type Inference

If a variable or constant declaration in the top level or in the schema is not annotated explicitly with a type, the declaration's type is inferred from the initial value.

- Integer literals are inferred to type `int`.

```python
a = 1  # The variable `a` has the type `int`
```

- Float literals are inferred to type `float`.

```python
a = 1.0  # The variable `a` has the type `float`
```

- String literals are inferred to type `str`.

```python
a = "s"  # The variable `a` has the type `str`
```

- Boolean literals are inferred to type `bool`

```python
a = True  # The variable `a` has the type `bool`
b = False  # The variable `b` has the type `bool`
```

- `None` and `Undefined` are inferred to type `any`

```python
a = None  # The variable `a` has the type `any`
b = Undefined  # The variable `b` has the type `any`
```

- List literals are inferred based on the elements of the literal, and to be variable-size.

```python
a = [1, 2, 3]  # The variable `a` has the type `[int]`
b = [1, 2, True]  # The variable `b` has the list union type `[int|bool]`
c = ["s", 1]  # The variable `c` has the list union type `[int|str]`
```

Please note that a empty list will be inferred to `[any]`

```python
a = []  # The variable `a` has the type `[any]`
```

- Dict literals are inferred based on the keys and values of the literal, and to be variable-size.

```python
a = {key = "value"}  # The variable `a` has the type `{str:str}`
b = {key = 1}  # The variable `b` has the type `{str:int}`
c = {key1 = 1, key2 = "s"}  # The variable `c` has the type `{str:int|str}`
```

Please note that a empty dict will be inferred to `{any:any}`

```python
a = {}  # The variable `a` has the type `{any:any}`
```

- The type of the if conditional expression carrying the runtime value will be statically inferred as a union type of all possible results.

```python
a: bool = True  # The variable `a` has the type `bool`
b = 1 if a else "s"  # The variable `b` has the type `int|str`
```

When a variable is deduced to a certain type, its type cannot be changed

```python
_a = 1
_a = "s"  # Error: expect int, got str(1)
```

#### Type Alias

We can use the `type` keyword to declare a type alias for all types in KCL to simplify the writing and use of complex types.

```python
type Int = int
type String = str
type StringOrInt = String | Int
type IntList = [int]
type StringAnyDict = {str:}
```

We can import a type through import and define an alias for it.

```py
import pkg

type Data = pkg.Data
```

In addition, we can use type aliases and union types to achieve similar enumeration functions.

```python
# A type alias of string literal union types
type Color = "Red" | "Yellow" | "Blue"

schema Config:
    color: Color = "Red"  # The type of color is `"Red" | "Yellow" | "Blue"`, and it has an alias `Color`, whose default value is `"Red"`

config = Config {
    color = "Blue"
}
```

The output YAML is

```yaml
config:
  color: Blue
```

Please note that the type alias name cannot be one of `any`, `int`, `float`, `bool` and `str` because of ambiguity.

```python
type any = int | str  # Error
type int = str  # Error
type float = int  # Error
type bool = True  # Error
type str = "A" | "B" | "C"  # Error
```

#### Type Guards

KCL supports the `typeof` function which can give very basic information about the type of values we have at runtime. In KCL, checking against the value returned by `typeof` is a type guard. KCL expects this to return a certain set of strings:

Example:

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

In addition, we can use the `as` keyword in conjunction with type guards to complete defensive type conversion programming.

Only types with partial order can be downcast converted, the use of the as keyword is as follows:

- Basic types of partial order relations, e.g., `float -> int`
- Partial order relation of union type, e.g., `int | str -> str` and `[int | str] -> [str]`
- Contains the partial order relation of the upper bound of the type, e.g., `any -> int`
- Partial order relationship of structure type, e.g., `base-schema -> sub-schema`

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

When a runtime error occurs in the `as` type conversion, a runtime error is thrown.

```python
a: any = "s"
b: int = a as int  # Error: The `str` type cannot be converted to the `int` type
```

If we don’t want to throw a runtime error, we can use the type guard for defensive coding with `if` expressions.

```python
a: any = "s"
b = a as int if typeof(a) == "int" else None  # The type of b is `int`
```

Note that the `as` conversion of literal type and union type is not supported, because they are not a certain runtime object, only int, float and other objects at runtime, there is no int literal, float literal object, and no union object.

### Schema

#### Overview

A schema is a language element to define a complex configuration.
We can define typed attributes, initialization assignment, and verification rules. In addition, KCL supports schema single inheritance, mixin and protocol to realize the reuse of complex configuration.

#### Basic

##### Attribute

The followings are some basic examples:

```python
# A person has a first name, a last name and an age.
schema Person:
    firstName: str
    lastName: str
    # The default value of age is 0
    age: int = 0
```

In KCL, we can use type annotations to define some attributes in the schema, each attribute can be set with an optional default value (such as the `age` attribute in the above code, its default value is `0`), attributes that are not set default values have an initial value of `Undefined`, which are not output in YAML.

Note, the immutability of attributes in the schema follows the same rules as the immutability of global variables, only mutable attributes in the schema can be modified in the schema.

```python
schema Person:
    age: int = 1  # Immutable attribute
    _name: str = "Alice"  # Mutable attribute

    age = 10  # Error
    _name = "Bob"  # Ok
```

###### Optional Attribute

Each attribute **must** be assigned with a not `None`/`Undefined` value as a schema instance unless it is modified by a question mark as an optional attribute.

Examples:

```python
schema Employee:
    bankCard: int  # bankCard is a required attribute, and it can NOT be None or Undefined
    nationality?: str  # nationality is an optional attribute, and it can be None or Undefined

employee = Employee {
    bankCard = None  # Error, attribute 'bankCard' of Employee is required and can't be None or Undefined
    nationality = None  # Ok
}
```

##### Irrelevant Order Calculation

The irrelevant order calculation in the schema indicates the reference relationship between the internal attributes of the schema. For example, when we declare an expression of the form `a = b + 1`, the calculation of the value of `a` depends on the calculation of the value of `b`. When the compiler calculate the value of `a` and the value of `a` depends on the value of `b`, the compiler will choose to first calculate the value of `b`, and then calculate the value of a according to the expression `a = b + 1`, which is slightly different from the calculation method of traditional procedural language the difference.

Since the calculation of values in the schema is based on dependencies, just like a directed acyclic graph traverses each node in the graph according to the order of topological sorting, the order of declaration of attributes in the schema is not so important, so the feature is called the irrelevant order calculation.

Please note that there can be no circular references between different schema attribute values.

We can see this feature through the following examples.

```python
schema Fib:
    n1: int = n - 1  # Refers to the attribute `n` declared after `n1`
    n2: int = n1 - 1
    n: int
    value: int = 1 if n <= 2 else Fib {n = n1}.value + Fib {n = n2}.value

fib8 = Fib {n = 8}.value
```

The output is

```yaml
fib8: 21
```

We can see that in the schema, we only need to simply specify the dependency between attributes, and the compiler will automatically calculate the value based on the dependency, which can help us save a lot of boilerplate code and reduce configuration difficulty of writing.

##### Schema Context

We can define the context of the schema to manage the attributes of the schema, and we can write schema parameters, temporary variables and expressions directly in the schema:

```python
schema Person[_name: str]:  # define a schema argument
    name: str = _name     # define a schema attribute
    age: int = 10         # define a schema attribute with default value
    hands: [int] = [i for i in [1, 2, 3]] # define a for statement
```

##### Validation

In addition to using **static typing** (the type annotation) and **immutability** in KCL schema mentioned earlier to ensure code stability, a bunch of validation rules are supported in a simple **check** block (KCL supports almost all authentication capabilities of [OpenAPI](https://www.openapis.org/)):

```python
import regex

schema Sample:
    foo: str
    bar: int
    fooList: [str]

    check:
        bar > 0  # minimum, also support the exclusive case
        bar < 100  # maximum, also support the exclusive case
        len(fooList) > 0  # min length, also support exclusive case
        len(fooList) < 100  # max length, also support exclusive case
        regex.match(foo, "^The.*Foo$")  # regex match
        isunique(fooList)  # unique
        bar in range(100)  # range
        bar in [2, 4, 6, 8]  # enum
        multiplyof(bar, 2)  # multipleOf
```

With the schema, all instances will be validated at compile time

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

In addition, we can use **and**, **or**, **if** to compose more complex conditional check logic:

```python
schema Sample:
    bar: int
    foo: str
    doCheck: bool

    check:
        regex.match(foo, "^The.*Foo$") and bar in [2, 4, 6, 8] if doCheck
```

In order to ensure that all check rules can play their corresponding roles well, we can test the rationality and correctness of different data combinations by writing KCL test cases, and run all test cases through the kcl test tool.

##### Documents

Usually after we write the schema model, we will write documentation comments for the schema, which can be completed by using a three-quoted string as follows:

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

##### Config

Suppose we have the following schema definition:

```python
schema Person:
    firstName: str
    lastName: str
```

A config could be defined with a JSON-like expression:

```python
person = Person {
    firstName = "firstName"
    lastName = "lastName"
}
```

At the same time, the schema adheres to strict attribute definitions,
and configuring undefined attributes will trigger a compilation error.

```python
person = Person {
    firstName = "firstName"
    lastName = "lastName"
    fullName = "fullName"  # Error: Cannot add member 'fullName' to schema 'Person', 'fullName' is not defined in schema 'Person'
}
```

We can use `if expressions` to dynamically add elements to the schema config, elements that meet the conditions are added to the schema config, and elements that do not meet the conditions are ignored. Besides, the **config selector expressions** can be used to init a schema instance.

```python
schema Base:
    count: int
    value: str

schema Person:
    base: Base
    labels: {str:str}
    name?: str

env = "prod"

person1 = Person {
    base.count = 2  # Config selector expression
    base.value = "value"  # A schema variable in schema can use selector expressions
    labels.key = "value"  # A dict variable in schema can use selector expressions
}

person2 = Person {
    base = {
        count = 1
        value = "value"
    }
    labels.key = "value"
    if env == "prod":
        labels.env = env
    else:
        labels.env = "other"
}
```

The output YAML is

```yaml
person1:
  base:
    count: 2
    value: value
  labels:
    key: value
person2:
  base:
    count: 1
    value: value
  labels:
    key: value
    env: prod
```

When we instantiate a schema without config parameters, we can generate schema instances in the following three forms:

```python
schema Data:
    id: int = 1

data1 = Data {}
data2 = Data() {}
data3 = Data()
```

In addition to using a schema type to instantiate a schema, we can also use a schema instance to get a new instance using the config expression.

```python
schema Config:
    id: int
    values: [int]

configOrigin = Config {
    id = 1
    values = [0, 1]
}
configNew = configOrigin {
    id = 2
    values += [2, 3]
}
```

The output is

```yaml
configOrigin:
  id: 1
  values:
    - 0
    - 1
configNew:
  id: 2
  values:
    - 0
    - 1
    - 2
    - 3
```

In addition, schema attribute default values can be modified by schema config.

```python
schema Person:
    age: int = 1
    name: str = "Alice"

    age = 2  # Error, can't change the default value of the attribute `age` in the schema context

person = Person {
    age = 3  # Ok, can change the default value of the attribute `age` in the schema config
}
```

#### Advanced

##### Protocol & Mixin

In addition to schema, an additional type definition method `protocol` is provided in KCL, and its properties are as follows:

- In a protocol, only attributes and their types can be defined, complex logic and check expressions cannot be written, and mixins cannot be used.
- A protocol can only constrain properties that do not start with `_`.
- A protocol can only inherit or refer to other protocols, but cannot inherit or refer to other schemas.

Besides, we can declare a complex assembly schema with optional **mixin** support and use **protocol** to add an optional host type to the dynamically inserted **mixin**.:

```python
schema Person:
    mixin [FullNameMixin]

    firstName: str  # Required
    lastName: str  # Required
    fullName?: str  # Optional
```

A fullName mixin which generates a fullName as a simple sample:

```python
protocol PersonProtocol:
    firstName: str
    lastName: str
    fullName?: str

mixin FullNameMixin for PersonProtocol:
    fullName = "{} {}".format(firstName, lastName)
```

Then we can get the schema instance by:

```python
person = Person {
    firstName = "John"
    lastName = "Doe"
}
```

The output is

```yaml
person:
  firstName: John
  lastName: Doe
  fullName: John Doe
```

Please note that the host type **protocol** can only be used for **mixin** definitions (the suffix name is `Mixin`), otherwise an error will be reported.

```python
protocol DataProtocol:
    data: str

schema Data for DataProtocol:  # Error: only schema mixin can inherit from protocol
    x: str = data
```

##### Index Signature

Index signatures can be defined in the KCL schema, and it means that the key-value constraints of the index signature can be used to construct a dict with the schema type, or additional checks can be added to the schema attributes to enhance the KCL type and semantic checks.

- Use the form `[{attr_alias}: {key_type}]: {value_type}` to define an index signature in the schema, and `{attr_alias}` can be omitted.

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

- Mandatory all attributes of the schema key and value types

```python
schema Person:
    name: str
    age: int  # error, conflicts with the index signature definition `[str]: str`
    [str]: str  # The values of all attributes of the schema can only be strings
```

- Mandatory all attribute key and value types are defined in the schema, which is equivalent to restricting all attribute types except the additional attributes.

```python
schema Person:
    name: str
    age: int
    [...str]: str  # Except for the `name` and `age` attributes, the key type of all other attributes of the schema must be `str`, and the value type must also be `str`.
```

- Define the index signature attribute alias and use it in its default value.

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

The output is

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

- Define the index signature attribute alias and use it with the check block.

```python
schema Data:
    [dataName: str]: str
    check:
        dataName in ["Alice", "Bob", "John"]

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

##### Inheritance

Like some other object-oriented languages, KCL provides fundamental but limited object-oriented support, such as **attribute reuse**, **private and public variables**, and **single inheritance**. Besides, KCL does NOT support multiple inheritances for the schema.

The following is an example of schema inheritance:

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

The output is

```yaml
employee:
  firstName: Bob
  lastName: Green
  age: 18
  bankCard: 123456
  nationality: null
```

Please note that KCL only allows **single inheritance** on schemas.

In addition, when the schema has an inheritance relationship, the properties of optional attributes are as follows:

- If the attribute is optional in the base schema, it could be optional or required in the sub-schema.
- If the attribute is required in the base schema, it must be required in the sub-schema.

```python
schema Person:
    bankCard?: int
    nationality: str

schema Employee(Person):
    bankCard: int  # Valid, both `bankCard: int` and `bankCard?: int` are allowed
    nationality?: str  # Error, only `nationality: str` is allowed
```

##### Schema Function

Schema map very nicely onto functions; it can have any number of input and output parameters. For example, the Fibonacci function can be written as follows using the recursive schema config:

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

##### Decorators

Just like Python, KCL supports the use of decorators on the schema. KCL Decorators dynamically alter the functionality of a schema without having to directly use sub schema or change the source code of the schema being decorated. And like a function call, the decorator supports passing in additional parameters.

Built-in decorators of schema

- `@deprecated`
  Mark whether a schema or schema attribute is deprecated. The `@deprecated` decorator supports three parameters:
  - **version** - string type, indicating the version information. The default value is empty.
  - **reason** - string type, indicating the deprecated reason. The default value is empty.
  - **strict** - bool type, indicating whether to report an error or warning. The default value is true. If `strict` is `True` and the error is thrown, the program will be interrupted. If `strict` is `False`, a warning will be output and the program will not be interrupted.

Examples:

```python
@deprecated
schema ObsoleteSchema:
    attr: str

schema Person:
    name: str = "John"
    attrs: ObsoleteSchema = {
        attr = "value"
    }

person = Person {}  # Error: ObsoleteSchema was deprecated
```

```python
schema Person:
    firstName: str = "John"
    lastName: str
    @deprecated(version="1.16", reason="use firstName and lastName instead", strict=True)
    name: str

JohnDoe = Person {  # Error: name was deprecated since version 1.16, use firstName and lastName instead
    name = "deprecated"
}
```

Note that the current version of KCL does not yet support user-defined decorators.

##### Members

Built-in functions and members of schema

- instances()
  Return the list of existing instances of a schema.

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

The output is

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

### Config Operations

#### Config Unification

##### | Operators

In KCL, we can use the union operator `|` to achieve the merging of configurations, the types supported by the union operator are as follows:

```txt
SchemaInstance | SchemaInstance
SchemaInstance | Dict
Dict | Dict
List | List
```

Unioning collection and schema data:

- Unioning List. Overwrite the list expression on the right side of the operator `|` to the list variable on the left side of the operator one by one according to the **index**.

```python
_a = [1, 2, 3]
_b = [4, 5, 6, 7]
x = _a | _b  # [4, 5, 6, 7]  1 -> 4; 2 -> 5; 3 -> 6; Undefined -> 7
```

Unioning to the specific index or all elements is still under discussion.

- Unioning Dict. Union the dict expression on the right side of the operator `|` one by one to the dict variable on the left side of the operator according to the **key**

```python
_a = {key1 = "value1"}
_b = {key1 = "overwrite", key2 = "value2"}
x = _a | _b  # {"key1": "overwrite", "key2": "value2"}
```

The union of collection and schema is a new one whose attributes are unioning b to a, preserving the order of the attributes of the operands, left before right.

- Unioning Schema. The union operation for schema is similar to dict.

Schema union could be done as:

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

Please note that when one of the left and right operands of the union operator is None, the other operand is returned immediately.

```python
data1 = {key = "value"} | None  # {"key": "value"}
data2 = None | [1, 2, 3]  # [1, 2, 3]
data3 = None | None  # None
```

The output is

```yaml
data1:
  key: value
data2:
  - 1
  - 2
  - 3
data3: null
```

##### : Operators

Pattern: `identifier : E` or `identifier : T E`

The value of the expression `E` with optional type annotation `T` will be unioned into the element value.

Examples:

```python
data = {
    labels: {key1: "value1"}
    # union {key2: "value2"} into the attribute labels.
    labels: {key2: "value2"}
}
```

Output:

```yaml
data:
  labels:
    key1: value1
    key2: value2
```

In addition to using attribute operators on the schema config attributes, variables inside and outside the schema can use attribute operators to perform different operations on the configuration.

- Using `:` outside the schema

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

Its equivalent configuration code can be expressed as

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

The output is

```yaml
config:
  data:
    d1: 1
    d2: 1
```

- Using `:` inside the schema

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

#### Config Override

##### = Operators

Pattern: `identifier = E` or `identifier : T = E`

The value of the expression `E` with optional type annotation `T` will override the attribute value.

Examples:

```python
schema Data:
    labels: {str:} = {key1 = "value1"}

data = Data {
    # override {key2: "value2"} into the attribute labels of the schema Data.
    labels = {key2 = "value2"}
}
```

Output:

```yaml
data:
  labels:
    key2: value2
```

Note:

- Especially, we can "delete" its content by overriding the attribute to `Undefined`, such as `{ a = Undefined }`.

#### Insert

##### += Operators

Pattern: `identifier += E` or `identifier : T += E`

Insert only works for list type `identifier`.

`E` will be inserted just after the specified index of the list `identifier`, and the following attributes after the index will be automatically shifted.

Examples:

```python
schema Data:
    labels: {str:} = {key1 = [0, 1, 3]}

data = Data {
    # insert [2] after the index 1 of the attribute labels.key1 of the schema Data.
    labels: {key1[1] += [2]}
}
```

Output:

```yaml
data:
  labels:
    key1:
      - 0
      - 1
      - 2
      - 3
```

If no index is specified, the last index will be used.

#### Notice

Please note that the calculations of the `=` and `+=` attribute operators of the same attribute are sequential, and the latter ones have a higher priority.

```python
x = {
    a = 1  # 1
} | {
    a = 2  # 1 -> 2
} | {
    a = 3  # 2 -> 3
}  # The final value of attribute `a` is 3
```

Please note that the `:` attribute operator represents an idempotent merge operation, and an error will be thrown when the values that need to be merged conflict.

Therefore, when we need a configuration to override or add and delete operations, it is best to use the `=` and `+=` operators

```python
data0 = {id: 1} | {id: 2}  # Error：conflicting values between {'id': 2} and {'id': 1}
data1 = {id: 1} | {id = 2}  # Ok, the value of `data` is {"id": 2}
```

The check rules for `:` operator for KCL value conflicts are as follows:

- For `None` and `Undefined` variables, they do not conflict with any value.

```python
data0 = None | {id: 1}  # Ok
```

- For `int`, `float`, `str` and `bool` types, when their values are different, they are considered as conflicts.

```python
data0 = 1 | 1  # Ok
data1 = 1 | "s"  # Error
```

- For list type
  - When their lengths are not equal, they are regarded as conflicts.
  - When their lengths are equal, as long as there is a conflict in the value of a child element, it is regarded as a conflict.

```python
data0 = [1] | [1]  # Ok
data1 = [1, 2] | [1]  # Error
```

- For dict/schema type
  - When the values of the same key conflict, they are regarded as conflicts

```python
data0 = {id: 1} | {id: 1}  # Ok
data1 = {id: 1} | {id: 2}  # Error
data1 = {id: 1} | {idAnother: 1}  # Ok
```

### Rule

In addition to using the check keyword for verification and writing in the schema, KCL also supports the use of the `rule` keyword to define a set of rules for policy verification

The KCL rule is the same as the schema/mixin/protocol and it is defined by indentation. We need write a rule per line and we can write if filter conditions and verification failure information for each rule. Different conditions are connected with logic `and` (similar to the way of writing in check block).

```python
rule SomeRule:
    age > 0, "rule check failure message"
```

We can call a KCL rule like instantiating a schema:

```python
age = 1
name = "Alice"

rule SomeRule:
    age > 0, "rule check failure message"
    name == "Alice"

rule1 = SomeRule()  # Rule call
rule2 = SomeRule {}  # Rule call
```

We can use protocol to implement type checking of rule structure:

```python
# Protocol definition
protocol Service:
    clusterIp: str
    $type: str

# Protocol definition
protocol Volume:
    mountPath: [str]

# Protocol
protocol SomeProtocol:
    id: int
    env: {str: any}
    services: [Service]
    volumes: [Volume]

rule SomeChecker for SomeProtocol:
    id > 0, "id must >0"

    all service in services {
        service.clusterIP == "NONE" if service.type == "ClusterIP"
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
            clusterIP = "NONE"
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

Please note that the combination of `protocol` and `rule` can separate attributes from their constraint definitions. We can define different rules and protocols in different packages and combine them as needed. This is different from check expressions in schema, which can only be combined with schema attributes.

Besides, the following two ways can be used to achieve the multiplexing of different Rules:

- Inline Call

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

- Inherit

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

We can obtain external data or input from the `option` function and the CLI parameter `-D` for verification:

- A simple example

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

- A complex example

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

Further, the above KCL rule code can be compiled into a target such as WASM and used at runtime.

### Module

KCL config files are organized as **modules**. A single KCL file is considered as a module, and a directory is considered as a package, which is a special module.

The modules in the same package are visible and cross-package references need to be visible through import.

Code structure:

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

#### Relative Path Import

We can use the operator `.` to realize the relative path import of KCL entry files.

main.k:

```python
import .model1  # Current directory module
import ..service  # Parent directory
import ...root  # Parent of parent directory

s = service.ImageService {}
m = root.Schema {}
```

#### Absolute Path Import

The semantics of `import a.b.c.d` is

1. If `kcl.mod` not exist, regard the current directory as the package root and search the path `a/b/c/d` from the current directory.
2. If the current directory search fails, search from the root path `ROOT_PATH/a/b/c/d`, else raise an import error.

The definition of the root path `ROOT_PATH` is the directory corresponding to the `kcl.mod` file from the current directory.

Code structure:

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

Note that for the KCL entry file `main.k`, it cannot be imported into the folder where it is located, otherwise a recursive import error will occur:

```python
import model  # Error: recursively loading
```

### Top-Level Argument

Assume some field need to be passed in dynamically like user input, we can define a top-level argument in a module:

```python
bankCard = option("bankCard")  # Get bankCard through the option function.
```

Then we can use the module as below:

```bash
kcl employee.k -D bankCard=123
```

Currently, supported types of top-level argument are number, string, bool, list and dict.

```bash
kcl main.k -D list_key='[1,2,3]' -D dict_key='{"key":"value"}'
```

We need to pay attention to the escape of quotation marks `"` and other symbols in the command line

#### Arguments with Setting Files

In addition, it also supports inputting a YAML file as top-level arguments.

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

In addition, the setting file also supports configuring command-line compilation parameters as follows:

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

KCL CLI -Y parameters also support multi-file configuration, and support separate writing and merging of compilation parameters and option top level arguments parameter configuration.

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

We can use the following command line to get the meaning of each configuration parameter or see KCL Quick Start

```bash
kcl --help
```

#### Option Functions

We can use the `option` function in the KCL code to get the top-level arguments.

```python
value = option(key="key", type='str', default="default_value", required=True, help="Set key value")
```

Parameters

- **key**: The argument key.
- **type**: The argument type to be converted.
- **default**: The argument default value when the key-value argument is not provided
- **required**: Report an error when the key-value argument is not provided and required is True, but don't provide the default value.
- **help**: The help message.

### Multi-file Compilation

In addition to the above KCL single file execution, we can compile multiple KCL entry files at the same time using the following command:

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

The output is:

```yaml
a: 1
b: 2
c: 3
d: 4
```

Taking advantage of the **multi-file combination**, we can assemble multiple KCL files without the need to use import management files. Let us see an example of combining **multi-file compilation** and **schema instance**.

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
import yaml

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
print("---\n".join([yaml.encode(_b, ignore_private=True) for _b in _backends]))
```

The command is

```bash
kcl model.k backend.k
```

The output is

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

### KCL CLI Path Selector

We can use KCL CLI `-S|--path-selector` parameter to select one or more values out of a KCL model.

The path selector looks like this:

`var.name`

#### Examples

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

The command is

```bash
kcl main.k -S var
```

The output is

```yaml
name: Alice
age: 18
```

### KCL CLI Variable Override

In addition to **Variable Selector**, KCL also allows us to directly modify the values in the configuration model through the KCL CLI `-O|--overrides` parameter.

The use of **Variable Override** is similar to [**Variable Selector**](#variable-selector), and the parameter contains three parts e.g., `pkg`, `identifier`, `attribute` and `override_value`.

```bash
kcl main.k -O override_spec
```

- `override_spec` represents a unified representation of the configuration model fields and values that need to be modified

```txt
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

#### Examples

##### Override Update Sample

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

##### Override Delete Sample

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
  y: s
```

### Summary

This page summarized the commonly used features in the KCL language. As a new language, KCL will gradually increase the functional features according to the requirements of the configuration scenario.

For more information, please try further resources:

- KCL codelabs
- KCL language specification
- KCL OpenAPI specification
