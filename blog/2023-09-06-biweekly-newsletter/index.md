---
slug: 2023-09-06-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 08.24 - 09.06) | Kubernetes Operator, IDE Extensions and v0.5.6 are out!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thank you to all contributors for their outstanding work over the past two weeks (08.10-08.23 2023). Here is an overview of the key content:

**🔧 Language and Toolchain Updates**

- **KCL Import Tool Updates** - Supports exporting JSON/YAML data to KCL configuration.
- **KCL IDE Updates** - Supports right-click formatting ability, formatting individual files or parts of KCL code.
- **KCL Documentation Tool Updates** - Exported documents support HTML escape.
- **KCL Package Management Tool KPM Updates** - `kpm run` command execution and error message optimization, supports running KCL packages located in local paths.
- **KCL Language Updates** - Optimized system package type check error messages and unified error message codes.

**📰 Official Website and Use Case Updates**

- KCL website adds v0.5.6 documentation version.
- Publishing KCL packages to docker.io or ghcr.io registries using Github Actions Example: [https://github.com/kcl-lang/kpm/blob/main/docs/push_by_github_action.md](https://github.com/kcl-lang/kpm/blob/main/docs/push_by_github_action.md)
- KCL Operator example: [https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator](https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/mutate-manifests/kcl-operator)

## Special Thanks

The following are listed in no particular order:

- Thanks to @jakezhu9 for the contribution of converting JSON and YAML configuration data to KCL configuration in the KCL Import Tool 🙌 [https://github.com/kcl-lang/kcl-go/pull/141](https://github.com/kcl-lang/kcl-go/pull/141)
- Thanks to @xxmao123 and @starkers for their contributions to the KCL NeoVim and Idea IDE extensions 🙌 [https://github.com/kcl-lang/intellij-kcl/pull/12](https://github.com/kcl-lang/intellij-kcl/pull/12)
- Thanks to @kolloch, @prahaladramji, and others for their valuable feedback and discussions during the use of KCL in the past two weeks 🙌

**Congratulations @jakezhu9 for becoming a KCL community Maintainer 🎉**

## Featured Updates

### KCL Operator

KCL Operator provides cluster integration, allowing you to use Access Webhook to generate, mutate, or validate resources based on KCL configuration when apply resources to the cluster. Webhook will capture creation, application, and editing operations, and execute [KCLRun](https://github.com/kcl-lang/krm-kcl) on the configuration associated with each operation, and the KCL programming language can be used to

- Add labels or annotations based on a condition.
- Inject a sidecar container in all KRM resources that contain a `PodTemplate`.
- Validating all KRM resources using KCL Schema, such as constraints on starting containers only in a root mode.
- Generating KRM resources using an abstract model or combining and using different KRM APIs.

With KCL Operator, you can automate resource configuration management and security validation in a Kubernetes cluster using lightweight KCL code, without the need to develop a webhook server to dynamically mutate and validate configurations at runtime.

Furthermore, leveraging KCL's modeling and abstraction capabilities, we can define functionality abstractions/compositions for different resource APIs and expose them in the form of KCL Schema. We can further generate OpenAPI Schema definitions from KCL Schema for other clients in the cluster to use, without manually maintaining complex OpenAPI Schema definitions for API abstractions/compositions. Here is an example of using KCL Operator to modify resource annotations:

#### 0. Prerequisites

Prepare a Kubernetes cluster like `k3d` the kubectl tool.

#### 1. Install KCL Operator

```shell
kubectl apply -f https://raw.githubusercontent.com/kcl-lang/kcl-operator/main/config/all.yaml
```

Use the following command to observe and wait for the pod status to be `Running`.

```shell
kubectl get po
```

#### 2. Deploy KCL Annotation Setting Model

```shell
kubectl apply -f- << EOF
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  # Set dynamic parameters required for the annotation modification model, here we can add the labels we want to modify/add
  params:
    annotations:
      managed-by: kcl-operator
  # Reference the annotation modification model on OCI
  source: oci://ghcr.io/kcl-lang/set-annotation
EOF
```

#### 3. Deploy a Pod to Verify the Model Result

Execute the following command to deploy a `Pod` resource:

```shell
kubectl apply -f- << EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  annotations:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
EOF
kubectl get po nginx -o yaml | grep kcl-operator
```

We can see the following output:

```shell
    managed-by: kcl-operator
```

We can see that the Nginx Pod automatically added the annotation `managed-by=kcl-operator`.

In addition, besides referencing an existing model for the source field of the `KCLRun` resource, we can directly set KCL code for the source field to achieve the same effect. For example:

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: set-annotation
spec:
  params:
    annotations:
      managed-by: kcl-operator
  # Resource modification can be achieved with just one line of KCL code
  source: |
    items = [item | {metadata.annotations: option("params").annotations} for item in option("items")]
```

We have provided more than 30 built-in models, and you can find more code examples in the following link: [https://github.com/kcl-lang/krm-kcl/tree/main/examples](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

### IDE Extension Updates

In the past two weeks, we have integrated the KCL language server LSP into NeoVim and Idea, enabling the completion, navigation, and hover features supported by VS Code IDE in NeoVim and IntelliJ IDEA.

- NeoVim KCL Extension

![kcl.nvim](/img/docs/tools/Ide/neovim/overview.png)

- IntelliJ Extension

![intellij](/img/docs/tools/Ide/intellij/overview.png)

For more information on downloading, installation, and features of the IDE plugins, please refer to:

- [https://kcl-lang.io/docs/user_docs/getting-started/install#neovim](https://kcl-lang.io/docs/user_docs/getting-started/install#neovim)
- [https://kcl-lang.io/docs/user_docs/getting-started/install#intellij-idea](https://kcl-lang.io/docs/user_docs/getting-started/install#intellij-idea)

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community.

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
