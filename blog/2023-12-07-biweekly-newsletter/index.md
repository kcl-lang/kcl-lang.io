---
slug: 2023-12-07-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 11.24 - 12.07) | How to Use Different Kubernetes Patch Strategies in KCL?
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thank you to all contributors for their outstanding work over the past two weeks (11.24 - 12.07 2023). Here is an overview of the key content:

**📦 Module Update**

The number of KCL models has increased to **240**, mainly including models related to Crossplane Provider and libraries related to JSON merging operations.
+ KCL JSON Patch library:_[https://artifacthub.io/packages/kcl/kcl-module/jsonpatch](https://artifacthub.io/packages/kcl/kcl-module/jsonpatch)_
+ KCL JSON Merge Patch library: _[https://artifacthub.io/packages/kcl/kcl-module/json_merge_patch](https://artifacthub.io/packages/kcl/kcl-module/json_merge_patch)_
+ KCL Kubernetes Strategy Merge Patch library: _[https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch](https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch)_
+ KCL Crossplane and Crossplane Provider series models: _[https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1&ts_query_web=crossplane](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1&ts_query_web=crossplane)_

**🔧 Toolchain Update**

- **Documentation Tool Updates**
  - Support documentation generation for third-party libraries that models depend on, such as the `k8s` module.
- **Validation Tool Updates**
  - Support validation results and error localization to YAML/JSON files, outputting error line and column number information.
- **Import Tool Updates**
  - Support mapping OpenAPI `multiplyOf` specification to KCL `multiplyof` function for validation.
  - Support outputting YAML Stream format Kubernetes CRD files into multiple KCL files.
  - Optimize KCL code generation by removing empty check statements.

**🏄 SDK Update**

In addition to the existing Go and Python SDKs in KCL, a new Rust SDK has been added (without LLVM dependency), which includes APIs for KCL file compilation, validation, testing, and code formatting.

**💻 IDE Updates**

- **Developer Experience**
  - Support incremental parsing and asynchronous compilation to enhance performance.
- **Bug Fixes**
  - Fixed the issue where string interpolation variables in assert statements cannot be navigated.
  - Fixed the issue where exceptional triggering of function completion in strings.
  - Fixed the issue with alias semantic check and completion in import statements.
  - Fixed the issue with check expression completion in schemas.

**📒 Documentation Updates**

+ Added index cards for KCL system library documentation for easy navigation: _[https://kcl-lang.io/docs/reference/model/overview](https://kcl-lang.io/docs/reference/model/overview)_
+ Updated KCL CLI reference documentation: _[https://kcl-lang.io/docs/tools/cli/kcl/overview](https://kcl-lang.io/docs/tools/cli/kcl/overview)_
+ Updated KCL API reference documentation: _[https://kcl-lang.io/docs/reference/xlang-api/overview](https://kcl-lang.io/docs/reference/xlang-api/overview)_
+ KCL 2023 & 2024 Roadmap document: _[https://kcl-lang.io/docs/community/release-policy/roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)_
+ Supplemented project structure introduction and FAQ for Intellij KCL repository: _[https://github.com/kcl-lang/intellij-kcl/pull/18](https://github.com/kcl-lang/intellij-kcl/pull/18)_

## Special Thanks

The following are listed in no particular order:

- Thanks to @professorabhay for supporting KCL testing diff function 🙌 _[https://github.com/kcl-lang/kcl/issues/940](https://github.com/kcl-lang/kcl/issues/940)_
- Thanks to @patrycju, @Callum Lyall, @Even Solberg, @Matt Gowie, and @ShiroDN for their valuable feedback and discussions during the promotion and usage of KCL 🙌

## Featured Updates

### Using Kubernetes Strategy Merge Patch to Update Configurations in KCL

In the current version of KCL, various **attribute operators** are supported to update and override configurations. However, the capability is relatively atomic and cannot cover the typical configuration strategy scenarios in cloud-native environments.

For Kubernetes configurations, it is common to use the `JSON Merge Patch` and `Strategy Merge Patch` capabilities natively supported by Kubernetes e.g., using tools such as `kubectl patch`, `kustomize`, and other patching capabilities supported by cloud-native configuration and policy tools.

To avoid repeatedly using KCL attribute operators to write configuration patch template codes when dealing with Kubernetes configurations, we provide the **Kubernetes Strategy Merge Patch library** for updating Kubernetes configurations. This library supports all merging strategies defined by native Kubernetes objects, such as overwriting, modifying, and adding items to list objects. Here is how to use it:

Create a new project and add the Strategy Merge Patch library dependency:

```shell
kcl mod init && kcl mod add strategic_merge_patch
```

Write the configuration patch code in `main.k` (using the `labels`, `replicas`, and `container` attributes of a `Deployment` template as an example):

```python
import strategic_merge_patch as s

original = {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "name": "my-deployment",
        "labels": {
            "app": "my-app"
        }
    },
    "spec": {
        "replicas": 3,
        "template": {
            "spec": {
                "containers": [
                    {
                        "name": "my-container-1",
                        "image": "my-image-1"
                    },
                    {
                        "name": "my-container-2",
                        "image": "my-image-2"
                    }
                ]
            }
        }
    }
}

patch = {
    "apiVersion": "apps/v1",
    "kind": "Deployment",
    "metadata": {
        "name": "my-deployment",
        "labels": {
            "version": "v1"
        }
    },
    "spec": {
        "replicas": 4,
        "template": {
            "spec": {
                "containers": [
                    {
                        "name": "my-container-1",
                        "image": "my-new-image-1"
                    },
                    {
                        "name": "my-container-3",
                        "image": "my-image-3"
                    }
                ]
            }
        }
    }
}

got = s.merge(original, patch)
```

Run the command to get the output:

```shell
kcl run
```

The output will be:

```yaml
original:
  metadata:
    name: my-deployment
    labels:
      app: my-app
  spec:
    replicas: 3
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-image-1
        - name: my-container-2
          image: my-image-2
patch:
  metadata:
    labels:
      version: v1
  spec:
    replicas: 4
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-new-image-1
        - name: my-container-3
          image: my-image-3
got:
  metadata:
    name: my-deployment
    labels:
      app: my-app
      version: v1
  spec:
    replicas: 4
    template:
      spec:
        containers:
        - name: my-container-1
          image: my-new-image-1
        - name: my-container-2
          image: my-image-2
        - name: my-container-3
          image: my-image-3
```

As seen in the output, the labels, replicas, and container fields of the Deployment template have all been updated with the correct values. For more documentation and usage examples, please refer to [the document](https://artifacthub.io/packages/kcl/kcl-module/strategic_merge_patch).

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community. See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.8.0 Milestone](https://github.com/kcl-lang/kcl/milestone/8)
