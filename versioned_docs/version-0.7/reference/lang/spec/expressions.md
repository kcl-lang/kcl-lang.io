---
title: "Expressions"
linkTitle: "Expressions"
type: "docs"
weight: 2
description: Expressions
---

## Syntax

In KCL, an expression specifies the computation of a value.

The syntax is the following:

```bnf
expression: test ("," test)*
test: if_expr | primary_expr | unary_expr | binary_expr
```

KCL expressions consist of `if` expression, `primary` expression, `unary` expression, and `binary` expression.

### Primary Expressions

Primary expressions are the operands for unary and binary expressions.

Operands are self-delimiting. An **operand** may be followed by any number of selector dot, a function call, or slice suffixes, to form a primary expression. The grammar uses `expression`, where a multiple-component expression is allowed, and `test` where it accepts an expression of only a single component.

Syntax:

```bnf
primary_expr: operand | primary_expr select_suffix | primary_expr call_suffix | primary_expr subscript_suffix
```

### Operands

Operand denotes the elementary value in an expression. An operand may be an identifier, a literal, or a parenthesized expression.

Syntax:

```bnf
operand: operand_name | number | string | "True" | "False" | "None" | "Undefined" | list_expr | list_comp | dict_expr | dict_comp | "(" expression ")"
operand_name: identifier | qualified_identifier
```

### Identifiers

In KCL, an identifier is a name, may with selectors, that identifies a value.

Syntax:

```bnf
identifier: NAME
```

Examples:

```python
x
a
_b
```

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

To simplify the definition of the qualified identifier, such as 'pkg.type', we additionally define `qualified_identifier`:

Syntax:

```bnf
qualified_identifier: identifier "." identifier
```

Examples:

```python
pkg.a
```

The package name in qualified_identifier must be imported.

### Basic Literals

Basic literals supported in KCL are `int`, `float`, `string` and `bool` including `True` and `False`. Evaluation of basic literal yields a value of the given type with the given value.

Syntax:

```bnf
operand: number | string | "True" | "False" | "None" | "Undefined"
```

Examples:

```python
1
2.3
"abc"
True
False
None
Undefined
```

See more details about **data type** spec.

### Parenthesized Expressions

An expression enclosed in parentheses yields the result of that expression.

Syntax:

```bnf
operand: '(' expression ')'
```

Examples:

```python
x = (1 + 2) * (3 + 4)  # 21
```

### Dictionary Expressions

A dictionary expression is a comma-separated immutable list of colon-separated key/value expression pairs, enclosed in curly brackets, and it yields a new dictionary object. An optional comma may follow the final pair.

```bnf
config_expr: '{' config_entries '}'
config_entries: config_entry [config_entry*]
config_comp: '{' (config_entry comp_clause+) '}'
config_entry: expr (':' | '=' | '+=') expr | double_star_expr | if_entry
double_star_expr: "**" expression
if_entry:
  'if' expr ';' if_entry_exec_block
  ('elif' expr ':' if_entry_exec_block)*
  ('else' ':' if_entry_exec_block)?
NEWLINE: '/r?/n'
```

Examples:

```python
{}
{"one": 1}
{"one": 1, "two": 2}
```

The key and value expressions are evaluated in left-to-right order. Evaluation fails if the same key is used multiple times.

Only hashable values may be used as the keys of a dictionary. This includes all built-in types except dictionaries, and lists.

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
    key1 = "value1"  # Ignore the comma ',' at the end of line
    key2 = "value2"
}  # {"key1": "value1", "key2": "value2"}
```

In addition, the **config selector expressions** can be used to init a schema instance.

```python
person = {
    base.count = 2
    base.value = "value"
    labels.key = "value"
}  # {"base": {"count": 2, "value": "value"}, "labels": {"key": "value"}}
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

### List Expressions

A list expression is a comma-separated immutable list of element expressions, enclosed in square brackets, and it yields a new list. An optional comma may follow the last element expression.

```bnf
list_expr: '[' [list_item [',']] ']'
list_item: test | "*" primary_expr | if_expr
```

Element expressions are evaluated in left-to-right order.

Examples:

