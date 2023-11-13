---
title: "Data Types"
linkTitle: "Data Types"
type: "docs"
weight: 2
description: Data Types
---

## Syntax

### Bool

Boolean values are the two constant objects `False` and `True`. They are used to represent truth values (although other values can also be considered false or true). The built-in function bool() can be used to convert any value to a Boolean, if the value can be interpreted as a truth value.

### Int

Int, or integer, is an arbitrarily sized integer, positive or negative, without decimals, of 64 binary digits precision(-9,223,372,036,854,775,808~9,223,372,036,854,775,807). Int is created by int literals or as the result of built-in functions and operators. Unadorned integer literals (including `hex`, `octal` and `binary` numbers) yield integers. The constructor int() can be used to produce int of a specific type.

Besides, integer literals may have an `SI` or `IEC` multiplier.

- `SI`: General integer or fixed-point number form: `P`, `T`, `G`, `M`, `K`, `k`, `m`, `u`, `n`.
- `IEC`: Corresponding power of 2: `Pi`, `Ti`, `Gi`, `Mi`, `Ki`.

```python
a = 1  # positive integer: 1
b = -1  # negative integer: -1
c = 0x10  # hexadecimal literal: 16
d = 0o10  # octal literal: 8, or the form `010`
e = 0b10  # binary literal: 2
f = 10Ki  # integer literal with IEC multiplier: 10240
g = 1M  # integer literal with SI multiplier: 1000000
h = int("10")  # int constructor: 10
i = int("10Ki")  # int constructor with multiplier: 10240
```

Notes:

- Report an error if unable to represent an integer value precisely.

### Float

Float, floating-point, approximation to real numbers, positive or negative, containing one or more decimals, of 64 bit IEEE 754 floats. The constructor float() can be used to produce int of a specific type.

```python
a = 1.10
b = 1.0
c = -35.59
d = 32.3+e18
f = -90.
g = -32.54e100
h = 70.2-E12
i = float("112")  # float constructor
```

Notes:

- Report an error if unable to represent a floating-point value due to overflow
- Report a warning if unable to represent a floating-point value due to underflow. Round to the nearest representable value if unable to represent a floating-point value due to limits on precision. These requirements apply to the result of any expression except for built-in functions for which an unusual loss of precision must be explicitly documented.

#### None

In KCL, `None` can indicate that the value of the object is empty, which is similar to `nil` in Go or `null` in Java, and corresponds to `null` in YAML and JSON.

```python
a = None
b = [1, 2, None]
c = {"key1" = "value1", "key2" = None}
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

`Undefined` is similar to None, but its semantics is that a variable is not assigned any value and will not be output to YAML or JSON.

```python
a = Undefined
b = [1, 2, Undefined]
c = {"key1" = "value1", "key2" = Undefined}
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

### Common Numeric Operations

Int and Float support the following operations (see built-in proposal for built-in details):

- `x + y`: sum of x and y.
- `x - y`: difference of x and y.
- `x * y`: product of x and y.
- `x / y`: quotient of x and y.
- `x // y`: floored quotient of x and y.
- `x % y`: remainder of x / y.
- `x ** y`: x to the power y.
- `-x`: x negated.
- `+x`: x unchanged.
- `~x`: x bitwise negation.
- `abs(x)`: absolute value or magnitude of x.
- `int(x)`: x converted to integer.
- `float(x)`: x converted to floating point.

KCL supports mixed arithmetic: when a binary arithmetic operator has operands of different numeric types, the operand with the "narrower" type is widened to that of the other, where integer is narrower than floating-point.

### String

Strings are immutable sequences of Unicode characters. String literals are written in a variety of ways:

```python
'allows embedded "double" quotes'  # Single quotes
"allows embedded 'single' quotes"  # Double quotes
'''Three single quotes''', """Three double quotes"""  # Triple quoted
```

Triple quoted strings may span multiple lines.

Indexing a string produces strings of length 1, for a non-empty string s, `s[0] == s[0:1]`.

```python
a =  "Hello, World!"
b = a[2:5]  # "llo"
c = a[-5:-2]  # "orl"
d = a[::-1]  # "'!dlroW ,olleH'"
```

