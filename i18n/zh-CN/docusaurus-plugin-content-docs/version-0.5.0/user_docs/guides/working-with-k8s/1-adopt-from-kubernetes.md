---
title: "从 Kubernetes 迁移"
sidebar_position: 1
---

## 简介

KCL 对 Kubernetes 配置提供了许多开箱即用的支持，通过 KCL 工具，我们可以将 Kubernetes Schema 和 配置集成到 KCL 中，本节内容将介绍如何使用 KCL 对 Kubernetes 进行集成

### 1. Kubernetes OpenAPI Spec

从 Kubernetes 1.4 开始，引入了对 OpenAPI 规范（在捐赠给 Open API Initiative 之前称为 swagger 2.0）的 alpha 支持，API 描述遵循 [OpenAPI 规范 2.0](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/2.0.md)，从 Kubernetes 1.5 开始，Kubernetes 能够直接从[源码自动地提取模型并生成 OpenAPI 规范](https://github.com/kubernetes/kube-openapi)，自动化地保证了规范和文档与操作/模型的更新完全同步。

此外，Kubernetes CRD 使用 [OpenAPI v3.0 validation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation) 来描述（除内置属性 apiVersion、kind、metadata 之外的）自定义 schema，在 CR 的创建和更新阶段，APIServer 会使用这个 schema 对 CR 的内容进行校验。

### 2. KCL OpenAPI 支持

KCLOpenAPI 工具支持从 OpenAPI/CRD 定义提取并生成 KCL schema. 在[KCLOpenapi Spec](/docs/tools/cli/openapi/spec)中明确定义了 OpenAPI 规范与 KCL 语言之间的映射关系。

### 3. 从 Kubernetes 模型迁移到 KCL

#### 3.1 基于 kusion_models 编写配置

我们为你提供了一个开箱即用的 `kusion_models` 包，让你可以快速开始。其中包含一个精心设计的前端模型，称为[服务器模型](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k)(Server schema)。你可以通过初始化 `Server schema` 来声明其配置。有关模式及其属性的说明和用法，请参阅 [Server schema 文档](https://kusionstack.io/docs/reference/model/kusion_models/kube/frontend/doc_server)。

#### 3.2 创建自定义的 models 前端模型

现有的 `kusion_models` 模型可能无法满足你的特定业务需求，那么你也可以设计自定义前端模型包。 您可基于预先生成的 Kubernetes KCL 包自定义您的前端模型。您还可以仿照`kube2kcl` 工具的模式，开发自定义脚本，完成配置数据的迁移。

##### 3.2.1 获取 Kubernetes KCL 模型

我们提供了预生成的各版本[Kubernetes KCL模型](https://github.com/orgs/KusionStack/packages/container/package/k8s)，您可以在项目下执行 `kpm add k8s:<version>` 来获得它。有关 kpm 使用的详细信息，请参考 [kpm快速入门指南](https://github.com/kcl-lang/kpm#quick-start)。

或者，如果您需要自己生成这些包，请参考[从 Kubernetes OpenAPI 文件生成 KCL 包](https://github.com/kcl-lang/kcl-openapi/blob/main/docs/generate_from_k8s_spec.md)。

##### 3.2.2 编写自定义前端模型

由于 Kubernetes 内置模型较为原子化和复杂，我们推荐以 Kubernetes 原生模型作为后端输出的模型，对其进一步抽象，而向用户暴露一份更为友好和简单的前端模型界面，具体您可参照 Konfig 仓库中 [kusion_models Server](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k) 模型的设计方式进行。

##### 3.2.3 迁移配置数据

对于存量的 Kubernetes 配置数据，您可以仿照 kube2Kcl 工具的做法，编写自定义的转换脚本，进行一键迁移。Kusion 后续将提供该脚本的编写脚手架和编写指南。

### 4. 从 Kubernetes CRD 迁移

如果您的项目中使用了 CRD，也可以采用类似的模式，生成 CRD 对应的 KCL schema，并基于该 schema 声明 CR。

* 从 CRD 生成 KCL Schema

    ```
    kcl-openapi generate model --crd --skip-validation -f your_crd.yaml
    ```

* 使用 KCL 声明 CR

    使用 KCL 声明 CR 的模式与声明 Kubernetes 内置模型配置的模式相同，在此不做赘述。

## 小结

本节介绍了如何使用 kcl-openapi 工具将 OpenAPI 规范映射到 KCL 语言特性，此外提供了将 KCL 与 OpenAPI 和 Kubernetes CRD 一起使用的快速入门指南帮助从 Kubernetes 进行迁移或集成。