```python
[]                      # [], empty list
[1]                     # [1], a 1-element list
[1, 2, 3]               # [1, 2, 3], a 3-element list
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

### Comprehensions

A comprehension constructs a new list or dictionary value by looping over one or more iterables and evaluating a body expression that produces successive elements of the result.

Syntax:

```bnf
list_comp: '[' list_item comp_clause+ ']' .
dict_comp: '{' entry comp_clause+ '}' .

comp_clause: 'for' loop_variables [","] 'in' test ['if' test]
loop_variables: primary_expr (',' primary_expr)*
```

A list comprehension consists of a single expression followed by one or more clauses, the first of which must be a `for` clause. Each `for` clause resembles a `for` statement, and specifies an iterable operand and a set of variables to be assigned by successive values of the iterable. An `if` cause resembles an `if` statement, and specifies a condition that must be met for the body expression to be evaluated. A sequence of `for` and `if` clauses acts like a nested sequence of `for` and `if` statements.

Examples:

```python
[x * x for x in range(5)]                 # [0, 1, 4, 9, 16]
[x * x for x in range(5) if x % 2 == 0]   # [0, 4, 16]
[[x, y] for x in range(5) \
        if x % 2 == 0 \
        for y in range(5) \
        if y > x]                       # [[0, 1], [0, 2], [0, 3], [0, 4], [2, 3], [2, 4]]
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

A dict comprehension resembles a list comprehension, but its body is a pair of expressions, key: value, separated by a colon, and its result is a dictionary containing the key/value pairs for which the body expression was evaluated. Evaluation fails if the value of any key is un-hashable.

Besides, we can use two variables in the dict comprehension, the first variable denotes the dict key and the second variable denotes the dict value of the key.

```python
data = {"key1" = "value1", "key2" = "value2"}
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

As with a `for` loop, the loop variables may exploit compound assignment:

```python
[x * y + z for [x, y], z in [[[2, 3], 5], [["o", 2], "!"]]]      # [11, 'oo!']
```

KCL does not accept an un-parenthesized list as the operand of a for clause:

```python
[x * x for x in 1, 2, 3]  # parse error: unexpected comma
```

Comprehensions defines a new lexical block, so assignments to loop variables have no effect on variables of the same name in an enclosing block:

```python
x = 1
_ = [x for x in [2]]            # new variable x is local to the comprehension
print(x)                        # 1
```

The operand of a comprehension's first clause (always a for) is resolved in the lexical block enclosing the comprehension. In the examples below, identifiers referring to the outer variable named x have been distinguished by subscript.

```python
x0 = [1, 2, 3]
[x * x for x in x0]                 # [1, 4, 9]
[x * x for x in x0 if x % 2 == 0]   # [4]
```

All subsequent for and if expressions are resolved within the comprehension's lexical block, as in this rather obscure example:

```python
x0 = [[1, 2], [3, 4], [5, 6]]
[x * x for x in x0 for x in x if x % 2 == 0]     # [4, 16, 36]
```

which would be more clearly rewritten as:

```python
x = [[1, 2], [3, 4], [5, 6]]
[z * z for y in x for z in y if z % 2 == 0]     # [4, 16, 36]
```

### Conditional Expressions

A conditional expression has the form `a if cond else b`. It first evaluates the condition `cond`. If it's true, it evaluates `a` and yields its value; otherwise it yields the value of `b`.

Syntax:

```bnf
if_expr: test "if" test "else" test
```

Examples:

```python
x = True if enabled else False  # if enabled is
```

### Unary Expressions

In KCL, supported unary operators are `+`, `-`, `~`, and `not`.

Syntax:

```bnf
unary_expr: ("+" | "-" | "~") primary_expr
          | "not" test
```

Usage:

```bnf
+ number        unary positive          (int, float)
- number        unary negation          (int, float)
~ number        unary bitwise inversion (int)
not x           logical negation        (any type)
```

The `+` and `-` operators may be applied to any number (int or float) and return the number.
The `not` operator returns the negation of the truth value of its operand.

Examples:

```python
~1   # -2
~-1  # 0
~0   # -1
not True   # False
not 0   # True
```

### Binary Expressions

In KCL, binary expressions consist of `comparisons`, `logical operations`, `arithmetic operations` and `membership tests`.

Syntax:

```bnf
binary_expr: test bin_op test
bin_op: 'or'
      | 'and'
      | '==' | '!=' | '<' | '>' | '<=' | '>='
      | 'in' | 'not' 'in'
      | '|'
      | '^'
      | '&'
      | '-' | '+'
      | '*' | '%' | '/' | '//'
      | '<<' | '>>'
