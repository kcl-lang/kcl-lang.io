---
slug: 2024-07-05-kcl-0.10.0-release
title: KCL v0.10.0 重磅发布 - 更稳定流畅的工具链和 IDE 体验，全新的 KCL Playground !
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.10.0 新版本现在已经可用**！本次发布为大家带来了三方面的重点更新

- _使用功能更完善和错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _更加全面丰富的标准库、三方库以及社区生态集成，涵盖不同应用场景和需求_
- _WASM SDK 支持无缝的浏览器运行与全新的 KCL Playground_

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## ❤️ 特别鸣谢

**感谢 KCL 在 v0.9 - v0.10 版本迭代所有 80 位社区参与者，以下排名不分先后**

_@eshepelyuk, @haarchri, @liangyuanpeng, @logo749, @bilalba, @borgius, @patrick-hermann-sva, @ovk, @east4ming, @wmcnamee-coreweave, @steeling, @sschne, @Jacob Colvin, @Richard Holmes, @Christopher Haar, @Yvan da Silva, @Uladzislau Maher, @Sergey Ryabin, @Lukáš Kubín, @Alexander Fuchs, @Divyansh Choukse, @Vishalk91-4, @DavidChevallier, @dennybaa, @bozaro, @vietanhtwdk, @hoangndst, @patpicos, @metacoma, @karlderkaefer, @kukacz, @Matthew Hodgkins, @Gao Jun, @Zack Zhang, @briheet, @Moulick, @stmcginnis, @Manoramsharma, @NishantBansal2003, @varshith257, @Harsh4902, @Gmin2, @shishir-11, @RehanChalana, @Shruti78, @jianzs, @vinayakjaas, @ChrisK, @Lan Liang, @Endre Karlson, @suin, @v3xro, @soubinan, @juanzolotoochin, @mnacharov, @ron1, @vfarcic, @phisco, @juanique, @zackzhangverkada, @warmuuh, @novohool, @officialasishkumar, @cx2c, @yonas, @shruti2522, @nwmcsween, @trogowski, @johnallen3d, @riven-blade, @gesmit74, @prakhar479, @Peter Boat, @Stéphane Este-Gracias, @Josh West, @Brandon Nason, @Anany, @dansrogers, @diefans, @DrummyFloyd_

## 📚 重点更新内容

### 🔧 核心功能

#### 语言

- 赋值语句中被赋值对象支持属性访问和索引访问。

现在，你可以通过**索引访问**的方式对被赋值对象的内容进行更改。

```kcl
_a = [0, 1] * 2
_a[0] = 2
_a[1] += 2
a = _a
```

通过编译，你将可以得到如下结果

```kcl
a:
- 2
- 3
- 0
- 1
```

你也可以通过**属性访问**的方式对被赋值对象的内容进行更改。

```kcl
_a = [{key1.key2 = [0] * 2}, {key3.key4 = [0] * 2}]
_a[0].key1.key2[0] = 1
_a[1].key3.key4[1] += 1
a = _a
```

通过编译，你可以得到如下结果：

```kcl
a:
- key1:
    key2:
    - 1
    - 0
- key3:
    key4:
    - 0
    - 1
```

- 对类型为单子面值常量 Schema 属性支持省略默认值

```kcl
schema Deployment:
    apiVersion: "apps/v1" = "apps/v1"
```

```kcl
schema Deployment:
    apiVersion: "apps/v1"  # 类型值与默认值相同，可以省略默认值
```

- 修复了 KCL 嵌套多层 config 块语义检查时间过长的问题。
- 去掉了语义解析器中的 unwrap() 语句, 减少 panic 的问题。
- 修复了带有 list index 的字段合并运算的计算错误。
- 修复 as 关键字在外部包存在时类型转换的错误
- 修复在 lambda 函数中 config 到 schema 的类型检查错误
- 优化函数参数调用/返回值 Dict 转 Schema 类型推导和检查，可以省略 Schema 名称简化配置书写
- 赋值语句支持形如 _config["key"] = "value" 或 _config.key = "value"的语法对配置进行原地修改
- 优化配置合并运算符的类型检查，可以在编译时发现更多类型错误
- 修复了 built-in API datetime 中日期格式的问题。
- 修复了 Schema 配置合并参数解析错误的问题。
- 优化了 KCL 部分报错信息。
- KCL 修复了 Schema 继承中循环依赖导致的异常错误。
- KCL 修复了配置自动合并失效的问题。
- KCL 优化了 Schema 继承中循环依赖的错误信息。
- KCL 对编译入口部分代码进行了重构。
- KCL 新增了 windows mingw 环境下链接库的 release。
- KCL 修复了 windows 环境下的 CI 错误。
- 优化了 KCL 运行时错误信息并且新增了部分测试用例。

