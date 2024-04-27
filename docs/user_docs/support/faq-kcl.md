---
sidebar_position: 2
---

# KCL

## 1. How to write a simple key-value pair configuration with KCL

Create a file named `config.k`

```python
cpu = 256
memory = 512
image = "nginx:1.14.2"
service = "my-service"
```

In the above KCL code, `cpu` and `memory` are defined to be declared as integer types, and their values are `256` and `512`, while `image` and `service` are string types, their values are `image` and `service`.

Use the following command to compile the above KCL file into YAML for output

```
kcl config.k
```

The output YAML is

```yaml
cpu: 256
memory: 512
image: nginx:1.14.2
service: my-service
```

If we want to output the YAML content to a file such as `config.yaml`, we can add the `-o|--output` CLI argument:

```
kcl config.k -o config.yaml
```

## 2. What are the basic data types in KCL?

KCL's current basic data types and values include:

- Integer type `int`
  - Examples: decimal positive integer `1`, decimal negative integer `-1`, hexadecimal integer `0x10`, octal integer `0o10`, binary integer `0b10`
- float type `float`
  - Examples: positive float `1.10`, `1.0`, negative float `-35.59`, `-90.`, scientific notation float `32.3e+18`, `70.2E-12`
- boolean type `bool`
  - Example: true value `True`, false value `False`
- String type `str` - marked with `'`, `"`
  - Example: double quoted string `"string"`, `"""string"""`, single quoted string `'string'`, `'''string'''`
- List type `list` - marked with `[`, `]`
  - Example: empty list `[]`, string list `["string1", "string2", "string3"]`
- Dictionary type `dict` - marked with `{`, `}`
  - Example: empty dictionary `{}`, dictionary whose keys and values ​​are all strings `{"key1": "value1", "key2": "value2"}`
- Structure type `schema` - defined with the keyword `schema`
- Null value type `None` - used to indicate that the value of a variable is null, corresponding to the `null` value of the output YAML
- Undefined value type `Undefined` - used to indicate that a variable has not been assigned a value, and a variable with a value of `Undefined` will not be output to YAML

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
```

> Note: All KCL variables can be assigned the null value `None` and the undefined value `Undefined`.

## 3. What do some KCL variable names prefixed with `_` underscore mean? What's the difference between without the `_` underscore prefix? In what scenarios are they suitable for use?

A variable with an underscore prefix in KCL represents a **hidden**, **mutable** variable, **hidden** means a variable with an underscore prefix will not be output to YAML, and **mutable** means that a variable with an underscore prefix can be repeatedly assigned multiple times, and a variable without an underscore prefix is immutable after being assigned.

```python
name = 'Foo'  # Exported and immutable variable
name = 'Bar'  # Error: An exported variable can only be assigned a value once
```

```python
_name = 'Foo'  # Hidden and mutable variable
_name = 'Bar'

schema Person:
    _name: str  # hidden and mutable
```

## 4. How to add elements to a dict?

We can use the union operator `|` or the dict unpacking operator `**` to add elements into a dict, and we can use `in` and `not in` operators to determine whether the dict variable contains a certain key.

```python
_left = {key: {key1 = "value1"}, intKey = 1}  # Note: `=` denotes override the value.
_right = {key: {key2 = "value2"}, intKey = 2}
dataUnion = _left | _right  # {"key": {"key1": "value1", "key2": "value2"}, "intKey": 2}
dataUnpack = {**_left, **_right}  # {"key": {"key1": "value1", "key2": "value2"}, "intKey": 2}
```

The output YAML is

```yaml
dataUnion:
  key:
    key1: value1
    key2: value2
  intKey: 2
dataUnpack:
  key:
    key1: value1
    key2: value2
  intKey: 2
```

It is also possible to add key-value pair to a dict using the `string interpolation` or the string `format` method.

```python
dictKey1 = "key1"
dictKey2 = "key2"
data = {
    "${dictKey1}" = "value1"
    "{}".format(dictKey2) = "value2"
}
```

The output YAML is

```yaml
dictKey1: key1
dictKey2: key2
data:
  key1: value1
  key2: value2
```

## 5. How to modify elements in dict?

We can use the union operator `|`, or the unpacking operator `**` to modify the elements in the dict

```python
_data = {key = "value"}  # {"key": "value"}
_data = _data | {key = "override_value1"}  # {"key": "override_value1"}
_data = {**_data, **{key = "override_value2"}}  # {"key": "override_value2"}
```

If we want to delete a value with a key of `key` in the dict, we can use the unpacking operator `**{key = Undefined}` or the merge operator `| {key = Undefined}` to overwrite, the value of the key is Undefined after overwriting, and no YAML output will be done.

## 6. How to add elements to list?

There are two ways to add elements to a list:

- Use `+`, `+=` and slice to concatenate list variables to add elements to the list

```python
_args = ["a", "b", "c"]
_args += ["end"]  # Add elements "end" to the end of the list: ["a", "b", "c", "end"]
_args = _args[:2] + ["x"] + _args[2:]  # Insert element "x" at list index 2:  ["a", "b", "x", "c", "end"]
_args = ["start"] + _args  # Add elements "start" to the head of the list: ["start", "a", "b", "x", "c", "end"]
```

- Use the `*` unpacking operator to concatenate and merge lists

```python
_args = ["a", "b", "c"]
_args = [*_args, "end"]  # Add elements "end" to the end of the list: ["a", "b", "c", "end"]
_args = ["start", *_args]  # Add elements "start" to the head of the list: ["start", "a", "b", "x", "c", "end"]
```

> Note: When the consecutive variables are `None/Undefined`, using `+` may cause an error, then we can use the list unpacking operator `*` or use the `or` operator to take the default value of the list to avoid null values judge.

```python
data1 = [1, 2, 3]
data2 = None
data3 = [*data1, *data2]  # Ok: [1, 2, 3]
data4 = data1 + data2 or []  # OK: [1, 2, 3], We can use the `or` operator to take the default value of data2 as [], when data2 is None/Undefined, take the empty list [] for calculation.
data5 = data1 + data2  # Error: can only concatenate list (not "NoneType") to list
```

## 7. How to modify/delete elements in list?

There are two ways to modify the elements in the list:

- Use slice to directly modify the value at an index of a list

```python
_index = 1
_args = ["a", "b", "c"]
_args = _args[:index] + ["x"] + _args[index+1:]  # Modify the element of list index 1 to "x": ["a", "x", "c"]
```

- Use the list comprehension to modify elements in a list

```python
_args = ["a", "b", "c"]
_args = ["x" if a == "b" else a for a in _args]  # Change the value of "b" in the list to "x": ["a", "x", "c"]
```

There are two ways to delete elements in a list:

- Use the list comprehension to delete elements with the `if` condition expressions.
- Use `filter` expression to filter elements.

For example, if we want to delete a number greater than 2 in a list `[1, 2, 3, 4, 5]`, we can write as follows:

```python
originList = [1, 2, 3, 4, 5]
oneWayDeleteListItem = [item for item in originList if item <= 2]
anotherWayDeleteListItem = filter item in originList {
    item <= 2
}
```

The output YAML is

```yaml
originList:
  - 1
  - 2
  - 3
  - 4
  - 5
oneWayDeleteListItem:
  - 1
  - 2
anotherWayDeleteListItem:
  - 1
  - 2
```

## 8. How to write a for loop in KCL? How to understand and use list comprehension and dict comprehension?

KCL currently only supports functional/declarative deductive for loops. We can traverse dict and list variables as follows:

The specific form of a list comprehension is (where `[]` are used on both sides of the comprehension):

```txt
[expression for expr in sequence1
            if condition1
            for expr2 in sequence2
            if condition2
            for expr3 in sequence3 ...
            if condition3
            for exprN in sequenceN
            if conditionN]
```

The specific form of dict comprehension is (where `{}` are used on both sides of the comprehension):

```txt
{expression for expr in sequence1
            if condition1
            for expr2 in sequence2
            if condition2
            for expr3 in sequence3 ...
            if condition3
            for exprN in sequenceN
            if conditionN}
