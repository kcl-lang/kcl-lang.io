---
sidebar_position: 0
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

## 参数说明

```shell
Usage:
  kcl [command]

Available Commands:
  clean       KCL clean tool
  completion  Generate the autocompletion script for the specified shell
  doc         KCL document tool
  fmt         KCL format tool
  import      KCL import tool
  lint        Run KCL codes.
  mod         KCL module management
  play        Open the kcl playground in the browser.
  registry    KCL registry management
  run         Run KCL codes.
  server      Run a KCL server
  test        KCL test tool
  version     Show version of the KCL CLI
  vet         KCL validation tool

Flags:
  -h, --help      help for kcl
  -v, --version   version for kcl

Additional help topics:
  kcl            

Use "kcl [command] --help" for more information about a command.
```
