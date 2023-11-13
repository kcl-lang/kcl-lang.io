---
sidebar_position: 1
---

# 概览

KCL 工具链是 KCL 语言的工具集合，旨在提升 KCL 的批量迁移、编写、编译和测试的效率。

| 类别       | 工具名称               | 说明                                                      |
| ---------- | ---------------------- | --------------------------------------------------------- |
| 主工具集   | **kcl**                | kcl 命令行工具提供对基于 KCL 语言的配置编写、编译和运行。 |
|            | kcl-test               | 即将提供                                                  |
|            | kcl-fmt                | kcl-fmt 工具提供对 KCL 代码的格式化                       |
|            | kcl-lint               | kcl-lint 工具提供对 KCL 代码的 lint 检查和自动修复        |
|            | kcl-doc                | kcl-doc 工具提供对 KCL 代码的文档解析和生成               |
|            | kcl-vet                | 使用 KCL 代码校验诸如 JSON 和 YAML 的数据格式             |
| ide 插件集 | IntelliJ IDEA KCL 插件 | 提供 IntelliJ IDEA 平台的 KCL 编写、编译辅助              |
|            | VS Code KCL 插件       | 提供 VS Code 平台的 KCL 编写、编译辅助                    |

## KCL 工具

### 命令行参数

```shell
USAGE:
    kcl [OPTIONS] [--] [input]...

Arguments:
  [input]...  Specify the input files to run

Options:
  -o, --output <output>
          Specify the YAML output file path
  -Y, --setting <setting>...
          Specify the input setting file
  -v, --verbose...
          Print test information verbosely
  -n, --disable_none
          Disable dumping None values
  -r, --strict_range_check
          Do perform strict numeric range checks
  -d, --debug
          Run in debug mode (for developers only)
  -k, --sort_keys
          Sort result keys
  -D, --argument <arguments>...
          Specify the top-level argument
  -S, --path_selector <path_selector>...
          Specify the path selector
  -O, --overrides <overrides>...
          Specify the configuration override path and value
      --target <target>
          Specify the target type
  -E, --external <package_map>...
          Mapping of package name and path where the package is located
  -h, --help
          Print help
```