```

The `if` in the above forms represents the filter condition, and the expression `expr` that satisfies the condition will be generated into a new list or dict

List comprehension example:

```python
_listData = [1, 2, 3, 4, 5, 6]
_listData = [l * 2 for l in _listData]  # All elements in _listData are multiplied by 2: [2, 4, 6, 8, 10, 12]
_listData = [l for l in _listData if l % 4 == 0]  # Filter out all elements in _listData that are divisible by 4: [4, 8, 12]
_listData = [l + 100 if l % 8 == 0 else l for l in _listData]  # Traverse _listData, when the element in it is divisible by 8, add 100 to the element, otherwise keep it unchanged: [4, 108, 12]
```

Note the difference between the two `if`s on lines 3 and 4 in the above code:

- The first `if` represents the filter condition of the variable `_listData` list comprehension itself, and cannot be followed by `else`. Elements that meet the conditions will be added to the list, and elements that do not meet the conditions will be removed. Besides, the process may change the length of the list.
- The second `if` represents the selection condition of the list iteration variable `l`, which means the `if-else` ternary expression, which must be followed by `else`, regardless of whether the condition is met, the resulting element is still in the list, the length of the list does not change.

Dict comprehension example:

```python
_dictData = {key1 = "value1", key2 = "value2"}
_dictData = {k = _dictData[k] for k in _dictData if k == "key1" and _dictData[k] == "value1"}  # Filter out the elements whose key is "key1" and value is "value1" in _dictData, {"key1": "value1"}
```

Use comprehension to get all keys of dict:

```python
dictData = {key1 = "value1", key2 = "value2"}
dictDataKeys = [k for k in _dictData]  # ["key1", "key2"]
```

Use comprehension to sort a dict in ascending order by key:

```python
dictData = {key3 = "value3", key2 = "value2", key1 = "value1"}  # {'key3': 'value3', 'key2': 'value2', 'key1': 'value1'}
dictSortedData = {k = dictData[k] for k in sorted(dictData)}  # {'key1': 'value1', 'key2': 'value2', 'key3': 'value3'}
```

Multi-level comprehension example:

```python
array1 = [1, 2, 3]
array2 = [4, 5, 6]
data = [a1 + a2 for a1 in array1 for a2 in array2]  # [5, 6, 7, 6, 7, 8, 7, 8, 9] len(data) == len(array1) * len(array2)
```

Double variable loop (list comprehension supports index iteration of list and value iteration of dict, which can simplify the code writing of list/dict iteration process):

- list

```python
data = [1000, 2000, 3000]
# Single variable loop
dataLoop1 = [i * 2 for i in data]  # [2000, 4000, 6000]
dataLoop2 = [i for i in data if i == 2000]  # [2000]
dataLoop3 = [i if i > 2 else i + 1 for i in data]  # [1000, 2000, 3000]
# Double variable loop
dataLoop4 = [i + v for i, v in data]  # [1000, 2001, 3002]
dataLoop5 = [v for i, v in data if v == 2000]  # [2000]
# Use _ to ignore loop variables
dataLoop6 = [v if v > 2000 else v + i for i, v in data]  # [1000, 2001, 3000]
dataLoop7 = [i for i, _ in data]  # [0, 1, 2]
dataLoop8 = [v for _, v in data if v == 2000]  # [2000]
```

- dict

```python
data = {key1 = "value1", key2 = "value2"}
# Single variable loop
dataKeys1 = [k for k in data]  # ["key1", "key2"]
dataValues1 = [data[k] for k in data]  # ["value1", "value2"]
# Double variable loop
dataKeys2 = [k for k, v in data]  # ["key1", "key2"]
dataValues2 = [v for k, v in data]  # ["value1", "value2"]
dataFilter = {k = v for k, v in data if k == "key1" and v == "value1"}  # {"key1": "value1"}
# Use _ to ignore loop variables
dataKeys3 = [k for k, _ in data]  # ["key1", "key2"]
dataValues3 = [v for _, v in data]  # ["value1", "value2"]
```

## 9. How to write an if conditional statement?

KCL supports two ways to write if conditional statements:

- if-elif-else block statement, where both elif and else blocks can be omitted, and the elif block can be used multiple times

```python
success = True
_result = "failed"
if success:
    _result = "success"
```

```python
success = True
if success:
    _result = "success"
else:
    _result = "failed"
```

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

- Conditional expression `<expr1> if <condition> else <expr2>`, similar to `<condition> ? <expr1> : <expr2>` ternary expression in C language

```python
success = True
_result = "success" if success else "failed"
```

> Note: When writing an if-elif-else block statement, pay attention to the colon `:` after the if condition and keep the indentation consistent.

In addition, conditional expressions can also be written directly in a list or dict (the difference is that the value to be written in the if expression written in the structure is not a statement):

- list

```python
env = "prod"
data = [
    "env_value"
    ":"
    if env == "prod":
        "prod"  # Write values that need to be added to data, not statements
    else:
        "other_prod"
]  # ["env_value", ":", "prod"]
```

- dict

```python
env = "prod"
config = {
    if env == "prod":
        MY_PROD_ENV = "prod_value"  # Write key-value pairs that need to be added to config, not statements
    else:
        OTHER_ENV = "other_value"
}  # {"MY_PROD_ENV": "prod_value"}
```

## 10. How to express logical operations such as "and" "or" "not"?

In KCL, use `and` for "logical and", use `or` for "logical or", use `not` for "not", which is similar to `&&`, `||` and `~` semantic in C language.

```python
done = True
col == 0
if done and (col == 0 or col == 3):
    ok = 1
```

For "bitwise AND", "bitwise OR" and "bitwise XOR" of integers, we can use `&`, `|` and `^` operators in KCL, which is similar to `&`, `|` and `^` semantic in C language.

```python
value = 0x22
bitmask = 0x0f

assert (value & bitmask) == 0x02
assert (value & ~bitmask) == 0x20
assert (value | bitmask) == 0x2f
assert (value ^ bitmask) == 0x2d
```

When we need to write a pattern such as `A if A else B`, we can use `A or B` to simplify, such as the following code:

```python
value = [0]
default = [1]
x0 = value if value else default
x1 = value or default  # Use `value or default` instead of `value if value else default`
```

## 11. How to judge whether a variable is None/Undefined, and whether a string/dict/list is empty?

Please note that `False`, `None`, `Undefined`, number `0`, empty list `[]`, empty dictionary `{}` and empty string `""`, `''`, `""""""`, `''''''` in the conditional expression, are all treated as `false` expressions.

For example, when judging a string variable `strData` is neither `None/Undefined` nor an empty string (string length is greater than 0), we can simply use the following expression:

```python
strData = "value"
if strData:
    isEmptyStr = False
```

Empty dictionary and empty list judgment examples:

```python
_emptyList = []
_emptyDict = {}
isEmptyList = False if _emptyList else True
isEmptyDict = False if _emptyDict else True
```

The output YAML is

```yaml
isEmptyList: true
isEmptyDict: true
```

Or use the boolean function `bool` to judge

```python
_emptyList = []
_emptyDict = {}
isEmptyList = bool(_emptyList)
isEmptyDict = bool(_emptyDict)
```

## 12. How to concatenate strings, format strings, check string prefixes and suffixes and replace string content?

- The `+` operator can be used to concatenate two strings in KCL

```python
data1 = "string1" + "string2"  # "string1string2"
data2 = "string1" + " " + "string2"  # "string1 string2"
```

- There are currently two ways to format strings in KCL:
  - `format` method for string variables `"{}".format()`
  - Using string interpolation `${}`

```python
hello = "hello"
a = "{} world".format(hello)
b = "${hello} world"
```

Note that if we want to use the `{` character or `}` alone in `"{}".format()`, we need to use `{{` and `}}` to convert `{` and `}` respectively, such as escaping a JSON string as follows:

```python
data = "value"
jsonData = '{{"key": "{}"}}'.format(data)
```

The output YAML is

```yaml
data: value
jsonData: '{"key": "value"}'
```

Note that if we want to use the `$` character alone in the `${}` interpolated string, we need to escape the `$` with `$$`

```python
world = "world"
a = "hello {}".format(world)       # "hello world"
b = "hello ${world}"               # "hello world"
c = "$$hello ${world}$$"           # "$hello world$"
c2 = "$" + "hello ${world}" + "$"  # "$hello world$"
```

The output YAML is

```yaml
world: world
a: hello world
b: hello world
c: $hello world$
c2: $hello world$
```

- Use the `startswith` and `endswith` methods of strings in KCL to check the prefix and suffix of strings

```python
data = "length"
isEndsWith = data.endswith("th")  # True
isStartsWith = "length".startswith('len')  # True
```

- Use the replace method of the string or the `regex.replace` function to replace the content of the string in KCL

```python
import regex
data1 = "length".replace("len", "xxx")  # Replace "len", "xxxgth" with "xxx"
data2 = regex.replace("abc123", r"\D", "0")  # Replace all non-digits in "abc123" with "0", "000123"
```

Among them, `r"\D"` means that we do not need to use `\\` to escape the backslash `\` in `\D`, which is mostly used in regular expression strings.

Besides, we can use index placeholders or keyword placeholders in string formatting expressions to format multiple strings

- Index placeholders

```python
x = '{2} {1} {0}'.format('directions', 'the', 'Read')
y = '{0} {0} {0}'.format('string')
```

The output YAML is

```yaml
x: Read the directions
y: string string string
```

- Keyword placeholders

```python
x = 'a: {a}, b: {b}, c: {c}'.format(a = 1, b = 'Two', c = 12.3)
```

The output YAML is

```yaml
x: "a: 1, b: Two, c: 12.3"
```

## 13. What is the difference between using single and double quotes in a string?

There is little difference between KCL single-quoted and double-quoted strings. The only difference is that we don't need to use `\"` to escape `"` in single-quoted strings, and we don't need to use `\'` to escape `'` in double-quoted strings.

```python
singleQuotedString = 'This is my book named "foo"'  # Don’t need to escape double quotes in single quoted strings.
doubleQuotedString = "This is my book named 'foo'"  # Don’t need to escape single quotes in double quoted strings.
```

In addition, a long string consisting of three single quotes or three double quotes does not need to be escaped (except for the beginning and end of the string), such as the following example:

```python
longStrWithQuote0 = """Double quotes in long strings "(not at the beginning and end)"""
longStrWithQuote1 = '''Double quotes in long strings "(not at the beginning and end)'''
longStrWithQuote2 = """Single quotes in long strings '(not at the beginning and end)"""
longStrWithQuote3 = '''Single quotes in long strings '(not at the beginning and end)'''
```

The output YAML is

```yaml
longStrWithQuote0: Double quotes in long strings "(not at the beginning and end)
longStrWithQuote1: Double quotes in long strings "(not at the beginning and end)
longStrWithQuote2: Single quotes in long strings '(not at the beginning and end)
longStrWithQuote3: Single quotes in long strings '(not at the beginning and end)
```

## 14. How to write a long multiline string?

In KCL, we can use a single-quoted string and newline characters `\n` or a triple-quoted string to write a multi-line string, and we can use the continuation character `\` to optimize the form of the KCL string. For example, for the three multi-line string variables in the following code, their values are the same:

```python
string1 = "The first line\nThe second line\nThe third line\n"
string2 = """The first line
The second line
The third line
"""
string3 = """\
The first line
The second line
The third line
"""  # It is recommended to use the long string writing form of `string3`.
```

The output YAML is

```yaml
string1: |
  The first line
  The second line
  The third line