#### 工具链

- kcl test 测试工具支持测试用例中的 print 函数输出

你可以在测试用例中使用 `print` 输出日志

```kcl
test_print = lambda {
    print("Test Begin ...")
}
```

通过 `kcl test` 命令运行测试用例，你可以看到对应日志：

```kcl
test_print: PASS (9ms)
Test Begin ...

--------------------------------------------------------------------------------
PASS: 1/1
```

- kcl import 工具新增对包含 AllOf 验证字段的 JSON Schema 格式导入为 KCL Schema 的支持

对于如下包含 AllOf 验证字段的 JSON Schema：

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://example.com/schemas/config",
  "description": "Schema for representing a config information.",
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "allOf": [
        {
          "pattern": "198.160"
        },
        {
          "pattern": "198.161"
        },
        {
          "pattern": "198.162"
        }
      ]
    },
    "price": {
      "type": "number",
      "minimum": 0
    }
  },
  "required": [
    "name"
  ]
}
```

将会生成对应 KCL Schema:

```kcl
"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""
import regex

schema Config:
    r"""
    Schema for representing a config information.

    Attributes
    ----------
    name : str, required
    price : float, optional
    """

    name: str
    price?: float

    check:
        regex.match(name, r"198.160")
        regex.match(name, r"198.161")
        regex.match(name, r"198.162")
        price >= 0 if price
