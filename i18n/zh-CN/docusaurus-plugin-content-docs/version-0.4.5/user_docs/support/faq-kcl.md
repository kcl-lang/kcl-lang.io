---
sidebar_position: 2
---

# KCL 语法

## 1. 如何用 KCL 写一个简单的 key-value 对配置

创建一个名为 `config.k` 的文件

```python
cpu = 256
memory = 512
image = "nginx:1.14.2"
service = "my-service"
```

上述 KCL 代码中，定义了 4 个变量 `cpu` 和 `memory` 被声明为整数类型，并且它们的值分别为 `256` 和 `512`，而 `image` 和 `service` 是字符串类型，它们的值分别为 `image` 和 `service`

使用如下命令可以将上述 KCL 文件编译为 YAML 进行输出

```
kcl config.k
```

得到的 YAML 输出为:

```yaml
cpu: 256
memory: 512
image: nginx:1.14.2
service: my-service
```

如果想要输出到文件，可以使用 `-o|--output` 参数:

```
kcl config.k -o config.yaml
```

## 2. KCL 中有哪些基本的数据类型？

KCL 目前的基本数值类型和值包含:

- 整数类型 `int`
  - 举例: 十进制正整数 `1`, 十进制负整数 `-1`, 十六进制整数 `0x10`, 八进制整数 `0o10`, 二进制整数 `0b10`
- 浮点数类型 `float`
  - 举例: 正浮点数 `1.10`, `1.0`, 负浮点数 `-35.59`, `-90.`, 科学记数法浮点数 `32.3e+18`, `70.2E-12`
- 布尔类型 `bool`
  - 举例: 真值 `True`, 假值 `False`
- 字符串类型 `str` - 使用引号 `'`, `"` 标记
  - 举例: 双引号字符串 `"string"`, `"""string"""`, 单引号字符串 `'string'`, `'''string'''`
- 列表类型 `list` - 使用 `[`, `]` 标记
  - 举例: 空列表 `[]`, 字符串列表 `["string1", "string2", "string3"]`
- 字典类型 `dict` - 使用 `{`, `}` 标记
  - 举例: 空字典 `{}`, 键值均为字符串类型的字典 `{"key1": "value1", "key2": "value2"}`
- 结构类型 `schema` - 使用关键字 `schema` 定义，并使用相应的 schema 名称进行实例化
- 空值类型 `None` - 用于表示一个变量的值为空，与输出 YAML 的 `null` 值对应
- 未定义值类型 `Undefined` - 用于表示一个变量未被赋值，值为 `Undefined` 的变量不会被输出到 YAML 中

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

注意: 所有 KCL 类型的变量均可赋值为空值 `None` 和未定义的值 `Undefined`

## 3. 有些 KCL 变量名带 `_` 下划线前缀表示什么？和不带 `_` 下划线前缀的区别是什么？分别适合什么场景下使用？

KCL 中带下划线前缀的变量表示一个**隐藏**的，**可变**的变量，**隐藏**表示带下划线前缀的变量不会被输出到 YAML 当中，包括包级别的下划线前缀变量和 schema 当中的下划线前缀变量。**可变**表示带下划线前缀的变量可被多次重复赋值，不带下划线前缀的变量被赋值后不可变。

带 `_` 下划线前缀的变量与不带 `_` 下划线前缀变量的区别是: 不带 `_` 下划线前缀变量默认是导出到 YAML 当中的，并且具有强不可变性；带 `_` 下划线前缀变量是不导出的，可变的。

```python
name = 'Foo' # 导出变量，不可变变量
name = 'Bar' # 错误：导出变量只能设置一次
```

```python
_name = 'Foo' # 隐藏变量，可变变量
_name = 'Bar'

schema Person:
    _name: str # hidden and mutable
```

## 4. 如何向 dict 中添加元素？

可以使用 union 运算符 `|`, 或者 dict 解包运算符 `**` 来向 dict 中添加一个元素，并且可以使用 `in`,`not in` 等关键字判断 dict 变量当中是否包含某一个键值

```python
_left = {key = {key1 = "value1"}, intKey = 1}  # 注意使用 = 表示覆盖
_right = {key = {key2 = "value2"}, intKey = 2}
dataUnion = _left | _right  # {"key": {"key1": "value1", "key2": "value2"}, "intKey": 2}
dataUnpack = {**_left, **_right}  # {"key": {"key1": "value1", "key2": "value2"}, "intKey": 2}
```

输出 YAML 为:

```yaml
dataUnion:
  key:
    key1: value1
    key2: value2
dataUnpack:
  key:
    key2: value2
```

此外还可以使用 `字符串插值` 或者字符串 `format` 成员函数特性向 kcl dict 添加变量键值对

```python
dictKey1 = "key1"
dictKey2 = "key2"
data = {
    "${dictKey1}" = "value1"
    "{}".format(dictKey2) = "value2"
}
```

输出 YAML 为:

```yaml
dictKey1: key1
dictKey2: key2
data:
  key1: value1
  key2: value2
```

## 5. 如何修改 dict 中的元素？

我们可以使用 union 运算符 `|`, 或者解包运算符 `**` 修改 dict 当中的元素

```python
_data = {key = "value"}  # {"key": "value"}
_data = _data | {key = "override_value1"}  # {"key": "override_value1"}
_data = {**_data, **{key = "override_value2"}}  # {"key": "override_value2"}
```

如果想要删除 dict 中某个键为 `key` 的值，可以使用解包运算符 `**{key = Undefined}` 或者合并运算符 `| {key = Undefined}` 进行覆盖，覆盖后 key 的值为 Undefined，不会进行 YAML 输出。

## 6. 如何向 list 中添加元素？

在 list 中添加元素有两种方式：

- 使用 `+`, `+=` 和 slice 切片连接组装 list 变量达到向 list 中添加元素的目的

```python
_args = ["a", "b", "c"]
_args += ["end"]  # 在list尾部添加元素"end", ["a", "b", "c", "end"]
_args = _args[:2] + ["x"] + _args[2:]  # 在list索引为2的地方插入元素"x", ["a", "b", "x", "c", "end"]
_args = ["start"] + _args  # 在list头部添加元素"start", ["start", "a", "b", "x", "c", "end"]
```

- 使用 `*` 解包运算符连接合并 list

```python
_args = ["a", "b", "c"]
_args = [*_args, "end"]  # 在list尾部添加元素"end", ["a", "b", "c", "end"]
_args = ["start", *_args]  # 在list头部添加元素"start", ["start", "a", "b", "c", "end"]
```

注意：当接连的变量为 `None/Undefined` 时，使用 `+` 可能会发生错误，这时使用 list 解包运算符 `*` 或者使用 `or` 运算符取 list 的默认值可以避免空值判断

```python
data1 = [1, 2, 3]
data2 = None
data3 = [*data1, *data2]  # Right [1, 2, 3]
data4 = data1 + data2 or [] # Right [1, 2, 3], 使用 or 取 data2 的默认值为 []， 当 data2 为 None/Undefined 时，取空列表 [] 进行计算
data5 = data1 + data2  # Error: can only concatenate list (not "NoneType") to list
```

## 7. 如何修改/删除 list 中的元素？

修改 list 中的元素分为两种方式：

- 直接修改 list 某个索引处的值，使用 slice 切片

```python
_index = 1
_args = ["a", "b", "c"]
_args = _args[:index] + ["x"] + _args[index+1:]  # 修改list索引为1的元素为"x", ["a", "x", "c"]
```

- 根据某个条件修改 list 当中的元素，使用 list comprehension 列表推导式

```python
_args = ["a", "b", "c"]
_args = ["x" if a == "b" else a for a in _args]  # 将list当中值为"b"的值都修改为"x", ["a", "x", "c"]
```

删除 list 中的元素分为两种方式：

- 使用 list for 推导表达式中 if 过滤条件
- 使用 filter 表达式对 list 进行元素过滤