string2: |
  The first line
  The second line
  The third line
string3: |
  The first line
  The second line
  The third line
```

## 15. How to use regular expressions in KCL?

Regular expressions can be used by importing the regular expression system module `import regex` in KCL, which includes the following functions:

- **match**: Regular expression matching function, which matches the input string according to the regular expression, and returns a bool type to indicate whether the match is successful.
- **split**: Regular expression split function, which splits the string according to the regular expression, and returns a list of split strings.
- **replace**: Regular expression replacement function, which replaces all substrings in the string that satisfies the regular expression, and returns the replaced string.
- **compile**: Regular expression compilation function, which returns bool type to indicate whether it is a valid regular expression.
- **search**: Regular expression search function, which searches all substrings that satisfy the regular expression, and returns a list of substrings.

Examples:

```python
import regex

regex_source = "Apple,Google,Baidu,Xiaomi"
regex_split = regex.split(regex_source, ",")
regex_replace = regex.replace(regex_source, ",", "|")
regex_compile = regex.compile("$^")
regex_search = regex.search("aaaa", "a")
regex_find_all = regex.findall("aaaa", "a")
regex_result = regex.match("192.168.0.1", "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$")  # Determine if it is an IP string
regex_result_false = regex.match("192.168.0,1", "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$")  # Determine if it is an IP string
```

The output YAML is

```yaml
regex_source: Apple,Google,Baidu,Xiaomi
regex_split:
  - Apple
  - Google
  - Baidu
  - Xiaomi
regex_replace: Apple|Google|Baidu|Xiaomi
regex_compile: true
regex_search: true
regex_find_all:
  - a
  - a
  - a
  - a
regex_result: true
regex_result_false: false
```

For longer regular expressions, we can also use **r-string** to ignore the escape of `\` symbols to simplify the writing of regular expression strings.

Examples:

```python
import regex

isIp = regex.match("192.168.0.1", r"^(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|[1-9])."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)$")  # Determine if it is an IP string
```

```python
import regex

schema Resource:
    cpu:         str = "1"
    memory:      str = "1024Mi"
    disk:        str = "10Gi"
    check:
        regex.match(cpu, r"^([+-]?[0-9.]+)([m]*[-+]?[0-9]*)$"), "cpu must match specific regular expression"
        regex.match(memory, r"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"), "memory must match specific regular expression"
        regex.match(disk, r"^([1-9][0-9]{0,63})(E|P|T|G|M|K|Ei|Pi|Ti|Gi|Mi|Ki)$"), "disk must match specific regular expression"
```

```python
import regex

schema Env:
    name:            str
    value?:          str
    check:
        len(name) <= 63, "a valid env name must be no more than 63 characters"
        regex.match(name, r"[A-Za-z_][A-Za-z0-9_]*"), "a valid env name must start with alphabetic character or '_', followed by a string of alphanumeric characters or '_'"
```

## 16. What is the meaning of schema in KCL?

Schema is a language element in KCL that defines the type of configuration data. Like struct in C language or class in Java, attributes can be defined in it, and each attribute has a corresponding type.

## 17. How to use schema?

In KCL, we can use the `schema` keyword to define a structure in which we can declare the various attributes of the schema.

```python
# A Person structure with firstName of attribute string type, lastName of string type, age of integer type.
schema Person:
    firstName: str
    lastName: str
    # The default value of the age attribute is 0.
    age: int = 0
```

A complex example:

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: str
    replica: int
    command: [str]
    labels: {str:str}
```

In the above code, `cpu` and `memory` are defined as integer types; `name`, `image` and `service` are string types; `command` is a list of string types; labels are dictionaries type whose key type and value type are both strings.

## 18. How to add "optional" and "required" constraints to the schema attribute?

The `?` operator is used in KCL to define an "optional" constraint for a schema, and the schema attribute is "required" by default.

```python
# A Person structure with firstName of attribute string type, lastName of string type, age of integer type.
schema Person:
    firstName?: str  # firstName is an optional attribute that can be assigned to None/Undefined
    lastName?: str  # age is an optional attribute that can be assigned to None/Undefined
    age: int = 18  # age is an optional attribute that can be assigned to None/Undefined.
```

## 19. How to write validation rules for attributes in schema?

In the schema definition, we can use the `check` keyword to write the validation rules of the schema attribute. As shown below, each line in the check code block corresponds to a conditional expression. When the condition is satisfied, the validation is successful. The conditional expression can be followed by `, "check error message"` to indicate the information to be displayed when the validation fails.

```python
import regex

schema Sample:
    foo: str  # Required, cannot be None/Undefined, and the type must be str
    bar: int  # Required, cannot be None/Undefined, and the type must be int
    fooList: [int]  # Required, cannot be None/Undefined, and the type must be int list
    color: "Red" | "Yellow" | "Blue"  # Required, literal union type, and must be one of "Red", "Yellow", "Blue".
    id?: int  # Optional, can be None/Undefined, the type must be int

    check:
        0 <= bar < 100  # bar must be greater than or equal to 0 and less than 100
        0 < len(fooList) < 100  # fooList cannot be None/Undefined, and the length must be greater than 0 and less than 100
        regex.match(foo, "^The.*Foo$")  # regular expression matching
        bar in range(100)  # bar can only range from 1 to 99
        bar in [2, 4, 6, 8]  # bar can only take 2, 4, 6, 8
        bar % 2 == 0  # bar must be a multiple of 2
        all foo in fooList {
            foo > 1
        }  # All elements in fooList must be greater than 1
        any foo in fooList {
            foo > 10
        }  # At least one element in fooList must be greater than 10
        abs(id) > 10 if id  # check expression with if guard, when id is not empty, the absolute value of id must be greater than 10
```

To sum up, the validation kinds supported in KCL schema are:

| Kind              | Method                                                                                    |
| ----------------- | ----------------------------------------------------------------------------------------- |
| Range             | Using comparison operators such as `<`, `>`                                               |
| Regex             | Using methods such as `match` from the `regex` system module                              |
| Length            | Using the `len` built-in function to get the length of a variable of type `list/dict/str` |
| Enum              | Using literal union types                                                                 |
| Optional/Required | Using optional/required attributes of schema                                              |
| Condition         | Using the check if conditional expression                                                 |

## 20. How to add documentation to schema and its attributes?

A complete schema document is represented as a triple-quoted string, with the following structure:

```python
schema Person:
    """The schema person definition

    Attributes
    ----------
    name : str
        The name of the person
    age : int
        The age of the person

    See Also
    --------
    Son:
        Sub-schema Son of the schema Person.

    Examples
    --------
    person = Person {
        name = "Alice"
        age = 18
    }
    """
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

## 21. How to write configuration based on schema? How to reuse the common configuration between multiple configurations?

In the process of schema instantiation, we can use the unpacking operator `**` to expand the public configuration

```python
schema Boy:
    name: str
    age: int
    hc: int

schema Girl:
    name: str
    age: int
    hc: int

config = {
    age = 18
    hc = 10
}

boy = Boy {
    **config
    name = "Bob"
}
girl = Girl {
    **config
    name = "Alice"
}
```

The output YAML is

```yaml
config:
  age: 18
  hc: 10
boy:
  name: Bob
  age: 18
  hc: 10
girl:
  name: Alice
  age: 18
  hc: 10
```

## 22. How to override the default value of schema attribute when writing configuration based on schema?

After defining a schema, we can use the schema name to instantiate the corresponding configuration, use the `:` operator to union schema attribute default values, and use `=` to override schema attribute default values.

```python
schema Meta:
    labels: {str:str} = {"key1" = "value1"}
    annotations: {str:str} = {"key1" = "value1"}

meta = Meta {
    labels: {"key2": "value2"}
    annotations = {"key2" = "value2"}
}
```

The output YAML is

```yaml
meta:
  labels:
    key1: value1
    key2: value2
  annotations:
    key2: value2
```

## 23. How to reuse schema definitions?

We can declare the schema name that the schema needs to inherit at the definition:

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
    nationality: str

employee = Employee {
    firstName = "Bob"
    lastName = "Green"
    age = 18
    bankCard = 123456
    nationality = "China"
}
```

The output YAML is

```yaml
employee:
  firstName: Bob
  lastName: Green
  age: 18
  bankCard: 123456
  nationality: China
```

> Note: KCL only allows schema single inheritance.

## 24. How to reuse schema logic through composition?

We can use KCL schema mixin to reuse schema logic. Mixins are generally used for functions such as separation of data in schema internal attributes, and data mapping, which can make KCL code more modular and declarative.

Note that it is not recommended to define dependencies for mixing attributes between different mixins, which will make the use of mixins complicated.

Examples:

```python
schema Person:
    mixin [FullNameMixin, UpperMixin]

    firstName: str
    lastName: str
    fullName: str
    upper: str

schema FullNameMixin:
    fullName = "{} {}".format(firstName, lastName)

schema UpperMixin:
    upper = fullName.upper()

person = Person {
    firstName = "John"
    lastName = "Doe"
}
```

The output YAML is

```yaml
person:
  firstName: John
  lastName: Doe
  fullName: John Doe
  upper: JOHN DOE
```

## 25. How to import other KCL files?

Other KCL files can be imported via the `import` keyword, and KCL configuration files are organized into modules. A single KCL file is considered a module, and a directory is considered a package, as a special module. The `import` keyword supports both relative path import and absolute path import

For example, for the following directory structure:

```
.
└── root
    ├── kcl.mod
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   │── service1.k
    │   └── service2.k
    └── mixin
        └── mixin1.k
```

For `main.k`, relative path import and absolute path import can be expressed as:

```python
import service  # Absolute path import, the root directory is the path where kcl.mod is located
import mixin  # Absolute path import, the root directory is the path where kcl.mod is located

import .model1  # Relative path import, current directory module
import ..service  # Relative path import, parent directory
import ...root  # Relative path import, parent directory of parent directory
```

> Note that for KCL's entry file `main.k`, it cannot import the folder where it is located, otherwise a circular import error will occur:

```python
import model  # Error: recursively loading
```

## 26. When can import be omitted?

KCL files in the same folder the not in the main package can refer to each other without importing each other. For example, for the following directory structure:

```
.
└── root
    ├── kcl.mod
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   │── service1.k
    │   └── service2.k
    └── mixin
        └── mixin1.k
```

When main.k is used as the KCL command line entry file, the variables in main.k, model1.k and model2.k in the model folder cannot refer to each other and need to be imported through import, but service1.k in the service folder and Variables in service2.k can refer to each other, ignoring import

service1.k

```python
schema BaseService:
    name: str
    namespace: str
```

service2.k

```python
schema Service(BaseService):
    id: str
```

## 27. There is a line of code that is too long, how to wrap it gracefully with correct syntax?

In KCL, we can use the continuation character `\` for newlines, and we can also use `\` in strings to indicate continuation.

An example of a long string concatenation continuation line:

```python
longString = "Too long expression " + \
             "Too long expression " + \
             "Too long expression "
```

An example of a continuation in the comprehension expression:

```python
data = [1, 2, 3, 4]
dataNew = [
    d + 2 \
    for d in data \
    if d % 2 == 0
]
```

An example of a continuation in the if expression:

```python
condition = 1
data1 = 1 \
    if condition \
    else 2
data2 = 2 \
if condition \
else 1
```

An example of a continuation in the long string:

```python
longString = """\
The first line\
The continue second line\
"""
```

Note: Use the line continuation character `\` while maintaining indentation, as follows:

- Error use case:

```python
data1 = [
    1, 2,
    3, 4 \
]  # Error, need to keep the indentation of the closing bracket ]

data2 = [
    1, 2,
  3, 4
]  # Error, requires uniform indentation of numbers 1 and 3
```

- Right use case:

```python
data1 = [
    1, 2,
    3, 4
]  # OK

data2 = [ \
    1, 2, \
    3, 4  \
]  # OK

data3 = [ \
    1, 2, \
  3, 4  \
]  # OK
```

## 28. What do these symbols `**` and `*` mean?

- `**`, `*` appear outside dict/list to represent power operator and multiplication operator respectively.

```python
data1 = 2 ** 4  # 16
data2 = 2 * 3  # 6
```

- `**`, `*` appear inside dict/list to indicate unpacking operator, often used for unpacking and merging of list/dict, similar to unpacking operator in Python

Unpacking of dict:

```python
data = {"key1" = "value1"}
dataUnpack = {**data, "key2" = "value2"}  # {"key1": "value1", "key2": "value2"}
```

Unpacking of list:

```python
data = [1, 2, 3]
dataUnpack = [*data, 4, 5, 6]  # [1, 2, 3, 4, 5, 6]
```

## 29. How to get child elements of list/dict/schema

- For list type, we can use `[]` to get an element in the list

```python
data = [1, 2, 3]  # Define an list of integer types
theFirstItem = data[0]  # Get the element with index 0 in the list, that is, the first element 1
theSecondItem = data[1]  # Get the element with index 1 in the list, which is the first element 2
```

> Note: The value of the index cannot exceed the length of the list, otherwise an error will occur, we can use the `len` function to get the length of the list.

```python
data = [1, 2, 3]
dataLength = len(data)  # List length is 3
item = data[3]  # Error: Index out of bounds
```

In addition, we can also use the negative index to get the elements in the list in reverse order.

```python
data = [1, 2, 3]
item1 = data[-1]  # Get the element with index -1 in the list, which is the last element 3
item2 = data[-2]  # Get the element with index -2 in the list, which is the second-to-last element 2
```

In summary, the value range of the list index is `[-len, len - 1]`

When we want to get a part of the sub-elements of the list, we can use the slice expression in `[]`, the specific syntax is `[<list start index>:<list end index>:<list traversal step size>]`, Note that the value range of the start and end of the index is `left closed right open [<list start index>, <list end index>)`, note that the three parameters can be omitted or not written.

```python
data = [1, 2, 3, 4, 5]
dataSlice0 = data[1:2]  # Get the set of elements in the list whose index starts at 1 and ends at 2 [2]
dataSlice1 = data[1:3]  # Get the set of elements in the list whose index starts at 1 and ends at 3 [2, 3]
dataSlice2 = data[1:]   # Get the set of elements in the list whose index starts at 1 and ends at the last index [2, 3, 4, 5]
dataSlice3 = data[:3]   # Get the set of elements in the list whose index starts at the first index and ends at 3 [1, 2, 3]
dataSlice4 = data[::2]  # Get the set of elements in the list whose index starts at the first index and ends at the last index (step size is 2) [1, 3, 5]
dataSlice5 = data[::-1] # Reverse the list, [5, 4, 3, 2, 1]
dataSlice6 = data[2:1]  # When the start, stop, step combination of three parameters does not meet the conditions, return an empty list [].
```

- For dict/schema types, we can use `[]` and `.` to get child elements in dict/schema.

```python
data = {key1: "value1", key2: "value2"}
data1 = data["key1"]  # "value1"
data2 = data.key1  # "value1"
data3 = data["key2"]  # "value2"
data4 = data.key2  # "value2"
```

```python
schema Person:
    name: str = "Alice"
    age: int = 18

