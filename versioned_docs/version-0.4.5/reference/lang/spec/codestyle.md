---
title: "Code Style"
linkTitle: "Code Style"
type: "docs"
weight: 2
description: Code Style
---
## Introduction

This document gives the KCL code style conventions. Good code style can play a vital role in the development and maintenance of the project. We can learn the KCL code style by referring to the full text of the description and sample codes, and use KCL format and lint tools to help coding.

## Source File Encoding

KCL file encoding should always use **UTF-8**.

## Code Layout

### Indentation

Use **4 spaces** per indentation level such as in the schema statement and if statement.

```python
schema PersonA:
  name: str  # non-recommended
  age: int

schema PersonB:
    name: str  # recommended
    age: int

if True:
    a = 1  # recommended
elif True:
  b = 2  # non-recommended
else:
      c = 3  # non-recommended
```

The closing brace/bracket/parenthesis on multiline constructs should line up under **first character** of the line that starts the multiline construct, as in:

```python
# valid and recommended
my_list = [
    1, 2, 3,
    4, 5, 6,
]
```

```python
# invalid
my_list = [
    1, 2, 3,
    4, 5, 6,
    ]
```

### Tabs or Spaces

- Spaces are the preferred indentation method.
- Tabs should be used solely to remain consistent with code that is already indented with tabs.

KCL disallows mixing the use of tabs and spaces for indentation and an error will be reported during the compile time.

### Blank Lines

- Surround top-level schema definitions with one blank line.
- Keep at most one blank line between two statements and remove redundant blank lines.
- Remove extra blank characters at the end of the line
- Remove extra blank characters in a blank line.
- There is no blank line in the header of the file, start writing from the first line.
- Only one blank line will be left at the end of the KCL file.

```python
# Remove blank lines in the file header
a = 1  # Remove white space at the end of the line
# Keep at most one blank line between two statements

b = 2
# Only leave one blank line at the end of the file

```

### Inline Expressions

Write indentation of KCL `if`, `elif`, `else` and other conditions on different lines.

```python
if True: print("")  # non-recommended

if True:  # recommended
    print("")
```

### Line Break and Continuation lines

- For long expressions, use the line continuation symbol `\` and keep the left end of multiple expressions aligned.
- The 4-space rule is optional for continuation lines.

```python
anotherString = "Too long expression " + \
            "Too long expression "  # non-recommended

longString = "Too long expression " + \
             "Too long expression " + \
             "Too long expression "  # recommended
```

### When to Use Trailing Commas

- Always use trailing commas.

### Maximum Line Length

- The general recommendation is **80 characters** but not absolute.

### Symbol Break White Space

Try to keep the spaces between different symbols, but not too many, usually one is good.

```python
a = 1  # recommended
b    =    1    +   2  # non-recommended
```

### Whitespace in Expressions and Statements

Avoid extraneous whitespace in the following situations:

- The parentheses `()`, brackets `[]` and braces `{}` in the expression have no spaces inside.

```python
a = (1 + 2)  # recommended
b = ( 1 + 2 )  # non-recommended

c = [1, 2, 3]  # recommended
d = [ 1, 2, 3 ]  # non-recommended

e = {key = "value"}  # recommended
f = { key = "value" }  # non-recommended
```

```python
spam(ham[1], {eggs = 2})  # recommended
spam( ham[ 1 ], { eggs = 2 } )  # non-recommended
```

- Between a trailing comma and a following close parenthesis.

```python
foo = [0,]  # recommended
bar = [0, ]  # non-recommended
```

- Immediately before the open parenthesis that starts the argument list of a function call.

```python
print(1)  # recommended
print (1)  # non-recommended
```

- Immediately before the open parenthesis that starts indexing or slicing.

```python
dct = {key = "value"}
lst = [1, 2, 3]

a = dct['key']  # recommended
b = dct ['key']  # non-recommended

c = lst[0]  # recommended
d = lst [1]  # non-recommended
```

- More than one space around an assignment `=` (or other) operator to align it with another.

```python
# recommended:
x = 1
y = 2
long_variable = 3
```

```python
# non-recommended:
x             = 1
y             = 2
long_variable = 3
```

- Always surround these binary operators with a single space on either side: assignment (`=`), augmented assignment (`+=`, `-=`, etc.), comparisons (`==`, `<`, `>`, `!=`, `<=`, `>=`, `in`, `not in`, `is`, `is not`), booleans (`and`, `or`, `not`).

```python
# recommended:
i = i + 1
submitted += 1
x = x * 2 - 1
hypot2 = x * x + y * y
c = (a + b) * (a - b)
```

```python
# non-recommended:
i = i+1
submitted+=1
x = x*2 - 1
hypot2 = x*x + y*y
c = (a+b) * (a-b)
```

- Break one blank line between different statements e.g., import, schema and expression statements.

```python
import math
import net