- `str(x=None) -> str`

Return a string. If _x_ is not provided, raise a runtime error.

```python
x = str(3.5) # "3.5"
```

#### Members

Built-in function and members of a string

- `str#len() -> int`
  Return the number of characters in the string.
- `capitalize() -> str`
  Return a copy of the string with its first character (if any) capitalized and the rest lowercased.
- `count(sub: str, start: int = 0, end: int = -1) -> int`
  Returns the number of (non-overlapping) occurrences of substring sub in string, optionally restricting to `[start:end]`, start being inclusive and end being exclusive.
- `endswith(suffix: str, start: int = 0, end: int = -1) -> bool`
  Returns `True` if the string ends with the specified suffix, otherwise return `False`, optionally restricting to `[start:end]`, start being inclusive and end being exclusive.
- `find(sub: str, start: int = 0, end: int = -1) -> int`
  Returns the lowest index where substring sub is found, or -1 if no such index exists, optionally restricting to `[start:end]`, start being inclusive and end being exclusive.
- `format(*args, **kwargs) -> str`
  Perform string interpolation. Format strings contain replacement fields surrounded by curly braces {}. Anything that is not contained in braces is considered literal text, which is copied unchanged to the output. If you need to include a bracket character in the literal text, it can be escaped by doubling: A replacement field can be either a name, a number or empty. Values are converted to strings using the str function.
- `index(sub: str, start: int = 0, end: int = -1) -> int`
  Returns the first index where sub is found, or raises an error if no such index exists, optionally restricting to `[start:end]` start being inclusive and end being exclusive.
- `isalnum() -> bool`
  Returns True if all characters in the string are alphanumeric (`[a-zA-Z0-9]`) and there is at least one character, False otherwise.
- `isalpha() -> bool`
  Returns True if all characters in the string are alphabetic (`[a-zA-Z]`) and there is at least one character.
- `isdigit() -> bool`
  Returns True if all characters in the string are digits (`[0-9]`) and there is at least one character.
- `islower() -> bool`
  Returns True if all cased characters in the string are lowercase and there is at least one character.
- `isspace() -> bool`
  Returns True if all characters are white space characters and the string contains at least one character.
- `istitle() -> bool`
  Returns True if the string is in title case and it contains at least one character. This means that every uppercase character must follow an uncased one (e.g., whitespace) and every lowercase character must follow a cased one (e.g., uppercase or lowercase).
- `isupper() -> bool`
  Returns True if all cased characters in the string are uppercase and there is at least one character.
- `join(iterable: list) -> str`
  Return a string which is the concatenation of the strings in iterable. A TypeError will be raised if there are any non-string values in iterable. The separator between elements is the string providing this method. Example:

  ```python
  >>> "|".join(["a", "b", "c"])
  "a|b|c"
  ```

- `lower() -> str`
  Returns a copy of the string with all the cased characters converted to lowercase.
- `lstrip(chars: str) -> str`
  Return a copy of the string with leading characters removed. The chars argument is a string specifying the set of characters to be removed. If omitted or None, the chars argument defaults to removing whitespace. The chars argument is not a prefix; rather, all combinations of its values are stripped:

  ```python
  >>> '   spacious   '.lstrip()
  'spacious   '
  >>> 'www.example.com'.lstrip('cmowz.')
  'example.com'
  ```

- `replace(old: str, new: str, count: int) -> str`
  Return a copy of the string with all occurrences of substring old replaced by new. If the optional argument count is given, only the first count occurrences are replaced.
- `rfind(sub: str, start: int = 0, end: int = -1) -> int`
  Return the highest index in the string where substring sub is found, such that sub is contained within s[start:end]. Optional arguments start and end are interpreted as in slice notation. Return -1 on failure.
- `rindex(sub: str, start: int = 0, end: int = -1) -> int`
  Returns the last index where sub is found, or raises an ValueError if no such index exists, optionally restricting to `[start:end]`, start being inclusive and end being exclusive.
- `rsplit(sep: str, maxsplit: int = -1) -> list`
  Return a list of the words in the string, using sep as the delimiter string. If maxsplit is given, at most maxsplit splits are done, the rightmost ones. If sep is not specified or None, any whitespace string is a separator. Except for splitting from the right, rsplit() behaves like split() which is described in detail below.
