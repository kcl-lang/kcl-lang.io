---
sidebar_position: 1
---

# 概览

KCL 工具链是 KCL 语言的工具集合，旨在提升 KCL 的批量迁移、编写、编译和测试的效率。

| 类别       | 工具名称                 | 说明                                                    |
| ---------- | ------------------------ | ------------------------------------------------------- |
| 主工具集   | **kcl** (kcl run 的别称) | kcl 命令行工具提供对基于 KCL 语言的配置编写、编译和运行 |
|            | kcl run                  | kcl 命令行工具提供对基于 KCL 语言的配置编写、编译和运行 |
|            | kcl doc                  | 解析KCL代码并生成文档                                   |
|            | kcl fmt                  | 格式化KCL代码                                           |
|            | kcl import               | 导入其他数据和模式到KCL                                 |
|            | kcl lint                 | 检查KCL的代码风格                                       |
|            | kcl mod                  | KCL模块相关功能和包管理                                 |
|            | kcl play                 | 在本地运行KCL playground                                |
|            | kcl registry             | KCL注册表相关功能                                       |
|            | kcl server               | 在本地运行KCL REST服务器                                |
|            | kcl test                 | 运行KCL中的单元测试                                     |
|            | kcl vet                  | 使用KCL验证JSON和YAML等数据文件                         |
| ide 插件集 | IntelliJ IDEA KCL 插件   | 提供 IntelliJ IDEA 平台的 KCL 编写、编译辅助            |
|            | NeoVim KCL 插件          | 提供 NeoVim 平台的 KCL 编写、编译辅助                   |
|            | VS Code KCL 插件         | 提供 VS Code 平台的 KCL 编写、编译辅助                  |

## KCL 工具

### 命令行参数

```shell
This command runs the kcl code and displays the output. 'kcl run' takes multiple input for arguments.

For example, 'kcl run path/to/kcl.k' will run the file named path/to/kcl.k

Usage:
  run [flags]

Aliases:
  run, r

Examples:
  # Run a single file and output YAML
  kcl run path/to/kcl.k

  # Run a single file and output JSON
  kcl run path/to/kcl.k --format json

  # Run multiple files
  kcl run path/to/kcl1.k path/to/kcl2.k

  # Run OCI packages
  kcl run oci://ghcr.io/kcl-lang/hello-world

  # Run the current package
  kcl run


Flags:
  -D, --argument strings        Specify the top-level argument
  -d, --debug                   Run in debug mode
  -n, --disable_none            Disable dumping None values
  -E, --external strings        Specify the mapping of package name and path where the package is located
      --format string           Specify the output format (default "yaml")
  -h, --help                    help for run
      --no_style                Set to prohibit output of command line waiting styles, including colors, etc.
  -o, --output string           Specify the YAML/JSON output file path
  -O, --overrides strings       Specify the configuration override path and value
  -S, --path_selector strings   Specify the path selectors
  -q, --quiet                   Set the quiet mode (no output)
  -Y, --setting strings         Specify the command line setting files
  -k, --sort_keys               Sort output result keys
  -r, --strict_range_check      Do perform strict numeric range checks
  -t, --tag string              Specify the tag for the OCI or Git artifact
  -V, --vendor                  Run in vendor mode
```