比如想要删除一个列表 `[1, 2, 3, 4, 5]` 中大于 2 的数字，则在 KCL 中可以写为:

```python
originList = [1, 2, 3, 4, 5]
oneWayDeleteListItem = [item for item in originList if item <= 2]
anotherWayDeleteListItem = filter item in originList {
    item <= 2
}
```

输出如下结果

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

## 8. 怎样写 for 循环？怎样理解和使用 list comprehension 列表推导式 和 dict comprehension 字典推导式 ？

KCL 目前仅支持函数式/声明式的推导式 for 循环方式，可以按照如下方式遍历 dict 和 list 变量:

list 推导式具体形式为(其中推导式两边使用方括号 `[]`):

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

dict 推导式具体形式为(其中推导式两边使用花括号 `{}`):

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

上述推导式中的 `if` 表示过滤条件，满足条件的表达式 `expr` 才会生成到新的 list 或 dict 中

list 推导式举例:

```python
_listData = [1, 2, 3, 4, 5, 6]
_listData = [l * 2 for l in _listData]  # _listData中所有元素都乘以2，[2, 4, 6, 8, 10, 12]
_listData = [l for l in _listData if l % 4 == 0]  # 筛选出_listData中可以被4整除的所有元素，[4, 8, 12]
_listData = [l + 100 if l % 8 == 0 else l for l in _listData]  # 遍历_listData, 当其中的元素可以被8整除时，将该元素加100，否则保持不变, [4, 108, 12]
```

注意上述代码中第 3 行和第 4 行两个 `if` 的区别:

- 第一个 `if` 表示 list 变量 `_listData` 本身的推导式过滤条件，后不能跟 `else`，满足该过滤条件的元素会继续放在该列表中，不满足条件的元素被剔除，有可能会使列表长度发生变化
- 第二个 `if` 表示 list 迭代变量 `l` 的选择条件，表示 `if-else` 三元表达式，后必须跟 `else`，不论是否满足该条件，产生的元素仍然在该列表中，列表长度不变

dict 推导式举例:

```python
_dictData = {key1 = "value1", key2 = "value2"}
_dictData = {k = _dictData[k] for k in _dictData if k == "key1" and _dictData[k] == "value1"}  # 将_dictData中key为"key1", value为"value1"的元素筛选出来, {"key1": "value1"}
```

使用推导式获得 dict 所有 key:

```python
dictData = {key1 = "value1", key2 = "value2"}
dictDataKeys = [k for k in _dictData]  # ["key1", "key2"]
```

使用推导式对 dict 按照 key 的字典序升序进行排序:

```python
dictData = {key3 = "value3", key2 = "value2", key1 = "value1"}  # {'key3': 'value3', 'key2': 'value2', 'key1': 'value1'}
dictSortedData = {k = dictData[k] for k in sorted(dictData)}  # {'key1': 'value1', 'key2': 'value2', 'key3': 'value3'}
```

多级推导式举例:

```python
array1 = [1, 2, 3]
array2 = [4, 5, 6]
data = [a1 + a2 for a1 in array1 for a2 in array2]  # [5, 6, 7, 6, 7, 8, 7, 8, 9] len(data) == len(array1) * len(array2)
```

双变量循环(for 推导表达式支持 list 的索引迭代以及 dict 的 value 迭代，可以简化 list/dict 迭代过程代码书写):

- list

```python
data = [1000, 2000, 3000]
# 单变量循环
dataLoop1 = [i * 2 for i in data]  # [2000, 4000, 6000]
dataLoop2 = [i for i in data if i == 2000]  # [2000]
dataLoop3 = [i if i > 2 else i + 1 for i in data]  # [1000, 2000, 3000]
# 双变量循环
dataLoop4 = [i + v for i, v in data]  # [1000, 2001, 3002]
dataLoop5 = [v for i, v in data if v == 2000]  # [2000]
# 使用_忽略循环变量
dataLoop6 = [v if v > 2000 else v + i for i, v in data]  # [1000, 2001, 3000]
dataLoop7 = [i for i, _ in data]  # [0, 1, 2]
dataLoop8 = [v for _, v in data if v == 2000]  # [2000]
```

- dict

```python
data = {key1 = "value1", key2 = "value2"}
# 单变量循环
dataKeys1 = [k for k in data]  # ["key1", "key2"]
dataValues1 = [data[k] for k in data]  # ["value1", "value2"]
# 双变量循环
dataKeys2 = [k for k, v in data]  # ["key1", "key2"]
dataValues2 = [v for k, v in data]  # ["value1", "value2"]
dataFilter = {k = v for k, v in data if k == "key1" and v == "value1"}  # {"key1": "value1"}
# 使用_忽略循环变量
dataKeys3 = [k for k, _ in data]  # ["key1", "key2"]
dataValues3 = [v for _, v in data]  # ["value1", "value2"]
```

## 9. 怎样写 if 条件语句？

KCL 支持两种方式书写 if 条件语句:

- if-elif-else 块语句，其中 elif 和 else 块均可省略，并且 elif 块可以使用多次

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

- 条件表达式 `<expr1> if <condition> else <expr2>`, 类似于 C 语言当中的 `<condition> ? <expr1> : <expr2>` 三元表达式

```python
success = True
_result = "success" if success else "failed"
```

注意：在书写 if-elif-else 块语句时注意书写 if 条件后的冒号 `:` 以及保持缩进的统一

除此之外，还可以在 list 或者 dict 结构中直接书写条件表达式(不同的是，在结构中书写的 if 表达式中需要书写的值而不是语句):

- list

```python
env = "prod"
data = [
    "env_value"
    ":"
    if env == "prod":
        "prod"  # 书写需要添加到 data 中的值，而不是语句
    else:
        "other_prod"
]  # ["env_value", ":", "prod"]
```

- dict

```python
env = "prod"
config = {
    if env == "prod":
        MY_PROD_ENV = "prod_value" # 书写需要添加到 config 中的键-值对，而不是语句
    else:
        OTHER_ENV = "other_value"
}  # {"MY_PROD_ENV": "prod_value"}
```

## 10. 怎样表达 "与" "或" "非" 等逻辑运算？

在 KCL 中，使用 `and` 表示"逻辑与", 使用 `or` 表示"逻辑或", 使用 `not` 表示"非", 与 C 语言当中的 `&&`, `||` 和 `~` 语义一致；

```python
done = True
col == 0
if done and (col == 0 or col == 3):
    ok = 1
```

对于整数的"按位与", "按位或"和"按位异或"，在 KCL 中使用 `&`, `|` 和 `^` 运算符表示, 与 C 语言当中的 `&`, `|` 和 `^` 语义一致；

```python
value = 0x22
bitmask = 0x0f

assert (value & bitmask) == 0x02
assert (value & ~bitmask) == 0x20
assert (value | bitmask) == 0x2f
assert (value ^ bitmask) == 0x2d
```

"逻辑或" `or` 的妙用：当需要书写诸如 `A if A else B` 类似的模式时，可以使用 `A or B` 进行简化，比如如下代码:

```python
value = [0]
default = [1]
x0 = value if value else default
x1 = value or default  # 使用 value or default 代替 value if value else default
```

## 11. 如何判断变量是否为 None/Undefined、字符串/dict/list 是否为空？

请注意，在 if 表达式的条件判断中，`False`、`None`、`Undefined`、数字 `0`、空列表 `[]`、空字典 `{}` 和空字符串 `""`, `''`, `""""""`, `''''''` 都被视为值为 `假` 的表达式。

比如判断一个字符串变量 `strData` 既不为 `None/Undefined` 也不为空字符串时(字符串长度大于 0)，就可以简单的使用如下表达式:

```python
strData = "value"
if strData:
    isEmptyStr = False
```

空字典和空列表判断举例:

```python
_emptyList = []
_emptyDict = {}
isEmptyList = False if _emptyList else True
isEmptyDict = False if _emptyDict else True
```

YAML 输出为:

```yaml
isEmptyList: true
isEmptyDict: true
```