```

#### Logical Operations

The `or` and `and` operators yield the logical disjunction and conjunction of their arguments, which need not be Booleans.

The expression `x or y` yields the value of `x` if its truth value is `True`, or the value of `y` otherwise.

```python
False or False   # False
False or True    # True
True  or True    # True
1 or "hello"     # 1
```

Similarly, `x` and `y` yields the value of `x` if its truth value is `False`, or the value of `y` otherwise.

```python
False and False   # False
False and True    # False
True  and True    # True
1 and "hello"     # "hello"
```

These operators use "short circuit" evaluation, so the second expression is not evaluated if the value of the first expression has already determined the result, allowing constructions like these:

```python
x and x[0] == 1   # x[0] is not evaluated if x is empty
len(x) == 0 or x[0] == ""
not x or not x[0]
```

#### Comparisons

The `==` operator reports whether its operands are equal; the `!=` operator is its negation.

The operators `<`, `>`, `<=`, and `>=` perform an ordered comparison of their operands. It is an error to apply these operators to operands of unequal type, unless one of the operands is an `int` and the other is a `float`. Of the built-in types, only the following support ordered comparison, using the ordering relation shown:

```bnf
NoneType        # None <= None
bool            # False < True
int             # mathematical
float           # as defined by IEEE 754
string          # lexicographical
list            # lexicographical
```

Comparison of floating-point values follows the IEEE 754 standard, which breaks several mathematical identities. For example, if `x` is a `NaN` value, the comparisons `x < y`, `x == y`, and `x > y` all yield false for all values of `y`.

The remaining built-in types support only equality comparisons. Values of type `dict` and `schema` compare equal if their elements compare equal, and values of type function or `builtin_function_or_method` are equal only to themselves.

```bnf
dict                            # equal contents
schema                          # equal exported-attributes
function                        # identity
builtin_function_or_method      # identity
```

#### Arithmetic Operations

The following table summarizes the binary arithmetic operations available for built-in types:

```bnf
Arithmetic (int or float; result has type float unless both operands have type int)
   number + number              # addition
   number - number              # subtraction
   number * number              # multiplication
   number / number              # real division  (result is always a float)
   number // number             # floored division
   number % number              # remainder of floored division
   number ^ number              # bitwise XOR
   number << number             # bitwise left shift
   number >> number             # bitwise right shift

Concatenation
   string + string
     list + list

Repetition (string/list)
      int * sequence
 sequence * int

Union
      int | int
     list | list
     dict | dict
   schema | schema
   schema | dict
basictype | basictype
```

The operands of the arithmetic operators `+`, `-`, `*`, `//`, and `%` must both be numbers (`int` or `float`) but need not have the same type. The type of the result has type `int` only if both operands have that type. The result of real division / always has type `float`.

The `+` operator may be applied to non-numeric operands of the same type, such as two lists, or two strings, in which case it computes the concatenation of the two operands and yields a new value of the same type.

```python
"Hello, " + "world"           # "Hello, world"
[1, 2] + [3, 4]               # [1, 2, 3, 4]
```

The `*` operator may be applied to an integer n and a value of type `string`, `list`, in which case it yields a new value of the same sequence type consisting of n repetitions of the original sequence. The order of the operands is immaterial. Negative values of n behave like zero.

```python
'mur' * 2               # 'murmur'
3 * range(3)            # [0, 1, 2, 0, 1, 2, 0, 1, 2]
```

The `&` operator requires two operands of the same type, such as `int`. For integers, it yields the bitwise intersection (AND) of its operands.

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

A union type is used to define a schema attribute type. See more details in **schema** spec.
Supported types in a union type are `int`, `str`, `float`, `bool`, `list` and `dict`.

Unioning collection and schema data:

- Unioning List. Overwrite the list expression on the right side of the operator `|` to the list variable on the left side of the operator one by one according to the **index**.

```python
_a = [1, 2, 3]
_b = [4, 5, 6, 7]
x = _a | _b  # [4, 5, 6, 7]  4 -> 1; 5 -> 2; 6 -> 3; 7 -> None
```

Unioning to the specific index or all elements is still under discussion.

- Unioning Dict. Union the dict expression on the right side of the operator `|` one by one to the dict variable on the left side of the operator according to the **key**

```python
_a = {key1 = "value1"}
_b = {key1 = "overwrite", key2 = "value2"}
_c = _a | _b  # {"key1": "overwrite", "key2": "value2"}
```

The union of collection and schema is a new one whose attributes are unioning b to a, preserving the order of the attributes of the operands, left before right.

Unioning to the specific key or all keys is still under discussion.

- Unioning Schema.

The union operation for schema is similar to dict.

Schema union could be done as:

```bnf
schema Person:
    firstName: str
    lastName: str

_a = Person {
    firstName = "John"
}
_b = {lastName = "Doe"}
_a = _a | _b  # {"firstName": "John", "lastName": "Doe"}
```

Unioning to a specific attribute is still under discussion. Unioning to all attributes is not applicable to schema instances.

See **selector expression** in **expression** spec for more details.

The `^` operator accepts operands of `int`. For integers, it yields the bitwise XOR (exclusive OR) of its operands.

The `<<` and `>>` operators require operands of `int` type both. They shift the first operand to the left or right by the number of bits given by the second operand. It is a dynamic error if the second operand is negative. Implementations may impose a limit on the second operand of a left shift.

```python
0x12345678 & 0xFF               # 0x00000078
0b01011101 ^ 0b110101101        # 0b111110000
0b01011101 >> 2                 # 0b010111
0b01011101 << 2                 # 0b0101110100
```

#### Membership Tests

Usage:

```bnf
      any in     sequence		(list, dict, schema, string)
      any not in sequence
```

The `in` operator reports whether its first operand is a member of its second operand, which must be a list, dict, schema, or string. The `not in` operator is its negation. Both return a Boolean.

The meaning of membership varies by the type of the second operand: the members of a list are its elements; the members of a dict are its keys; the members of a string are all its substrings.

```python
1 in [1, 2, 3]                  # True

d = {"one" = 1, "two" = 2}
"one" in d                      # True
"three" in d                    # False
1 in d                          # False
[] in d                         # False

"nasty" in "dynasty"            # True
"a" in "banana"                 # True
"f" not in "way"                # True

d = data {one = 1, two = 2}       # data is a schema with attributes one and two
"one" in d                      # True
"three" in d                    # False
```

### Function Invocations

KCL allows calling built-in functions and functions from built-in and system modules. Whether KCL allows defining new functions is under discussion.

Syntax:

```bnf
call_suffix: "(" [arguments [","]] ")"
arguments: argument ("," argument)*
argument: test | identifier "=" test | "*" test | "**" test
```

To call a function, the basic way is shown as the following code excerpt:

```python
print("An argument")

import math
# 2 powers 3 is 8.
a = math.pow(2, 3)
```

As you can see, arguments are separated with `,`. Arguments can only be passed in this way. KCL supports positional arguments and key-value arguments.

Note that:

- Some functions have parameters with default values.
- Some functions accept variadic arguments.

When an argument is not supplied for a parameter without a default value,
an error will be reported.

### Selector Expressions

A selector expression selects the attribute or method of the value.

#### Select Attributes

Syntax:

```bnf
select_suffix: ["?"] "." identifier
```

KCL provides a wealth of ways to identify or filter attributes.

x.y

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
```

x?.y

If the x if None/Undefined or empty(empty list or dict), just return None, otherwise behave as x.y.

Examples

```python
noneData = None
data?.name # None

emptyDict = {}
emptyDict?.name # None

