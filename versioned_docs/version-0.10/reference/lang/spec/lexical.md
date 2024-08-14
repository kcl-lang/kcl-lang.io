---
title: "Lexical"
linkTitle: "Lexical"
type: "docs"
weight: 2
description: Lexical
---

## Lexical Conventions

This chapter covers the KCL lexical conventions including grammar notation, lines, comments and tokens.

## Grammar Notation

The syntax is specified using Extended Backus-Naur Form (EBNF), porting to lark parser ([https://github.com/lark-parser/lark](https://github.com/lark-parser/lark)).

```
- name  grammar production
- NAME  lexical token
- "x"   lexical token
- ()    grouping
- |     alternation
- []    option (0 or 1 times)
- ?     option (0 or 1 times)
- *     repetition (0 to n times)
- +     repetition (1 to n times)
```

## Source File Encoding

KCL source code is Unicode text encoded in **UTF-8**.

The following are basic Unicode elements, which will be used in literal notations.

```
newline           ::= U+000A
quota             ::= singlequote | doublequote
singlequote       ::= U+0027
doublequote       ::= U+0022
source character  ::= Unicode code point
```

The form a...b in literal notations represents the set of characters from a through b.

## Line Structure

The line structure of KCL programs is equivalent to that of Python.

A KCL program is divided into a number of logical lines. Each logical line consists of one or more physical lines.

A token named `NEWLINE` is used to divide logical lines.

A physical line is a sequence of characters end with a line termination sequence, which can be the ASCII LF (linefeed) character, the ASCII sequence CR LF (return followed by linefeed), or the ASCII CR (return) character.

### Explicit Line Joining

To join multiple physical lines into one logical line, the `\` character can be used. The character should be the last none-space character in each physical line except the very last line.

> **note**
>
> Any character except the ASCII space, tab (`\t`) and formfeed (`\f`) is considered a none-space character.

- A line ending in a backslash cannot carry a comment (, which will be introduced shortly afterwards).
- A backslash does not continue a comment.
- A backslash does not continue a token except for string literals (i.e., tokens other than string literals cannot be split across physical lines using a backslash).
- A backslash is illegal elsewhere on a line outside a string literal.

### Implicit Line Joining

Expressions in parentheses, square brackets or curly braces can be split over more than one physical line without using backslashes.

- Implicitly continued lines can carry comments.
- The indentation of the continuation lines is not important.
- Blank continuation lines are allowed.
- There is no `NEWLINE` token between implicit continuation lines.
- Implicitly continued lines can also occur within triple-quoted strings (see below); in that case they cannot carry comments.

### Blank Lines

### Indentation

### Comments

Starting with a `#` character that is not part of a string literal is a comment. A comment ends at the end of the physical line.

A comment signifies the end of the logical line unless the implicit line joining rules are invoked.

Comments are ignored by the syntax.

### Identifiers and Keywords

Identifiers (also referred to as names) are described by the following lexical definitions.

Within the ASCII range (from `U+0001` to `U+007F`), the valid characters for identifiers are the uppercase and lowercase letters `A` through `Z`, the underscore `_` and, except for the first character, the digits `0` through `9`.

Identifiers are unlimited in length. The case is significant.

### Keywords

The following identifiers are used as reserved words, or keywords of the language, and cannot be used as ordinary identifiers. They must be spelled exactly as written here:

```
True       False      None        Undefined   import
and        or         in          is          not
as         if         else        elif        for
schema     mixin      protocol    check       assert
all        any        map         filter      lambda
rule
```

The following tokens are not used, but they are reserved as possible future keywords:

```
pass       return     validate   rule        flow
def        del        raise      except      try
finally    while      from       with        yield
global     nonlocal   struct     class       final
```

### Literals

Literals are notations for constant values of some built-in types.

### String Literals

String literals are described by the following lexical definitions:

```
stringliteral   ::=  [stringprefix](shortstring | longstring)
stringprefix    ::=  "r" | "R"
shortstring     ::=  "'" shortstringitem* "'" | '"' shortstringitem* '"'
longstring      ::=  "'''" longstringitem* "'''" | '"""' longstringitem* '"""'
shortstringitem ::=  shortstringchar | stringescapeseq
longstringitem  ::=  longstringchar | stringescapeseq
shortstringchar ::=  <any source character except "\" or newline or the quote>
longstringchar  ::=  <any source character except "\">
stringescapeseq ::=  "\" <any source character>
```

Multiple adjacent string or bytes literals (delimited by whitespace),possibly using different quoting conventions, are allowed, and their meaning is the same as their concatenation.

### Numeric Literals

There are two types of numeric literals: integers and floating-point numbers.

Integer literals are described by the following lexical definitions:

```
integer      ::=  decinteger | bininteger | octinteger | hexinteger
decinteger   ::=  nonzerodigit (["_"] digit)* | "0"+ (["_"] "0")*
bininteger   ::=  "0" ("b" | "B") (["_"] bindigit)+
octinteger   ::=  "0" ("o" | "O") (["_"] octdigit)+
hexinteger   ::=  "0" ("x" | "X") (["_"] hexdigit)+
nonzerodigit ::=  "1"..."9"
digit        ::=  "0"..."9"
bindigit     ::=  "0" | "1"
octdigit     ::=  "0"..."7"
hexdigit     ::=  digit | "a"..."f" | "A"..."F"
```

Floating-point literals are described by the following lexical definitions:

```
floatnumber   ::=  pointfloat | exponentfloat
pointfloat    ::=  [digitpart] fraction | digitpart "."
exponentfloat ::=  (digitpart | pointfloat) exponent
digitpart     ::=  digit (["_"] digit)*
fraction      ::=  "." digitpart
exponent      ::=  ("e" | "E") ["+" | "-"] digitpart
```

## Operators and Delimiters

### Operators

The following tokens are operators:

```python
+       -       *       **      /       //      %
<<      >>      &       |       ^       <       >
~       <=      >=      ==      !=      @
```

### Delimiters

The following tokens serve as delimiters in the grammar:

```python
(       )       [       ]       {       }
,       :       .       ;       =       +=
-=      *=      **=     /=      //=     %=
<<=     >>=     &=      |=      ^=
```

The period can also occur in floating-point literals.

The following printing ASCII characters have special meaning as part of other tokens or are otherwise significant to the lexical analyzer:

```
'       "       #       \
```

The following printing ASCII characters are not used in KCL. Their occurrence outside string literals and comments is an unconditional error:

```
?       `
```

## Reference

Since the lexical conventions of KCL is very similar to that of Python, we use the following document as the reference when writing this chapter.

- [https://docs.python.org/3/reference/lexical_analysis.html](https://docs.python.org/3/reference/lexical_analysis.html)
