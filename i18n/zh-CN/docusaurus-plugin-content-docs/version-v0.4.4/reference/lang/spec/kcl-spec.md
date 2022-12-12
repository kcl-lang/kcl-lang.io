---
title: "KCL Spec"
linkTitle: "KCL Spec"
type: "docs"
weight: 2
description: KCL Spec
---
## 词法规则

### 关键字和保留字

下面是 KCL 语言的关键字：

```python
    True       False      None        Undefined   import
    and        or         in          is          not
    as         if         else        elif        for
    schema     mixin      protocol    check       assert
    all        any        map         filter      lambda
    rule
```

下面是 KCL 语言的保留字：

```python
    pass       return     validate   rule        flow
    def        del        raise      except      try
    finally    while      from       with        yield
    global     nonlocal   struct     class       final
```

### 行注释

```python
# a comment
```

### 运算符

```python
    +       -       *       **      /       //      %
    <<      >>      &       |       ^       <       >
    ~       <=      >=      ==      !=      =
    +=      -=      *=      **=     /=      //=     %=
    <<=     >>=     &=      ^=
```

### 分隔符

```python
    (       )       [       ]       {       }
    ,       :       .       ;       @
```

### 运算符的优先级

以下的运算符列表根据优先级从 **高到底** 排列：

| Operator                                                         | Description                                              |
| ---------------------------------------------------------------- | -------------------------------------------------------- |
| `**`                                                             | Exponentiation (highest priority)                        |
| `+x` `-x` `~x`                                                   | Positive, negative, bitwise NOT                          |
| `*` `/` `%` `//`                                                 | Multiplication, division, floor division and remainder   |
| `+` `-`                                                          | Addition and subtraction                                 |
| `<<` `>>`                                                        | Left and right shifts                                    |
| `&`                                                              | Bitwise AND                                              |
| `^`                                                              | Bitwise XOR                                              |
| `|`                                                              | Bitwise OR                                               |
| `in`, `not in`, `is`, `is not`, `<`, `<=`, `>`, `>=`, `!=`, `==` | Comparisons, including membership and identity operators |
| `not`                                                            | Boolean NOT                                              |
| `and`                                                            | Boolean AND                                              |
| `or`                                                             | Boolean OR                                               |
| `if – else`                                                     | Conditional expression =                                  |
| `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `&=`, `|=`, `^=`, `**=`, `//=`, `<<=`, `>>=`                     | Assign |

## EBNF 语法

