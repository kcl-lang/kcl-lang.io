# KPT KCL SDK

[kpt](https://github.com/GoogleContainerTools/kpt) 是一个以包为中心的工具链，可实现配置原地编辑、自动化和交付，通过将声明性配置作为数据进行操作，从而简化 Kubernetes 平台和 KRM 驱动的基础设施（例如，Config Connector、Crossplane）的大规模管理，以实现 Kubernetes 配置编辑的自动化包括转换和验证。

KCL 可用于创建函数来转换和/或验证 YAML Kubernetes 资源模型 (KRM) 输入/输出格式，但我们提供 KPT KCL SDK 来简化函数编写过程。

## 先决条件

+ 安装 [kpt](https://github.com/GoogleContainerTools/kpt)
+ 安装 Docker

## 快速开始

Let’s write a KCL function which add annotation `managed-by=kpt` only to Deployment resources.

让我们编写一个仅向 Deployment 资源添加注释 `managed-by=kpt` 的 KCL 函数

## 获取示例

```bash
git clone https://github.com/KusionStack/kpt-kcl-sdk.git/
cd ./kpt-kcl-sdk/get-started/set-annotation
```

## 显示 KRM

```bash
kpt pkg tree
```

输出为

```bash
set-annotation
├── [kcl-fn-config.yaml]  KCLRun set-annotation
└── data
    ├── [resources.yaml]  Deployment nginx-deployment
    └── [resources.yaml]  Service test
```

## 更新 `FunctionConfig`

```yaml
# kcl-fn-config.yaml
apiVersion: fn.kpt.dev/v1alpha1
kind: KCLRun
metadata: # kpt-merge: /set-annotation
  name: set-annotation
# EDIT THE SOURCE!
# This should be your KCL code which preloads the `ResourceList` to `option("resource_list")
source: |
  [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kpt"}} for resource in option("resource_list").items]
```

## 测试和运行

通过 kpt 运行 KCL 代码

```bash
# Note: you need add sudo and --as-current-user flags to ensure KCL has permission to write temp files in the container filesystem.
sudo kpt fn eval ./data -i docker.io/peefyxpf/kcl-kpt:unstable --as-current-user --fn-config kcl-fn-config.yaml

# Verify that the annotation is added to the `Deployment` resource and the other resource `Service` 
# does not have this annotation.
cat ./data/resources.yaml | grep annotations -A1 -B5
```

## 更多文档和示例

+ [KPT KCL SDK](https://github.com/KusionStack/kpt-kcl-sdk)
