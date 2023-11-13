---
sidebar_position: 3
---

# YAML

## 1. What is the difference between single and double quote YAML strings?

- YAML double-quoted strings are the only style that can express arbitrary strings, by using `\` escape characters, such as `\"` to escape double quotes `"`, `\\` to escape backslashes `\`, and a single backslash `\` can be used as a continuation character for double-quoted strings.
- YAML single-quoted strings differ from YAML double-quoted strings in that `\` and `"` can be used freely without escaping, but two single-quotes `''` are used to escape single-quote `'` characters.

For the following example, the contents of the three string variables are the same.

```yaml
string1: 'here '' s to "quotes"'
string2: 'here''s to "quotes"'
string3: here's to "quotes"
```

> Note: KCL's strategy for outputting YAML strings is to output unquoted strings or double-quoted strings preferentially when single quotes appear in the string content, and output single-quoted strings in other cases to avoid the burden of understanding.

For more details, please refer to [YAML Spec v1.2](https://yaml.org/spec/1.2.1/)

## 2. What is the meaning of symbols such as | - + > in YAML?

When using KCL multi-line strings (triple quote strings), the output YAML often carries some special tokens, such as `|`, `-`, `+` and `>`, etc. These tokens usually are the representation method of YAML multi-line string, such as the following KCL code:

```python
data = """This is a KCL multi line string (the first line)
This is a KCL multi line string (the second line)
This is a KCL multi line string (the third line)


"""
var = 1
```

The output YAML is

```yaml
data: |+
  This is a KCL multi line string (the first line)
  This is a KCL multi line string (the second line)
  This is a KCL multi line string (the third line)


var: 1
```

- `|` represents **block style**, which is used to represent a multi-line string, where all newlines in the string represent the real newlines.
- `>` represents **folding style**, in which all newlines in the string will be replaced by spaces.
- `+` and `-` are used to control the use of newlines at the end of strings. The default is to keep a single newline at the end of the string. If we want to remove all newlines, we can put a `-` after the style indicator `|` or `>`. If we want to keep the newline at the end, we need to put a `+` after `|` or `>`.

For more details, please refer to [YAML Multiline String](https://yaml-multiline.info/) and [YAML Spec v1.2](https://yaml.org/spec/1.2.1/)

## 3. What is the meaning of numbers that appear after symbols | - + > such as |1 and |2 in YAML?

Numbers represent **explicit indentation indicators** in YAML. For long strings in YAML, YAML usually the first non-blank line determines the indentation level of the string, and when the first non-blank line is preceded by a non-leading character, such as a newline, we must use **explicit indent indicators** to specify the indent level of the content, such as `|1` and `|2` etc.

For example, for the following KCL code:

```python
longStringStartWithNewline = """
This is the second line
This is the third line
"""

```

```yaml
longStringStartWithNewline: |2

  This is the second line
  This is the third line
```

- Writing long strings from the first line.

```python
longString = """This is the second line
This is the third line
"""
```

- Writing long strings with line continuation characters.

```python
longString = """\
This is the second line
This is the third line
"""
```

The YAML output by the above two methods is:

```yaml
longString: |
  This is the second line
  This is the third line
```

For more details, please refer to [YAML Spec v1.2](https://yaml.org/spec/1.2.1/)