- `rstrip(chars: str) -> str`
  Return a copy of the string with trailing characters removed. The chars argument is a string specifying the set of characters to be removed. If omitted or None, the chars argument defaults to removing whitespace. The chars argument is not a suffix; rather, all combinations of its values are stripped:

  ```python
  >>> '   spacious   '.rstrip()
  '   spacious'
  >>> 'mississippi'.rstrip('ipz')
  'mississ'
  ```

- `split(sep: str, maxsplit: int) -> list`
  Return a list of the words in the string, using sep as the delimiter string. If maxsplit is given, at most maxsplit splits are done (thus, the list will have at most maxsplit+1 elements). If maxsplit is not specified or -1, then there is no limit on the number of splits (all possible splits are made).

  If sep is given, consecutive delimiters are not grouped together and are deemed to delimit empty strings (for example, `'1,,2'.split(',')` returns `['1', '', '2']`). The sep argument may consist of multiple characters (for example, `'1<>2<>3'.split('<>')` returns `['1', '2', '3']`). Splitting an empty string with a specified separator returns `['']`.

  For example:

  ```python
  >>> '1,2,3'.split(',')
  ['1', '2', '3']
  >>> '1,2,3'.split(',', maxsplit=1)
  ['1', '2,3']
  >>> '1,2,,3,'.split(',')
  ['1', '2', '', '3', '']
  ```

  If sep is not specified or is None, a different splitting algorithm is applied: runs of consecutive whitespace are regarded as a single separator, and the result will contain no empty strings at the start or end if the string has leading or trailing whitespace. Consequently, splitting an empty string or a string consisting of just whitespace with a `None` separator returns `[]`.

  For example:

  ```python
  >>> '1 2 3'.split()
  ['1', '2', '3']
  >>> '1 2 3'.split(maxsplit=1)
  ['1', '2 3']
  >>> '   1   2   3   '.split()
  ['1', '2', '3']
  ```

- `splitlines(keepends: str) -> list`
  Return a list of the lines in the string, breaking at line boundaries('\n', '\r\n', '\r'). Line breaks are not included in the resulting list unless keepends is given and true.

  This method splits on the following line boundaries. In particular, the boundaries are a superset of universal newlines.

  For example:

  ```python
  >>> 'ab c\n\nde fg\rkl\r\n'.splitlines()
  ['ab c', '', 'de fg', 'kl']
  >>> 'ab c\n\nde fg\rkl\r\n'.splitlines(keepends=True)
  ['ab c\n', '\n', 'de fg\r', 'kl\r\n']
  ```

  Unlike `split()` when a delimiter string sep is given, this method returns an empty list for the empty string, and a terminal line break does not result in an extra line:

  ```python
  >>> "".splitlines()
  []
  >>> "One line\n".splitlines()
  ['One line']
  ```

  For comparison, `split('\n')` gives:

  ```python
  >>> ''.split('\n')
  ['']
  >>> 'Two lines\n'.split('\n')
  ['Two lines', '']
  ```

- `startswith(prefix: str, start: int = 0, end: int = -1) -> bool`
  Return `True` if string starts with the prefix, otherwise return False. prefix can also be a list of prefixes to look for. With optional start, test string beginning at that position. With optional end, stop comparing string at that position.
- `strip(chars: str) -> str`
  Return a copy of the string with the leading and trailing characters removed. The chars argument is a string specifying the set of characters to be removed. If omitted or None, the chars argument defaults to removing whitespace. The chars argument is not a prefix or suffix; rather, all combinations of its values are stripped:

  ```python
  >>> '   spacious   '.strip()
  'spacious'
  >>> 'www.example.com'.strip('cmowz.')
  'example'
  ```

  The outermost leading and trailing chars argument values are stripped from the string. Characters are removed from the leading end until reaching a string character that is not contained in the set of characters in chars. A similar action takes place on the trailing end. For example:

  ```python
  >>> comment_string = '#....... Section 3.2.1 Issue #32 .......'
  >>> comment_string.strip('.#! ')
  'Section 3.2.1 Issue #32'
  ```

