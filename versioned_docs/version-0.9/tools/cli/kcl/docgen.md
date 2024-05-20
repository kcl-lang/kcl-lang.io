---
sidebar_position: 2
---

# Doc

The KCL Document tool supports extracting model documents from KCL source code and supports to output Markdown, HTML and OpenAPI formats. This document introduces the document specification of the KCL language, gives an example of how to use the KCL Document tool to extract documents.

## Document Specification of KCL

The documentation of the KCL file mainly contains the following two parts:

- Current KCL module document: description of the current KCL file
- All schema documents contained in the KCL file: a description of the current schema, including schema description, schema attribute descriptions, and Examples. The specific format is as follows:

1. Schema description

```python
"""This is a brief description of the Schema
"""
```

2. Description of each attribute of Schema: including attribute description, attribute type, default value, optional or required

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

`----------` indicates that `Attributes` is a title (the length of the symbol `-` is the same as the length of the title), the attribute name and attribute type are separated by a colon `:`, the description of the attribute is written on another line with indentation. The default value of the attribute is separated by a comma `,` after the attribute type, and it is written in the form of `default is {default value}`. In addition, it is necessary to indicate whether the attribute is optional/required. Write `optional` after the default value for an optional attribute, and write `required` after the default value for a required attribute.

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

In addition, the KCL docstring syntax should use a subset of the [re-structured text (reST)](https://docutils.sourceforge.io/rst.html) and be rendered using the [Sphinx](https://www.sphinx-doc.org/en/master/).

## Generating Documentation From KCL

Use the `kcl doc generate` command to extract documentation from a user-specified file or directory and output it to the specified directory.

Generate Markdown document for current package with a `kcl.mod` file.

```shell
kcl doc generate
```

Generate HTML document for current package

```shell
kcl doc generate --format html
```

Generate Markdown document for specific package

```shell
kcl doc generate --file-path <package path>
```

Generate Markdown document for specific package to a `<target directory>`

```shell
kcl doc generate --file-path <package path> --target <target directory>
```

## Appendix

### Concept of reST

For documents in reST format, paragraphs and indentation are important, new paragraphs are marked with blank lines, and indentation is the indentation indicated in the output. Font styles can be expressed as follows:

- \*Italic\*
- \*\*Bold\*\*
- \`\`Monospaced\`\`

Refer to [reST](https://docutils.sourceforge.io/rst.html) for more information.

## Args

### kcl doc

```shell
This command shows documentation for KCL modules or symbols.

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
This command generates documents for KCL modules.

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
