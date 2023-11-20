---
title: "Statements"
linkTitle: "Statements"
type: "docs"
weight: 2
description: Statements
---

## Syntax

In KCL, statements consist of small statements and compound statements. The syntax is the following:

```bnf
preamble_statement: preamble_small_stmt | preamble_compound_stmt
preamble_small_stmt: (small_stmt | import_stmt) NEWLINE
preamble_compound_stmt: compound_stmt | schema_stmt
statement: small_stmt NEWLINE | compound_stmt
compound_stmt: if_stmt
small_stmt: assign_stmt | expr_stmt | assert_stmt
```

The preamble statement is used to define the module level statements, consist of `statement`, `import_stmt`, and `schema_stmt`. The statement is used to define the block level statements, which are used in the `if` statement and `schema` statement.

### Small Statements

A small statement is comprised of a single logical line. Multiple statements in one-line are not allowed.

#### Assignment Statements

Generally, assign_stmt is divided into assignment and augmented assignment. The syntax is the following:

```bnf
assign_stmt: target_primary (":" type) ("=" target_primary)* "=" test | target_primary aug_assign test
aug_assign: "+=" | "-=" | "*=" | "**=" | "/=" | "//=" | "%=" | "&=" | "|=" | "^=" | "<<=" | ">>="
target_primary: identifier | target_primary DOT identifier
```

An assignment statement has the form `lhs = rhs`. It evaluates the expression on the right-hand side then assigns its value (or values) to the variable (or variables) on the left-hand side.

The **target_primary** on the left-hand side is an `identifier` or an `identifier` followed by select dots.

Note: When using **target_primary** will cause collisions, use **primary_expr** as an alternative.

Examples:

```python
k = 1
a.b = "a.b"
```

To keep it simple, the compound target is not supported as **target_primary**.

The right value of an assignment statement is a conditional expression, which is discussed separately.

An augmented assignment, which has the form `lhs op= rhs` updates the variable `lhs` by applying a binary arithmetic operator op (one of +, -, \*, /, //, %, &, |, ^, <<, >>) to the previous value of `lhs` and the value of `rhs`.

The **target_primary** on the left-hand side is the same as assignment statement. Examples:

```python
_x -= 1
_filename += ".k"
```

There is no concept of in-place modification in KCL. The `aug_assign` statement will modify a copy of the **target_primary** and assign the copy to **target_primary**.

In particular, in KCL, the `|=` symbol represents the **union** operation, which is defined as follows:

- The behavior of the **union** operation needs to be consistent with the behavior of the **configuration definition**.

See **expressions** spec for more details of union operator in **Arithmetic Operations**.

#### Expression Statements

An expression statement evaluates an expression and discards its result.

Syntax:

```bnf
expr_stmt: expression
```

An expression statement supported in KCL is function invocation expression, which is discussed in **expression** spec.

```python
print(k) # print a variable
```

#### Import Statements

Import statements are used to **search** and **load** a module, and define a name or names in the local namespace for the scope where the import statement occurs.

Syntax:

```bnf
import_stmt: "import" dot_name ("as" NAME)?
dot_name: [leading_dots] identifier (DOT identifier)*
leading_dots: "."+
```

Examples:

```python
import math # import a built-in module math
import pkg # import pkg
import pkg.foo # import pkg.foo
import pkg.subpkg # import a subpkg in a pkg
import .pkg2.subpkg3 # import a subpkg in a pkg inside of current pkg
import ...pkg2 # Go two levels up then import pkg2
```

See **module** spec for more details of module spec.

#### Assert Statements

Assert statements are a convenient way to insert debugging assertions into KCL code.

The syntax is the following:

```
assert_stmt: ASSERT test ("if" test)? ("," test)?
```

The conditional expression in assert will be evaluated and get a boolean. Report an error if returning a `False`.

Examples:

```python
assert: x > 1 # report an error on x <= 1
```

#### Conditional Statements

KCL allows using conditional statements to control the instructions to
be executed. They are also called the control-flow statements.

The only type of control-flow syntax is the well-known `if-elif-else` syntax.

The syntax of the `if-elif-else` statement is the following.

```bnf
if_stmt: "if" test ":" suite ("elif" test ":" suite)* (ELSE ":" suite)?
suite: small_stmt | NEWLINE _INDENT statement+ _DEDENT
```

An `if` or `elif` statement evaluates a given expression. When the expression
is evaluated to `True`, a list of statements following `:` are executed.

The following is an example:

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

#### Schema Statements

Schema statements are used to define a type of configuration data. The syntax is the following:

```bnf
schema_stmt: [decorators] "schema" identifier ["[" [arguments] "]"] ["(" operand_name ")"] ":" NEWLINE [schema_body]
schema_body: _INDENT (string NEWLINE)* [mixin_stmt] (schema_attribute_stmt | statement)* [check_block] _DEDENT
```

See **schema** spec for more details of schema spec.