person = Person {}
name1 = person.name  # "Alice"
name2 = person["name"]  # "Alice"
age1 = person.age  # 18
age2 = person.age  # 18
```

When the key value does not exist in the dict, return the value `Undefined`.

```python
data = {key1 = "value1", key2 = "value2"}
data1 = data["not_exist_key"]  # Undefined
data2 = data.not_exist_key  # Undefined
```

We can use the `in` keyword to determine whether a key value exists in dict/schema

```python
data = {key1 = "value1", key2 = "value2"}
exist1 = "key1" in data  # True
exist2 = "not_exist_key" in data  # False
```

When there is `.` in the key value or when we need to get the value corresponding to a key value variable at runtime, we can only use the `[]` method. If there is no special case, use `.`:

```python
name = "key1"
data = {key1 = "value1", key2 = "value2", "contains.dot" = "value3"}
data1 = data[name]  # "value1"
data2 = data["contains.dot"]  # "value3"
# Note that this is wrong: data3 = data.contains.dot
```

> Note: The above sub-element operators cannot operate on values of non-list/dict/schema collection types, such as integers, nulls, etc.

```python
data = 1
data1 = 1[0]  # Error
```

```python
data = None
data1 = None[0]  # Error
```

When getting the child elements of the collection type, it is often necessary to make a non-null or length judgment:

```python
data = []
item = data[0] if data else None
```

We can use the `?` operator to make an if non-null judgment, and return None when the condition is not satisfied. For example, the above code can be simplified to:

```python
data = []
item1 = data?[0]  # When data is empty, return the empty value None
item2 = data?[0] or 1  # When data is empty, return the empty value None, if we don't want to return None, we can also use the or operator to return other default values e.g., "1" in `data?[0] or 1`
```

Use more `?` operators to avoid complicated and cumbersome non-null judgments

```python
data = {key1.key2.key3 = []}
item = data?.key1?.key2?.key3?[0]
```

## 30. How to get the type of a variable in KCL code

The KCL `typeof` built-in function can return the type (string representation) of a variable immediately for type assertion.

Examples:

```python
import sub as pkg

_a = 1

t1 = typeof(_a)
t2 = typeof("abc")

schema Person:
    name?: any

_x1 = Person{}
t3 = typeof(_x1)

_x2 = pkg.Person{}
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

## 31. How to solve the conflict between keywords and KCL variable names?

For identifier names that conflict with keywords, we can add a `$` prefix before the identifier to define a keyword identifier. For example, in the following code, keywords such as `if`, `else` can be used as identifiers with the `$` prefix and we can get the corresponding YAML output

```python
$if = 1
$else = "s"

schema Data:
    $filter: str = "filter"

data = Data {}
```

The output YAML is

```yaml
data:
  filter: filter
if: 1
else: s
```

> Note: Prefixing non-keyword identifiers with `$` has the same effect as not adding.

```python
_a = 1
$_a = 2  # Equivalent to `_a = 2`
```

## 32. Are built-in types of KCL a keyword of KCL? Whether they can be used for the definition of variables

The built-in types of KCL include `int`, `float`, `bool` and `str`, which are not KCL keywords and can be used to define variables, such as the following code:

```py
int = 1
str = 2
```

The output YAML is

```yaml
int: 1
str: 2
```

> Note: If there are no special requirements, it is not recommended that the names of variables take these built-in types, because in some languages, they exist as keywords.

## 33. How to implement enumeration in KCL?

There are two ways to implement enumeration in KCL

- Use **literal union types** (recommended)

```python
schema Person:
    name: str
    gender: "Male" | "Female"

person = Person {
    name = "Alice"
    gender = "Male"  # gender can only be "Male" or "Female"
}
```

```python
schema Config:
    colors: ["Red" | "Yellow" | "Blue"]  # colors is an enumerated array

config = Config {
    colors = [
        "Red"
        "Blue"
    ]
}
```

- Use schema check expressions

```python
schema Person:
    name: str
    gender: "Male" | "Female"

    check:
        gender in ["Male", "Female"]

person = Person {
    name = "Alice"
    gender = "Male"  # gender can only be "Male" or "Female"
}
```

## 34. How to get the length of dict

In KCL, we can use the `len` built-in function to directly find the length of a dict

```python
len1 = len({k1: "v1"})  # 1
len2 = len({k1: "v1", k2: "v2"})  # 2
varDict = {k1 = 1, k2 = 2, k3 = 3}
len3 = len(varDict)  # 3
```

In addition, the `len` function can also be used to get the length of `str` and `list` types

```python
len1 = len("hello")  # 5
len2 = len([1, 2, 3])  # 3
```

## 35. How to write conditional configuration in KCL

In KCL, in addition to writing `if-elif-else` conditional expressions in top-level statements, it also supports writing conditional expressions in KCL complex structures (list/dict/schema), and supports conditional configuration writing.

```python
x = 1
# Conditional configuration in list
dataList = [
    if x == 1: 1
]
# Conditional configuration in dict
dataDict = {
    if x == 1: key1 = "value1"  # Inline form
    elif x == 2:
        key2 = "value2"  # Multi-line form
}

schema Config:
    id?: int

env = "prod"
# Conditional configuration in schema
dataSchema = Config {
    if env == "prod":
        id = 1
    elif env == "pre":
        id = 2
    elif env == "test":
        id = 3
}
```

## 36. Does the == operator in KCL do deep comparisons?

`==` operator in KCL

- For primitive types `int`, `float`, `bool`, `str` variables are directly compared to see if their values are equal
- Variables of composite types `list`, `dict`, `schema` will deeply recursively compare their sub-elements for equality
  - `list` type deep recursive recursive comparison of the value and length of each index
  - `dict`/`schema` types deeply recursively compare the value of each attribute (regardless of the order in which the attributes appear)

```python
print([1, 2] == [1, 2])  # True
print([[0, 1], 1] == [[0, 1], 1])  # True
print({k1 = 1, k2 = 2} == {k2 = 2, k1 = 1})  # True

print([1, 2] == [1, 2, 3])  # False
print({k1 = 1, k2 = 2, k3 = 3} == {k2 = 2, k1 = 1})  # False
```

## 37. How to modify existing configuration blocks in KCL

In KCL, there are three **attribute operators** `=`, `+=`, `:`, which can be used to modify existing configuration blocks, and can use **unpacking operator** ` **` etc. "inherit" all attribute fields and values ​​of a configuration block.

- The `=` attribute operator means overriding, use `=` operator to override/delete the attribute with priority, (if it is overwritten with `Undefined`, it means deletion)
- The `+=` attribute operator means adding, which is generally used to add sub-elements to the attributes of the list type. The operand type following the `+=` attribute operator can only be of the list type.
- The `:` attribute operator means idempotent merge. When the value conflicts, an error is reported, and when there is no conflict, the merge is performed

### Override attribute operator =

The most commonly used attribute operator is `=`, which indicates the assignment of an attribute. When the same attribute is used multiple times, it means overwriting. For global variables outside `{}` or attributes within `{}`, it means using value overrides this global variable or attribute

```python
data = { # define a dictionary type variable data
    a = 1 # use = to declare a attribute a in data with a value of 1
    b = 2 # use = to declare a attribute b in data with a value of 2
} # The final data value is {"a": 1, "b": 2}
```

we can also use the override attribute operator at the schema instantiation to achieve the effect of overriding the default value of the schema. Generally, when creating a new schema instance, if there is no special requirement, we can generally use `=`

```python
schema Person:
    name: str = "Alice" # schema Person's name attribute has default value "Alice"
    age: int = 18 # schema Person's age attribute has a default value of 18

bob = Person {
    name = "Bob" # "Bob" -> "Alice", the value of the attribute name "Bob" will override the default value "Alice" of the schema Person name attribute
    age = 10 # 10 -> 18, the value of the attribute age of 10 will override the default value of the schema Person age attribute of 18
} # The final value of bob is {"name": "Bob", age: 10}
```

### Insert attribute operator +=

The insert attribute operator means to add the value of an attribute in place, such as adding a new element to a list type attribute

```python
data = {
    args = ["kcl"] # use = to declare an attribute in data with value ["kcl"] args
    args += ["-Y", "settings.yaml"] # Add two elements "-Y", "settings.yaml" to attribute args using += operator
} # The final data value is {"args": ["kcl", "-Y", "settings.yaml"]}
```

### Merge attribute operators :

The merge attribute operator means idempotent merging of different configuration block values ​​of an attribute. When the values ​​to be merged conflict, an error is reported. It is mostly used in complex configuration merging scenarios.

