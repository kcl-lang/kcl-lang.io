---
slug: 2024-02-22-newsletter
title: KCL 最新动态速递 (2024 02.02 - 2024.02.22)
authors:
  name: KCL 团队
  title: KCL 团队
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter-zh.png)

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

本栏目将会双周更新 KCL 语言社区最新动态，包括功能、官网更新和最新的社区动态等，帮助大家更好地了解 KCL 社区！

**_KCL 官网：[https://kcl-lang.io](https://kcl-lang.io)_**

## 内容概述

感谢所有贡献者过去一段时间 (2024 02.02 - 2024.02.22) 的杰出工作，以下是重点内容概述

**📦 模型更新**

- JSON Schema 库发布 0.0.4 版本，修复类型定义错误, 可以执行如下命令更新或添加依赖

```shell
kcl mod add jsonschema:0.0.4
```

**🏄 语言更新**

**KCL 发布 0.8.0 预览版本**，主要包含如下更新

- 新增 file 系统库用于读取 KCL 模块信息和系统文件，包含 `read`, `glob`, `workdir` 和 `modpath` 函数，详见 Issue: https://github.com/kcl-lang/kcl/issues/1049
- 优化非预期 token 的语法错误提示
- 去除 Schema 对象内部非预期的内置类型属性通过 print 输出
- 修复非预期的字典生成表达式中的 key 与循环变量相同时的变量计算
- 修复 schema 内部诸如 "$if" 的字符串标识符定义找不到的错误

**🔧 工具链更新**

- kcl run 支持使用 `-H` 参数输出以 `_` 开头的隐藏字段
- kcl run 支持直接运行远端 Git 仓库代码
- kcl mod 新增 kcl mod graph 子命令输出模块依赖图
- kcl fmt 修复 else 块中存在 if 语句时的格式化错误

**💻 IDE 更新**

- 优化了内置函数和系统库的补全以及悬停文档提升
- 修复了配置块内部 if 语句符号不能跳转和补全的问题
- 增加变量引用错误时的快速修复功能

**🎁 API 更新**

- OverrideFile API 新增诸如 `a["b"].c` 的 path 对配置进行查询和修改

**🚀 插件系统更新**

除了使用 Python 为 KCL 插件函数，现在支持使用 Go 为 KCL 编写插件函数，使用方式非常简单。

+ 定义插件 (以一个包含 add 函数的 hello 插件作为示例)

```go
package hello_plugin

import (
	"kcl-lang.io/kcl-go/pkg/plugin"
)

func init() {
	plugin.RegisterPlugin(plugin.Plugin{
		Name: "hello",
		MethodMap: map[string]plugin.MethodSpec{
			"add": {
				Body: func(args *plugin.MethodArgs) (*plugin.MethodResult, error) {
					v := args.IntArg(0) + args.IntArg(1)
					return &plugin.MethodResult{V: v}, nil
				},
			},
		},
	})
}
```

+ 使用插件

```go
package main

import (
	"fmt"

	"kcl-lang.io/kcl-go/pkg/kcl"
	"kcl-lang.io/kcl-go/pkg/native"                // Import the native API
	_ "kcl-lang.io/kcl-go/pkg/plugin/hello_plugin" // Import the hello plugin
)

func main() {
	// Note we use `native.MustRun` here instead of `kcl.MustRun`, because it needs the cgo feature.
	yaml := native.MustRun("main.k", kcl.WithCode(code)).GetRawYamlResult()
	fmt.Println(yaml)
}

const code = `
import kcl_plugin.hello

name = "kcl"
three = hello.add(1,2) # 3
`
```

**🚢 集成更新**

- 发布 Ansible KCL 模块初始版本，支持基本的运行 KCL 代码功能，其他功能完善中
- KCL FluxCD Controller 优化 Git Source 功能，OCI Source 功能支持中

## 特别鸣谢

以下排名不分先后

- 感谢 @octonawish-akcodes 和 @d4v1d03
 对 KCL FAQ 文档和 KCL IDE 功能的持续贡献 🙌
- 感谢 @octonawish-akcodes 对 Ansible KCL Module 的贡献
- 感谢 @AkashKumar7902 和 @Vanshikav123 对 KCL 包管理工具功能的贡献 🙌
- 感谢 @StevenLeiZhang 对 KCL 文档和 KCL 插件的贡献
- 感谢 @TheChinBot, @Evgeny Shepelyuk, @yonas, @steeling, @vtomilov, @Fdall, @CloudZero357, @bozaro, @starkers 和 @FLAGLORD 等在近段时间使用 KCL 过程中提供的宝贵建议与反馈 🙌

## 其他资源

预计 2024 年 2 月底会发布 0.8 正式版本，感谢所有 KCL 用户和社区小伙伴在社区中提出的宝贵反馈与建议。后续我们会发布更多 KCL 技术和案例文章，敬请期待! 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们。

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
