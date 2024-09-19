---
slug: 2024-09-18-kcl-0.10.0-release
title: KCL v0.10.0 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## Introduction

The KCL team is pleased to announce that **KCL v0.10.0 is now available**! This release has brought three key updates to everyone

- _Enhance the coding experience and efficiency with a more performant, feature-rich, and less error-prone KCL language, toolchain, and IDE._
- _A more comprehensive and diverse set of standard libraries, third-party libraries, and community ecosystem integrations, covering different application scenarios and requirements._
- The WASM SDK supports browser running and the new KCL Playground._

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF). KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

## ❤️ Special Thanks

**We would like to extend our heartfelt thanks to all 80 community contributors who participated in the iteration from version v0.9 to v0.10. The following list is in no particular order.**

_@eshepelyuk, @haarchri, @liangyuanpeng, @logo749, @bilalba, @borgius, @patrick-hermann-sva, @ovk, @east4ming, @wmcnamee-coreweave, @steeling, @sschne, @Jacob Colvin, @Richard Holmes, @Christopher Haar, @Yvan da Silva, @Uladzislau Maher, @Sergey Ryabin, @Lukáš Kubín, @Alexander Fuchs, @Divyansh Choukse, @Vishalk91-4, @DavidChevallier, @dennybaa, @bozaro, @vietanhtwdk, @hoangndst, @patpicos, @metacoma, @karlderkaefer, @kukacz, @Matthew Hodgkins, @Gao Jun, @Zack Zhang, @briheet, @Moulick, @stmcginnis, @Manoramsharma, @NishantBansal2003, @varshith257, @Harsh4902, @Gmin2, @shishir-11, @RehanChalana, @Shruti78, @jianzs, @vinayakjaas, @ChrisK, @Lan Liang, @Endre Karlson, @suin, @v3xro, @soubinan, @juanzolotoochin, @mnacharov, @ron1, @vfarcic, @phisco, @juanique, @zackzhangverkada, @warmuuh, @novohool, @officialasishkumar, @cx2c, @yonas, @shruti2522, @nwmcsween, @trogowski, @johnallen3d, @riven-blade, @gesmit74, @prakhar479, @Peter Boat, @Stéphane Este-Gracias, @Josh West, @Brandon Nason, @Anany, @dansrogers, @diefans, @DrummyFloyd_

## 📚 Key Updates

### 🔧 Core Features

#### Language

- Supports both **attribute access** and **index access** in assignment statements.

Now you can change the content of the assigned object through **index access**.

```kcl
_a = [0, 1] * 2
_a[0] = 2
_a[1] += 2
a = _a
```

After compilation, you will get the following result

```kcl
a:
- 2
- 3
- 0
- 1
```

Or you can change the content of the assigned object through **attribute access**.

```kcl
_a = [{key1.key2 = [0] * 2}, {key3.key4 = [0] * 2}]
_a[0].key1.key2[0] = 1
_a[1].key3.key4[1] += 1
a = _a
```

After compilation, you will get the following result:

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

- For single constant schema properties, the default value can be omitted.

```kcl
schema Deployment:
    apiVersion: "apps/v1" = "apps/v1"
```

```kcl
schema Deployment:
    apiVersion: "apps/v1"  # "apps/v1" is the default value
```

- Fixed the issue of semantic check time being too long when nesting multiple config blocks in KCL.
- Removed the `unwrap()` statement in the semantic parser to reduce panic issues.
- Fixed the calculation error of the field merge operation with a list index.
- Fixed the type conversion error when the `as` keyword exists in an external package.
- Fixed the type check error when the `config` is converted to the `schema` in a lambda function.
- Optimized the type inference and check of the `Dict` return value of the optimization function parameter call, which can omit the schema name to simplify the configuration writing.
- Supported the syntax of `_config["key"] = "value"` or `_config.key = "value"` to modify the configuration in place in the assignment statement.
- Optimized the type check of the configuration merge operator, which can find more type errors at compile time.
- Fixed the issue of the `datetime` date format in the built-in API.
- Fixed the Schema configuration merge parameter parsing error.
- Optimized the error message.
- Fixed the unexpected error caused by the circular dependency in the Schema inheritance.
- Fixed the issue of the automatic merge of the configuration being invalid.
- KCL optimized the error message of the circular dependency in the Schema inheritance.
- KCL refactored the code in the compilation entry.
- KCL added the release of the library under the windows mingw environment.
- KCL fixed the CI error in the windows environment.
- Optimized the KCL runtime error message and added some test cases.

#### Toolchain

- Added the `kcl test` tool to support the `print` function output in test cases.

You can use the `print` function to output logs in test cases.

```kcl
test_print = lambda {
    print("Test Begin ...")
}
```

By running the `kcl test` command to run the test case, you can see the corresponding log:

```kcl
test_print: PASS (9ms)
Test Begin ...

--------------------------------------------------------------------------------
PASS: 1/1
```

- kcl import tool supports importing JSON Schema with AllOf validation fields into KCL Schema.

For JSON Schema containing AllOf validation fields:

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

It will generate the corresponding KCL Schema:

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

- KCL package management tool supports adding a KCL package from a Git repository subdirectory as a third-party library.

By the following command, the KCL package management tool supports adding a KCL package from a Git repository subdirectory as a third-party library.

```shell
kcl mod add <package_name> --git <git_url> --commit <commit_id>
```

Taking <https://github.com/kcl-lang/flask-demo-kcl-manifests.git> as an example, add the KCL package named `cc` in the subdirectory of this repository as a dependency:

```shell
kcl mod add cc --git https://github.com/kcl-lang/flask-demo-kcl-manifests.git --commit 8308200
```

- The kcl-playground based on the WASM backend is online.

![kclplayground](/img/blog/2024-09-18-kcl-0.10.0-release/kclplayground.png)

- kcl import tool supports importing the entire Go Package and converting all Go struct definitions into KCL Schema definitions.
- Fixed the compilation error of kcl import when importing Kubernetes CRD and OpenAPI Schema.
- Optimized the output format of `kcl mod init`.
- `kcl fmt` tool supports retaining the blank lines between multiple code snippets, which will not delete all of them.
- Fixed the issue of the package management tool not recognizing the package relative path `${KCL_MOD}` in the compilation entry.
- The package management tool adjusts the plainHttp option to be optional.
- The package management tool fixes the compilation entry recognition error caused by the wrong root directory.
- The package management tool adds a cache for login credentials to reduce security risks.
- The package management tool fixes the compilation failure caused by the virtual compilation entry.
- The package management tool fixes the missing default dependencies in the kcl.mod.
- The package management tool fixes the calculation error of the vendor path, which causes the third-party library to be re-downloaded.
- The package management tool fixes the failure to push the OCI registry with the https protocol.
- The package management tool fixes the compilation failure when compiling multiple *.k files.
- The package management added more test cases.
- The package management tool fixed the circular dependency issue caused by adding the git subpackage multiple times as a dependency.
- The package management tool fixed the missing dependencies path when use the `kcl mod metadata` command.
- The package management tool preloads the MVS version management algorithm in the Add, Update command, controlled by the environment variable SupportMVS=true.
- KCL tree-sitter adds sequence operations and selector support.
- KCL tree-sitter optimizes some syntax rules and adds more test cases.
- Fixed the issue of the kcl fmt tool formatting the Schema index signature comment error.
- Fixed the issue of kcl import importing the Kubernetes CRD setting the -o parameter to an unexpected error.
- Fixed the issue of kcl import importing an empty Go struct outputting an unexpected KCL Schema error.
- Optimized the code structure and document structure of kcl-openapi.
- Added more test cases and optimized the code structure of kcl-playground.
- krm-kcl function fixed some errors in the tests and documents.
- krm-kcl function fixed the issue of dependency download failure.
- kcl-operator updated and fixed some document content, optimized some code structures.
- kcl-operator added some test cases and optimized the release process.
- kcl-operator added automatic authentication when initializing containers.
- kcl fmt tool provides C API.
- kcl fmt tool removes redundant blank lines in if blocks.

#### IDE

- The IDE adds hints for the schema parameter.

![schemaargshint](/img/blog/2024-09-18-kcl-0.10.0-release/schemaargshint.png)

- Fixed the semantic highlighting of the schema index signature key.
- Supported the use of the kcl.work configuration file to divide the IDE workspace.
- Fixed the issue of the IDE not recognizing the schema instantiation parameters.
- Fixed auto-complete errors in the IDE schema doc.
- Fixed the issue of auto-complete failure in the IDE unification attributes.
- Supported the fine-grained completion of distinguishing attribute and value semantics when instantiating the Schema.
- KCL vim plugin updates the installation document.
- KCL vscode plugin removes the response to yaml files.
- KCL vscode plugin adds Apache 2.0 License.
- Fix the use of ':' in the Schema merge operator definition attribute instantiation completion.
- Fixed the unexpected completion in the Schema Doc.
- Fixed the kcl-language-server command-line version display issue.
- Supported the IDE to disable the save formatting configuration for NeoVim, VS Code, and other plugins.
- Removed the default key bindings of the KCL NeoVim plugin and supported user customization.
- Fixed the code highlighting failure of the first line and first column.
- Fixed the dead lock issue of the IDE.
- IDE adds more output logs.
- IDE optimizes the find ref function.
- IDE fixed the failure when update kcl.mod.
- IDE fixed the failure of finding reference.
- IDE fixed the failure of code highlighting when opening a file.
- LSD restructured some code structures and adjusted some API scopes.
- IDE fixed the issue of the IDE does not synchronize after updating dependencies with kpm.
- IDE fixed the panic caused by circular dependencies.
- IDE fixed the issue of auto-completion failure in the if expression.
- IDE fixed the failure of code highlighting for the Schema member with an index signature.
- KCL intellij IDE plugin supports LSP4IJ.