```python
data = {
    labels: {key1: "value1"} # define a labels, its type is dict, the value is {"key1": "value1"}
    labels: {key2: "value2"} # Use : to combine different configuration values ​​of labels
} # The final data value is {"labels": {"key1": "value1", "key2": "value2"}}
```

The merge attribute operator is an idempotent operator, and the writing order of the configuration blocks to be merged does not affect the final result. For example, the two `labels` attributes in the above example can also be written in reverse order.

```python
data = { # The merged writing order of the same attribute labels does not affect the final result
    labels: {key2: "value2"} # define a label whose type is dict and the value is {"key2": "value2"}
    labels: {key1: "value1"} # Use : to combine different configuration values ​​of labels
} # The final data value is {"labels": {"key1": "value1", "key2": "value2"}}
```

Note: The merge attribute operator will check the merged values ​​for conflicts, and report an error when the configuration values ​​that need to be merged conflict.

```python
data = {
    a: 1 # the value of a is 1
    a: 2 # Error: The value 2 of a cannot be merged with the value 1 of a because the results conflict and the merge is not commutative
}
```

```python
data = {
    labels: {key: "value"}
    labels: {key: "override_value"} # Error: The values ​​"value" and "override_value" of the key attributes of two labels are conflicting and cannot be merged
}
```

The coalescing operator is used differently for different types

- Attributes of different types cannot be merged
- When the attribute is a basic type such as int/float/str/bool, the operator will judge whether the values ​​to be merged are equal, and a merge conflict error will occur if they are not equal

```python
data = {
    a: 1
    a: 1 # Ok
    a: 2 # Error
}
```

- when the attribute is of type list
  - Merge conflict error occurs when two lists that need to be merged are not of equal length
  - When the lengths of the two lists to be merged are equal, recursively merge each element in the list according to the index

```python
data = {
    args: ["kcl"]
    args: ["-Y", "settings.yaml"] # Error: The lengths of the two args attributes are not the same and cannot be merged
    env: [{key1: "value1"}]
    env: [{key2: "value2"}] # Ok: The value of the final env attribute is [{"key1": "value1"}, {"key2": "value2"}]
}
```

- When the attribute is of type dict/schema, recursively merge each element in dict/schema according to key

```python
data = {
    labels: {key1: "value1"}
    labels: {key2: "value2"}
    labels: {key3: "value3"}
} # The final data value is {"labels": {"key1": "value1", "key2": "value2", "key3": "value3"}}
```

- the result of combining an attribute of any type with None/Undefined is itself

```python
data = {
    args: ["kcl"]
    args: None # Ok
    args: Undefined #Ok
} # The final data value is {"args": ["kcl"]}
```

Support declaration and merging of top-level variables using the `:` attribute (we can still declare a configuration block using `config = Config {}`)

```python
schema Config:
    id: int
    value: str

config: Config {
    id: 1
}
config: Config {
    value: "1"
}
"""
Two Config configuration blocks are defined here, and the : operator can be used to merge the two configuration blocks together. The equivalent code for the merge is as follows:
config: Config {
    id: 1
    value: "1"
}
"""
```

To sum up, the usage scenario of the merge attribute operator `:` is mainly the merge operation of the complex data structure list/dict/schema. In general, if there is no special requirement, the two attribute operators `=` and `+=` are used. Yes, so the best practice for attribute operators is as follows

- For primitive types, use the `=` operator
- For the list type, the `=` and `+=` operators are generally used. Use `=` to completely override the list attribute, and use `+=` to add elements to the list
- For dict/schema types, the `:` operator is generally used

In addition, when a configuration already exists, we can use the unpacking operator `**` to get all field values ​​of this configuration and modify the fields with different attribute operators, and get a new configuration

```python
configBase = {
    intKey = 1 # A attribute of type int
    floatKey = 1.0 # A attribute of type float
    listKey = [0] # A attribute of type list
    dictKey = {key1: "value1"} # an attribute of type dict
}
configNew = {
    **configBase # Unpack and inline configBase into configNew
    intKey = 0 # Use override attribute operator = to override intKey attribute to 1
    floatKey = Undefined # Use override attribute operator = remove floatKey attribute
    listKey += [1] # Add an attribute 1 to the end of the listKey attribute using the add attribute operator +=
    dictKey: {key2: "value2"} # Use the merge attribute operator: extend a key-value pair for the dictKey attribute
}
```

The output YAML result is:

```yaml
configBase:
  intKey: 1
  floatKey: 1.0
  listKey:
    - 0
  dictKey:
    key1: value1
configNew:
  intKey: 0
  listKey:
    - 0
    - 1
  dictKey:
    key1: value1
    key2: value2
```

Alternatively two configuration blocks can be combined using the `|` operator:

```python
configBase = {
    intKey = 1 # A attribute of type int
    floatKey = 1.0 # A attribute of type float
    listKey = [0] # A attribute of type list
    dictKey = {key1: "value1"} # an attribute of type dict
}
configNew = configBase | { # Use | to merge
    intKey = 0 # Use override attribute operator = to override intKey attribute to 1
    floatKey = Undefined # Use override attribute operator = remove floatKey attribute
    listKey += [1] # Add an attribute 1 to the end of the listKey attribute using the add attribute operator +=
    dictKey: {key2: "value2"} # Use the merge attribute operator: extend a key-value pair for the dictKey attribute
}
```

The output YAML is

```yaml
configBase:
  intKey: 1
  floatKey: 1.0
  listKey:
    - 0
  dictKey:
    key1: value1
configNew:
  intKey: 0
  listKey:
    - 0
    - 1
  dictKey:
    key1: value1
    key2: value2
```

### The solution to the conflicting values on the attribute 'attr' between {value1} and {value2} error in KCL

When an error like conflicting values on the attribute 'attr' between {value1} and {value2} occurs in KCL, it is usually a problem with the use of the merge attribute operator `:`, indicating that when the `value1` and `value2` configurations are merged, the attribute A conflict error occurred at `attr`. In general, modify the attr attribute of value2 to other attribute operators, use `=` to indicate overwrite, and use `+=` to indicate addition

For example for the following code:

```python
data = {k: 1} | {k: 2} # Error: conflicting values on the attribute 'k' between {'k': 1} and {'k': 2}
```

We can use the `=` attribute operator to modify it to the following form

```python
data = {k: 1} | {k = 2} # Ok: the value 2 will override the value 1 through the `=` operator
```

## 38. How to traverse multiple elements at the same time in the for comprehension?

In KCL, we can use for comprehension to traverse multiple elements

- Example 1: two dimension element loop

```python
dimension1 = [1, 2, 3]  # The length of the dimension1 list is 3
dimension2 = [1, 2, 3]  # The length of the dimension2 list is 3
matrix = [x + y for x in dimension1 for y in dimension2]  # The length of the matrix list is 9 = 3 * 3
```

The output YAML is:

```yaml
dimension1:
  - 1
  - 2
  - 3
dimension2:
  - 1
  - 2
  - 3
matrix:
  - 2
  - 3
  - 4
  - 3
  - 4
  - 5
  - 4
  - 5
  - 6
```

- Example 2: Use for loop and `zip` built-in function to traverse multiple lists one by one by index

```python
dimension1 = [1, 2, 3]  # The length of the dimension1 list is 3
dimension2 = [1, 2, 3]  # The length of the dimension2 list is 3
dimension3 = [d[0] + d[1] for d in zip(dimension1, dimension2)]  # The length of the dimension1 list is 3
```

The output YAML is:

```yaml
dimension1:
  - 1
  - 2
  - 3
dimension2:
  - 1
  - 2
  - 3
dimension3:
  - 2
  - 4
  - 6
```

## 39. How to set default value for option function in KCL

In KCL, when the value of the option attribute is None/Undefined or empty, we can use the logical `or` to directly specify a default value.

```python
value = option("key") or "default_value"  # When the value of key exists, take the value of option("key"), otherwise take "default_value"
```

Or use the default parameter of the option function.

```python
value = option("key", default="default_value")  # When the value of key exists, take the value of option("key"), otherwise take "default_value"
```

## 40. How to check that multiple attributes cannot be empty or set values at the same time in schema in KCL?

In KCL, a single attribute of schema cannot be empty by default, unless we use the attribute optional operator `?`.

```python
schema Person:
    name: str  # Required.
    age: int  # Required.
    id?: int  # Optional.
```

When it is necessary to check that the schema attributes cannot be empty at the same time or only one of them is empty, it needs to be written with the help of schema check expressions. The following takes two attributes `a`, `b` of the schema `Config` as an example to illustrate.

- `a` and `b` attributes cannot be empty at the same time.

```python
schema Config:
    a?: str
    b?: str

    check:
        a or b
```

- `a` and `b` attributes can only have one or both empty (cannot exist at the same time or not empty)

```python
schema Config:
    a?: str
    b?: str

    check:
        not a or not b
```

## 41. A file is imported in KCL, but the schema defined by other KCL files in the same directory cannot be found. What might be the reason?

It may be caused to import only this file in this folder. In KCL, import statement supports importing the entire folder, and also supports importing a certain KCL file under a certain folder. For the following directory structure.

```
.
├── kcl.mod
├── main.k
└── pkg
    ├── pkg1.k
    ├── pkg2.k
    └── pkg3.k
```

There is an entry file main.k in the root directory. You can write the following code in main.k to import the entire pkg folder. At this time, all schema definitions in the pkg folder are visible to each other.

```python
import pkg
```

We can also write the following code to import a single file pkg/pkg1.k. At this time, pkg1.k cannot find other files, namely the schema definitions under pkg2.k/pkg3.k

```python
import pkg.pkg1
```

## 42. How is indentation handled in KCL?

In KCL, when a colon `:`, square bracket pair `[]` and curly bracket pair `{}` appear, we generally need to use newline + indentation, and the number of indented spaces for the same indentation level needs to be consistent. The indentation level is generally represented by 4 spaces.

- colon `:` followed by newline and indent

```python
"""Indentation in if statements"""
_a = 1
_b = 1
if _a >= 1:  # colon `:` followed by newline and indent
    if _a > 8:
        _b = 2
    elif a > 6:
        _b = 3

"""Indentation in schema statements"""
schema Person:  # colon `:` followed by newline and indent
    name: str
    age: int
```

- opening bracket `[` followed by newline and indent

