---
slug: 2024-07-05-kcl-0.9.0-release
title: KCL v0.9.0 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## Introduction

The KCL team is pleased to announce that **KCL v0.9.0 is now available**! This release has brought three key updates to everyone

- _Enhance the coding experience and efficiency with a more performant, feature-rich, and less error-prone KCL language, toolchain, and IDE._
- _A more comprehensive and diverse set of standard libraries, third-party libraries, and community ecosystem integrations, covering different application scenarios and requirements._
- _Richer multi-language SDKs and plugins, seamlessly integrating with different programming languages and development environments._

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF). KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

## ❤️ Special Thanks

**We would like to extend our heartfelt thanks to all 120 community contributors who participated in the iteration from version v0.8 to v0.9 over the past 120 days. The following list is in no particular order.**

_@Shashank Mittal, @MattHodge, @officialasishkumar, @Gmin2, @Akash Kumar, @sfshumaker, @sanzoghenzo, @MOHAMED FAWAS, @bradkwadsworth-mw, @excalq, @Daksh-10, @metacoma, @Wes McNamee, @Stéphane Este-Gracias, @octonawish-akcodes, @zong-zhe, @shashank-iitbhu, @NAVRockClimber, @AkashKumar7902, @Petrosz007, @patrycju, @Korada Vishal, @selfuryon, @tvandinther, @vtomilov, @Peefy, @taylormonacelli, @Tertium, @Stefano Borrelli, @Bishal, @kukacz, @borgius, @steeling, @jheyduk, @HStéphane Este-Gracias, @userxiaosi, @folliehiyuki, @kubernegit, @nizq, @Alexander Fuchs, @ihor-hrytskiv, @Mohamed Asif, @reedjosh, @Wck-iipi, @evensolberg, @aldoborrero@ron18219, @rodrigoalvamat, @mproffitt, @karlhepler, @shruti2522, @leon-andria, @prahaladramji, @Even Solberg, @utnim2, @warjiang, @Asish Kumar, @He1pa, @Emmanuel Alap, @d4v1d03, @Yvan da Silva, @Abhishek, @DavidChevallier, @zargor, @Kim Sondrup, @SamirMarin, @Hai Wu, @MatisseB, @beholdenkey, @nestoralonso, @HAkash Kumar, @olinux, @liangyuanpeng, @ngergs, @Penguin, @ealap, @markphillips100, @Henri Williams, @eshepelyuk, @CC007, @mintu, @M Slane, @zhuxw, @atelsier, @aleeriz, @LinYunling, @YvanDaSilva, @chai2010, @Sergey Ryabin, @vfarcic, @vemoo, @riven-blade, @ibishal, @empath-nirvana, @bozaro, @jgascon-nx, @reckless-huang, @Sergei Iakovlev, @Blarc, @JeevaRamanathan, @dennybaa, @PrettySolution, @east4ming, @nkabir, @sestegra, @XiaoK29, @ricochet1k, @yjsnly, @umaher, @SjuulJanssen, @wilsonwang371, @Lukáš Kubín, @samuel-deal-tisseo, @blakebarnett, @Uladzislau Maher, @ytsarev, @Vishalk91-4, @Stephen C, @Tom van Dinther, @MrGuoRanDuo, @dopesickjam_

## 📚 Key Updates

### ⚡️ Performance Enhancements

#### Runtime Performance

In the new KCL v0.9 release, a new fast runtime mode has been introduced. This can be enabled by setting the `KCL_FAST_EVAL=1` environment variable, which improves startup and runtime performance. For configurations using Schema (such as the `k8s` third-party library), this offers approximately a **3x** performance boost compared to previous versions. For simple configurations without Schema, output YAML performance has been tested to surpass tools like `helm template` and `kustomize build` that use YAML and Go Templates.

#### IDE Performance

KCL IDE has further optimized incremental compilation and performance for semantic analysis in large projects. For KCL projects with around 400 files, the end-to-end response time has been reduced to **20%** of the previous version.

### 🔧 Core Features

#### Language

- String interpolation now supports escaping with `\${}` similar to Shell to cancel interpolation.

```python
world = "world"
hello_world_0 = "hello ${world}"  # hello world
hello_world_1 = "hello \${world}" # hello ${world}
```

- Added schema type support to the `typeof` function for distinguishing schema types from instances.

```python
schema Foo:
    bar?: str

foo = Foo {}
type_schema = typeof(foo) # schema
type_type = typeof(Foo) # type
```

- Added a `full_pkg` keyword argument to the `instances()` method of Schema to read instances of the corresponding schema from all code.

```python
schema Person:
    name: str

alice = Person {name = "Alice"}
all_persons = Person.instances(True)
```

- Removed implicit comparison between bool and int types `0 < True`.
- Removed comparison features for the list type `[0] < [1]`.
- Added type assertion failure functionality to the `as` keyword.
- Optimized closure variable capture logic of `lambda` functions and configuration code blocks `{}` in different scopes to be more intuitive.

#### Toolchain

- `kcl run` now supports outputting configurations in TOML format with the `--format` toml option.
- `kcl mod add` now supports adding dependencies from private third-party OCI Registries and Git repositories with the `--oci` and `--git` options.
- `kcl import` now supports importing entire Go Packages as KCL Schemas.
- `kcl import` now supports importing files with YAML stream format (`---`).
- `kcl import` now supports importing TOML files as KCL configurations.
- `kcl clean` now supports cleaning external dependencies and compile caches.
- `kcl mod init` now supports setting the version of a new KCL module with the `--version` tag.
- Commands like `kcl run`, `kcl mod add`, and `kcl mod pull` now support accessing private repositories via local Git.