或者使用布尔函数 `bool` 进行判断

```python
_emptyList = []
_emptyDict = {}
isEmptyList = bool(_emptyList)
isEmptyDict = bool(_emptyDict)
```

## 12. 字符串怎样拼接、怎样格式化字符串、怎样检查字符串前缀、后缀？怎样替换字符串内容？

- KCL 中可以使用 `+` 运算符连接两个字符串

```python
data1 = "string1" + "string2"  # "string1string2"
data2 = "string1" + " " + "string2"  # "string1 string2"
```

- KCL 中目前存在两种格式化字符串的方式:
  - 字符串变量的 format 方法 `"{}".format()`
  - 字符串插值 `${}`

```python
hello = "hello"
a = "{} world".format(hello)
b = "${hello} world"
```

注意，如果想在 `"{}".format()` 中单独使用 `{` 字符或者 `}`, 则需要使用 `{{` 和 `}}` 分别对 `{` 和 `}` 进行转义，比如转义一个 JSON 字符串如下代码：

```python
data = "value"
jsonData = '{{"key": "{}"}}'.format(data)
```

输出 YAML 为:

```yaml
data: value
jsonData: '{"key": "value"}'
```

注意，如果想在 `${}` 插值字符串中单独使用 `$` 字符，则需要使用 `$$` 对 `$` 进行转义

```python
world = "world"
a = "hello {}".format(world)       # "hello world"
b = "hello ${world}"               # "hello world"
c = "$$hello ${world}$$"           # "$hello world$"
c2 = "$" + "hello ${world}" + "$"  # "$hello world$"
```

输出 YAML 为:

```yaml
world: world
a: hello world
b: hello world
c: $hello world$
c2: $hello world$
```

- KCL 中使用字符串的 `startswith` 和 `endswith` 方法检查字符串的前缀和后缀

```python
data = "length"
isEndsWith = data.endswith("th")  # True
isStartsWith = "length".startswith('len')  # True
```

- KCL 中使用字符串的 replace 方法或者 regex.replace 函数替换字符串的内容

```python
import regex
data1 = "length".replace("len", "xxx")  # 使用"xxx"替换"len", "xxxgth"
data2 = regex.replace("abc123", r"\D", "0")  # 替换"abc123"中的所有非数字为"0", "000123"
```

其中，`r"\D"` 表示不需要使用 `\\` 转义 `\D` 中的反斜杠 `\`，多用于正则表达式字符串中

此外，我们可以在字符串格式化表达式中插入索引占位符或者关键字占位符用于格式化多个字符串

- 索引占位符

```python
x = '{2} {1} {0}'.format('directions', 'the', 'Read')
y = '{0} {0} {0}'.format('string')
```

输出为:

```yaml
x: Read the directions
y: string string string
```

- 关键字占位符

```python
x = 'a: {a}, b: {b}, c: {c}'.format(a = 1, b = 'Two', c = 12.3)
```

输出为:

```yaml
x: 'a: 1, b: Two, c: 12.3'
```

## 13. 字符串中使用单引号和双引号的区别是什么？

KCL 单引号和双引号字符串几乎没有区别。唯一的区别是，不需要在单引号字符串中使用 `\"` 转义双引号 `"`，不需要在双引号字符串中使用 `\'` 转义单引号引号 `'`。

```python
singleQuotedString = 'This is my book named "foo"'  # Don’t need to escape double quotes in single quoted strings.
doubleQuotedString = "This is my book named 'foo'"  # Don’t need to escape single quotes in double quoted strings.
```

此外在 KCL 中，使用三个单引号或者三个双引号组成的长字符串，无需在其中对单引号或者三引号进行转义 (除字符串首尾)，比如如下例子：

```python
longStrWithQuote0 = """Double quotes in long strings "(not at the beginning and end)"""
longStrWithQuote1 = '''Double quotes in long strings "(not at the beginning and end)'''
longStrWithQuote2 = """Single quotes in long strings '(not at the beginning and end)"""
longStrWithQuote3 = '''Single quotes in long strings '(not at the beginning and end)'''
```

输出 YAML：

```yaml
longStrWithQuote0: Double quotes in long strings "(not at the beginning and end)
longStrWithQuote1: Double quotes in long strings "(not at the beginning and end)
longStrWithQuote2: Single quotes in long strings '(not at the beginning and end)
longStrWithQuote3: Single quotes in long strings '(not at the beginning and end)
```

## 14. 如何编写跨行的长字符串？

KCL 中可以使用单引号字符串 + 换行符 `\n` 或者三引号字符串书写一个多行字符串，并且可以借助续行符 `\` 优化 KCL 字符串的形式，比如对于如下代码中的三个多行字符串变量，它们的制是相同的：

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
"""  # 推荐使用 string3 长字符串的书写形式
```

输出 YAML 为：

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

## 15. 如何使用正则表达式？

通过在 KCL 中导入正则表达式库 `import regex` 即可使用正则表达式，其中包含了如下函数:

- **match**: 正则表达式匹配函数，根据正则表达式对输入字符串进行匹配，返回 bool 类型表示是否匹配成功
- **split**: 正则表达式分割函数，根据正则表达式分割字符串，返回分割字串的列表
- **replace**: 正则表达式替换函数，替换字符串中所有满足正则表达式的子串，返回被替换的字符串
- **compile**: 正则表达式编译函数，返回 bool 类型表示是否是一个合法的正则表达式
- **search**: 正则表达式搜索函数，搜索所有满足正则表达式的子串，返回子串的列表

使用举例:

```python
import regex

regex_source = "Apple,Google,Baidu,Xiaomi"
regex_split = regex.split(regex_source, ",")
regex_replace = regex.replace(regex_source, ",", "|")
regex_compile = regex.compile("$^")
regex_search = regex.search("aaaa", "a")
regex_find_all = regex.findall("aaaa", "a")
regex_result = regex.match("192.168.0.1", "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$")  # 判断是否是一个IP字符串
regex_result_false = regex.match("192.168.0,1", "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$")  # 判断是否是一个IP字符串
```

输出 YAML:

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

对于比较长的正则表达式，还可以使用 r-string 忽略 `\` 符号的转义简化正则表达式字符串的书写:

```python
import regex

isIp = regex.match("192.168.0.1", r"^(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|[1-9])."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)."+r"(1\d{2}|2[0-4]\d|25[0-5]|[1-9]\d|\d)$")  # 判断是否是一个IP字符串
```

更多举例:

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

## 16. KCL 当中的 schema 是什么含义？

schema 是 KCL 中一种语言元素，用于定义配置数据的类型，像 C 语言中的 struct 或者 Java 中的 class 一样，在其中可以定义属性，每种属性具有相应的类型。

## 17. 如何声明 schema？

KCL 中使用 schema 关键字可以定义一个结构，在其中可以申明 schema 的各个属性

```python
# 一个Person结构，其中具有属性字符串类型的firstName, 字符串类型的lastName, 整数类型的age
schema Person:
    firstName: str
    lastName: str
    # age属性的默认值为0
    age: int = 0
```

一个复杂例子:

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

在上面的代码中，`cpu` 和 `memory` 被定义为整数 int 类型；`name`，`image` 和 `service` 是字符串 str 类型; `command` 是字符串类型的列表; labels 是字典类型，其键类型和值类型均为字符串。

## 18. 如何为 schema 属性添加 "不可变"、"必选" 约束？

KCL 中使用 `?` 运算符定义一个 schema 的"可选"约束，schema 属性默认都是"必选"的

```python
# 一个Person结构，其中具有属性字符串类型的firstName, 字符串类型的lastName, 整数类型的age
schema Person:
    firstName?: str  # firstName是一个可选属性，可以赋值为None/Undefined
    lastName?: str  # age是一个可选属性，可以赋值为None/Undefined
    # age属性的默认值为0
    age: int = 18  # age是一个必选属性，不能赋值为None/Undefined，并且是一个不可变属性
    age = 10  # Error, age是一个不可变的属性