```python
data = [  # opening bracket `[` followed by newline and indent
    1
    2
    3
]  # unindent before closing bracket ]
```

```python
data = [  # opening bracket `[` followed by newline and indent
    i * 2 for i in range(5)
]  # unindent before closing bracket `]`
```

- opening bracket `{` followed by newline and indent

```python
data = {  # opening bracket `{` followed by newline and indent
    k1 = "v1"
    k2 = "v2"
} # unindent before closing brace `}`
```

```python
data = {  # opening bracket `{` followed by newline and indent
    str(i): i * 2 for i in range(5)
}  # unindent before closing brace `}`
```

## 43. How to write simple tests for KCL code?

The current version of KCL does not support internal program debugging, we can use the assert statement and the print function to achieve data assertion and viewing.

```python
a = 1
print("The value of a is", a)
assert a == 1
```

In addition, we can also use the kcl-test test tool to write KCL internal test cases

Assuming there is a hello.k file, the code is as follows:

```python
schema Person:
    name: str = "kcl"
    age: int = 1

hello = Person {
    name = "hello kcl"
    age = 102
}
```

Construct the hello_test.k test file with the following contents:

```python
schema TestPerson:
    a = Person{}
    assert a.name == 'kcl'

schema TestPerson_age:
    a = Person{}
    assert a.age == 1

schema TestPerson_ok:
    a = Person{}
    assert a.name == "kcl"
    assert a.age == 1
```

Then execute the kcl-test command in the directory:

```
$ kcl-test
ok   /pkg/to/app [365.154142ms]
$
```

## 44. How to define and use functions in KCL?

The schema structure acts as a function to a certain extent, and this function has the ability to have multiple input parameters and multiple output parameters. For example, the following code can implement the function of a Fibonacci sequence:

```python
schema Fib:
    n: int
    value: int = 1 if n <= 2 else (Fib {n: n - 1}).value + (Fib {n: n - 2}).value

fib8 = (Fib {n: 8}).value
```

The output is

```yaml
fib8: 21
```

A schema function that merges lists into dictionaries

```python
schema UnionAll[data, n]:
    _?: [] = data
    value?: {:} = ((UnionAll(data=data, n=n - 1) {}).value | data[n] if n > 0 else data[0]) if data else {}

schema MergeList[data]:
    """Union all elements in a list returns the merged dictionary

    [{"key1": "value1"}, {"key2": "value2"}, {"key3": "value3"}] -> {"key1": "value1", "key2": "value2", "key3": "value3"}
    """
    _?: [] = data
    value?: {:} = (UnionAll(data=data, n=len(data) - 1) {}).value if data else {}
```

In addition, KCL supports defining a function using the `lambda` keyword:

```python
func = lambda x: int, y: int -> int {
    x + y
}
a = func(1, 1)  # 2
```

A lambda function has the following properties:

- A lambda function takes the value of the last expression as the return value of the function, and an empty function body returns None.
- The return value type annotation can be omitted, the return value type is the type of the last expression value.
- There are no order-independent features in the function body, all expressions are executed in order.

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

A lambda function cannot participate in any computation and can only be used in assignment and call statements.

```python
func = lambda x: int, y: int -> int {
    x + y
}
x = func + 1  # Error: unsupported operand type(s) for +: 'function' and 'int(1)'
```

```python
a = 1
func = lambda x: int {
    x + a
}
funcOther = lambda f, para: int {
    f(para)
}
r = funcOther(func, 1)  # 2
```

The output is

```python
a: 1
r: 2
```

We can define an anonymous function and call it directly

```python
result = (lambda x, y {
    z = 2 * x
    z + y
})(1, 1)  # 3
```

Anonymous functions can be also used in for loops

```python
result = [(lambda x, y {
    x + y
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 3, 3, 4]
```

Functions can be defined and used in the KCL schema

```python
_funcOutOfSchema = lambda x: int, y: int {
    x + y
}
schema Data:
    _funcInSchema = lambda x: int, y: int {
        x + y
    }
    id0: int = _funcOutOfSchema(1, 1)
    id1: int = _funcInSchema(1, 1)
    id2: int = (lambda x: int, y: int {
        x + y
    })(1, 1)
```

The output YAML is

```yaml
data:
  id0: 2
  id1: 2
  id2: 2
```

## 45. Why do we get an error when a variable is assigned an enumeration type (a literal union type)?

In KCL, a attribute defined as a literal union type is only allowed to receive a literal value or a variable of the same literal union type during assignment. For example, the following code is correct:

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

data = Data {
    color = "Red"  # Ok, can be assigned as "Red", "Yellow" and "Blue"
}
```

However the following code is wrong:

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

_color = "Red"

data = Data {
    color = _color  # Error: expect str(Red)|str(Yellow)|str(Blue), got str
}
```

This is because there is no type declared for the variable `_color`, it will be deduced by the KCL compiler as a `str` string type, so when a "larger" type `str` is assigned to a "smaller" type `"Red" | "Yellow" | "Blue"` will report an error, one solution is to declare a type for the `_color` variable, the following code is correct:

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

_color: "Red" | "Yellow" | "Blue" = "Red"

data = Data {
    color = _color  # Ok
}
```

Further, we can use type aliases to simplify enumeration (writing of literal union types), such as the following code:

```python
type Color = "Red" | "Yellow" | "Blue"  # Define a type alias, which can be reused in different places, reducing the amount of code writing

schema Data:
    color: Color

_color: Color = "Red"

data = Data {
    color = _color  # Ok
}
```

## 46. Procedural for loop

KCL provides comprehensions and all/any/map/filter expressions for processing a collection element, which meets most needs, and provides a procedural for loop body. Providing a procedural for loop body is not very demanding from the current scenario, so there is no procedural for loop support yet.

In addition, although KCL does not support procedural for loops, it is possible to "construct" corresponding procedural for loops through for loops and lambda functions.

```python
result = [(lambda x: int, y: int -> int {
    # Write procedural for loop logic in the lambda function.
    z = x + y
    x * 2
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 2, 4, 4]
```

## 47. Default variables are immutable

The immutability of KCL variables means that the exported variables starting with non-underscore `_` in the KCL top-level structure cannot be changed after initialization.

```python
schema Person:
    name: str
    age: int

a = 1  # a will be output to YAML, once assigned it cannot be modified
_b = 1  # _b The variable is named with an underscore and will not be output to YAML. It can be modified by multiple assignments
_b = 2
alice = Person {
    name = "Alice"
    age = 18
}
```

There are two ways of specifying that variables are immutable:

- non-underscore top-level variables outside the schema

```python
a = 1 # immutable exported variable
_b = 2 # mutable non-export variable
```

## 48. Is there a type like Go `interface{}`/`any` or Java `Object` in KCL?

In KCL, we can use the `any` type annotation to define a variable to store any values such as integers, strings and schemas. For example:

```python
schema Data:
    id: int = 1

var_list: [any] = [1, "12", Data {}]
```

The output YAML is

```yaml
var_list:
  - 1
  - "12"
  - id: 1
```

In addition, we can also use the `typeof` function to determine the type of variables during KCL code execution:

```python
schema Data1:
    id: int = 1

schema Data2:
    name: str = "name"

data_list: [any] = [Data1 {}, Data2 {}]
data_type_list: [str] = [typeof(data) for data in data_list]
```

The output YAML is

```yaml
data_list:
  - id: 1
  - name: name
data_type_list:
  - Data1
  - Data2
```

## 49. How to develop a KCL plugin?

KCL plugins are installed in the plugins subdirectory of KCL (usually installed in the `$HOME/.kcl/plugins` directory), or set through the `$KCL_PLUGINS_ROOT` environment variable. Besides, the `plugins` directory could also be placed at the `pwd` path. For plugin developers, plugins are managed in the [Git repository](https://github.com/kcl-lang/kcl-plugin), and the plugin repository can be cloned to this directory for development.

KCL has built-in kcl-plugin scaffolding command to assist users to write KCL plug-ins in Python language, so that the corresponding plug-ins can be called in the KCL file to enhance the KCL language itself, such as accessing the network, reading and writing IO, CMDB query and encryption and decryption functions.

```
usage: kcl-plugin [-h] {list,init,info,gendoc,test} ...

positional arguments:
  {list,init,info,gendoc,test}
                        kcl plugin sub commands
    list list all plugins
    init init a new plugin
    info show plugin document
    gendoc gen all plugins document
    test test plugin

optional arguments:
  -h, --help show this help message and exit
```

For example, if you want to develop a plugin named io, you can use the following command to successfully create a new io plugin

```
kcl-plugin init io
```

Then you can use the following command to get the root path of the plugin and cd to the corresponding io plugin directory for development

```
kcl-plugin info
```

For example, if you want to develop a function read_file to read a file, you can write python code in `plugin.py` of `$plugin_root/io`:

```python
# Copyright 2020 The KCL Authors. All rights reserved.

import pathlib

INFO = {
    'name': 'io',
    'describe': 'my io plugin description test',
    'long_describe': 'my io plugin long description test',
    'version': '0.0.1',
}


def read_file(file: str) -> str:
    """Read string from file"""
    return pathlib.Path(file).read_text()

```

In addition, you can write the corresponding test function in `plugin_test.py`, or you can directly write the following KCL file for testing:

```python
import kcl_plugin.io

text = io.read_file('test.txt')
```

You can also use the info command to view information about the io plugin

```
kcl-plugin info io
```

```
{
    "name": "io",
    "describe": "my io plugin description test",
    "long_describe": "my io plugin long description test",
    "version": "0.0.1",
    "method": {
        "read_file": "Read string from file"
    }
}
```

Finally, the plugin that has written the test can be merged with MR in the `kcl_plugins` repository.

## 50. How to do basic type conversion in KCL

You can use the `int()`, `float()` function and `str()` function to convert the basic types between `int`, `float` and `str`.

```
_t = 1

t_str: str = str(_t)           # you will get "t_str: '1'"
t_int: int = int(t_str)        # you will get "t_int: 1"
t_float: float = float(t_str)  # you will get "t_float: 1.0"
```

For more information about type conversion, see [KCL Builtin Types](https://kcl-lang.io/docs/reference/lang/tour#built-in-types) and [KCL Type System](https://kcl-lang.io/docs/reference/lang/tour#type-system).

## 51. Is there an easy way to unpack a list into a string?

The KCL list provides built-in string formatting methods, which can be achieved using the str function or the format function of the str variable, such as the following code:

```python
allowed = ["development", "staging", "production"]

schema Data:
    environment: str
    check:
        environment in allowed, "environment must be one of {}".format(allowed)
```

## 52. How to output pretty json string in KCL?

KCL has in-built support for getting formatted JSON strings. Here's how you can do it:

Paste the below content in your main.k file.

```python
import json

config = {
    key1 = "value1"
    key2 = "value2"
}
configJson = json.encode(config, ignore_private=True, indent=4)
```

After running this code, `configJson` variable will contain a prettified JSON string.

```json
config:
  key1: value1
  key2: value2
configJson: |-
  {
      "key1": "value1",
      "key2": "value2"
  }
```

## 53. How to calculate the hash or md5 value of KCL objects?

KCL have in-built support for calculating MD5 hashes as well. Here is how you can do it:

Paste the below content in your main.k file.

```python

import crypto

schema Person:
    a: int

aa = Person {a = 1}
bb = Person {a = 2}
cc = Person {a = 2}
aahash = crypto.md5(str(aa))
bbhash = crypto.md5(str(bb))
cchash = crypto.md5(str(cc))
```

After running above script, You'll get output like this:

```bash
aa:
  a: 1
bb:
  a: 2
cc:
  a: 2
aahash: 1992c2ef118972b9c3f96c3f74cdd1a5
bbhash: 5c71751205373815a9f2e022dd846758
cchash: 5c71751205373815a9f2e022dd846758
```

## 54. How to deduplicate str lists?

You can use KCL to deduplicate lists of strings as shown in the code snippet below:

```python
to_set = lambda items: [str] {
    [item for item in {item = None for item in items}]
}

data = to_set(["aa", "bb", "bb", "cc"])
dataIsUnique = isunique(data)
```

After running above script, You'll get output like this:

```bash
data:
- aa
- bb
- cc
dataIsUnique: true
```

## 55. How do i omit attributes in the output for variables with "None" value?

In KCL, there is a builtin disableNone feature `-n` that does not print variables with null value.

```python
a = 1
b = None
```

You can use the following command to run the above script(main.k) with disableNone feature

```shell
kcl main.k -n
```

The output comes out as:

```yaml
a: 1
```

## 56. How to write a schema where a property can have one or more different schemas of definitions?

We can use union types (sum types) in KCL. For example

```shell
schema Config:
    route: EndPoint | Gateway

schema EndPoint:
    attr: str

schema Gateway:
    attr: str
```

## 57. How to convert dict and schema within kcl?

In KCL, dict is a dynamic data that does not have the check constraint of a schema. We can convert dict to a schema to obtain constraints. We can directly assign dict data to schema type data, and KCL runtime will automatically complete type conversion and perform type checking.

```shell
schema Person:
    name: str
    age: int

    check:
        age > 20

config = {
    name = "Alice"
    age = 25
}
alice: Person = config
```

## 58. Please explain the relationship and usage of 'r' prefix in a String and String Interpolation.

In KCL, we can use `${..}` for string interpolation. But in some cases, we don't want to escape it. Therefore, we use create a raw string by prefixing the string literal with `'r'` or `'R'`. An example KCL code over here is:

```python
worldString = "world"
s = "Hello ${worldString}"
raw_s = r"Hello ${worldString}"
```

The output comes out as:

```bash
worldString: world
s: Hello world
raw_s: Hello ${worldString}
```

## 59. How does KCL infer return types in lambdas?

For lambda(s),KCL automatically infers the return value type in the function body, although we can explicitly specify it. An example KCL code over here is:

```python
f1 = lambda t: Type1 {
    Type2 {}
} # The type of f1 is (Type1) -> Type2

f2 = lambda t: Type1 -> Type2 {
    Type2 {}
} # The type of f2 is (Type1) -> Type2
```

## 60. How to convert a list of lists to a single list in KCL?

To convert a list of lists into a single list, we use the `sum()` function. For example if we have a number of lists such as `[[1,2],[3,4], [5,6]]`, we use the KCL code given below to convert these three lists into a single list:

```python
final_list = sum([[1,2],[3,4],[5,6]], [])
```

The above KCL code gives the output:

```yaml
final_list:
  - 1
  - 2
  - 3
  - 4
  - 5
  - 6
```

## 61. What does `version: "v1" = "v1"` mean?

The first `"v1"` over here denotes that the type of the variable `version` is of string literal type. The second `"v1"` denotes that the default value of the variable `version` is `"v1"`.

## 62. How to define a schema to verify the contents of a given JSON file?

We can use the kcl `vet` tool to validate the JSON data in a given JSOn file. For example, in the below data.json file we use the KCL file(schema.k) below to validate the `age` parameter.

data.json

```json
[
  {
    "name": "Alice",
    "age": 18
  },
  {
    "name": "Bob",
    "age": 10
  }
]
```

schema.k

```kcl
schema Person:
    name: str
    age: int

    check:
        age >= 10
```

The command to validate the JSON data below gives the output `Validate success!`.

```bash
kcl vet data.json schema.k
```

## 63. How can i extend an array's default value in a given schema?

We use the += operator to extend the default values in an array.

```KCL 
schema MyApp:
   args: [str] = ["default", "args"]

app = MyApp {
   args += ["additional", "args"]
}
```