KCL 采用 Python 的 [LarkParser](https://lark-parser.readthedocs.io/en/latest/) 工具描述语法，规范规则如下：

```bnf
// Copyright 2021 The KCL Authors. All rights reserved.

//////////// KCL grammar ////////////
start: (NEWLINE | preamble_statement)*

//////////// statement ////////////
preamble_statement: preamble_small_stmt | preamble_compound_stmt
preamble_small_stmt: (small_stmt | import_stmt) NEWLINE
preamble_compound_stmt: compound_stmt | schema_stmt
statement: small_stmt NEWLINE | compound_stmt
compound_stmt: if_stmt
small_stmt: assign_stmt | expr_stmt | assert_stmt

//////////// import_stmt ////////////
import_stmt: IMPORT dot_name (AS NAME)?
dot_name: [leading_dots] identifier (DOT identifier)*
leading_dots: DOT+

/////////// assert_stmt ////////////
assert_stmt: ASSERT test (COMMA test)?

//////////// if_stmt ////////////
if_stmt: IF test COLON suite (ELIF test COLON suite)* (ELSE COLON suite)?
suite: small_stmt NEWLINE | NEWLINE _INDENT statement+ _DEDENT

//////////// assign_stmt ////////////
assign_stmt: primary_expr (ASSIGN primary_expr)* ASSIGN test
    | primary_expr augassign test
augassign: COMP_PLUS | COMP_MINUS | COMP_MULTIPLY | COMP_DOUBLE_STAR | COMP_DIVIDE
    | COMP_DOUBLE_DIVIDE | COMP_MOD | COMP_AND | COMP_OR | COMP_XOR | COMP_SHIFT_LEFT
    | COMP_SHIFT_RIGHT

//////////// schema_stmt ////////////
schema_stmt: [decorators] SCHEMA [RELAXED] identifier [LEFT_BRACKETS [arguments] RIGHT_BRACKETS] [LEFT_PARENTHESES operand_name RIGHT_PARENTHESES] COLON NEWLINE [schema_body]
schema_body: _INDENT (string NEWLINE)* [mixin_stmt] (schema_attribute_stmt | statement)* [check_block] _DEDENT
schema_attribute_stmt: [decorators] (FINAL)? identifier COLON type [(ASSIGN | augassign) test] NEWLINE

/////////// decorators ////////////
decorators: (AT primary_expr NEWLINE)+

//////////// type ////////////
type: type_element (OR type_element)*
type_element: schema_type | basic_type | compound_type
schema_type: operand_name
basic_type: STRING_TYPE | INT_TYPE | FLOAT_TYPE | BOOL_TYPE
compound_type: list_type | dict_type
list_type: LEFT_BRACKETS (type)? RIGHT_BRACKETS
dict_type: LEFT_BRACE (type)? COLON (type)? RIGHT_BRACE

//////////// check_block ////////////
check_block: CHECK COLON NEWLINE _INDENT check_expr+ _DEDENT
check_expr: check_test [COMMA primary_expr] NEWLINE
check_test: or_test [IF or_test]

//////////// mixin_stmt ////////////
mixin_stmt: MIXIN LEFT_BRACKETS [mixins | multiline_mixins] RIGHT_BRACKETS NEWLINE
multiline_mixins: NEWLINE _INDENT mixins NEWLINE _DEDENT
mixins: operand_name (COMMA (NEWLINE mixins | operand_name))*

//////////// expression_stmt ////////////
expr_stmt: expression
expression: test (COMMA test)*
test: if_expr | primary_expr | unary_expr | binary_expr
if_expr: test IF test ELSE test
unary_expr: (PLUS | MINUS | NOT) primary_expr | L_NOT test
binary_expr: test bin_op test
bin_op: L_OR
      | L_AND
      | EQUAL_TO | NOT_EQUAL_TO | LESS_THAN | GREATER_THAN | LESS_THAN_OR_EQUAL_TO | GREATER_THAN_OR_EQUAL_TO 
      | IN | L_NOT IN | IS | IS L_NOT
      | OR
      | XOR
      | AND
      | MINUS | PLUS
      | MULTIPLY | MOD | DIVIDE | DOUBLE_DIVIDE
      | SHIFT_LEFT | SHIFT_RIGHT

primary_expr: operand | primary_expr select_suffix | primary_expr call_suffix | primary_expr subscript_suffix | primary_expr schema_expr
operand: operand_name | number | string
    | TRUE | FALSE | NONE | list_expr | list_comp | dict_expr
    | dict_comp | LEFT_PARENTHESES test RIGHT_PARENTHESES
operand_name: identifier | qualified_identifier

select_suffix: DOT (identifier | dict_identifier_selector | list_identifier_selector)
dict_identifier_selector: MULTIPLY | LEFT_BRACE identifier (COMMA identifier)* RIGHT_BRACE
list_identifier_selector: subscript_suffix

//////////// call_suffix ////////////
call_suffix: LEFT_PARENTHESES [arguments [COMMA]] RIGHT_PARENTHESES

//////////// subscript_suffix ////////////
subscript_suffix: LEFT_BRACKETS (test | [test] COLON [test] [COLON [test]]) RIGHT_BRACKETS

//////////// arguments ////////////
arguments: argument (COMMA argument)*
argument: test | NAME ASSIGN test | MULTIPLY test | DOUBLE_STAR test


//////////// operand ////////////
identifier: NAME
qualified_identifier: identifier DOT identifier

//////////// list_expr ////////////
list_expr: LEFT_BRACKETS [list_items | NEWLINE _INDENT list_items _DEDENT] RIGHT_BRACKETS
list_items: list_item ((COMMA [NEWLINE] | NEWLINE) list_item)* [COMMA] [NEWLINE]
list_item: test | star_expr
list_comp: LEFT_BRACKETS (list_item comp_clause+ | NEWLINE _INDENT list_item comp_clause+ _DEDENT) RIGHT_BRACKETS
//////////// dict_expr ////////////
dict_expr: LEFT_BRACE [entries | NEWLINE _INDENT entries _DEDENT] RIGHT_BRACE
dict_comp: LEFT_BRACE (entry comp_clause+ | NEWLINE _INDENT entry comp_clause+ _DEDENT) RIGHT_BRACE
entries: entry ((COMMA [NEWLINE] | NEWLINE) entry)* [COMMA] [NEWLINE]
entry: test COLON test | double_star_expr
comp_clause: FOR loop_variables [COMMA] IN or_test [NEWLINE] [IF test [NEWLINE]]

star_expr: MULTIPLY primary_expr
double_star_expr: DOUBLE_STAR primary_expr
loop_variables: primary_expr (COMMA primary_expr)*

//////////// schema_expr ////////////
schema_expr: (LEFT_PARENTHESES [arguments] RIGHT_PARENTHESES)? dict_expr

//////////// misc ////////////
number: DEC_NUMBER | HEX_NUMBER | BIN_NUMBER | OCT_NUMBER | FLOAT_NUMBER | IMAG_NUMBER
string: STRING | LONG_STRING

// Tokens

ASSIGN: "="
COLON: ":"
SEMI_COLON: ";"
COMMA: ","
LEFT_PARENTHESES: "("
RIGHT_PARENTHESES: ")"
LEFT_BRACKETS: "["
RIGHT_BRACKETS: "]"
LEFT_BRACE: "{"
RIGHT_BRACE: "}"
PLUS: "+"
MINUS: "-"
MULTIPLY: "*"
DIVIDE: "/"
MOD: "%"
DOT: "."
AND: "&"
OR: "|"
XOR: "^"
NOT: "~"
LESS_THAN: "<"
GREATER_THAN: ">"
EQUAL_TO: "=="
NOT_EQUAL_TO: "!="
GREATER_THAN_OR_EQUAL_TO: ">="
LESS_THAN_OR_EQUAL_TO: "<="
DOUBLE_STAR: "**"
DOUBLE_DIVIDE: "//"
SHIFT_LEFT: "<<"
SHIFT_RIGHT: ">>"
AT: "@"

COMP_PLUS: "+="
COMP_MINUS: "-="
COMP_MULTIPLY: "*="
COMP_DIVIDE: "/="
COMP_MOD: "%="
COMP_AND: "&="
COMP_OR: "|="
COMP_XOR: "^="
COMP_DOUBLE_STAR: "**="
COMP_DOUBLE_DIVIDE: "//="
COMP_SHIFT_LEFT: "<<="
COMP_SHIFT_RIGHT: ">>="

// Special tokens
IMPORT: "import"
AS: "as"
SCHEMA: "schema"
MIXIN: "mixin"
RELAXED: "relaxed"
CHECK: "check"
FOR: "for"
ASSERT: "assert"
IF: "if"
ELIF: "elif"
ELSE: "else"
L_OR: "or"
L_AND: "and"
L_NOT: "not"
IN: "in"
IS: "is"
FINAL: "final"
LAMBDA: "lambda"

STRING_TYPE: "str"
INT_TYPE: "int"
FLOAT_TYPE: "float"
BOOL_TYPE: "bool"

// Constant tokens
TRUE: "True"
FALSE: "False"
NONE: "None"

NAME: /[a-zA-Z_]\w*/
COMMENT: /#[^\n]*/
NEWLINE: ( /\r?\n[\t ]*/ | COMMENT )+

STRING: /[ubf]?r?("(?!"").*?(?<!\\)(\\\\)*?"|'(?!'').*?(?<!\\)(\\\\)*?')/i
LONG_STRING: /[ubf]?r?(""".*?(?<!\\)(\\\\)*?"""|'''.*?(?<!\\)(\\\\)*?''')/is

DEC_NUMBER: /\-?0|\-?[1-9]\d*/i
HEX_NUMBER.2: /\-?0[xX][0-9a-fA-F]+/i
OCT_NUMBER.2: /\-?0[oO][0-7]+/i
BIN_NUMBER.2 : /\-?0[bB][0-1]+/i
FLOAT_NUMBER.2: /(([-+]?\d+\.\d*|\.\d+)(e[-+]?\d+)?|\d+(e[-+]?\d+))/i
IMAG_NUMBER.2: /\d+j/i | FLOAT_NUMBER "j"i

%ignore /[\t \f]+/  // WS
%ignore /\\[\t \f]*\r?\n/   // LINE_CONT
%declare _INDENT _DEDENT
```