```

## 19. 如何为 schema 中的属性编写校验规则？

在 schema 定义当中可以使用 check 关键字编写 schema 属性的校验规则, 如下所示，check 代码块中的每一行都对应一个条件表达式，当满足条件时校验成功，当不满足条件时校验失败, 条件表达式后可跟 `, "check error message"` 表示当校验失败时需要显示的信息

```python
import regex

schema Sample:
    foo: str  # Required, 不能为None/Undefined, 且类型必须为str
    bar: int  # Required, 不能为None/Undefined, 且类型必须为int
    fooList: [int]  # Required, 不能为None/Undefined, 且类型必须为int列表
    color: "Red" | "Yellow" | "Blue"  # Required, 字面值联合类型，且必须为"Red", "Yellow", "Blue"中的一个，枚举作用
    id?: int  # Optional，可以留空，类型必须为int

    check:
        bar >= 0  # bar必须大于等于0
        bar < 100 # bar必须小于100
        len(fooList) > 0  # fooList不能为None/Undefined，并且长度必须大于0
        len(fooList) < 100 # fooList不能为None/Undefined，并且长度必须小于100
        regex.match(foo, "^The.*Foo$") # regex 正则表达式匹配
        bar in range(100) # range, bar范围只能为1到99
        bar in [2, 4, 6, 8] # enum, bar只能取2, 4, 6, 8
        bar % 2 == 0  # bar必须为2的倍数
        all foo in fooList {
            foo > 1
        }  # fooList中的所有元素必须大于1
        any foo in fooList {
            foo > 10
        }  # fooList中至少有一个元素必须大于10
        abs(id) > 10 if id  # check if 表达式，当 id 不为空时，id的绝对值必须大于10
```

此外，上述 check 当中比较表达式还可以简写为:

```python
0 <= bar < 100
0 < len(fooList) < 100
```

综上所述，KCL Schema 中支持的校验类型为:

| 校验类型 | 使用方法                                                |
| -------- | ------------------------------------------------------- |
| 范围校验 | 使用 `<`, `>` 等比较运算符                                |
| 正则校验 | 使用 `regex` 系统库中的 `match` 等方法                      |
| 长度校验 | 使用 `len` 内置函数，可以求 `list/dict/str` 类型的变量长度 |
| 枚举校验 | 使用字面值联合类型                                      |
| 非空校验 | 使用 schema 的可选/必选属性                             |
| 条件校验 | 使用 check if 条件表达式                                |

## 20. 如何为 schema 及其属性添加文档注释？

一个完整的 schema 属性注释使用三引号字符串表示，其中的结构如下所示:

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

## 21. 如何基于 schema 编写配置？多个配置之间如何复用公共的配置？

在 schema 实例化的过程中可以使用解包运算符 `**` 对公共的配置进行展开

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

输出 YAML 为:

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

## 22. 基于 schema 编写配置时如何覆盖 schema 属性的默认值？

在定义 schema 后，可以使用 schema 名称实例化相应的配置，使用 `:` 运算符对 schema 默认值进行 union, 使用 `=` 对 schema 默认值进行覆盖。对于 int/float/bool/str 类型的 schema 属性，union 和覆盖的效果相同; 对于 list/dict/schema 类型的 schema 属性，union 和覆盖的效果不同;

```python
schema Meta:
    labels: {str:str} = {"key1" = "value1"}
    annotations: {str:str} = {"key1" = "value1"}

meta = Meta {
    labels: {"key2": "value2"}
    annotations = {"key2" = "value2"}
}
```

输出 YAML 为:

```yaml
meta:
  labels:
    key1: value1
    key2: value2
  annotations:
    key2: value2
```

## 23. 如何通过继承来复用 schema 定义？

可以在 schema 定义处声明 schema 需要继承的 schema 名称:

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

输出 YAML 为:

```yaml
employee:
  firstName: Bob
  lastName: Green
  age: 18
  bankCard: 123456
  nationality: China
```

注意: KCL 只允许 schema 单继承

## 24. 如何通过组合复用 schema 逻辑？

可以使用 KCL schema mixin 复用 schema 逻辑，mixin 一般被用于 schema 内部属性的分离数据，和数据映射等功能，可以使 KCL 代码更具模块化和声明性。注意不同的 mixin 之间的混入属性不建议定义依赖关系，会使得 mixin 使用方式复杂，一般一个 mixin 中作不超过三个属性混入即可。

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

输出 YAML 为:

```yaml
person:
  firstName: John
  lastName: Doe
  fullName: John Doe
  upper: JOHN DOE
```

## 25. 如何导入其他 KCL 文件？

通过 import 关键字可以导入其他 KCL 文件，KCL 配置文件被组织为模块。单个 KCL 文件被视为一个模块，目录被视为一个包，作为一个特殊的模块。import 关键字支持相对路径导入和绝对路径导入两种方式

比如对于如下目录结构:

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

对于 `main.k`, 相对路径导入和绝对路径导入分别可以表示为:

```python
import service  # 绝对路径导入, 根目录为kcl.mod所在的路径
import mixin  # 绝对路径导入, 根目录为kcl.mod所在的路径

import .model1  # 相对路径导入, 当前目录模块
import ..service  # 相对路径导入, 父目录
import ...root  # 相对路径导入, 父目录的父目录
```

注意，对于 KCL 的入口文件 `main.k`, 其不能导入自身所在的文件夹，否则会发生循环导入错误:

```python
import model  # Error: recursively loading
```

## 26. 什么情况下可以省略 import ？

除了 main 包当中的同一文件夹下的 KCL 可以相互引用而不需通过 import 相互引用，比如对于如下目录结构:

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

当 main.k 作为 KCL 命令行入口文件时, model 文件夹中的 main.k, model1.k 和 model2.k 中的变量不能相互引用，需要通过 import 导入，但是 service 文件夹中的 service1.k 和 service2.k 当中的变量可以互相引用，忽略 import

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

## 27. 有一行代码太长了，如何在语法正确的情况下优雅地换行？

在 KCL 中可以使用续行符 `\` 进行换行, 并且在字符串中也可以使用 `\` 表示续行

长字符串连接续行举例:

```python
longString = "Too long expression " + \
             "Too long expression " + \
             "Too long expression "
```

推导表达式续行举例:

```python
data = [1, 2, 3, 4]
dataNew = [
    d + 2 \
    for d in data \
    if d % 2 == 0
]
```

if 表达式续行举例:

```python
condition = 1
data1 = 1 \
    if condition \
    else 2
data2 = 2 \
if condition \
else 1
```

三引号字符串内部续行举例:

```python
longString = """\
The first line\
The continue second line\
"""
```

注意: 使用续行符 `\` 的同时缩进的保持, 如下所示:

错误用例:

```python
data1 = [
    1, 2,
    3, 4 \  
]  # Error, 需要保持右方括号]的缩进

data2 = [
    1, 2,
  3, 4 
]  # Error, 需要数字1和3的缩进统一
```

正确用例:

```python
data1 = [
    1, 2,
    3, 4
]  # Right, 带缩进的列表定义

data2 = [ \
    1, 2, \
    3, 4  \
]  # Right, 使用续行符的列表定义, 实际效果是单行列表