#### IDE

- Supports multiple quick fix options.
- Syntax highlighting for `kcl.mod` and `kcl.mod.lock` files.
- Partial syntax hover highlighting in the IDE.
- `import` completion for external dependencies.
- Function symbol highlighting and Inlay Hints displaying default variable types.

![inlayhint](/img/blog/2024-07-05-kcl-0.9.0-release/inlayhint.png)

#### API

- The Override API now supports setting different attribute operators (`:`, `=`, and `+=`) for configuration overrides.
- Go API now supports prototext format and KCL schema output as KCL configurations.
- Go API now supports serializing any Go Type and Go Value to KCL Schema and configurations.

### 📦️ Standard Libraries and Third-Party Libraries

#### Standard Libraries

- Added the `file` standard library for file IO operations, such as reading configurations from YAML and performing configuration merges.

```python
import file
import yaml
import json_merge_patch as p

config = p.merge(yaml.decode(file.read("deployment.yaml")), {
    metadata.name = "override_value"
})
```

For more functions in the `file` module, see: [https://www.kcl-lang.io/docs/reference/model/file](https://www.kcl-lang.io/docs/reference/model/file)

- Added the `template` standard library for writing template configurations.

```python
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

- Added the `runtime` standard library for capturing runtime exceptions, useful for `kcl test` tool to test exception cases.

```python
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

#### Third-Party Libraries

The number of KCL models has increased to **313**, including major updates as follows:

- `k8s` released version 1.30
- `argo-cd` released version 0.1.1
- `argo-workflow` released version 0.0.3
- `istio` released version 1.21.2
- `victoria-metrics-operator` released version 0.45.1
- `cert-manager` released version 0.1.2
- `cilium` released version 0.1.1
- `Longhorn` released version 0.0.1
- `jsonpatch` released version 0.0.5, supporting rfc6901Decode
- Added a new third-party library `difflib` for comparing configuration differences
- Added `argo-cd-order` for sorting argocd sync operation resource order
- Added models for `cluster-api`, including `cluster-api`, `cluster-api-provider-metal3`, `cluster-api-provider-gcp`, `cluster-api-addon-provider-helm`, `cluster-api-addon-provider-aws`, `cluster-api-provider-azure`, and more

### ☸️ Ecosystem Integration

- Fixed concurrency issue in Argo KCL plugin causing Sync errors.
- Releasing Flux KCL Controller [https://github.com/kcl-lang/flux-kcl-controller](https://github.com/kcl-lang/flux-kcl-controller), currently supporting GitOps with OCI and Git configurations.
- KCL officially integrated into Crossplane Functions Marketplace, releasing v0.9.0 [https://github.com/crossplane-contrib/function-kcl](https://github.com/crossplane-contrib/function-kcl).

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

Additionally, you can find more real use cases of KCL with other ecosystem projects here:

- [https://github.com/mindwm/mindwm-gitops](https://github.com/mindwm/mindwm-gitops)
- [https://github.com/vfarcic/crossplane-kubernetes](https://github.com/vfarcic/crossplane-kubernetes)
- [https://github.com/giantswarm/crossplane-gs-apis/blob/main/crossplane.giantswarm.io/xnetworks/package/compositions/peered-vpc-network.yaml](https://github.com/giantswarm/crossplane-gs-apis/blob/main/crossplane.giantswarm.io/xnetworks/package/compositions/peered-vpc-network.yaml)
- [https://github.com/upbound/configuration-aws-eks/blob/main/apis/composition-kcl.yaml](https://github.com/upbound/configuration-aws-eks/blob/main/apis/composition-kcl.yaml)

### 🧩 Multi-Language SDKs and Plugins

#### Multi-Language SDKs

The number of KCL multi-language SDKs has increased to **7**, currently supporting Rust, Go, Java, .NET, Python, Node.js, and WASM. These can be used without installing additional KCL command-line tools, optimizing the installation size to **90%** of previous versions and removing the need for complex system dependencies. Furthermore, each SDK provides the same APIs for code execution, code analysis, type parsing, and adding external dependencies. Here are some examples with the Java and C# SDKs:

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

For more information on installing and using other SDKs, see [https://github.com/kcl-lang/lib](https://github.com/kcl-lang/lib)

#### Multi-Language Plugins

The number of KCL multi-language plugins has increased to **3**, currently supporting Go, Python, and Java. Only basic SDK dependencies are required to achieve seamless interoperation between common languages and KCL. Here are some examples with Python and Java plugins:

Write the following KCL code (main.k)

```python
import kcl_plugin.my_plugin

result = my_plugin.add(1, 1)
```

Use the Python SDK to register a Python function for calling in KCL

```python
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

Use the Java SDK to register a Java function for calling in KCL

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

For more examples of using other multi-language plugins, see [https://www.kcl-lang.io/docs/reference/plugin/overview](https://www.kcl-lang.io/docs/reference/plugin/overview)

Additionally, you can find more real use cases of KCL multi-language plugins here:

- [https://github.com/cakehappens/kcfoil/blob/main/cmd/kcf/template.go](https://github.com/cakehappens/kcfoil/blob/main/cmd/kcf/template.go)

## 🌐 Other Resources

🔥 Check out the [KCL Community](https://github.com/kcl-lang/community) and join us 🔥

For more resources, refer to:

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
