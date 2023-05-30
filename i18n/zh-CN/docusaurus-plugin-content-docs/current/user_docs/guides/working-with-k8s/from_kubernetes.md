---
title: "将 Kubernetes 模型转换为 KCL 模型"
sidebar_position: 1
---

## 1. Kubernetes OpenAPI Spec

从 Kubernetes 1.4 开始，引入了对 OpenAPI 规范的 alpha 支持（之前称为 Swagger 2.0，后来捐赠给了 OpenAPI Initiative），并且 API 描述遵循 [OpenAPI Spec 2.0](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/2.0.md)。自 Kubernetes 1.5 开始，Kubernetes 可以[直接从源代码中提取模型，然后生成 OpenAPI 规范文件](https://github.com/kubernetes/kube-openapi)，以便自动保持规范和文档与操作和模型一致更新。

除此之外，Kubernetes CRD 使用 [OpenAPI V3.0 验证](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation) 来描述自定义模式（除了内置的 apiVersion、Kind 和 metadata 属性之外），APIServer 在资源创建和更新阶段使用它来验证 CR。

## 2. KCL 的 OpenAPI 支持

`kcl-openapi` 工具支持从 Kubernetes OpenAPI/CRD 中提取和生成 KCL 模型（schema）。[KCL OpenAPI 规范](/docs/tools/cli/openapi/spec) 定义了 OpenAPI 规范和 KCL 语言特性之间的映射关系。要快速开始使用该工具，请参见 [KCL OpenAPI 工具](/docs/tools/cli/openapi/)。

## 3. 从 Kubernetes 迁移到 KCL

完整的 Kubernetes 内置模型 OpenAPI 定义存储在 [Kubernetes OpenAPI-Spec 文件](https://github.com/kubernetes/kubernetes/blob/master/api/openapi-spec/swagger.json)中。将该文件作为输入，KCL OpenAPI 工具可以生成相应版本的所有模型（model）的 schema。在下面的部分中，我们将以部署发布场景为例介绍如何从 Kubernetes 迁移到 KCL。假设你的项目正在使用 [Kubernetes Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) 来定义 Deployment 配置，迁移到 KCL 只需要以下步骤：

### 3.1 基于模型编写配置

我们为你提供了一个开箱即用的 `kusion_models` 包，让你可以快速开始。其中包含一个精心设计的前端模型，称为[服务器模型](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k)(Server schema)。你可以通过初始化 `Server schema` 来声明其配置。有关模式及其属性的说明和用法，请参阅 [Server schema 文档](https://kusionstack.io/docs/reference/model/kusion_models/kube/frontend/doc_server)。

### 3.2 构建你的自定义前端模型

现有的 KCL 模型可能无法满足你的特定业务需求，那么你也可以设计你自己的自定义前端模型包。在 Konfig 的 `kusion_kubernetes` 目录中，有一个 Kubernetes 1.22 生成模型的副本，你可以基于它设计你的自定义模型。你还可以开发自定义脚本以迁移你的配置数据，就像 `kube2kcl` 工具所做的那样。

### 3.2.1 将 Kubernetes Deployment 转换为 KCL 模型

在 Konfig 存储库的 `base/pkg/kusion_kubernetes` 目录下已经有 [Kubernetes 1.22 生成模型](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_kubernetes/api/apps/v1/deployment.k)的副本。你可以跳过这一步并使用现有的模型，或者如果需要，可以生成其他版本的模型。

现在让我们生成 Kubernetes 模型的 v1.23 版本。从 [Kubernetes v1.23 OpenAPI 规范](https://github.com/kubernetes/kubernetes/blob/release-1.23/api/openapi-spec/swagger.json)中，我们可以找到 `apps/v1.Deployment` 模型的定义，以下是部分内容摘录：

```json
{
    "definitions": {
        "io.k8s.api.apps.v1.Deployment": {
            "description": "Deployment enables declarative updates for Pods and ReplicaSets.",
            "properties": {
                "apiVersion": {
                    "description": "APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                    "type": "string"
                },
                "kind": {
                    "description": "Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                    "type": "string"
                },
                "metadata": {
                    "$ref": "#/definitions/io.k8s.apimachinery.pkg.apis.meta.v1.ObjectMeta",
                    "description": "Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata"
                },
                "spec": {
                    "$ref": "#/definitions/io.k8s.api.apps.v1.DeploymentSpec",
                    "description": "Specification of the desired behavior of the Deployment."
                },
                "status": {
                    "$ref": "#/definitions/io.k8s.api.apps.v1.DeploymentStatus",
                    "description": "Most recently observed status of the Deployment."
                }
            },
            "type": "object",
            "x-kubernetes-group-version-kind": [
                {
                    "group": "apps",
                    "kind": "Deployment",
                    "version": "v1"
                }
            ]
        }
    },
    "info": {
        "title": "Kubernetes",
        "version": "unversioned"
    },
    "paths": {},
    "swagger": "2.0"
}
```

你可以将上述规范保存为 `deployment.json` 文件，并运行 `kcl-openapi generate model -f deployment.json`，KCL Schemas 将会生成并输出到你当前的工作空间。其他 Kubernetes 模型也可以保存在该规范文件中，并且可以类似地进行生成。

#### 3.2.2 设计自定义前端模型

由于 Kubernetes 内置模型结构复杂且对初学者来说有些棘手，我们建议将 Kubernetes 的原生模型作为后端输出模型，并设计一批前端模型，将其作为一种更抽象、更友好和更简单的用户接口。你可以参考 [Konfig 存储库中 Server Schema](https://github.com/KusionStack/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k) 的设计模式。

#### 3.2.3 迁移配置数据

你可以开发自定义脚本以自动迁移你的配置数据。KCL 稍后将为此脚本提供编写脚手架和编写指南。

## 4. 从 Kubernetes CRD 迁移

如果你已经开发了 CRD，你可以生成KCL 版本的 CRD 模式，并基于它声明 CR。

- 从 CRD 生成 KCL Schema

    ```bash
    kcl-openapi generate model --crd --skip-validation -f <your_crd.yaml>
    ```

- 在 KCL 中基于 CRD 定义 CR

    你可以初始化 CRD 模式来定义 CR，或者你可以使用生成的模式作为后端模型，并为用户设计一个前端界面进行初始化。这类似于 `KCL Models` 在 Kubernetes 内置模型上的实践。