schema Person:
    name: str

person = Person {
    name = "Alice"
}
```

- Compound statements (multiple statements on the same line) are generally discouraged

```python
# recommended:
if foo == 'blah':
    do_blah_thing()
do_one()
do_two()
do_three()
```

```python
# non-recommended:
if foo == 'blah': do_blah_thing()
do_one(); do_two(); do_three()
```

## Naming Conventions

### Naming Styles

The following naming styles are commonly distinguished:

- `b` (single lowercase letter)
- `B` (single uppercase letter)
- `lowercase`
- `lower_case_with_underscores`
- `UPPERCASE`
- `UPPER_CASE_WITH_UNDERSCORES`
- `CapitalizedWords` (capitalize all letters of the acronym in ``CapitalizedWords`` e.g., `HTTPServer`.)
- `mixedCase` (differs from `CapitalizedWords` by initial lowercase character)
- `Capitalized_Words_With_Underscores` (ugly and non-recommended)

### Names to Avoid

Never use the characters 'l' (lowercase letter el), 'O' (uppercase letter oh), or 'I' (uppercase letter eye) as single-character variable names.

### Package and Module Names

Package and module names should have short, all-lowercase names.

### Schema Names

Schema names should normally use the `CapWords` convention.

### Constants

Constants are usually defined on a module level and written in all capital letters with underscores separating words such as `MAX_OVERFLOW` and `TOTAL`.

## Import

- Imports should usually be on separate lines.
- Imports are always put at the top of the file, just after any module comments and docstrings, and before module globals and constants.
- Imports should be grouped in the following order and we should put a blank line between each group of imports.
  1. Standard library imports.
  2. Related third party plugin imports.
  3. Local application/library specific imports.
- Use an alias when we import a package name with a relatively long path.
- Leave only one space between the Import keyword and the package name.

```python
import net  # recommended
import    math  # non-recommended

import ..pkg.internal_pkg as alias_pkg  # recommended
```

## Comments

- Comments should be complete sentences. The first word should be capitalized unless it is an identifier that begins with a lower-case letter (never alter the case of identifiers!).
- Block comments generally consist of one or more paragraphs built out of complete sentences, with each sentence ending in a period.
- Use two spaces after a sentence-ending period in multi-sentence comments, except after the final sentence.

### Block Comments

Block comments generally apply to some (or all) code that follows them, and are indented to the same level as that code. Each line of a block comment starts with a `#` and **a single space**(unless it is indented text inside the comment).

Paragraphs inside a block comment are separated by a line containing a single `#`.

```python
# This is a block comment
a = 1
```

### Inline Comments

Use inline comments sparingly.

An inline comment is a comment on the same line as a statement. Inline comments should be separated by **at least two spaces** from the statement. They should start with a `#` and **a single space**.

```python
a = 1  # This is an inline comment
```

### Documentation Strings

Write docstrings for all public schema and schema attributes.

```python
schema Person:
    """
    Person schema doc string
    """

    name: str = "Alice"
    """
    Person schema attribute name doc string
    """
```

## String

- Single-quoted strings and double-quoted strings are the same in KCL.
- Use double-quoted string with lowercase prefix
- For triple-quoted strings, always use double quote characters to be consistent with the docstring convention.
- When a string contains single or double quote characters, use the other one to avoid backslashes in the string.

```python
strA = b"123"  # recommended
strB = B'123'  # non-recommended

strC = "'123'"  # recommended
strD = "\"123\""  # non-recommended
```

## Number

- Use lowercase for the prefix of non-decimal numbers, and use uppercase for the number itself.

```python
foo = 0xAB  # recommended
bar = 0Xab  # non-recommended
```

## Operators

### Binary Operators

- Leave only one space before and after the assignment `=`.
- Leave only one space before and after the binary operator in the expression.

```python
a = 1  # recommended
b=2  # non-recommended
c= 3  # non-recommended
d =4  # non-recommended

_value = (1 + 2 * 3)  # recommended
_value = (1+2*3)  # non-recommended
```

### Unary Operators

- There is only no space after unary operators e.g., `~`, `+` and `-`.

```python
_value = 1 + -2 * ~3  # recommended
_value = 1+ - 2 * ~ 3  # non-recommended
```

- There is no space after `**` and `*` in the dict/list deduction expressions and argument expressions.

```python
_list = [1, 2, 3]
_list = [*_list, [4, 5 ,6]]  # recommended
_list = [* _list, [4, 5 ,6]]  # non-recommended

_dict = {**{k = "v"}, **{k = "v"}}  # recommended
_dict = {** {k = "v"}, ** {k = "v"}}  # non-recommended
```

- Use `is not` operator rather than `not ... is`.

