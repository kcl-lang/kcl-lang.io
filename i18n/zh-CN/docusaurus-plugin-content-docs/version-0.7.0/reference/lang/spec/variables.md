---
title: "Variables"
linkTitle: "Variable"
type: "docs"
weight: 2
description: Variable
---

In KCL, variables can be defined using assign statements. For example, the following statement defines a variable `spam` to a string `"ham"`.

```python
spam = "ham"
```

There are two types of variables, which are global variables and list comprehension local variables.

- A global variable is defined not within any context.
- A comprehension local variable is defined inside a comprehension.

A variable can be used after definition, until the end of the current scope.

For a global variable, the scope is the module it is defined in. Note that a module can consists of multiple source files.

For a list comprehension local variable, the scope is the list comprehension it is defined in.

More information on modules, list comprehensions and scopes will be discussed in later chapters.

## Immutability

Global variables are immutable. In other words, once defined such a variable cannot be redefined (or, i.e., modified).

The following code is illegal, and KCL will report an error during evaluation.

```python
spam = "ham"
spam = "eggs" # Error: The immutability rule is violated!
```

- A variable starts with the `_` character is mutable.

```python
_spam
cond = True
if cond:
    _spam = "ham"
else:
    _spam = "eggs"
```

## Variable Exporting

As shown in the preview chapter, KCL is able to export evaluation results to the standard output according to a target data format.

The rules are the followings:

- Living global variables at the end of an evaluation will be dumped out.
- If the name of a variable starts with the `_` character, it will not be dumped out.

## Uniqueness of Exported Variable Identifier

Each exported variable identifier must be unique in its package, so that an exported variable could be located uniquely by package location path and variable identifier, such as 'a.b.c:var', in which 'a.b.c' locates a package.

Two variable identifiers are different if:

- they are spelled differently
- they are defined in different packages and are not compiled in a single execution

Identifying an exported variable should be supported by the kcl compiler, which needs to provide corresponding identifying features through the command line and api form.
