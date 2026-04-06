---
slug: 2024-07-05-kcl-0.9.0-release
title: KCL v0.9.0 重磅发布 - 小体积，高性能，更丰富的生态集成
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## 简介

KCL 团队很高兴地宣布 **KCL v0.9.0 新版本现在已经可用**！本次发布为大家带来了三方面的重点更新

- _使用性能更好、功能更完善和错误更少的 KCL 语言、工具链和 IDE 提升代码编写体验和效率_
- _更加全面丰富的标准库、三方库以及社区生态集成，涵盖不同应用场景和需求_
- _更丰富的多语言 SDK 和插件，无缝地集成不同编程语言和开发环境_

[KCL](https://github.com/kcl-lang) 是一个 CNCF 基金会托管的基于约束的记录及函数语言，期望通过成熟的编程语言技术和实践来改进对大量繁杂配置比如云原生 Kubernetes 配置场景的编写，致力于构建围绕配置的更好的模块化、扩展性和稳定性，更简单的逻辑编写，以及更简单的自动化和生态工具集成。

## ❤️ 特别鸣谢

**感谢 KCL 在 v0.8 - v0.9 版本迭代过去 120 天中所有 120 位社区参与者，以下排名不分先后**

_@Shashank Mittal, @MattHodge, @officialasishkumar, @Gmin2, @Akash Kumar, @sfshumaker, @sanzoghenzo, @MOHAMED FAWAS, @bradkwadsworth-mw, @excalq, @Daksh-10, @metacoma, @Wes McNamee, @Stéphane Este-Gracias, @octonawish-akcodes, @zong-zhe, @shashank-iitbhu, @NAVRockClimber, @AkashKumar7902, @Petrosz007, @patrycju, @Korada Vishal, @selfuryon, @tvandinther, @vtomilov, @Peefy, @taylormonacelli, @Tertium, @Stefano Borrelli, @Bishal, @kukacz, @borgius, @steeling, @jheyduk, @HStéphane Este-Gracias, @userxiaosi, @folliehiyuki, @kubernegit, @nizq, @Alexander Fuchs, @ihor-hrytskiv, @Mohamed Asif, @reedjosh, @Wck-iipi, @evensolberg, @aldoborrero@ron18219, @rodrigoalvamat, @mproffitt, @karlhepler, @shruti2522, @leon-andria, @prahaladramji, @Even Solberg, @utnim2, @warjiang, @Asish Kumar, @He1pa, @Emmanuel Alap, @d4v1d03, @Yvan da Silva, @Abhishek, @DavidChevallier, @zargor, @Kim Sondrup, @SamirMarin, @Hai Wu, @MatisseB, @beholdenkey, @nestoralonso, @HAkash Kumar, @olinux, @liangyuanpeng, @ngergs, @Penguin, @ealap, @markphillips100, @Henri Williams, @eshepelyuk, @CC007, @mintu, @M Slane, @zhuxw, @atelsier, @aleeriz, @LinYunling, @YvanDaSilva, @chai2010, @Sergey Ryabin, @vfarcic, @vemoo, @riven-blade, @ibishal, @empath-nirvana, @bozaro, @jgascon-nx, @reckless-huang, @Sergei Iakovlev, @Blarc, @JeevaRamanathan, @dennybaa, @PrettySolution, @east4ming, @nkabir, @sestegra, @XiaoK29, @ricochet1k, @yjsnly, @umaher, @SjuulJanssen, @wilsonwang371, @Lukáš Kubín, @samuel-deal-tisseo, @blakebarnett, @Uladzislau Maher, @ytsarev, @Vishalk91-4, @Stephen C, @Tom van Dinther, @MrGuoRanDuo, @dopesickjam_

## 📚 重点更新内容

### ⚡️ 性能提升

#### 运行性能

在 KCL v0.9 新版本中，引入了一个新的快速运行模式，可以通过设置 `KCL_FAST_EVAL=1` 环境变量开启，从而提升启动速度和运行时性能。

对于使用 Schema 的配置（比如 `k8s` 三方库），相比于之前的版本可以获得 **3 倍**左右的性能提升。对于简单的不使用 Schema 的配置，输出 YAML 性能经测试超过 `helm template` 和 `kustomize build` 等使用 YAML 和 Go Template 的工具。

#### IDE 性能

KCL IDE 在大型项目上针对语义分析部分进行了进一步的增量编译和性能优化，对于 400 个文件左右的 KCL 项目, IDE 端到端响应时间可以减小为之前版本的 **20%**。

### 🔧 核心功能

#### 语言

- 字符串插值支持类似 Shell 的 `\${}` 转义功能取消插值

```kcl
world = "world"
hello_world_0 = "hello ${world}"  # hello world
hello_world_1 = "hello \${world}" # hello ${world}
```

- `typeof` 函数新增 Schema 类型的支持用于区分 schema 类型和实例

```kcl
schema Foo:
    bar?: str

foo = Foo {}
type_schema = typeof(foo) # schema
type_type = typeof(Foo) # type
```

- Schema 的 `instances()` 方法新增关键字参数 `full_pkg` 参数用于读取所有代码中对应 Schema 的实例

```kcl
schema Person:
    name: str

alice = Person {name = "Alice"}
all_persons = Person.instances(True)
```

- 去除 bool 类型和 int 类型隐式比较的功能 `0 < True`
- 去除 list 类型的比较功能 `[0] < [1]`
- `as` 关键字增加类型断言失败功能
- 优化 `lambda` 函数和配置代码块 `{}` 在不同作用域的闭包变量捕获逻辑，更符合直觉

#### 工具链

- `kcl run` 支持使用 `--format toml` 输出 TOML 格式的配置
- `kcl mod add` 支持使用 `--oci` 和 `--git` 添加私有三方 OCI Registry 和 Git 仓库的依赖
- `kcl import` 支持从整个 Go Package 导入为 KCL Schema
- `kcl import` 支持导入带 YAML Stream `---` 格式的文件
- `kcl import` 支持从 TOML 文件导入为 KCL 配置
- `kcl clean` 支持清理外部依赖和编译缓存
- `kcl mod init` 支持 `--version` 标签设置 KCL 新建模块的版本

* `kcl run`, `kcl mod add` 和 `kcl mod pull` 等命令支持通过本地 Git 对私有仓库进行访问

#### IDE

- 支持多个 Quick Fix 修复选项
- 支持 `kcl.mod` 和 `kcl.mod.lock` 文件的高亮
- IDE 支持部分语法悬停高亮
- 支持 `import` 对外部依赖的补全
- 支持函数符号的高亮和 Inlay Hints 显示缺省的变量类型

![inlayhint](/img/blog/2024-07-05-kcl-0.9.0-release/inlayhint.png)

#### API

- Override API 支持设置配置覆盖时使用不同的属性运算符 `:`, `=` 和 `+=`
- Go API 支持 prototext 格式和 KCL schema 输出为 KCL 配置
- Go API 支持任意 Go Type 和 Go Value 序列化为 KCL Schema 和配置

### 📦️ 标准库及三方库

#### 标准库

- 新增标准库 `file` 用于文件 IO 操作，比如从 YAML 读取配置并进行配置合并操作

```kcl
import file
import yaml
import json_merge_patch as p

config = p.merge(yaml.decode(file.read("deployment.yaml")), {
    metadata.name = "override_value"
})
```

其他更多 file 模块函数详见：https://www.kcl-lang.io/docs/reference/model/file

- 新增标准库 `template` 用于模版配置编写

```kcl
import template

_data = {
    name = "handlebars",
    v = [ { a = 1 }, { a = 2 } ],
    c = { d = 5 },
    g = { b = [ { aa = { bb = 55} }, { aa = { bb = 66} } ] },
    people = [ "Yehuda Katz", "Alan Johnson", "Charles Jolley" ]
}

content = template.execute("""\
Hello world from {{name}}

{{#each v}}
{{this.a}}
{{/each}}
{{ c.d }}
{{#each people}}
{{ this }}
{{/each}}
{{#each g.b}}
{{this.aa.bb}}
{{/each}}
""", _data)
```

- 新增标准库 `runtime` 可以用于捕获运行时异常，并用于 `kcl test` 工具测试异常用例

```kcl
import runtime

schema Person:
    name: str
    age: int

    check:
        0 <= age <= 120, "age must be in [1, 120], got ${age}"

test_person_check_error = lambda {
    assert runtime.catch(lambda {
        p = Person {name = "Alice", age: -1}
    }) == "age must be in [1, 120], got -1"
}
```

#### 三方库

KCL 模型数量新增至 **313 个**, 主要包含如下更新:

- `k8s` 发布 1.30 版本
- `argo-cd` 发布 0.1.1 版本
- `argo-workflow` 0.0.3 版本
- `istio` 发布 1.21.2 版本
- `victoria-metrics-operator` 发布 0.45.1 版本
- `cert-manager` 发布 0.1.2 版本
- `cilium` 发布 0.1.1 版本
- `Longhorn` 发布 0.0.1 版本
- `jsonpatch` 发布 0.0.5 版本，支持 rfc6901Decode
- 新增 `difflib` 三方库，支持比较配置差异
- 新增 `argo-cd-order` 用于排序 `argocd` 同步操作的资源顺序
- 新增 `cluster-api` 相关的模型库：包括 `cluster-api`, `cluster-api-provider-metal3`, `cluster-api-provider-gcp`, `cluster-api-addon-provider-helm`, `cluster-api-addon-provider-aws`, `cluster-api-provider-azure` 等

### ☸️ 生态集成

- 修复 Argo KCL 插件并发 Sync 报错的问题
- Flux KCL Controller 发布 [https://github.com/kcl-lang/flux-kcl-controller](https://github.com/kcl-lang/flux-kcl-controller)，目前支持 OCI 和 Git 配置进行 GitOps
- KCL 正式登陆 Crossplane 函数市场并发布 v0.9.0 版本 [https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl)

```yaml
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: example
spec:
  compositeTypeRef:
    apiVersion: example.crossplane.io/v1beta1
    kind: XR
  mode: Pipeline
  pipeline:
    - step: basic
      functionRef:
        name: function-kcl
      input:
        apiVersion: krm.kcl.dev/v1alpha1
        kind: KCLInput
        source: |
          # Read the XR
          oxr = option("params").oxr
          # Patch the XR with the status field
          dxr = oxr | {
              status.dummy = "cool-status"
          }
          # Construct a AWS bucket
          bucket = {
              apiVersion = "s3.aws.upbound.io/v1beta1"
              kind = "Bucket"
              metadata.annotations: {
                  "krm.kcl.dev/composition-resource-name" = "bucket"
              }
              spec.forProvider.region = option("oxr").spec.region
          }
          # Return the bucket and patched XR
          items = [bucket, dxr]
    - step: automatically-detect-ready-composed-resources
      functionRef:
        name: function-auto-ready
```

此外，可以在这里找到更多的关于 KCL 和其他生态项目一起使用的真实用例

- [https://github.com/mindwm/mindwm-gitops](https://github.com/mindwm/mindwm-gitops)
- [https://github.com/vfarcic/crossplane-kubernetes](https://github.com/vfarcic/crossplane-kubernetes)
- [https://github.com/giantswarm/crossplane-gs-apis/blob/main/crossplane.giantswarm.io/xnetworks/package/compositions/peered-vpc-network.yaml](https://github.com/giantswarm/crossplane-gs-apis/blob/main/crossplane.giantswarm.io/xnetworks/package/compositions/peered-vpc-network.yaml)
- [https://github.com/upbound/configuration-aws-eks/blob/main/apis/composition-kcl.yaml](https://github.com/upbound/configuration-aws-eks/blob/main/apis/composition-kcl.yaml)

### 🧩 多语言 SDK 和插件

#### 多语言 SDK

KCL 多语言 SDK 新增至 **7 个**, 目前主要支持 Rust, Go, Java, .NET, Python, Node.js 和 WASM，无需额外安装 KCL 命令行即可使用，安装体积优化为之前版本的 **90%**，且不需要复杂的系统依赖。

此外，不同的 SDK 均提供了相同的 API，主要包括代码运行，代码分析，类型解析和添加外部依赖等操作，下面以 Java 和 C# SDK 为例

- Java

```java
import com.kcl.api.API;
import com.kcl.api.Spec.ExecProgram_Args;
import com.kcl.api.Spec.ExecProgram_Result;

public class ExecProgramTest {
    public static void main(String[] args) throws Exception {
        API api = new API();
        ExecProgram_Result result = api
                .execProgram(ExecProgram_Args.newBuilder().addKFilenameList("path/to/kcl.k").build());
        System.out.println(result.getYamlResult());
    }
}
```

- C#

```csharp
namespace KclLib.Tests;

using KclLib.API;

public class KclLibAPITest
{
    public static void Main()
    {
        var execArgs = new ExecProgram_Args();
        execArgs.KFilenameList.Add("path/to/kcl.k");
        var result = new API().ExecProgram(execArgs);
        Console.WriteLine(result.YamlResult);
    }
}
```

更多其他 SDK 安装和使用方式详见：[https://github.com/kcl-lang/lib](https://github.com/kcl-lang/lib)

#### 多语言插件更新

KCL 多语言插件新增至 **3 个**，目前主要支持 Go, Python 和 Java, 仅需要基础的 SDK 依赖，可以实现通用语言和 KCL 的无缝互操作，下面以 Python 和 Java 插件为例

编写如下 KCL 代码 (main.k)

```kcl
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```

使用 Python SDK 注册 Python 函数实现在 KCL 中调用

```kcl
import kcl_lib.plugin as plugin
import kcl_lib.api as api

plugin.register_plugin("my_plugin", {"add": lambda x, y: x + y})

def main():
    result = api.API().exec_program(
        api.ExecProgram_Args(k_filename_list=["main.k"])
    )
    assert result.yaml_result == "result: 2"

main()
```

使用 Java SDK 注册 Java 函数实现在 KCL 中调用

```java
package com.kcl;

import com.kcl.api.API;
import com.kcl.api.Spec.ExecProgram_Args;
import com.kcl.api.Spec.ExecProgram_Result;

import java.util.Collections;

public class PluginTest {
    public static void main(String[] mainArgs) throws Exception {
        API.registerPlugin("my_plugin", Collections.singletonMap("add", (args, kwArgs) -> {
            return (int) args[0] + (int) args[1];
        }));
        ExecProgram_Result result = new API()
                .execProgram(ExecProgram_Args.newBuilder().addKFilenameList("main.k").build());
        System.out.println(result.getYamlResult());
    }
}
```

更多其他多语言插件使用方式详见：[https://www.kcl-lang.io/docs/reference/plugin/overview](https://www.kcl-lang.io/docs/reference/plugin/overview)

此外，可以在这里找到更多的关于 KCL 多语言插件使用的真实用例

- [https://github.com/cakehappens/kcfoil/blob/main/cmd/kcf/template.go](https://github.com/cakehappens/kcfoil/blob/main/cmd/kcf/template.go)

## 🌐 其他资源

🔥 查看 _[KCL 社区](https://github.com/kcl-lang/community)_ 加入我们 🔥

更多其他资源请参考：

- [KCL 网站](https://kcl-lang.io/)
- [KusionStack 网站](https://kusionstack.io/)
