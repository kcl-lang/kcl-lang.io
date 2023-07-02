---
slug: 2022-kcl-0.4.6-release-blog
title: KCL v0.4.6 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL, KusionStack, Kusion]
---

<!-- KCL v0.4.6 is Coming - New IDE Extension, Helm/Kustomize/KPT Integrations-->

## Introduction

The KCL team is pleased to announce that KCL v0.4.6 is now available! This release has brought three key updates to everyone: **Language**, **Tools**, and **Integrations**.

+ *Use KCL IDE extensions to improve KCL code writing experience and efficiency*
+ *Helm/Kustomize/KPT cloud-native community tool integrations*
+ *Improve the KCL multilingual SDK for easy application integration*

You can visit the [KCL release page](https://github.com/KusionStack/kcl/releases/tag/v0.4.6) or the [KCL website](https://kcl-lang.io/) to get KCL binary download link and more detailed release information.

[KCL](https://github.com/KusionStack/kcl) is an open-source, constraint-based record and functional language. KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

This blog will introduce the content of KCL v0.4.6 and recent developments in the KCL community to readers.

## Language

### Builtin Functions

Added KCL string `removeprefix` and `removesuffix` member functions to remove prefix and suffix substrings from strings

```python
data1 = "prefix-string".removeprefix("prefix-") # "string" 
data2 = "string-suffix".removesuffix("-suffix") # "string"
```

See [here](https://kcl-lang.io/docs/reference/model/builtin#string-builtin-member-functions) for more.

### Compiler Information

In previous versions of KCL, running the KCL command-line tool once only displayed one error message and warning. In KCL v0.4.6, it supported the ability to display multiple errors and warnings in one compilation and improved error information to improve the efficiency of KCL code error troubleshooting, such as for the following KCL code (main.k).

```python
metadata = {
    labels = {key = "kcl
}
```

Execute the following KCL command, then you can see the syntax errors including the unterminated string and the brace mismatch errors.

```shell
$ kcl main.k
error[E1001]: InvalidSyntax
 --> main.k:2:21
  |
2 |     labels = {key = "kcl
  |                     ^ unterminated string
  |

error[E1001]: InvalidSyntax
 --> main.k:2:24
  |
2 |     labels = {key = "kcl
  |                        ^ expected "}"
  |
```

### Top-level schema assign statement union operator

In previous versions of KCL, when writing the following KCL code, the two schema configurations with the same name were merged and output. In KCL v0.4.6, it was required to explicitly use the attribute merge operator instead of the attribute overlay operator.

+ Before

```python
schema Config:
    id?: int
    value?: str

config = Config {
    id = 1
}
config = Config {
    value = "value"
}
```

+ After

```python
schema Config:
    id?: int
    value?: str

# Use the union operator `:` instead of the override operator
config: Config {
    id = 1
}
# Use the union operator `:` instead of the override operator
config: Config {
    value = "value"
}
```

### Path selector simplification

We use the path selector CLI parameter (-S) without filling in the package path, and can directly filter internal variables.

For the KCL code (main.k):

```python
schema Person:
    name: str
    age: int

person = Person {
    name = "Alice"
    age = 18
}
```

We run the following command:

```shell
$ kcl main.k -S person
name: Alice
age: 18
```

### Bugfix

#### Inline conditional configuration block syntax error

Before KCL v0.4.6, an unexpected syntax error will appear when writing the following KCL code. In the new version, we fixed similar issues.

```python
env = "prod"
config = {if env == "prod": labels = {"kubernetes.io/env" = env}}
```

#### Schema required attribute check

In previous versions of KCL, for the following KCL code, there was an error where the `versions` attribute was not assigned as expected. In KCL v0.4.6, we fixed similar issues.

```python
schema App:
    data?: [int]
    version: Version

schema Version:
    versions: [str]

app = App {
    version = Version {}
}
```

## Tools

### KCL VS Code Extension

In this version, we have released a new KCL VS Code extension and a language service server rewritten using the Rust language, which has improved performance by about 20 times compared to previous KCL IDE versions. We also support real-time display of KCL errors and warnings in the IDE, as well as new features such as KCL code completion.

+ **Real-time display of KCL errors and warnings**

![Diagnostics](/img/docs/tools/Ide/vs-code/Diagnostics.gif)

+ **Go to Definition**

![Goto Definition](/img/docs/tools/Ide/vs-code/GotoDef.gif)

+ **Completion**

![Completion](/img/docs/tools/Ide/vs-code/Completion.gif)

+ **Hover**

![Hover](/img/docs/tools/Ide/vs-code/Hover.gif)

See [here](https://kcl-lang.io/docs/tools/Ide/vs-code) for more.

### Kusion VS Code Extension

On the basis of the KCL VS Code extension, we also provide a Kusion VS Code extension that is more closely integrated with cloud-native scenarios, supporting one-click application configuration preview and deploying. See [here](https://github.com/KusionStack/vscode-kusion) for more.

### Package Management Tools

In the new version of KCL v0.4.6, we have provided a new KCL package management tool with the alpha version, which allows users to access the KCL modules in the community with a few commands. For example, the KCL Kubernetes model can be imported through the following command.

```shell
kpm init kubernetes_demo && kpm add -git https://github.com/awesome-kusion/konfig.git -tag v0.0.1
```

Write a KCL code to import the Kubernetes models (main.k).

```python
import konfig.base.pkg.kusion_kubernetes.api.apps.v1 as apps

apps.Deployment {
    metadata.name = "nginx-deployment"
    spec = {
        replicas = 3
        selector.matchLabels.app = "nginx"
        template.metadata.labels = selector.matchLabels
        template.spec.containers = [
            {
                name = selector.matchLabels.app
                image = "nginx:1.14.2"
                ports = [
                    {containerPort = 80}
                ]
            }
        ]
    }
}
```

Execute the following command to run the KCL code to obtain an nginx deployment YAML output.

```shell
$ kpm run
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
        - image: "nginx:1.14.2"
          name: nginx
          ports:
            - containerPort: 80
```

+ See [here](https://kcl-lang.io/docs/user_docs/guides/package-management/overview) for more information about the **kpm** tool.
+ See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-konfig/overview) for more information about the **konfig** model.

## Integrations

### Kubernetes Tool Integrations

In KCL v0.4.6, we provide KCL plugin support for configuration management tools such as Helm, Kustomize, and KPT in the Kubernetes community using a unified programming interface. Writing a few lines of KCL code can non-intrusively complete the mutation and validation of existing Kustomize YAML and Helm Charts.

For example, writing a small amount of KCL code to modify resource labels/annotations, injecting sidecar container configuration, and using KCL schema to verify resources.

Below is a detailed explanation of the integration of KCL using the Kustomize tool. There is no need to install any KCL-related binaries to use the Kustomize KCL plugin, just install the Kustomize tool locally.

Firstly, execute the following command to obtain a Kustomize YAML configuration example:

```shell
git clone https://github.com/KusionStack/kustomize-kcl.git &&cd ./kustomize-kcl/examples/set-annotation/
```

Then execute the following command using KCL code to add only one `managed-by=kustomize-kcl` annotation for all `Deployment` resources

```shell
sudo kustomize fn run ./local-resource/ --as-current-user --dry-run
```

The output YAML is:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: test
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
spec:
  selector:
    app: MyApp
  ports:
  - protocol: TCP
    port: 80
    targetPort: 9376
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
  annotations:
    config.kubernetes.io/path: example-use.yaml
    internal.config.kubernetes.io/path: example-use.yaml
    # This annotation is added through the kcl code.
    managed-by: kustomize-kcl
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

In the YAML configuration mentioned above, we only wrote one line of KCL code to add a `managed-by=kustomize-kcl` annotation to all deployment resources.

```python
[resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kcl"}} for resource in option("resource_list").item]
```

In addition, we have provided commonly used container and service configuration mutation and validation KCL models for Kustomize/Helm/KPT tools and will continue to improve them.

+ See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kustomize_kcl_plugin) for more information about the Kustomize KCL plugin.
+ See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/helm_kcl_plugin) for more information about the Helm KCL Plugin.
+ See [here](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/kpt_kcl_sdk) for more information about the KPT KCL Plugin.

### Multilingual SDK

In this new version, we have released a new kclvm-go SDK that integrates KCL into your Go application and provides rich APIs for interacting with KCL. You can click [here](https://kcl-lang.io/docs/next/reference/xlang-api/go-api) for detailed API documents. In addition, we have also updated the following features and bug fixes:

+ Thank @jakezhu9 for fixing unexpected KCL formatting API unit testing errors in CI Pipeline for kclvm-go.
+ Thank @Ekko for contributing to the bidirectional conversion support of Go struct and KCL schema. Please refer to:
  + [Go struct -> KCL schema](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genkcl.go#L23)
  + [KCL schema -> Go struct](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/gengo.go#L23)
+ Support for conversion from KCL schema to protobuf message, see [here](https://github.com/KusionStack/kclvm-go/blob/main/pkg/tools/gen/genpb.go#L25) for more.
+ Support APIs for obtaining schema types and instances from the KCL code, see [here](https://kcl-lang.io/docs/reference/xlang-api/go-api#func-getschematype) for more.

## Other updates and bug fixes

+ The KCL Python plugin function is not enabled by default. If you need to enable it, please refer to the [plugin document](https://kcl-lang.io/docs/reference/plugin/overview).
+ KCL playground supports code-sharing capabilities, which can be accessed by visiting the [KCL website](https://kcl-lang.io/) and clicking on the playground button to experience.
+ See [here](https://github.com/KusionStack/kcl/milestone/3?closed=1) for more updates and bug fixes.

## Documents

The versioning semantic option is added to the [KCL website](https://kcl-lang.io/). Currently, v0.4.3, v0.4.4, v0.4.5, and v0.4.6 versions are supported.

## Next

It is expected that in the middle of 2023, we will release **KCL v0.5.0**. The expected key evolution includes:

+ More IDE extensions, package management tools, Helm/Kustomize/KPT scenario integration, feature support, and user experience improvement.
+ Provide more out-of-box KCL model support for cloud-native scenarios, mainly including containers, services, computing, storage, and networks.
+ Support KCL Schema to directly generate Kubernetes CRD.
+ Support `kubectl` and `helmfile` KCL plugins, directly generating, mutating, and validating Kubernetes resources through the KCL code.
+ Support for mutating and validating YAML by running KCL code through the admission controller at the Kubernetes runtime.
+ More support for non-Kubernetes scenarios, such as data cleaning of AI models through the KCL schema and database schema integration support.

For more details, please refer to [KCL v0.5.0 Milestone](https://github.com/KusionStack/kcl/milestone/5)

## FAQ

For more information, see [KCL FAQ](https://kcl-lang.io/docs/user_docs/support/).

## Additional Resources

Thank all KCL users for their valuable feedback and suggestions during this version release. For more resources, please refer to:

+ [KCL Website](https://kcl-lang.io/)
+ [Kusion Website](https://kusionstack.io/)
+ [KCL Repo](https://github.com/KusionStack/kcl)
+ [Kusion Repo](https://github.com/KusionStack/kusion)
+ [Konfig Repo](https://github.com/KusionStack/konfig)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏
