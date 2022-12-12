---
title: "builtin"
sidebar_position: 1
---
KCL 提供了一个内置系统模块的列表，这些模块是自动加载的，无需提供任何模块名称即可直接使用。例如，`print` 就是一个广泛使用的内置模块提供的函数。

## 类型转换

KCL的 `bool`、`int`、`float`、`str`、`list`、`dict`等类型有内置同名的转换函数。其中 `int` 不仅仅可以用于截断浮点数，也可以用来将字符串转化为整数（解析时为10进制，也可以制定其他值）。

下面是类型相关函数常见的用法：

```py
b1 = bool(1)  # true
b2 = bool(1.5)  # true
b3 = bool("true")  # true
b4 = bool("")  # false
b5 = bool([])  # false
b6 = bool({})  # false

i1 = int("11")  # 11
i2 = int("11", base=8)  # 9
i3 = int("11", base=2)  # 3

f1 = float(1)  # 1.0
f2 = float("1.5")  # 1.5

s1 = str(1)  # 1

l1 = list([1, 2, 3])
```

## print

`print(*args:any, end:str='\n')`

内置的打印函数，提供不同类型的可变参数打印，默认在结尾添加一个换行符号。以下上常见的用法：

```python
print("hello KCL")
print()
print(None, end=':')
print(None)
print(True)
print(False)
print(123)
print(123.0)
print('abc ${123}')
print("abc ${456}")
print([1,'a', True])
print(1,'a', True)
print({})
print({a: 123})
```

输出格式如下：

```shell
hello KCL

None:None
True
False
123
123.0
abc 123
abc 456
[1, 'a', True]
1 a True
{}
{'a': 123}
```

如果不希望在默认换行时，可以通过 `end=''` 命名参数重新指定结尾的字符串。

## multiplyof

`multiplyof(a:int, b:int) -> bool`

判断整数 `a` 是否为 `b` 的整数倍，返回布尔值：

```python
print(multiplyof(2, 1))  # True
print(multiplyof(1, 2))  # False
print(multiplyof(0, 1))  # True
print(multiplyof(0, 2))  # True
print(multiplyof(1, 0))  # Error
```

`0` 是任何数的倍数。但是 `b` 不能为 `0`，否则将抛出异常。

## isunique

`isunique(list: [any]) -> bool`

判断数组中是否存在重复的元素，返回布尔值：

```python
print(isunique([]))     # True
print(isunique([1]))    # True
print(isunique([1, 2])) # True

print(isunique([1, 1]))     # False
print(isunique([1, 1.0]))   # False
print(isunique([1.1, 1.1])) # False

print(isunique(['abc', "abc"]))      # False
print(isunique(['abc', "a${'bc'}"])) # False
```

需要注意的是整数和浮点数会忽略类型差异，根据值是否相等判断。

## len

`len(x: str | [any] | {:}) -> int`

返回字符串、列表和数组的长度：

```python
print(len([])) # 0
print(len({})) # 0

print(len([1]))       # 1
print(len({abc:123})) # 1

print("abc") # 3
```

注：不支持对 `schema` 对象计算长度。

## abs

`abs(x: number) -> number`

计算 `x` 的绝对值。

## all_true

`all_true(x:str|[]|{:}) -> bool`

判断列表或字典类全部元素为真，用法如下：

```python
print(all_true([])) # True
print(all_true({})) # True

print(all_true([True])) # True
print(all_true([1]))    # True

print(all_true([True, False])) # False
print(all_true([True, None]))  # False
```

当列表为空时返回真。

<!--
反直觉特性:
print(all_true({abc: False})) # True

可以考虑调整对 str 和 dict 的语言
-->

## any_true

`any_true(x:str|[]|{:}) -> bool`

判断可迭代对象中至少有一个元素为真，用法如下：

```python
print(any_true([]))  # False
print(any_true([1])) # True
```

## bin

`bin(x:number) -> str`

返回整数的二进制表示的字符串，用法如下：

```python
print(bin(8)) # 0b1000
```

## hex

`hex(number)`

返回整数的十六进制表示的字符串，用法如下：

```python
print(hex(18)) # 0x12
```

## oct

`oct(number)`

返回整数的八进制表示的字符串，用法如下：

```python
print(oct(10)) # 0o12
```

## option

`option(key:str, type:str='', required=False, default=None, help="") -> any`

获取命令行参数输入的值。

## ord

`ord(c) -> int`

获取字符的 Unicode 码点值，用法如下：

```python
print(ord('A')) # 65
print(ord('B')) # 66
print(ord('C')) # 67
```

## sorted

`sorted(x: []) -> []`

返回排序后的列表，用法如下：

```python
_a = []
_b = [2, 1]

_c = sorted(_a)
_d = sorted(_b)

print(_a) # []
print(_b) # [2, 1]
print(_c) # []
print(_d) # [1, 2]
```

## range

`range(start:int, end:int, step=1) -> [int]`

产生迭代列表，用法如下：

```python
print(range(1,5))      # [1, 2, 3, 4]
print(range(1,5, 2))   # [1, 3]
print(range(5, 1, -1)) # [5, 4, 3, 2]
```

## min

`min(x:[number]) -> number`

返回列表中最小的元素，用法如下：

```python
print(min([1,2])) # 1
print(min([2,1])) # 1
```

<!--
对字符串列表的语义是否需要收紧?
-->

## max

`max(x:[number]) -> number`

返回列表中最大的元素，用法如下：

```python
print(max([1,2])) # 2
print(max([2,1])) # 2
```

## sum

`sum(x:[number], init_value=0) -> number`

返回列表中全部元素的和，用法如下：

```
print(sum([1,2]))       # 3
print(sum([2,1], 1000)) # 1003
```

## pow

`pow(x: number, y: number, z: number = None) -> number`

 计算 `x**y`，如果 `z` 非空则计算 `(x**y)%z`，支持整数和浮点数。

下面的常见的用法：

```python
print(pow(2,3))    # 8
print(pow(2, 3, 5)) # 8%5 == 3

print(pow(2, 0.5)) # 1.414
```

## round

`round(number: int|float, ndigits:int|None) -> float | int`

返回 `number` 的四舍五入近似值。如果 `ndigits` 非 `None` 则返回浮点数并保留指定位数的小数（不能为负数），否则返回整数结构。

下面是常用的用法：

```python
print(round(1))   # 1
print(round(1.4)) # 1
print(round(1.5)) # 2

print(round(1.5555, 1)) # 1.6
print(round(1.5555, 2)) # 1.56

print(round(1.5555))    # 2
print(round(1.5555, 0)) # 2.0
```

需要注意的是，`ndigits` 为 `None` 和 `0` 的区别是前缀返回 `int` 类型、后者返回 `float` 类型。

## typeof

`typeof(x: any, full_name: bool = False) -> str`

输出 `x` 在运算时的类型。当 `full_name` 参数设置为 `True` 时，将返回 `pkg.schema` 形式的包前缀。

下面是常见的用法：

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

## zip

`zip(*args: str|list|dict)`

用于将可迭代的对象作为参数，将对象中对应的元素打包成一个个元组，然后返回由这些元组组成的列表。

下面是常见的用法：

```py
a = zip([0, 1, 2], [3, 4, 5])
b = zip([0, 1], [3, 4, 5])
c = zip([0, 1, 2], [3, 4, 5, 6])

# 输出
# a:
# - - 0
#   - 3
# - - 1
#   - 4
# - - 2
#   - 5
# b:
# - - 0
#   - 3
# - - 1
#   - 4
# c:
# - - 0
#   - 3
# - - 1
#   - 4
# - - 2
```
