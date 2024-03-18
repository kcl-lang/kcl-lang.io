---
title: "builtin"
sidebar_position: 1
---

KCL provides a list of built-in functions that are automatically loaded and can be used directly without providing any module name. For example, `print` is a function provided by a widely used built-in module.

## Type Conversion Functions

KCL's `bool`, `int`, `float`, `str`, `list`, `dict` and other types have built-in conversion functions of the same name. Among them, `int` can not only be used to truncate floating-point numbers, but also can be used to convert strings to integers (decimal when parsing, other values can also be specified).

The following are common uses of type-related functions:

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

## String Builtin Member Functions

- [String Spec](/docs/reference/lang/spec/datatypes)

## print

`print(*args:any, end:str='\n')`

The built-in print function, which provides different types of variable parameter printing, adds a newline at the end by default. The following are common usages:

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

The output is:

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

If you do not want the default newline, you can re-specify the ending string with the `end=''` named parameter.

```python
print("Hello KCL", end='')
```

## multiplyof

`multiplyof(a:int, b:int) -> bool`

Check whether the integer `a` is an integer multiple of `b`, and return a boolean value:

```python
print(multiplyof(2, 1))  # True
print(multiplyof(1, 2))  # False
print(multiplyof(0, 1))  # True
print(multiplyof(0, 2))  # True
print(multiplyof(1, 0))  # Error
```

`0` is a multiple of any number. But `b` cannot be `0`, otherwise an exception will be thrown.

## isunique

`isunique(list: [any]) -> bool`

Check if there are duplicate elements in an array, and return a boolean value:

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

It should be noted that integers and floating-point numbers ignore the type difference and judge whether the values are equal.

## len

`len(x: str | [any] | {:}) -> int`

Return the length of strings, lists, and arrays:

```python
print(len([])) # 0
print(len({})) # 0

print(len([1]))       # 1
print(len({abc:123})) # 1

print("abc") # 3
```

Note: Calculating lengths on `schema` objects is not supported.

## abs

`abs(x: number) -> number`

Calculate the absolute value of `x`.

## all_true

`all_true(x:str|[]|{:}) -> bool`

Judging that all elements of a list or dictionary class are true, the usage is as follows:

```python
print(all_true([])) # True
print(all_true({})) # True

print(all_true([True])) # True
print(all_true([1]))    # True

print(all_true([True, False])) # False
print(all_true([True, None]))  # False
```

Returns true when the list is empty.

## any_true

`any_true(x:str|[]|{:}) -> bool`

Judging that at least one element in the iterable object is true, the usage is as follows:

```python
print(any_true([]))  # False
print(any_true([1])) # True
```

## bin

`bin(x:number) -> str`

A string that returns the binary representation of an integer, used as follows:

```python
print(bin(8)) # 0b1000
```

## hex

`hex(number)`

A string that returns the hexadecimal representation of an integer, used as follows:

```python
print(hex(18)) # 0x12
```

## oct

`oct(number)`

A string that returns the octal representation of an integer, used as follows:

```python
print(oct(10)) # 0o12
```

## option

`option(key:str, type:str='', required=False, default=None, help="") -> any`

Gets the value of the command line top level argument input.

## ord

`ord(c) -> int`

Get the Unicode code point value of the character, the usage is as follows:

```python
print(ord('A')) # 65
print(ord('B')) # 66
print(ord('C')) # 67
```

## sorted

`sorted(x: []) -> []`

Returns the sorted list, used as follows:

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

Generates an iterable list, used as follows:

```python
print(range(1,5))      # [1, 2, 3, 4]
print(range(1,5, 2))   # [1, 3]
print(range(5, 1, -1)) # [5, 4, 3, 2]
```

## min

`min(x:[number]) -> number`

Returns the smallest element in the list, used as follows:

```python
print(min([1,2])) # 1
print(min([2,1])) # 1
```

## max

`max(x:[number]) -> number`

Returns the largest element in the list, used as follows:

```python
print(max([1,2])) # 2
print(max([2,1])) # 2
```

## sum

`sum(x:[number], init_value=0) -> number`

Returns the sum of all elements in the list, used as follows:

```
print(sum([1,2]))       # 3
print(sum([2,1], 1000)) # 1003
```

## pow

`pow(x: number, y: number, z: number = None) -> number`

Computes `x**y`, or `(x**y)%z` if `z` is not empty, supports integer and floating point numbers, used as follows:

```python
print(pow(2,3))    # 8
print(pow(2, 3, 5)) # 8%5 == 3

print(pow(2, 0.5)) # 1.414
```

## round

`round(number: int|float, ndigits:int|None) -> float | int`

Returns the rounded approximation of `number`. If `ndigits` is not `None` returns a float with the specified number of decimal places (cannot be negative), otherwise returns an integer structure, used as follows:

```python
print(round(1))   # 1
print(round(1.4)) # 1
print(round(1.5)) # 2

print(round(1.5555, 1)) # 1.6
print(round(1.5555, 2)) # 1.56

print(round(1.5555))    # 2
print(round(1.5555, 0)) # 2.0
```

It should be noted that the difference between `ndigits` being `None` and `0` is that the prefix returns `int` type, the latter returns `float` type.

## typeof

`typeof(x: any, full_name: bool = False) -> str`

Output the type of `x` at runtime. When the `full_name` parameter is set to `True`, the package prefix of the form `pkg.schema` will be returned, used as follows:

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

## zip

`zip(*args: str|list|dict)`

It is used to take an iterable object as a parameter, pack the corresponding elements in the object into tuples, and then return a list composed of these tuples, used as follows:

```py
a = zip([0, 1, 2], [3, 4, 5])
b = zip([0, 1], [3, 4, 5])
c = zip([0, 1, 2], [3, 4, 5, 6])

# Output
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