emptyList = []
emptyList?[0] # None
```

As a supplementary of the `selector` expression in KCL code, the KCL compiler needs to provide corresponding identifying and filtering features through the command line and api form.

#### Select Methods

Syntax:

```bnf
select_suffix: "." identifier
```

A `identifier` identifies method belongs to the built-in types `string`, `list`, `dict`, and `schema`.

- A selector expression fails if the value does not have an attribute of the specified name.
- A selector expression that selects a method typically appears within a call expression, as in these examples:

Examples:

```python
["able", "baker", "charlie"].index("baker")     # 1
"banana".count("a")                             # 3
"banana".reverse()                              # error: string has no .reverse field or method
Person.instances()                              # all instances of schema Person
```

But when not called immediately, the selector expression evaluates to a bound method, that is, a method coupled to a specific receiver value. A bound method can be called like an ordinary function, without a receiver argument:

```bnf
f = "banana".count
f                                               # <built-in method count of string value>
f("a")                                          # 3
f("n")                                          # 2
```

### Index Expressions

An index expression `a[i]` yields the `i` th element of an indexable type such as a string or list. The index `i` must be an `int` value in the range `-n` ≤ `i` < `n`, where `n` is `len(a)`; any other index results in an error.

Syntax:

```bnf
subscript_suffix: "[" [test] "]"
```

A valid negative index `i` behaves like the non-negative index `n+i`, allowing for convenient indexing relative to the end of the sequence.

```python
"abc"[0]                        # "a"
"abc"[1]                        # "b"
"abc"[-1]                       # "c"

["zero", "one", "two"][0]       # "zero"
["zero", "one", "two"][1]       # "one"
["zero", "one", "two"][-1]      # "two"
```

An index expression `d[key]` may also be applied to a dictionary `d`, to obtain the value associated with the specified key. It returns `Undefined` if the dictionary contains no such key.

An index expression appearing on the left side of an assignment causes the specified list or dictionary element to be updated:

```python
a = range(3)            # a == [0, 1, 2]
b = a[2]  # 2
```

It is a dynamic error to attempt to update an element of an immutable type, such as a list or string, or a frozen value of a mutable type.

### Slice Expressions

A slice expression `a[start:stop:stride]` yields a new value containing a sub-sequence of `a`, which must be a string, or list.

```bnf
subscript_suffix: "[" [test] [":" [test] [":" [test]]] "]"
```

Each of the `start`, `stop`, and `stride` operands is optional; if present, and not `None`, each must be an integer.
The `stride` value defaults to 1. If the stride is not specified, the colon preceding it may be omitted too. It is an error to specify a stride of zero.

Conceptually, these operands specify a sequence of values `i` starting at start and successively adding `stride` until `i` reaches or passes `stop`. The result consists of the concatenation of values of `a[i]` for which `i` is valid.`

The effective start and stop indices are computed from the three operands as follows. Let `n` be the length of the sequence.

**If the stride is positive**: If the `start` operand was omitted, it defaults to -infinity. If the `end` operand was omitted, it defaults to +infinity. For either operand, if a negative value was supplied, `n` is added to it. The `start` and `end` values are then "clamped" to the nearest value in the range 0 to `n`, inclusive.

**If the stride is negative**: If the `start` operand was omitted, it defaults to +infinity. If the `end` operand was omitted, it defaults to -infinity. For either operand, if a negative value was supplied, `n` is added to it. The `start` and `end` values are then "clamped" to the nearest value in the range -1 to `n`-1, inclusive.

```python
"abc"[1:]               # "bc"  (remove first element)
"abc"[:-1]              # "ab"  (remove last element)
"abc"[1:-1]             # "b"   (remove first and last element)
"banana"[1::2]          # "aaa" (select alternate elements starting at index 1)
"banana"[4::-2]         # "nnb" (select alternate elements in reverse, starting at index 4)
```

It's not allowed to define a slice expression as a left value in KCL.
Cause list and string are immutable, re-slicing can directly operate to operand to ensure better performance.

#### Quantifier Expressions

Quantifier expressions act on collection: list or dict, generally used to obtain a certain result after processing the collection, mainly in the following four forms:

```bnf
quant_expr: quant_op [ identifier ',' ] identifier 'in' quant_target '{' expr ['if' expr] '}'
quant_target: string | identifier | list_expr |list_comp | dict_expr | dict_comp
quant_op: 'all' | 'any' | 'filter' | 'map'
```

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