data3 = [ \
    1, 2, \
  3, 4  \
]  # Right, 使用续行符的列表定义, 无需保持缩进, 实际效果是单行列表
```

## 28. **, * 这些符号是什么意思？

- `**`, `*` 出现在 dict/list 外部时分别表示乘方运算符和乘法运算符

```python
data1 = 2 ** 4  # 2的4次方等于16
data2 = 2 * 3  # 2乘以3等于6
```

- `**`, `*` 出现在 dict/list 内部时表示解包运算符，经常用于 list/dict 的解包和合并, 与 Python 当中的解包运算符用法相同

dict 的解包:

```python
data = {"key1" = "value1"}
dataUnpack = {**data, "key2" = "value2"}  # 将data解包合并入dataUnpack中, {"key1": "value1", "key2": "value2"}
```

list 的解包:

```python
data = [1, 2, 3]
dataUnpack = [*data, 4, 5, 6]  # 将data解包合并入dataUnpack中, [1, 2, 3, 4, 5, 6]
```

## 29. 如何取 list/dict/schema 的子元素

在 KCL 中可以使用 select 表达式或者 subscript 表达式取 list/dict/schema 的子元素

- 对于 list 类型，可以使用 `[]` 取列表中的某一个元素或者某一些元素

```python
data = [1, 2, 3]  # 定义一个整数类型的数组
theFirstItem = data[0]  # 取数组中索引为0的元素，即第一个元素 1
theSecondItem = data[1]  # 取数组中索引为1的元素，即第一个元素 2
```

注意：索引的取值不能超出列表的长度，否则会发生错误，可以使用 `len` 函数获得数组的长度

```python
data = [1, 2, 3]
dataLength = len(data)  # 数组长度为3
item = data[3]  # 发生数组索引越界错误
```

此外，还可以使用负数索引倒序获得列表中的元素

```python
data = [1, 2, 3]
item1 = data[-1]  # 取数组中索引为-1的元素，即最后一个元素 3
item2 = data[-2]  # 取数组中索引为-2的元素，即倒数第二个元素 2
```

综上，列表索引的取值范围为 `[-len, len - 1]`

当想要取得列表的一部分时，可以在 `[]` 中使用切片表达式，其具体语法为 `[<列表开始索引>:<列表终止索引>:<列表遍历步长>]`，注意索引开始终止的取值区间为 `左闭右开[<列表开始索引>, <列表终止索引>)`，注意三个参数均可省略不写

```python
data = [1, 2, 3, 4, 5]
dataSlice0 = data[1:2]  # 取列表中索引开始为 1, 终止索引为 2 的元素集合 [2]
dataSlice1 = data[1:3]  # 取列表中索引开始为 1, 终止索引为 3 的元素集合 [2, 3]
dataSlice2 = data[1:]   # 取列表中索引开始为 1, 终止索引为 最后一个索引 的元素集合 [2, 3, 4, 5]
dataSlice3 = data[:3]   # 取列表中索引开始为 第一个索引, 终止索引为 3 的元素集合 [1, 2, 3]
dataSlice4 = data[::2]  # 取列表中索引开始为 第一个索引, 终止索引为 最后一个索引 的元素集合(步长为2) [1, 3, 5]
dataSlice5 = data[::-1] # 反转一个列表，[5, 4, 3, 2, 1]
dataSlice6 = data[2:1]  # 当开始，终止，步长三个参数组合不满足条件时返回空列表 []

```

- 对于 dict/schema 类型，可以使用 `[]` 和 `.` 两种方式取 dict/schema 中的子元素

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

当键值在 dict 中不存在时，返回未定义值 `Undefined`

```python
data = {key1 = "value1", key2 = "value2"}
data1 = data["not_exist_key"]  # Undefined
data2 = data.not_exist_key  # Undefined
```

可以使用 `in` 关键字判断某个键值是否在 dict/schema 中存在

```python
data = {key1 = "value1", key2 = "value2"}
exist1 = "key1" in data  # True
exist2 = "not_exist_key" in data  # False
```

当键值中存在 `.` 时或者需要运行时取一个键值变量对应的值时，只能使用 `[]` 方式，如无特殊情况，使用 `.` 即可:

```python
name = "key1"
data = {key1 = "value1", key2 = "value2", "contains.dot" = "value3"}
data1 = data[name]  # "value1"
data2 = data["contains.dot"]  # "value3"
# 注意这样子是不对的 data3 = data.contains.dot
```

注意：上述取子元素的运算符不能对非 list/dict/schema 集合类型的值进行操作，比如整数，空值等。

```python
data = 1
data1 = 1[0] # error
```

```python
data = None
data1 = None[0] # error
```

在取集合类型的子元素时往往要进行非空或者长度判断：

```python
data = []
item = data[0] if data else None
```

可以使用非空判断符 `?` 添加在 `[]`, `.` 的前面表示进行 if 非空判断，当不满足条件时返回 None，比如上述代码可以简化为:

```python
data = []
item1 = data?[0]  # 当data为空时，返回空值 None
item2 = data?[0] or 1  # 当data为空时，返回空值 None, 如果不想返回 None, 还可与 or 运算符连用返回其他默认值
```

使用 `?` 可以进行递归调用, 避免复杂繁琐的非空判断

```python
data = {key1.key2.key3 = []}
item = data?.key1?.key2?.key3?[0]
```

## 30. 如何在 KCL 代码中判断变量的类型

KCL typeof built-in 函数可以在该函数执行时立即返回一个变量的类型(字符串表示)用于类型断言

用法举例:

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

# 输出
# t1: int
# t2: str
# t3: Person
# t4: Person
# t5: sub.Person
# t6: __main__.Person
```

## 31. 关键字和 KCL 变量名冲突了可以怎么解决?

对于与关键字冲突的标识符，可以在标识符前添加 `$` 前缀用于定义一个关键字标识符，比如如下代码中使用了 `if`, `else` 等关键字作为标识符并且可以得到相应的 YAML 输出

```python
$if = 1
$else = "s"

schema Data:
    $filter: str = "filter"

data = Data {}
```

输出 YAML：

```yaml
data:
  filter: filter
if: 1
else: s
```

注意：在非关键字标识符前添加 `$` 前缀的效果与不添加相同

```python
_a = 1
$_a = 2  # 等效于 `_a = 2`
```

## 32. KCL 的内置类型是 KCL 的关键字吗？是否可用于变量的定义

KCL 的内置类型包括 `int`, `float`, `bool` 和 `str` 四种类型，它们不是 KCL 的关键字，可用于变量的定义，比如如下代码：

```py
int = 1
str = 2
```

输出 YAML 为:

```yaml
int: 1
str: 2
```

注意：如无特殊需求，不建议变量的名称取这些内置类型，因为在有些语言当中，它们作为关键字存在

## 33. 如何在 KCL 中实现类似 Enum 枚举的功能

有两种方式可以在 KCL 中实现 Enum 枚举的方式

- (推荐)使用**字面值类型**的**联合类型**

```python
schema Person:
    name: str
    gender: "Male" | "Female"

person = Person {
    name = "Alice"
    gender = "Male"  # gender 只能为 "Male" 或者 "Female" 
}
```

一个复杂例子

```python
schema Config:
    colors: ["Red" | "Yellow" | "Blue"]  # colors 是一个枚举数组

config = Config {
    colors = [
        "Red"
        "Blue"
    ]
}
```

- 使用 schema 的 check 表达式

```python
schema Person:
    name: str
    gender: "Male" | "Female"

    check:
        gender in ["Male", "Female"]

person = Person {
    name = "Alice"
    gender = "Male"  # gender 只能为 "Male" 或者 "Female" 
}
```

## 34. 如何求字典 dict 的长度

在 KCL 中可以使用 `len` 内置函数直接求 dict 的长度

```python
len1 = len({k1: "v1"})  # 1
len2 = len({k1: "v1", k2: "v2"})  # 2
varDict = {k1 = 1, k2 = 2, k3 = 3}
len3 = len(varDict)  # 3
```

此外，使用 `len` 函数还可以求 `str` 和 `list` 类型长度

```python
len1 = len("hello")  # 5
len2 = len([1, 2, 3])  # 3
```

## 35. 如何在 KCL 中编写带条件的配置

在 KCL 中，除了支持在顶级的语句中书写 `if-elif-else` 条件表达式以外，还支持在 KCL 复杂结构（list/dict/schema）中书写条件表达式，支持带条件的配置书写。

```python
x = 1
# List 结构中的 if 条件语句
dataList = [
    if x == 1: 1
]
# Dict 结构中的 if 条件语句
dataDict = {
    if x == 1: key1 = "value1"  # 可以同一行书写
    elif x == 2:
        key2 = "value2"  # 可以跨行书写
}
# Schema 结构中的 if 条件语句
schema Config:
    id?: int
env = "prod"
dataSchema = Config {
    if env == "prod":
        id = 1
    elif env == "pre":
        id = 2
    elif env == "test":
        id = 3
}
```