```python
# recommended:
if foo is not None:
    a = 1
```

```python
# non-recommended:
if not foo is None:
    a = 1
```

## Dict

- There is no space before the colon `:` at the instantiation of KCL dict and schema config, and a space after the colon `:`.

```python
d1 = {labels: {k1 = "v1"}}  # recommended
d2 = {labels : {k1 = "v1"}}  # non-recommended
d3 = {labels :{k1 = "v1"}}  # non-recommended
```

- Always surround the override attribute operator `=` and the insert attribute operator `+=` with a single space on either sid.

```python
d1 = {key = "value"}  # recommended
d2 = {key= "value"}  # non-recommended
d3 = {key ="value"}  # non-recommended
```

```python
d1 = {key += [0, 1, 2]}  # recommended
d2 = {key+= [0, 1, 2]}  # non-recommended
d3 = {key +=[0, 1, 2]}  # non-recommended
```

- Remove all commas at the end of the line in the KCL multiline dict because the end commas of each line are optional.

```python
d = {
    key1 = "value1"
    key2 = "value2"
    key3 = "value3"
    key4 = "value4"
}
```

## List

- Keep only **one space** after the comma `,` separating elements in the list

```python
a = [1, 2, 3]  # recommended
b = [1,2,3]  # non-recommended
```

- Keep only **one space** before and after the comprehension expression token `for` and `in` in the dict and list.

```python
a = [i for i in range(10)]  # recommended
b = [i  for  i  in  range(10)]   # non-recommended
```

## Slice

- Keep the same number of spaces before and after the colon `:` of the list slice.

```python
l = [1, 2, 3]
a = l[0:2]  # recommended
b = l[0 : 2]  # non-recommended
c = l[0: 2]  # non-recommended

d = l[0 + 0 : 1 + 1]  # recommended
d = l[0 + 0:1 + 1]  # non-recommended
```

## Schema

- Leave only one space before and after the schema attribute assignment `=`.
- Always add a doc string to a schema, which is a good programming habit.

```python
schema Person:
    """
    Schema doc string
    """
    name: str = "Alice"  # recommended
    age : int=12  # non-recommended

person = Person {}
```

- Keep **no spaces** around the schema inheritance operator `()`

```python
schema Base:
    name: str

schema Person(Base):  # recommended
    age: int

schema Schema ( Base ):  # non-recommended
    age: int
```

- Keep **only one space** between the brackets and the schema name of the config at schema instantiation.

```python
schema Base:
    name: str

schema Person(Base):
    age: int

personA = Person{}  # non-recommended
personB = Person {}  # recommended
```

- Keep **only one space** between the **mixin** keyword and the following `[]` operator

```python
schema NameMixin:
    name: str = "name"

schema Person:
    mixin   [NameMixin]  # non-recommended
    age: int

schema Parent:
    mixin [NameMixin]  # recommended
    age: int
```

### Attribute Annotations

- Annotations for schema attributes should have a single space after the colon `:` and no space before the colon `:`.

```python
# recommended:
schema Person:
    name: str  # No space before the colon `:`
    age: int = 18  # Spaces around assignment`=`
```

```python
# non-recommended:
schema Person:
    codeA:int  # No space after the colon `:`
    codeB : int  # Space before the colon `:`
    name: str="Alice"  # No spaces around assignment`=`
```

- There are no spaces around the colon `:` in the dict type annotation.

```python
schema Person:
    labels: {str:str}  # recommended
    keyValues: {str : str}  # non-recommended
```

### Arguments

- There are no spaces around the assignment `=` in the function/schema/decorator keyword arguments (kwargs).

```python
schema Person[nameVar]:
    # Decorator kwargs
    @deprecated(strict=False)  # recommended
    name: str = nameVar

    @deprecated(strict = False)  # non-recommended
    age: int

# Schema kwargs
personA = Person(nameVar="Alice") {}  # recommended
personB = Person(nameVar = "Bob") {}  # non-recommended

# Function kwargs
print("", end='')  # recommended
print("", end = '')  # non-recommended
```

## Keywords

- Only one space is usually reserved around the keyword, such as `schema`, `mixin`, `final`, `is` and `not`, etc.

```python
schema NameMixin:
    check:
        name not None

schema Person:
    """
    Person schema definition
    """
    mixin [NameMixin]

    final name: str = "Alice"
    age: int

person = Person {
    age = 18
}
```

## Function

- There are no spaces around the function/package select operator `.`
- There are no spaces between the function name and the parentheses `()`.

```python
import math

print(math.log(10))   # recommended
print( math . log (10))  # non-recommended
```

## Other Recommendations

- All commas `,` semicolons `;`, colons `:` has no spaces before them.

```python
if True:
    a = 1;b = 2  # non-recommended
    c = 3; d = 4  # recommended
```
