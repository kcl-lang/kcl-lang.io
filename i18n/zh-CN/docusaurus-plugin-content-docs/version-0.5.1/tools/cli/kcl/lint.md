---
sidebar_position: 3
---

# Lint 检查代码风格

KCL 支持通过内置的命令行工具对 KCL 代码进行检查，并支持多种输出格式。本文档展示 KCL Lint 工具的使用方式。

## 示例

### 工程结构

```text
.
└── Test
    └── kcl.mod
    └── a.k
    └── b.k
    └── dir
        └── c.k
    └── test.k
```

`a.k`,`b.k`,`c.k`,`test.k` 为测试的 kcl 文件。

命令：

```shell
kcl-lint your_config.k
```

或

```shell
kcl-lint your_config_path
```

### CLI 参数

```shell
USAGE:
    kcl-lint [OPTIONS] [--] [input]...

ARGS:
    <input>...    Sets the input file to use

OPTIONS:
        --emit_warning            Emit warning message
    -h, --help                    Print help information
    -v, --verbose                 Print test information verbosely
    -Y, --setting <setting>...    Sets the input file to use
```

- input: 需要检查的单个 `.k` 文件路径或路径目录下的所有 `.k` 文件，支持绝对路径或当前目录的相对路径