- `title() -> str`
  Return a titlecased version of the string where words start with an uppercase character and the remaining characters are lowercase.

  For example:

  ```python
  >>> 'Hello world'.title()
  'Hello World'
  ```

  The algorithm uses a simple language-independent definition of a word as groups of consecutive letters. The definition works in many contexts but it means that apostrophes in contractions and possessives form word boundaries, which may not be the desired result:

  ```python
  >>> "they're bill's friends from the UK".title()
  "They'Re Bill'S Friends From The Uk"
  ```

- `upper() -> str`
  Return a copy of the string with all the cased characters 4 converted to uppercase. Note that `s.upper().isupper()` might be `False` if s contains uncased characters or if the Unicode category of the resulting character(s) is not “Lu” (Letter, uppercase), but e.g., “Lt” (Letter, titlecase).
- `removeprefix(prefix: str) -> str`
  If the string starts with the prefix string, return string[len(prefix):]. Otherwise, return a copy of the original string.
  ```python
  >>> "prefix-data".removeprefix("prefix-")
  "data"
  ```
- `rermovesuffix(suffix: str) -> str`
  If the string ends with the suffix string and that suffix is not empty, return string[:-len(suffix)]. Otherwise, return a copy of the original string.
  ```python
  >>> "data-suffix".removesuffix("-suffix")
  "data"
  ```

### List

Lists are immutable sequences, typically used to store collections of homogeneous items (where the precise degree of similarity will vary by application).

Lists may be constructed in several ways:

- Using a pair of square brackets to denote the empty list: `[]`
- Using square brackets, separating items with commas: `[a]`, `[a, b, c]`
- Using a list comprehension: `[x for x in iterable]`
- Using the type constructor: list() or list(iterable)

The constructor builds a list whose items are the same and in the same order as iterable’s items.Iterable may be either a sequence, a container that supports iteration, or an iterator object. If iterable is already a list, a copy is made and returned, similar to `iterable[:]`. For example, `list('abc')` returns `['a', 'b', 'c']` and `list([1, 2, 3])` returns `[1, 2, 3]`. If no argument is given, the constructor creates a new empty list `[]`.

Lists implement all of the common sequence operations.

#### Members

- `len()`
  Return the number of items in the list.

### Common Sequence Operations

The operations in the following table are supported by List and Dict.

This table lists the sequence operations sorted in ascending priority. In the table, s and t are sequences of the same type, n, i, j and k are integers and x is an arbitrary object that meets any type and value restrictions imposed by s.

The `in` and `not in` operations have the same priorities as the comparison operations. The +
(concatenation) and \* (repetition) operations have the same priority as the corresponding numeric operations.

| Operation    | Result                                             | Notes |
| ------------ | -------------------------------------------------- | ----- |
| `x in s`     | `True` if an item of s is equal to x, else `False` | #1    |
| `x not in s` | `False` if an item of s is equal to x, else `True` | #1    |
| `s + t`      | the concatenation of s and t                       | #5    |
| `s[i]`       | ith item of s, origin 0                            | #2    |
| `s[i:j]`     | slice of s from i to j                             | #2 #3 |
| `s[i:j:k]`   | slice of s from i to j with step k                 | #2 #4 |
| `min(s)`     | smallest item of s                                 |       |
| `max(s)`     | largest item of s                                  |       |

Notes:

- 1. While the in and not in operations are used only for simple containment testing in the
     general case, some specialized sequences (str) also use them for subsequence testing:

```python
>>> "gg" in "eggs"
True
```

- 2. If i or j is negative, the index is relative to the end of sequence s: `s.len() + i` or `s.len() + j` is substituted. But note that -0 is still 0.
- 3. The slice of s from i to j is defined as the sequence of items with index k such that `i <= k < j`. If i or j is greater than `s.len()`, use `s.len()`. If i is omitted or None, use 0. If j is omitted or None, use `s.len()`. If i is greater than or equal to j, the slice is empty.
- 4. The slice of s from i to j with step k is defined as the sequence of items with index `x = i + n*k` such that `0 <= n < (j-i)/k`. In other words, the indices are `i`, `i+k`, `i+2*k`, `i+3*k` and so on, stopping when j is reached (but never including j). When k is positive, i and j are reduced to s.len() if they are greater. When k is negative, i and j are reduced to s.len()

  - If they are greater. If i or j are omitted or None, they become “end” values (which end depends on the sign of k). Note, k cannot be zero. If k is None, it is treated like 1.