## 36. KCL 中的 == 运算符会作深度比较嘛？

KCL 中的 `==` 运算符

- 对于基本类型 `int`, `float`, `bool`, `str` 的变量是直接比较它们的值是否相等
- 对于复合类型 `list`, `dict`, `schema` 的变量会深度递归地比较其中的子元素是否相等
  - `list` 类型深度递归递归比较每个索引的值以及长度
  - `dict`/`schema` 类型深度递归比较每个属性的值(与属性出现的顺序无关)

```python
print([1, 2] == [1, 2])  # True
print([[0, 1], 1] == [[0, 1], 1])  # True
print({k1 = 1, k2 = 2} == {k2 = 2, k1 = 1})  # True

print([1, 2] == [1, 2, 3])  # False
print({k1 = 1, k2 = 2, k3 = 3} == {k2 = 2, k1 = 1})  # False
```

## 37. 如何对 KCL 中已有的配置块进行修改

在 KCL 中，存在三种**属性运算符** `=`、`+=`、`:`，可以用来对已有配置块进行修改，并且可以使用**解包运算符** `**` 等"继承"一个配置块的所有属性字段和值。

- `=` 属性运算符表示覆盖，使用 `=` 运算符可以对属性进行有优先级的覆盖/删除，(如果是用 `Undefined` 覆盖则表示删除)
- `+=` 属性运算符表示添加，一般用于对 list 类型的属性添加子元素，`+=` 属性运算符后跟的操作数类型也只能为 list 类型
- `:` 属性运算符表示幂等合并，当值发生冲突时进行报错，不冲突时进行合并

### 覆盖属性运算符=

最常使用的属性运算符是 `=`，表示一个属性的赋值，多次对同一个属性进行使用时表示覆盖，对于 `{}` 外的全局变量或者 `{}` 内的属性均表示使用值覆盖这个全局变量或者属性

```python
data = {  # 定义一个字典类型的变量 data
    a = 1  # 使用 = 在 data 中声明一个值为 1 的属性 a
    b = 2  # 使用 = 在 data 中声明一个值为 1 的属性 b
}  # 最终 data 的值为 {"a": 1, "b": 1}
```

在 schema 实例化处也可以使用覆盖属性运算符实现对 schema 默认值的覆盖效果，一般在创建新的 schema 实例时如无特殊的需求，一般使用 `=` 即可

```python
schema Person:
    name: str = "Alice"  # schema Person 的 name 属性具有默认值 "Alice"
    age: int = 18  # schema Person 的 age 属性具有默认值 18 
        
bob = Person {
    name = "Bob"  # "Bob" -> "Alice", 属性 name 的值 "Bob" 的值会覆盖 schema Person name 属性的默认值 "Alice"
    age = 10  # 10 -> 18, 属性 age 的值 10 的值会覆盖 schema Person age 属性的默认值 18
}  # 最终 bob 的值为 {"name": "Bob", age: 10}
```

### 插入属性运算符 +=

插入属性运算符表示对一个属性的值进行原地添加，比如向一个 list 类型的属性添加新的元素

```python
data = {
    args = ["kcl"]  # 使用 = 在 data 中声明一个值为 ["kcl"] 的属性 args
    args += ["-Y", "settings.yaml"]  # 使用 += 运算符向属性 args 中添加两个元素"-Y", "settings.yaml"
}  # 最终 data 的值为 {"args": ["kcl", "-Y", "settings.yaml"]}
```

### 合并属性运算符:

合并属性运算符表示对一个属性的不同配置块值进行幂等的合并，当需要合并的值发生冲突时进行报错，多用于复杂配置合并场景

```python
data = {
    labels: {key1: "value1"}  # 定义一个 labels, 它的类型为 dict, 值为 {"key1": "value1"}
    labels: {key2: "value2"}  # 使用 : 将 labels 不同的配置值进行合并
}  # 最终 data 的值为 {"labels": {"key1": "value1", "key2": "value2"}}
```

合并属性运算符属于幂等运算符，需要合并的配置块的书写顺序不影响其最终结果，比如上述例子中的两个 `labels` 属性也可以调换顺序书写

```python
data = {  # 同一个属性 labels 的合并书写顺序不影响最终结果
    labels: {key2: "value2"}  # 定义一个 labels, 它的类型为 dict, 值为 {"key2": "value2"}
    labels: {key1: "value1"}  # 使用 : 将 labels 不同的配置值进行合并
}  # 最终 data 的值为 {"labels": {"key1": "value1", "key2": "value2"}}
```

注意：合并属性运算符会对合并的值进行冲突检查，当需要合并的配置值发生冲突时进行报错

```python
data = {
    a: 1  # a 的值为 1
    a: 2  # Error: a 的值 2 不能与 a 的值 1 进行合并，因为其结果存在冲突，且合并是不可交换的
}
```

```python
data = {
    labels: {key: "value"}
    labels: {key: "override_value"}  # Error: 两个 labels 的 key 属性的值 "value" 和 "override_value" 是冲突的，不可合并
}
```

合并运算符对不同类型的使用方式不同

- 不同类型的属性不能进行合并
- 当属性为 int/float/str/bool 等基本类型时，运算符会判断需要合并的值是否相等，不相等时发生合并冲突错误

```python
data = {
    a: 1
    a: 1  # Ok
    a: 2  # Error
}
```

- 当属性为 list 类型时
  - 当需要合并的两个 list 长度不相等时，发生合并冲突错误
  - 当需要合并的两个 list 长度相等时，按照索引递归地合并 list 当中的每一个元素

```python
data = {
    args: ["kcl"]
    args: ["-Y", "settings.yaml"]  # Error: 两个 args 属性的长度不相同，不能进行合并
    env: [{key1: "value1"}]
    env: [{key2: "value2"}]  # Ok: 最终 env 属性的值为 [{"key1": "value1"}, {"key2": "value2"}]
}
```

- 当属性为 dict/schema 类型时，按照 key 递归地合并 dict/schema 当中的每一个元素

```python
data = {
    labels: {key1: "value1"}
    labels: {key2: "value2"}
    labels: {key3: "value3"}
}  # 最终 data 的值为 {"labels": {"key1": "value1", "key2": "value2", "key3": "value3"}}
```

- 任意类型的属性与 None/Undefined 合并的结果都是其自身

```python
data = {
    args: ["kcl"]
    args: None  # Ok
    args: Undefined  #Ok
}  # 最终 data 的值为 {"args": ["kcl"]}
```

