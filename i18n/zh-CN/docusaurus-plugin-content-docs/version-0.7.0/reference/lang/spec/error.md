---
title: "Errors"
linkTitle: "Errors"
type: "docs"
weight: 2
description: Errors
---

When errors happen, developers should be able to detect the error and abort
execution. Thus, KCL introduce the `assert` syntax.

In the previous topic of `schema` syntax. Errors can also be raised when a
schema is violated.

## Syntax

The syntax of the `assert` statement is the following.

```bnf
assert_stmt: ASSERT simple_expr (IF simple_expr)? (COMMA test)?
```

In the basic form, an `assert` statement evaluates an expression. If the
expression is evaluated to `False`, the assertion is failed, and an error
should be reported.

In the extended form, an error message can be provided. The error message is
another expression. It is only evaluated when the expression to be evaluated
is evaluated to `False`. The evaluation result of the error message is printed
when reporting the error.

The following is an example:

```python
a = 1
b = 3
condition = False
# a != b evaluates to True, therefore no error should happen.
assert a != b
# a == b is False, in the reported error message, the message "SOS" should be printed.
assert a == b, "SOS"
# if condition is True, then assert `a == b`, if failed, the message "error message" will be printed.
assert a == b if condition, "error message"
```

## The Implementation

When an error happens, no matter it is caused by the `assert` or the `schema` syntax,
the virtual machine should exit with an exit code greater than `0`.

The virtual machine may choose to dump the back trace information, and it is strongly recommended to implement it.

In practice, KCL can dump back trace by default, and an argument can be introduced to disable it.
