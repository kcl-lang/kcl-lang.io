---
sidebar_position: 3
---

# YAML 语法

## 1. YAML 字符串使用单引号和双引号的区别是什么？

- YAML 双引号字符串是唯一能够表达任意字符串的样式，通过使用 `\` 转义字符，比如使用 `\"` 转义双引号 `"`,使用 `\\` 转义反斜杠 `\`，并且可以使用单个反斜杠 `\` 作为双引号字符串的续行符
- YAML 单引号字符串与 YAML 双引号字符串不同的是可以自由地使用 `\` 和 `"` 而不需要转义，但是使用两个单引号 `''` 转义单引号 `'` 字符

比如对于如下的例子，三个字符串变量的内容是相同的

```yaml
string1: 'here '' s to "quotes"'
string2: "here's to \"quotes\""
string3: here's to "quotes"
```

因此，KCL 输出 YAML 字符串的策略是当字符串内容出现单引号时，优先输出无引号字符串或双引号字符串，其他情况输出单引号字符串以避免理解上的负担。

更多细节可参考: [YAML 规范 v1.2](https://yaml.org/spec/1.2.1/)

## 2. YAML 中出现的 | - + > 等符号是什么含义？

在使用 KCL 多行字符串(使用三引号括起来的字符串)，输出的 YAML 经常会携带一些特殊的记号，如 `|`,`-`,`+` 和 `>` 等，这些记号通常为 YAML 多行字符串的表示方法，比如对于如下 KCL 代码：

```python
data = """This is a KCL multi line string (the first line)
This is a KCL multi line string (the second line)
This is a KCL multi line string (the third line)


"""
var = 1
```

输出 YAML 为：

```yaml
data: |+
  This is a KCL multi line string (the first line)
  This is a KCL multi line string (the second line)
  This is a KCL multi line string (the third line)


var: 1
```

- `|` 表示**块字符串样式**，用于表示一个多行字符串，其中的所有换行符都表示字符串真实的换行；
- `>` 表示**块折叠样式**，在其中所有的换行符将被空格替换；
- `+` 和 `-` 用于控制在字符串末尾使用换行符的情况。默认情况为字符串末尾保留单个换行符，如果要删除所有换行符，可以在样式指示符 `|` 或 `>` 后面放置一个 `-` 来完成，如果要保留末尾的换行符，则需要在 `|` 或 `>` 后面放置一个 `+`

更多细节可参考: [YAML 多行字符串](https://yaml-multiline.info/) 和 [YAML 规范 v1.2](https://yaml.org/spec/1.2.1/)

## 3. YAML 中在 | - + > 等符号之后出现的数字是什么含义？

数字表示 YAML 当中的**显式缩进指示符**。对于 YAML 中的长字符串，YAML 通常第一个非空行确定字符串的缩进级别，而当第一个非空行前面具有非前导字符时，比如换行符，YAML 要求必须使用**显式缩进指示符**来指定内容的缩进级别，比如 `|2` 和 `|1` 等

比如对于如下 KCL 代码:

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

如果不需要长字符串开头的空行或换行符，则可以以如下两种方式进行 KCL 长字符串书写

- 长字符串从第 1 行开始书写

```python
longString = """This is the second line
This is the third line
"""
```

- 使用续行符

```python
longString = """\
This is the second line
This is the third line
"""
```

以上两种方式输出的 YAML 均为:

```yaml
longString: |
  This is the second line
  This is the third line
```

更多细节可参考: [YAML 规范 v1.2](https://yaml.org/spec/1.2.1/)
