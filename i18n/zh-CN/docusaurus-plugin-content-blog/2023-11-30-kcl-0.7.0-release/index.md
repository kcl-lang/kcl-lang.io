---
slug: 2023-11-30-kcl-0.7.0-release
title: KCL v0.7.0 重磅发布 - 面向云原生场景更完善的生态模型、语言和工具链
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.7.0 新版本现在已经可用**！本次发布为大家带来了三方面的重点更新：**语言**、**工具链**、**社区集成 & 扩展支持**。

- _使用功能更完善错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _全新的 KCL 命令行工具，集成 KCL 包管理，doc, test 周边工具链生态，包罗万象，一键直达_
- _丰富的 KCL 三方库市场 artifacthub.io, 提供了超过 200 种 KCL 三方库，尽情挑选，无限可能_

进一步您可以在 [KCL v0.7.0 发布页面](https://github.com/kcl-lang/kcl/releases/tag/v0.7.0) 或者 [KCL 官方网站](https://kcl-lang.io) 获得下载安装指南和详细发布信息。

[KCL](https://github.com/kcl-lang/kcl) 是一个 CNCF 基金会托管的面向云原生领域开源的基于约束的记录及函数编程语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于围绕配置的模块化、扩展性和稳定性，打造更简单的逻辑编写体验，构建更简单的自动化和生态集成路径。

本文重点介绍 KCL v0.7.0 版本的更新内容以及 KCL 社区的近期动态。

## 语言更新

### ⭐️ 全新的 KCL 命令行工具

在新版本中提供了全新的 KCL 命令行工具, 目标是将 KCL 周边生态囊括在一起，为您提供统一简明的操作页面，包罗万象，一键直达。

新的 KCL 命令行工具将会以继续 kcl 作为命令前缀，目前提供包含编译，包管理，格式化工具等多个子命令。

![cli-help](/img/blog/2023-11-30-kcl-0.7.0-release/cli-help.png)

### 🔧 诊断信息的优化

在 KCL 新版本中，在部分代码错误信息中增加了修复建议，比如变量名称写错或者查找不到 import 的代码包

```python
import sub as s1

The_first_kcl_program = s.The_first_kcl_program
```

![did you mean](/img/blog/2023-11-30-kcl-0.7.0-release/did-you-mean.png)

![try-kcl-mod-add](/img/blog/2023-11-30-kcl-0.7.0-release/try-kcl-mod-add.png)

### 🚀 语言编写体验优化

#### 去掉了部分代码块中的缩进检查

在 KCL 新版本中，我们取消了配置代码块的严格缩进检查，如果 KCL 代码写成这样

```python
schema TestIndent:
    name: str
    msg: str
    id: int

test_indent = TestIndent {
                    name = "test"
  msg = "test"
              id = 1
}
```

使用 kcl fmt 命令会可以一键格式化

![kcl-fmt](/img/blog/2023-11-30-kcl-0.7.0-release/kclfmt.gif)

#### 函数类型注解

在 KCL 新版本中，新增了函数类型注解，您可以在新版本的 KCL 中编写如下带有类型注解的 lambda。

```python
schema Test:
    name: str

identity: (Test) -> bool = lambda res: Test -> bool {
    res.name == "hello"
}

c = identity(Test { name = "hello" })
```

### 🏄 API 更新

- 新增 KCL 单元测试 API: _[https://github.com/kcl-lang/kcl/pull/904](https://github.com/kcl-lang/kcl/pull/904)_
- KCL Schema 模型解析 API 增强版 GetFullSchemaType支持获取带有三方库的 KCL 包相关信息和 Schema 属性默认值 _[https://github.com/kcl-lang/kcl/pull/906](https://github.com/kcl-lang/kcl/pull/906)_
- 新增 KCL 符号重命名 API: _[https://github.com/kcl-lang/kcl/pull/890](https://github.com/kcl-lang/kcl/pull/890)_

### 🐞 其他更新及错误修复

- KCL 命令行工具支持输入文件通配符进行编译 `kcl path/to/*.k`
- 修复部分场景字典类型的类型推导错误 https://github.com/kcl-lang/kcl/pull/900
- 修复 Schema 参数的检查 https://github.com/kcl-lang/kcl/pull/877/files
- 修复了带有三方库的KCL程序编译缓存失效的问题 https://github.com/kcl-lang/kcl/pull/841
- 错误信息中补全缺失的 lambda 的类型信息 https://github.com/kcl-lang/kcl/pull/771
- 修复了诊断信息中单数和复数的问题 https://github.com/kcl-lang/kcl/pull/769
- 修复了带有类型注解赋值语句中类型检查失效的问题 https://github.com/kcl-lang/kcl/pull/757
- 增加了检查，禁止同名的 import 语句 https://github.com/kcl-lang/kcl/pull/727

## IDE & 工具链更新

### IDE 更新

#### KCL IDE 插件支持了对符号的引用跳转及重命名功能

IDE 增加了对符号的引用跳转支持，使用`转到引用`或`查找所有引用`：

![find-ref](/img/docs/tools/Ide/vs-code/FindRefs.png)

对符号进行`重命名`：

![rename](/img/docs/tools/Ide/vs-code/Rename.gif)

#### IDE 支持对引用语句和联合类型的格式化

优化了引用语句与其他代码块之间的空行行为（格式化为一个空行）和联合类型的空格行为（多个类型之间格式化为以 `|` 间隔）：

![fmt](/img/blog/2023-10-25-kcl-biweekly-newsletter/Format.gif)

#### KCL IDE 插件基于新增了大量补全提示

针对**配置定义**这一核心环节，简化用户基于模型编写配置的心智、提升配置编辑的效率。此外，增强了调用内置函数时参数补全。talk is cheap，我们直接来看效果：

![func-completion](/img/blog/2023-11-08-biweekly-newsletter/module-function-completion.gif)

![conf-completion](/img/blog/2023-11-08-biweekly-newsletter/config-completion.gif)

而对于**模型设计**环节，也新增了对 docstring 的快速生成，减少手敲 boilerplate：

![gen-docstring](/img/blog/2023-11-08-biweekly-newsletter/docstring-gen.gif)

#### 性能提升

- KCL 设计并重构了新的语义模型以及支持最近符号查找和符号语义信息查询 API
- IDE 补全，跳转和悬停等功能实现迁移至新语义模型，显著降低 IDE 功能开发难度和代码量
- KCL 编译器支持语法增量解析以及语义增量检查，大部分场景提升 KCL 编译构建和 IDE 插件使用性能 **5-10 倍**

#### 其他更新和错误修复

- KCL IntelliJ 插件适配 2023.2+ 版本
- 支持对标准库和内置函数的悬停提示，支持对 KCL 代码错误的快速修复
- 优化了对引用语句和 union 类型的格式化输出。
- 修复了语言服务虚拟文件系统相关的bug：文件维度的变更引发会语言服务崩溃，必须重启 IDE 恢复，现已修复。
- 支持包管理工具引入的外部包依赖 import 语句补全
- 修复函数参数未定义类型错误显示位置

### 测试工具更新

担心您的 KCL 程序写错了，要不来测测 ？本次更新提供了全新的 KCL 测试工具，代码好坏，一测便知 ！新的 KCL 测试工具支持使用 KCL 函数编写单元测试并使用工具执行测试。

您可以在后缀名为 “\_test.k” 文件中通过 lambda 表达式来编写您的测试用例。

```python
import .app

# Convert the `App` model into Kubernetes Deployment and Service Manifests
test_kubernetesRender = lambda {
    a = app.App {
        name = "app"
        containers.ngnix = {
            image = "ngnix"
            ports = [{containerPort = 80}]
        }
        service.ports = [{ port = 80 }]
    }
    deployment_got = kubernetesRender(a)
    assert deployment_got[0].kind == "Deployment"
    assert deployment_got[1].kind == "Service"
}
```

通过 kcl test 命令可以运行这个测试用例并查看测试结果。

测试通过会将得到如下结果：

![test-pass](/img/blog/2023-11-30-kcl-0.7.0-release/test-pass.png)

如果测试失败了，kcl test 会将输出错误信息进行输出。

![test-failed](/img/blog/2023-11-30-kcl-0.7.0-release/test-failed.png)

### KCL 包管理工具

新增 update 命令用于自动更新本地依赖，使用 `kcl mod update` 将会自动下载本地缺失的三方库。具体参考: https://github.com/kcl-lang/kpm/pull/212

### KCL 导入工具发布

支持从 YAML/JSON/CRD/Terraform Schema 一键生成 KCL 配置/模型，实现自动化迁移。

如果您有如下 yaml 文件：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

通过命令 `kcl import test.yaml` 您可以将其转换为 KCL 程序。

```python
"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""

apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx-deployment"
    labels = {
        app = "nginx"
    }
}
spec = {
    replicas = 3
    selector = {
        matchLabels = {
            app = "nginx"
        }
    }
    template = {
        metadata = {
            labels = {
                app = "nginx"
            }
        }
        spec = {
            containers = [
                {
                    name = "nginx"
                    image = "nginx:1.14.2"
                    ports = [
                        {
                            containerPort = 80
                        }
                    ]
                }
            ]
        }
    }
}
```

更多详细内容请参考[一键从 Kubernetes 生态迁移到 KCL](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/adopt-from-kubernetes)

## 社区集成 & 扩展更新

### KCL 三方库市场 ArtifactHub

通过集成 artifacthub.io 我们构建了一个 KCL 三方库市场，在这里您尽可以大展您的才华，与我们一同分享您对 KCL 程序的独特理解，您也可以尽情挑选，找到适合您自己的 KCL 三方库 ！

打开首页，直接搜索您需要的关键字，就能看到关于 KCL 三方库的相关内容 ！

![artifachub-index](/img/blog/2023-11-30-kcl-0.7.0-release/artifachub-index.png)

在三方库首页，可以查看关于三方库的详细内容和相关文档。

![pkg-page](/img/blog/2023-11-30-kcl-0.7.0-release/pkg-page.png)

如果您不知道该如何使用这些三方库，右侧的按钮可以为您唤起安装页面。

![install-pkg](/img/blog/2023-11-30-kcl-0.7.0-release/install-pkg.png)

欢迎大家来 artifacthub.io 为 KCL 社区贡献您的三方库，让 KCL 社区变得更加丰富多彩！

贡献指南：https://kcl-lang.io/docs/user_docs/guides/package-management/how-to/publish_pkg_to_ah

## 其他更新

完整更新和错误修复列表详见: https://github.com/kcl-lang/kcl/compare/v0.6.0...v0.7.0

## 文档更新

KCL 网站新增 KCL v0.7.0 文档内容并支持版本化语义选项，目前支持 v0.4.x, v0.5.x, v0.6.x 和 v0.7.0 版本选择，同时欢迎社区同学进行文档共建。

## 社区动态

### KCL 正式成为 CNCF 沙箱项目

🎉 🎉 🎉 2023 年 9 月 20 日，KCL 项目通过了全球顶级开源基金会云原生计算基金会（CNCF）技术监督委员会评定，正式成为 CNCF 沙箱项目。

更多详情详见: https://kcl-lang.io/blog/2023-09-19-kcl-joining-cncf-sandbox/

### 特别鸣谢

感谢社区的小伙伴在 KCL v0.7.0 版本中的贡献，以下排名不分先后

- 感谢 @jakezhu9 对 KCL Import 工具 Terraform Schema 到 KCL Schema 转换的贡献 🙌 _[https://github.com/kcl-lang/kcl-go/pull/152](https://github.com/kcl-lang/kcl-go/pull/152)_
- 感谢 @jakezhu9 对 kpm 集成 Import 工具的贡献 🙌 _[https://github.com/kcl-lang/kpm/pull/194](https://github.com/kcl-lang/kpm/pull/194)_
- 感谢 @zwpaper 对 KCL 文档和 Tree Sitter Grammar 做出的贡献 🙌 _[https://github.com/kcl-lang/tree-sitter-kcl/pull/1](https://github.com/kcl-lang/tree-sitter-kcl/pull/1)_ 等
- 感谢 @jakezhu9 对 KCL 语法解析单元测试的改进，将部分测试用例统一迁移到使用 snaptest 框架 🙌 _[https://github.com/kcl-lang/kcl/pull/794](https://github.com/kcl-lang/kcl/pull/794)_ 等
- 感谢 @opsnull 对 KCL 官网文档中代码示例的纠错和贡献 🙌 _[https://github.com/kcl-lang/kcl-lang.io/pull/182](https://github.com/kcl-lang/kcl-lang.io/pull/182)_
- 感谢 @prahaladramji 对 KCL IntelliJ 插件格式化功能的纠错和优化 🙌 _[https://github.com/kcl-lang/intellij-kcl/pull/15](https://github.com/kcl-lang/intellij-kcl/pull/15)_
- 感谢 @jakezhu9 对 KCL benchmark 由单线程 Rc 到 Arc 的改进，对 KCL 导入工具中关于引用路径的 bug修复 🙌 _[https://github.com/kcl-lang/kcl-go/pull/170](https://github.com/kcl-lang/kcl-go/pull/170)_ 等
- 感谢 @liangyuanpeng 为 KCL 模型贡献 karmada 模型包，欢迎！🙌 _[https://github.com/kcl-lang/artifacthub/pull/48/files](https://github.com/kcl-lang/artifacthub/pull/48/files)_
- 感谢 @cr7258 对 KCL 模型库以及 KCL 文档的贡献 🙌
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/203](https://github.com/kcl-lang/kcl-lang.io/pull/203)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/209](https://github.com/kcl-lang/kcl-lang.io/pull/209)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/210](https://github.com/kcl-lang/kcl-lang.io/pull/210)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/211](https://github.com/kcl-lang/kcl-lang.io/pull/211)_
  - _[https://github.com/kcl-lang/modules/pull/67](https://github.com/kcl-lang/modules/pull/67)_
- 感谢 @XiaoK29 为 KCL IDE 的悬停和引用查找功能代码架构重构以及 KCL 文档的贡献 🙌
  - _[https://github.com/kcl-lang/kcl/pull/887](https://github.com/kcl-lang/kcl/pull/887)_
  - _[https://github.com/kcl-lang/kcl/pull/899](https://github.com/kcl-lang/kcl/pull/899)_
  - _[https://github.com/kcl-lang/kcl-lang.io/pull/205](https://github.com/kcl-lang/kcl-lang.io/pull/205)_
- 感谢 @MeenuyD, @negz 对 Crossplane KCL Composition Functions 集成的讨论与支持 🙌
  - _[https://github.com/kcl-lang/kcl/issues/885](https://github.com/kcl-lang/kcl/issues/885)_
- 感谢 @kolloch 对 Bazel KCL 构建规则脚本的宝贵反馈 🙌
  - _[https://github.com/kcl-lang/rules_kcl/pull/2](https://github.com/kcl-lang/rules_kcl/pull/2)_

## 下一步计划

感谢所有 KCL 用户和社区小伙伴在此次版本更新过程中提出的宝贵反馈与建议。预计 2024 年 2 月，我们将发布 KCL v0.8.0 版本，更多详情请参考 KCL 2024 路线规划 和 KCL v0.8.0 Milestone，如果您有更多的想法和需求，欢迎在 KCL Github 仓库发起 Issues 或讨论，也欢迎加入我们的社区进行交流 🙌 🙌 🙌

更多其他资源请参考：

- KCL 网站: https://kcl-lang.io/
- Kusion 网站: https://kusionstack.io/
- KCL GitHub 仓库: https://github.com/kcl-lang/kcl
- Kusion GitHub 仓库: https://github.com/KusionStack/kusion

- KCL v0.8.0 Milestone: https://github.com/kcl-lang/kcl/milestone/8
- KCL 2024 路线规划: https://github.com/kcl-lang/kcl/issues/882
- KCL 社区: https://github.com/kcl-lang/community