```

- 包管理工具支持添加 Git 仓库中子包作为三方库。

通过如下命令，KCL 包管理工具支持添加 git 仓库中的某个子目录下的 KCL Package 作为三方库。

```shell
kcl mod add <package_name> --git <git_url> --commit <commit_id>
```

以 <https://github.com/kcl-lang/flask-demo-kcl-manifests.git> 为例，添加这个仓库中的子目录中名为 cc 的 KCL package 作为依赖：

```shell
kcl mod add cc --git https://github.com/kcl-lang/flask-demo-kcl-manifests.git --commit 8308200
```

- 基于 WASM 后端的 kcl-playground <https://play.kcl-lang.io/> 上线。

[kclplayground](/img/blog/2024-09-18-kcl-0.10.0-release/kclplayground.png)

- kcl import 工具支持导入整个 Go Package 并将其中所有的 Go 结构体定义转换为 KCL Schema 定义
- 修复 kcl import 在 Kubernetes CRD 和 OpenAPI 导入 Schema 的编译错误
- 优化 kcl mod init 的输出格式
- kcl fmt 工具支持保留用户在多个代码片段之间的空行，不会全部删除
- 包管理工具修复了编译入口无法识别包相对路径 ${KCL_MOD} 的问题。
- 包管理工具将 plainHttp 选项调整为可选。
- 包管理工具修复了编译入口识别错误根目录的问题。
- 包管理工具添加登录凭证的缓存，以降低安全风险。
- 包管理工具修复了由于虚拟编译入口导致的编译失败问题。
- 包管理工具修复了默认依赖在 kcl.mod 中的缺失。
- 包管理工具修复了 vendor path 计算错误导致的三方库重新下载的问题。
- 包管理工具修复了 push https 协议 OCI registry 失败的问题。
- 包管理工具修复了多次添加 git 子包作为依赖时导致的循环依赖问题。
- 包管理工具修复了 metadata 中三方库依赖路径丢失的问题。
- 包管理工具 Add, Update 命令预载了 MVS 版本管理算法，通过环境变量 SupportMVS=true 控制开启。
- 包管理工具修复了编译多个 *.k 文件失败的 bug。
- 包管理工具新增部分测试用例。
- KCL tree-sitter 新增 sequence operations, selector 支持。
- KCL tree-sitter 优化了部分语法规则，添加了更多测试用例。
- 修复 kcl fmt 工具对 Schema 索引签名注释错误的格式化位置
- 修复 kcl import 导入 Kubernetes CRD 时设置 -o 参数非预期的报错
- 修复 kcl import 导入空 Go 结构体输出非预期的 KCL Schema 错误
- kcl-openapi 对代码结构和文档结构进行了优化和调整。
- kcl-playground 添加了更多的测试用例，对工程结构体进行了优化和升级。
- krm-kcl function 修复了部分测试和文档中的错误。
- krm-kcl function 修复了依赖下载失败的问题。
- kcl-operator 更新和修复了部分文档内容，优化了部分代码结构。
- kcl-operator 新增部分测试用例，优化了发布流程。
- kcl-operator 新增了初始化容器时的自动鉴权。
- KCL fmt 工具提供了 C api。
- KCL fmt 工具移除了 if 块中多余的空行。

#### IDE

- IDE 新增了对 schema 参数的 hints。

![schemaargshint](/img/blog/2024-09-18-kcl-0.10.0-release/schemaargshint.png)

- 修正了 schema index signature key 的语义高亮。
- 支持使用 kcl.work 配置文件划分 IDE 工作空间
- 修复 Schema 示例化参数无法显示语义信息的问题
- 修复了 IDE 中 schema doc 的错误补全。
- 修复了 IDE 中 unification 块中定义的属性无法自动补全的问题。
- 支持 Schema 实例化时区分属性和值语义的细粒度补全。
- KCL vim 插件更新安装文档。
- KCL vscode 插件移除了 yaml 文件的响应。
- KCL vscode 插件补充了 Apache 2.0 License
- 修复 Schema 使用 : 合并运算符定义属性实例化时的补全
- 修复在 Schema Doc 中非预期的补全
- 修复 kcl-language-server 命令行版本显示问题
- 支持 NeoVim, VS Code 等插件禁用保存时格式化配置
- KCL NeoVim 插件移除默认的 key bindings, 支持用户自定义
- 修复了第一行第一列代码高亮失效的问题。
- 修复了 IDE 偶发死锁的问题。
- IDE 增加了更多输出日志。
- IDE find ref 功能优化。
- IDE 修复了更新 kcl.mod 失效的问题。
- IDE 修复了 find ref 错误。
- IDE 修复了打开文件时代码高亮失败。
- LSP 部分代码结构重构，调整了部分 API 的作用域。
- IDE 修复了 kpm 更新依赖后，IDE 没有同步更新的问题。
- IDE 修复了由循环依赖导致的崩溃。
- IDE 修复了 find reference 在 minin 结构中的错误。
- IDE 修复了 if 表达式中自动补全失效的问题。
- IDE 修复了带有索引签名的 Schema 成员高亮失效的问题。
- KCL intellij IDE 插件支持 LSP4IJ。

#### API

- OverrideFile API 支持使用 : 合并运算符在编译时对配置进行自动合并修改
- 重构了 override_file API 的错误信息。
- 修复 KCL C API 非预期的数据格式化错误。
- Kotlin API 完整测试和用例更新，详见 https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api
- Lua API 产出初步版本，欢迎贡献，详见 https://github.com/kcl-lang/lib/tree/main/lua
- kcl-go API 支持 jsonschema 的导入。
- 新增 kcl_version API 支持 WASM host。

### 📦️ 标准库及三方库

#### 标准库

- 新增 file.current() 函数用以获取当前运行 KCL 文件的全路径。

```kcl
import file