支持顶级变量使用 `:` 属性声明与合并(仍然可使用 `config = Config {}` 的方式声明一个配置块)

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
此处定义了两个 Config 配置块，使用 : 运算符将可以两个配置块合并在一起，其合并的等效代码如下:
config: Config {
    id: 1
    value: "1"
}
"""
```

综上所述，合并属性运算符 `:` 的使用场景主要为复杂数据结构 list/dict/schema 的合并操作，一般情况如无特殊需求使用 `=` 和 `+=` 两种属性运算符即可，因此属性运算符的最佳实践如下

- 对于基本类型，采用 `=` 运算符
- 对于 list 类型，一般采用 `=` 和 `+=` 运算符，使用 `=` 表示完全覆盖 list 属性，使用 `+=` 表示向 list 中添加元素
- 对于 dict/schema 类型，一般采用 `:` 运算符

此外，当已经存在一个配置时，可以使用解包运算符 `**` 获得此配置的所有字段值并对其中的字段使用不同属性运算符进行修改，并获得一个新的配置

```python
configBase = {
    intKey = 1  # 一个 int 类型的属性
    floatKey = 1.0  # 一个 float 类型的属性
    listKey = [0]  # 一个 list 类型的属性
    dictKey = {key1: "value1"}  # 一个 dict 类型的属性
}
configNew = {
    **configBase  # 将 configBase 解包内联到 configNew 中
    intKey = 0  # 使用 覆盖属性运算符 = 将 intKey 属性覆盖为 1
    floatKey = Undefined  # 使用 覆盖属性运算符 = 删除 floatKey 属性
    listKey += [1]  # 使用 添加属性运算符 += 为 listKey 属性尾部添加一个属性 1
    dictKey: {key2: "value2"}  # 使用 合并属性运算符 : 为 dictKey 属性扩展一个键-值对
}
```

输出的 YAML 结果为:

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

或者可以使用 `|` 运算符对两个配置块合并:

```python
configBase = {
    intKey = 1  # 一个 int 类型的属性
    floatKey = 1.0  # 一个 float 类型的属性
    listKey = [0]  # 一个 list 类型的属性
    dictKey = {key1: "value1"}  # 一个 dict 类型的属性
}
configNew = configBase | { # 使用 | 进行合并
    intKey = 0  # 使用 覆盖属性运算符 = 将 intKey 属性覆盖为 1
    floatKey = Undefined  # 使用 覆盖属性运算符 = 删除 floatKey 属性
    listKey += [1]  # 使用 添加属性运算符 += 为 listKey 属性尾部添加一个属性 1
    dictKey: {key2: "value2"}  # 使用 合并属性运算符 : 为 dictKey 属性扩展一个键-值对
}
```

输出的 YAML 结果为:

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

### KCL 发生 conflicting values on the attribute 'attr' between {value1} and {value2} 错误的解决方式

当 KCL 发生类似 conflicting values on the attribute 'attr' between {value1} and {value2} 错误时，一般是合并属性运算符 `:` 的使用问题，表明 `value1` 和 `value2` 配置进行合并时在属性 `attr` 处发生了冲突错误。一般情况将 value2 的 attr 属性修改为其他属性运算符即可，使用 `=` 表示覆盖，使用 `+=` 表示添加

比如对于如下代码:

```python
data = {k: 1} | {k: 2}  # Error: conflicting values on the attribute 'k' between {'k': 1} and {'k': 2}
```

则可以使用 `=` 属性运算符修改为如下形式

```python
data = {k: 1} | {k = 2}  # Ok: the value 2 will override the value 1 through the `=` operator
```

## 38. KCL 中如何同时遍历多个元素

KCL 中可以使用 for 推导表达式遍历多个元素

- 举例 1: 使用 for 进行 2 维元素遍历

```python
dimension1 = [1, 2, 3]  # dimension1 列表的长度是 3
dimension2 = [1, 2, 3]  # dimension2 列表的长度是 3
matrix = [x + y for x in dimension1 for y in dimension2]  # matrix 列表的长度是 9 = 3 * 3
```

输出结果如下:

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

- 举例 2: 使用 for 循环配合 zip 内置函数按照索引一一对应对多个列表进行遍历

```python
dimension1 = [1, 2, 3]  # dimension1 列表的长度是 3
dimension2 = [1, 2, 3]  # dimension2 列表的长度是 3
dimension3 = [d[0] + d[1] for d in zip(dimension1, dimension2)]  # dimension3 列表的长度是 3
```

输出结果如下:

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

## 39. KCL 中如何为 option 函数设定默认值

在 KCL 中，当 option 属性的值为 None/Undefined 空时，可以使用逻辑或 `or` 直接指定一个默认值

```python
value = option("key") or "default_value"  # 当 key 的值存在时，取 option("key") 的值，否则取 "default_value"
```

或者使用 option 函数的 default 参数

```python
value = option("key", default="default_value")  # 当 key 的值存在时，取 option("key") 的值，否则取 "default_value"
```

## 40. KCL 中 schema 怎么检查多个属性不能同时为空

在 KCL 中，对于 schema 的单个属性不能为空可以使用属性非空标记

```python
schema Person:
    name: str  # required. name 不能为空
    age: int  # required. age 不能为空
    id?: int  # optional. id 可以留空
```

而对于需要检查 schema 属性不能同时为空或者只能有一者为空的情况时，需要借助 schema check 表达式进行书写，下面以同一个 schema Config 的两个属性 a, b 为例进行说明

- Config 的 a, b 属性不能同时为空

```python
schema Config:
    a?: str
    b?: str

    check:
        a or b, "a属性和b属性不能同时为空"
```

- Config 的 a, b 属性只能有一个为空或者都为空（不能同时存在或不为空）

```python
schema Config:
    a?: str
    b?: str

    check:
        not a or not b, "a属性和b属性不能同时填写"
```

## 41. KCL 中 import 了某个文件但是找不到其同目录下其他 KCL 文件定义的 schema 可能是什么原因

可能是与使用 import 仅导入了这个文件夹的这一个文件导致，在 KCL 中，import 支持导入整个文件夹，也支持导入某一个文件夹下的的某一个 KCL 文件，比如对于如下目录结构

```
.
├── kcl.mod
├── main.k
└── pkg
    ├── pkg1.k
    ├── pkg2.k
    └── pkg3.k
```

在根目录下存在入口文件 main.k，可以在 main.k 中书写如下代码导入整个 pkg 文件夹，此时 pkg 文件夹下的所有 schema 定义互相可见

```python
import pkg
```

还可以书写如下代码导入单个文件 pkg/pkg1.k，此时 pkg1.k 不能找到其他文件即 pkg2.k/pkg3.k 下的 schema 定义

```python
import pkg.pkg1
```

## 42. KCL 中的缩进是如何处理的?

在 KCL 中，在出现冒号 `:`、中括号对 `[]` 以及大括号对 `{}` 时，一般需要使用换行 + 缩进，同一缩进级的缩进空格数需要保持一致，一个缩进级一般采用 4 个空格表示

- 冒号 `:` 后跟换行 + 缩进

```python
"""if 语句中的缩进"""
_a = 1
_b = 1
if _a >= 1:  # 冒号后跟换行+缩进
    if _a > 8:
        _b = 2
    elif a > 6:
        _b = 3

"""schema 定义中的缩进"""
schema Person:  # 冒号后跟换行+缩进
    name: str
    age: int
```

- 中括号对 `[]` 后跟换行 + 缩进

```python
data = [  # 左中括号 [ 后跟换行+缩进
    1
    2
    3
]  # 右中括号 ] 前取消缩进
```

```python
data = [  # 左中括号 [ 后跟换行+缩进
    i * 2 for i in range(5)
]  # 右中括号 ] 前取消缩进
```

- 大括号对 `{}` 后跟换行 + 缩进

```python
data = {  # 左大括号 { 后跟换行+缩进
    k1 = "v1"
    k2 = "v2"
}  # 右大括号 } 前取消缩进
```

```python
data = {  # 左大括号 { 后跟换行+缩进
    str(i): i * 2 for i in range(5)
}  # 右大括号 } 前取消缩进
```

## 43. 如何为 KCL 代码编写简单的测试？

KCL 目前的版本还不支持内部程序调试，可以使用 assert 语句以及 print 函数实现数据的断言和打印查看

```python
a = 1
print("The value of a is", a)
assert a == 1
```

此外，还可以借助 kcl-test 测试工具编写 KCL 内部编写测试用例

假设有 hello.k 文件，代码如下:

```python
schema Person:
    name: str = "kcl"
    age: int = 1

hello = Person {
    name = "hello kcl"
    age = 102
}
```

构造 hello_test.k 测试文件，内容如下：

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

然后在目录下执行 kcl-test 命令:

```
$ kcl-test
ok   /pkg/to/app [365.154142ms]
$
```

## 44. KCL 中如何定义函数或定义方法？

schema 结构在一定程度上充当了函数的功能，并且这个函数具有多个输入参数和多个输出参数的能力，比如如下代码可以实现一个斐波那契数列的功能:

```python
schema Fib:
    n: int
    value: int = 1 if n <= 2 else (Fib {n: n - 1}).value + (Fib {n: n - 2}).value

fib8 = (Fib {n: 8}).value
```

输出结果为:

```yaml
fib8: 21
```

一个合并列表为字典的 schema 函数

```python
schema UnionAll[data, n]:
    _?: [] = data
    value?: {:} = ((UnionAll(data=data, n=n - 1) {}).value | data[n] if n > 0 else data[0]) if data else {}

schema MergeList[data]:
    """Union一个列表中的所有元素返回合并字典

    [{"key1": "value1"}, {"key2": "value2"}, {"key3": "value3"}] -> {"key1": "value1", "key2": "value2", "key3": "value3"}
    """
    _?: [] = data
    value?: {:} = (UnionAll(data=data, n=len(data) - 1) {}).value if data else {}
```

此外，KCL 支持使用 `lambda` 关键字定义一个函数:

```python
func = lambda x: int, y: int -> int {
    x + y
}
a = func(1, 1)  # 2
```

lambda 函数具有如下特性：

- lambda 函数将最后一个表达式的值作为函数的返回值，空函数体返回 None。
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

输出为：

```python
a: 1
r: 2
```

可以定义一个匿名函数并直接调用

```python
result = (lambda x, y {
    z = 2 * x
    z + y
})(1, 1)  # 3
```

可以在 for 循环使用使用匿名函数

```python
result = [(lambda x, y {
    x + y
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 3, 3, 4]
```

可以在 KCL schema 中定义并使用函数

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

输出 YAML 为:

```yaml
data:
  id0: 2
  id1: 2
  id2: 2
```

## 45. 为什么变量赋值为枚举类型(字面值联合类型)时会报错

在 KCL 中，被定义为字面值联合类型的属性，在赋值时仅允许接收一个字面值或者同为字面值联合类型的变量，比如如下代码是正确的：

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

data = Data {
    color = "Red"  # Ok, 赋值为 "Red"、"Yellow" 和 "Blue" 均可
} 
```

然而以下代码是错误的：

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

_color = "Red"

data = Data {
    color = _color  # Error: expect str(Red)|str(Yellow)|str(Blue), got str
} 
```

这是因为没有为变量 `_color` 申明一个类型，它会被 KCL 编译器推导为 `str` 字符串类型，因此当一个 “较大” 的类型 `str` 赋值为一个 “较小” 的类型时 `"Red" | "Yellow" | "Blue"` 会报错，一个解决方式是为 `_color` 变量声明一个类型，以下代码是正确的：

```python
schema Data:
    color: "Red" | "Yellow" | "Blue"

_color: "Red" | "Yellow" | "Blue" = "Red"

data = Data {
    color = _color  # Ok
}
```

进一步地，我们可以使用类型别名来简化枚举(字面值联合类型的书写)，比如如下代码：

```python
type Color = "Red" | "Yellow" | "Blue"  # 定义一个类型别名，可以在不同的地方重复使用，降低代码书写量

schema Data:
    color: Color

_color: Color = "Red"

data = Data {
    color = _color  # Ok
}
```

## 46. 过程式的 for 循环

KCL 中为何不支持过程式的 for 循环！

KCL 提供了推导表达式以及 all/any/map/filter 表达式等用于对一个集合元素进行处理，满足大部分需求，提供过程式的 for 循环体从目前场景看需求暂时不强烈，因此暂未提供过程式的 for 循环支持

此外，KCL 中虽然没有支持过程式的 for 循环，但是可以通过 for 循环和 lambda 函数“构造”相应的过程式 for 循环

```python
result = [(lambda x: int, y: int -> int {
    # 在其中书写过程式的 for 循环逻辑
    z = x + y
    x * 2
})(x, y) for x in [1, 2] for y in [1, 2]]  # [2, 2, 4, 4]
```

## 47. 默认变量不可变

KCL 变量不可变性是指 KCL 顶层结构中的非下划线 `_` 开头的导出变量初始化后不能被改变。

```python
schema Person:
    name: str
    age: int

a = 1  # a会输出到YAML中，一旦赋值不可修改
_b = 1  # _b变量以下划线开头命名，不会输出到YAML中, 可多次赋值修改
_b = 2
alice = Person {
    name = "Alice"
    age = 18
}
```

规定变量不可变的方式分为两类：

- schema 外的非下划线顶层变量

```python
a = 1  # 不可变导出变量
_b = 2  # 可变非导出变量
```

## 48. 在 KCL 中存在类似 Go `interface{}`/`any` 或者 Java `Object` 的类型嘛?

In KCL, we can use the `any` type annotation to define a variable to store any values such as integers, strings and schemas. For example:

在 KCL 中，我们可以使用 `any` 类型注解来定义一个变量存储任意类型比如整数、字符串、schema 结构等数据。比如如下例子:

```python
schema Data:
    id: int = 1

var_list: [any] = [1, "12", Data {}]
```

输出 YAML 为:

```yaml
var_list:
- 1
- '12'
- id: 1
```

此外，我们可以使用 `typeof` 函数来判断 KCL 变量的类型:

```python
schema Data1:
    id: int = 1

schema Data2:
    name: str = "name"

data_list: [any] = [Data1 {}, Data2 {}]
data_type_list: [str] = [typeof(data) for data in data_list]
```

输出 YAML 为:

```yaml
data_list:
- id: 1
- name: name
data_type_list:
- Data1
- Data2
```

## 49. 如何通过编写 KCL 插件进行扩展?

KCL 插件在 KCLVM 的 plugins 子目录（通常安装在 `$HOME/.kusion/kclvm/plugins` 目录），或者通过 `$KCL_PLUGINS_ROOT` 环境变量设置（环境变量优先级更高）。对于插件开发人员，插件都在 [Git 仓库](https://github.com/KusionStack/kcl-plugin)管理，可以将插件仓库克隆到该目录进行开发。

KCL 内置了 kcl-plugin 脚手架命令用于辅助用户使用 Python 语言编写 KCL 插件，以便在 KCL 文件当中调用相应的插件对 KCL 语言本身进行增强，比如访问网络，读写 IO，CMDB 查询和加密解密等功能。

```
usage: kcl-plugin [-h] {list,init,info,gendoc,test} ...

positional arguments:
  {list,init,info,gendoc,test}
                        kcl plugin sub commands
    list                list all plugins
    init                init a new plugin
    info                show plugin document
    gendoc              gen all plugins document
    test                test plugin

optional arguments:
  -h, --help            show this help message and exit
```

比如想要开发一个名为 io 插件，就可以使用如下命令成功新建一个 io 插件

```
kcl-plugin init io
```

然后可以使用如下命令获得 plugin 的根路径并 cd 到相应的 io 插件目录进行开发

```
kcl-plugin info
```

比如想要开发一个读文件的函数 read_file，就可以在 `$plugin_root/io` 的 `plugin.py` 中进行 python 代码编写：

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

另外可以在 `plugin_test.py` 中编写相应的测试函数，也可以直接编写如下所示 KCL 文件进行测试：

```python
import kcl_plugin.io

text = io.read_file('test.txt')
```

还可以使用 info 命令查看 io 插件的信息

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

最后将编写测试完成的插件在 `kcl_plugins` 仓库提 MR 合并即可

## 50. 如何在 KCL 中进行基本类型转换

可以使用`int()`, `float()`和`str()` 这些内置的方法来进行 `int`, `float` 和 `str` 之间的基本类型转换.

```
_t = 1

t_str: str = str(_t)           # 输出的 t_str 为一个字符串 "t_str: '1'"
t_int: int = int(t_str)        # 输出的 t_int 为一个整型 "t_int: 1"
t_float: float = float(t_str)  # 输出的 t_float 为一个浮点型 "t_float: 1.0"
```

如果您想查看更多详细的关于KCL类型系统和类型转换的内容，您可以查阅 [KCL 内置类型](https://kcl-lang.io/docs/reference/lang/tour#built-in-types) 和 [KCL 类型系统](https://kcl-lang.io/docs/reference/lang/tour#type-system)。