- 5. Concatenating immutable sequences always results in a new object. This means that building up a sequence by repeated concatenation will have a quadratic runtime cost in the total sequence length. To get a linear runtime cost, you must switch to one of the alternatives below:

  - if concatenating str objects, you can build a list and use `str.join()` at the end

- 6. `index` raises `ValueError` when x is not found in s. Not all implementations support passing the additional arguments i and j. These arguments allow efficient searching of subsections of the sequence. Passing the extra arguments is roughly equivalent to using `s[i:j].index(x)`, only without copying any data and with the returned index being relative to the start of the sequence rather than the start of the slice.

### Dict

Dict is an immutable mapping object maps hashable values to arbitrary objects. A dictionary’s keys are almost arbitrary values. Values that are not hashable, that is, values containing lists, dictionaries may not be used as keys. Numeric types used for keys obey the normal rules for numeric comparison: if two numbers compare equal (such as 1 and 1.0) then they can be used interchangeably to index the same dictionary entry. (Note however, that since computers store floating-point numbers as approximations it is usually unwise to use them as dictionary keys.) Dict is ordered. The order of the keys is the order of their declaration.

Dictionaries can be created by placing a comma-separated list of keys: value pairs within braces, for example: `{'jack': 4098, 'sjoerd': 4127}` or `{4098: 'jack', 4127: 'sjoerd'}`, by the dict constructor, or list/dict comprehension.

- `dict(obj)`

Return a new dictionary initialized from an optional positional argument and a possibly empty set of keyword arguments.If no positional argument is given, an empty dictionary is created. If a positional argument is given and it is a mapping object, a dictionary is created with the same key-value pairs as the mapping object. Otherwise, the positional argument must be an iterable object. Each item in the iterable must itself be an iterable with exactly two objects. The first object of each item becomes a key in the new dictionary, and the second object the corresponding value. If a key occurs more than once, the last value for that key becomes the corresponding value in the new dictionary. If keyword arguments are given, the keyword arguments and their values are added to the dictionary created from the positional argument. If a key being added is already present, the value from the keyword argument replaces the value from the positional argument. To illustrate, the following examples all return a dictionary equal to `{"one": 1, "two": 2, "three": 3}`:

```python
>>> a = {'two': 2, 'one': 1, 'three': 3}
>>> b = {'one': 1, 'two': 2, 'three': 3}
>>> c = {'three': 3, 'one': 1, 'two': 2}
>>> a == b == c
True
```

Providing keyword arguments as in the first example only works for keys that are valid KCL identifiers. Otherwise, any valid keys can be used.

In the dict comprehension, key/value pairs yielded by the generator expression is set in the dictionary in the order yielded: the first occurrence of the key determines its insertion order, and the last determines the value associated to it.

```python
>>> {str(i): 2 * i for i in range(3)}
{"0": 0, "1": 2, "2": 4}

>>> a = {"one": 1, "two": 2, "three": 3}
>>> b = {k: v for k, v in a if v >= 2}
{two: 2, three: 3}
```

#### Operations & Members

These are the operations that dictionaries the support.

- `list(d)`
  Return a list of all the keys used in the dictionary d.
- `len()`
  Return the number of items in the dictionary d.
- `d[key]`
  Return the item of d with key. Return Undefined if key is not in the map.
- `key in d`
  Return True if d has a key, else False.
- `key not in d`
  Equivalent to not key in d.
- `d.key`
  Return the item of d with key. Return Undefined if key is not in the map.

Dictionaries compare equal if and only if they have the same (key, value) pairs(keys' ordering matters). Order comparisons (‘<’, ‘<=’, ‘>=’, ‘>’) raise TypeError.

```python
>>> d = {"one": 1, "two": 2, "three": 3, "four": 4}
>>> d
{'one': 1, 'two': 2, 'three': 3, 'four': 4}
>>> list(d)
['one', 'two', 'three', 'four']
```