#### API

- OverrideFile API supports using the `:` merge operator to automatically merge and modify configurations at compile time.
- Refactored the error message of the override_file API.
- Fixed the unexpected data formatting error of the KCL C API.
- Kotlin API complete test and case update, see https://www.kcl-lang.io/docs/reference/xlang-api/kotlin-api
- Lua API the mvs version, welcome to contribute, see https://github.com/kcl-lang/lib/tree/main/lua
- kcl-go API supports importing jsonschema.
- Added kcl_version API support for WASM host.

### 📦️ Standard Libraries and Third-Party Libraries

#### Standard Libraries

- Added the file.current() function to get the full path of the current running KCL file.

```kcl
import file

a = file.current()
```

After compiling, you can get the following result:

```kcl
a: /Users/xxx/xxx/main.k 
```

- KCL added some built-in APIs parameters to support the encoding parameter.

```kcl
sha512(value: str, encoding: str = "utf-8") -> str
```

- KCL has added a new built-in API, crypto.blake3, to support the use of the Blake algorithm for hashing.

```kcl
import crypto
blake3 = crypto.blake3("ABCDEF")
```

- KCL has added a new built-in API, isnullish, to support determining whether a field is empty.

```kcl
a = [100, 10, 100]
A = isnullish(a)
e = None
E = isnullish(e)
```

- KCL has added a new built-in API, datetime.validate, to support validating date content.

```kcl
import datetime
assert datetime.validate("2024-08-26", "%Y-%m-%d")
```

#### Third-Party Libraries

- cluster-api-provider-azure updated to v1.16.0
- cluster-api updated to v1.7.4
- konfig updated to v0.6.0
- karmada updated to v0.1.1
- k8s updated to 1.31
- gateway-api updated to 0.2.0
- karpenter updated to 0.2.0
- crossplane updated to 1.16.0
- cilium updated to 0.3.0
- external-secrets updated to 0.1.2
- The New Module List
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

### ☸️ Ecosystem Integration

- Flux KCL Controller released v0.4.0 version, aligning with most of the Flux Kustomize Controller functions to meet the needs of directly using KCL to replace Kustomize for Flux GitOps.
- KRM KCL Specification released v0.10.0 beta version, adding private Git repository pull and ignore TLS check functions.
- KCL Nix Package released v0.9.8 version.
- Crossplane KCL Function released v0.9.4 version, see https://github.com/crossplane-contrib/function-kcl
- KCL Bazel Rules updated to KCL v0.10.0 beta version, see https://github.com/kcl-lang/rules_kcl
- KCL Flux Controller passed the parameter optimization, added more test cases, and a more complete release and test process.

### 🧩 Multi-Language SDKs and Plugins

#### Multi-Language SDKs

- KCL Go SDK supports interacting with the KCL core Rust API in RPC mode or CGO mode through build tags, with CGO mode enabled by default and RPC mode enabled by -tags rpc.
- New KCL C/C++ language SDK.
- Added Go, Java, Python, Rust, .NET, C/C++ and other multi-language API Specs, related documents, test cases, and use cases.
- Added KCL Kotlin and Swift language SDKs, which have not yet officially released dependency packages. Contributions are welcome.
- Added KCL WASM lib support for node.js and browser integration.
- Refactored and optimized the KCL Python/Go/Java code.
- KCL WASM SDK fixed the issue caused by the '\0' escape character.
- KCL lib supports cross-platform compilation.
- KCL WASM SDK adds some test cases.

#### Multi-Language Plugins

- KCL Plugin supports development through Rust.
- Add more test cases for the KCL Plugin.

### 📖 Documentation Updates

- Added Python, Java, Node.js, Rust, WASM, .NET, C/C++ and other multi-language API documents.
- Updated the IDE Quick Start document.
- New Blog "A Comparative Overview of Jsonnet and KCL".
- Updated the crd in "Adapt From Kubernetes CRD Resources" in the documentation.
- Added the KCL review article at kubecon 2024.
- Added the document for built-in API.
- Added the document for the integration of the package management tool with OCI registry and Git Repo.
- Added the document for `include` and `exclude` fields in the kcl.mod.
- Added FAQ about the `docker-credential-desktop not found` solution.
- Added reference documents for some resources in the konfig.
- Add API documentation for KCL WASM.
- Added API documentation for KCL Rust Plugin Development.
- Add FAQ document about the `mixin` and `protocol`.
- Fixed some document errors.

## 🌐 Other Resources

🔥 Check out the [KCL Community](https://github.com/kcl-lang/community) and join us 🔥

For more resources, refer to:

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