a = file.current()
```

通过编译，你可以得到如下结果：

```kcl
a: /Users/xxx/xxx/main.k # 当前编译的文件路径
```

- 加密标准库新增参数，支持对参数传入参数进行编码。

```kcl
sha512(value: str, encoding: str = "utf-8") -> str
```

- 新增 built-in API crypto.blake3 支持使用 Blake 算法进行哈希加密。

```kcl
import crypto
blake3 = crypto.blake3("ABCDEF")
```

- 新增 built-in API isnullish 支持判断字段是否为空。

```kcl
a = [100, 10, 100]
A = isnullish(a)
e = None
E = isnullish(e)
```

- 新增 built-in API datetime.validate 支持验证日期内容。

```kcl
import datetime
assert datetime.validate("2024-08-26", "%Y-%m-%d")
```

#### 三方库

- cluster-api-provider-azure 更新至 v1.16.0
- cluster-api 更新至 v1.7.4
- konfig 更新至 v0.6.0
- karmada 更新至 v0.1.1
- k8s 更新至 1.31
- gateway-api 更新至 0.2.0
- karpenter 更新至 0.2.0
- crossplane 更新至 1.16.0
- cilium 更新至 0.3.0
- external-secrets 更新至 0.1.2
- 新增模型列表
  - fluxcd-kcl-controller
  - fluxcd-kustomize-controller
  - fluxcd-helm-controller
  - fluxcd-source-controller
  - fluxcd-image-reflector-controller
  - fluxcd-image-automation-controller
  - fluxcd-notification-controller
  - kwok
  - crossplane-provider-vault 1.0.0
  - outdent 0.1.0
  - kcl_lib 0.1.0

### ☸️ 生态集成

- Flux KCL Controller 发布 v0.4.0 版本，对齐绝大部份 Flux Kustomize Controller 功能，满足直接使用 KCL 代替 Kustomize 作 Flux GitOps 的需求
- KRM KCL 规范发布 v0.10.0 beta 版本，新增私有 Git 仓库拉取和忽略 TLS 检查等功能
- KCL Nix Package 发布 v0.9.8 版本
- Crossplane KCL Function 发布 v0.9.4 版本，具体内容详见 https://github.com/crossplane-contrib/function-kcl
- KCL Bazel Rules 更新 KCL v0.10.0 beta 版本，具体内容详见 https://github.com/kcl-lang/rules_kcl
- Flux KCL Controller 传入参数优化, 新增更多的测试用例，更加完整的 release 和测试流程。

### 🧩 多语言 SDK 和插件

#### 多语言 SDK

- KCL Go SDK 支持通过 build tags 区分以 RPC 模式还是 CGO 模式与 KCL 核心 Rust API 进行交互，默认为 CGO 模式，可以通过 -tags rpc 开启 RPC 模式
- 新增 KCL C/C++ 语言 SDK。
- 新增了 Go, Java, Python, Rust, .NET, C/C++ 等多语言 API Spec，相关文档，测试用例和使用案例。
- 代码结构调整，go 相关代码移动的 go 文件目录中。
- 新增 KCL Kotlin 和 Swift 语言初版 SDK，尚未正式发布依赖包，欢迎参与贡献
- 新增 KCL WASM lib 支持 node.js 和 浏览器集成。
- 重构优化了 KCL python/Go/Java 的部分代码。
- KCL WASM SDK 修复了 '\0' 转义符号导致的问题。
- KCL lib 支持跨平台编译。
- KCL WASM SDK 增加部分测试用例。

#### 多语言插件更新

- KCL Plugin 支持通过 Rust 开发。
- 新增部分插件开发测试用例。

### 📖 文档更新

- 新增 Python, Java, Node.js, Rust, WASM, .NET, C/C++ 等多语言 API 文档。
- 更新了 IDE Quick Start 文档。
- 新增博客 A Comparative Overview of Jsonnet and KCL
- 更新文档 Adapt From Kubernetes中的 crd 资源。
- 新增了 KCL 在 kubecon 2024 的回顾文章。
- 文档中增加了新增 built-in API 相关的文档。
- 调整了文档中包管理工具与 OCI registry 和 Git Repo 部分集成的文档。
- 新增了文档中关于 kcl.mod include 和 exclude 字段的描述。
- 新增了关于 docker-credential-desktop not found 的解决方案。
- 新增了 konfig 库部分资源的参考文档。
- 新增了关于 KCL WASM 相关的 API 文档。
- 新增了关于 Rust 开发 KCL 插件相关的 API。
- 新增了关于 mixin 和 protocol 相关的 FAQ 文档。
- 修复了部分文档错误。

## 🌐 其他资源

🔥 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们 🔥

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
