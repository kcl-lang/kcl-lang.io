---
sidebar_position: 2
---

# 文档生成工具

KCL 命令行工具支持从 KCL 源码中一键提取模型文档，并支持 Markdown, HTML, OpenAPI 等输出格式。本文介绍 KCL 语言的文档规范，举例说明如何使用 KCL 文档生成工具提取文档。

## KCL 语言的文档规范

KCL文件的文档主要包含如下两个部分：

- 当前 KCL 模块的文档：对当前 KCL 文件的说明
- KCL 文件内包含的所有 Schema 的文档：对当前 Schema 的说明，其中包含 Schema 描述、Schema 各属性的描述、Examples 三部分，具体格式如下：

1. Schema 描述

```python
"""这是Schema一个简短的描述信息
"""
```

2. Schema 各属性的描述：包含属性描述、属性类型、默认值、是否可选

```python
"""
Attributes
----------
x : type, default is a, optional.
    Description of parameter `x`.
y : type, default is b, required.
    Description of parameter `y`.
"""
```

其中，使用 `----------` 表示 `Attributes` 为一个标题(`-` 符号长度与标题长度保持一致)，属性名称与属性类型用冒号 `:` 分隔，属性的说明另起一行并增加缩进进行书写。属性的默认值说明跟在属性类型之后使用逗号 `,` 分隔，书写为 `default is {默认值}` 形式，此外需要说明属性是否为可选/必选，对于可选属性在默认值之后书写 `optional`，对于必选属性在默认值之后书写 `required`。

3. Examples

```python
"""
Examples
--------
val = Schema {
    name = "Alice"
    age = 18
}
"""
```

此外，KCL 文档字符串语法应采用 [re-structured text (reST)](https://docutils.sourceforge.io/rst.html) 语法子集，并使用 [Sphinx](https://www.sphinx-doc.org/en/master/) 渲染呈现。

## 从 KCL 源码生成文档

使用 `kcl doc generate` 命令，从用户指定的文件或目录中提取文档，并输出到指定目录。

为当前 KCL 包生成 Markdown 文档到 `/docs` 目录 (包含 kcl.mod 文件)

```shell
kcl doc generate
```

为当前 KCL 包生成 HTML 文档到 `/docs` 目录 (包含 kcl.mod 文件)

```shell
kcl doc generate --format html
```

指定 KCL 包路径生成 Markdown 文档到 `/docs` 目录

```shell
kcl doc generate --file-path <package path>
```

指定 KCL 包路径生成 Markdown 文档并保存到 `<目标目录>`。

```shell
kcl doc generate --file-path <package path> --target <target directory>
```

## 文档工具附录

### 常见的 reST 概念

对于 reST 格式的文档，段落和缩进很重要，新段落用空白行标记，缩进即为表示输出中的缩进。可以使用如下方式表示字体样式：

- \*斜体\*
- \*\*粗体\*\*
- \`\`等宽字体\`\`

参考 [reST 文档](https://docutils.sourceforge.io/rst.html)获得更多帮助。

## 参数说明

### kcl doc

```shell
This command shows documentation for KCL package or symbol.

Usage:
  kcl doc [command]

Aliases:
  doc, d

Examples:
  # Generate document for current package
  kcl doc generate


Available Commands:
  generate    Generates documents from code and examples

Flags:
  -h, --help   help for doc

Use "kcl doc [command] --help" for more information about a command.
```

### kcl doc generate

```shell
Usage:
  kcl doc generate [flags]

Aliases:
  generate, gen, g

Examples:
  # Generate Markdown document for current package
  kcl doc generate

  # Generate Html document for current package
  kcl doc generate --format html

  # Generate Markdown document for specific package
  kcl doc generate --file-path <package path>

  # Generate Markdown document for specific package to a <target directory>
  kcl doc generate --file-path <package path> --target <target directory>


Flags:
      --escape-html         Whether to escape html symbols when the output format is markdown. Always scape when the output format is html. Default to false.
      --file-path string    Relative or absolute path to the KCL package root when running kcl-doc command from
                            outside of the KCL package root directory.
                            If not specified, the current work directory will be used as the KCL package root.
      --format string       The document format to generate. Supported values: markdown, html, openapi. (default "md")
  -h, --help                help for generate
      --ignore-deprecated   Do not generate documentation for deprecated schemas.
      --target string       If not specified, the current work directory will be used. A docs/ folder will be created under the target directory.
      --template string     The template directory based on the KCL package root. If not specified, the built-in templates will be used.
```
