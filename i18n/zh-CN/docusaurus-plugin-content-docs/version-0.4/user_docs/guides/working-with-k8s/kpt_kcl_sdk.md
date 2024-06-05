# KPT KCL SDK

[kpt](https://github.com/GoogleContainerTools/kpt) 是一个以包为中心的工具链，可实现配置原地编辑、自动化和交付，通过将声明性配置作为数据进行操作，从而简化 Kubernetes 平台和 KRM 驱动的基础设施（例如，Config Connector、Crossplane）的大规模管理，以实现 Kubernetes 配置编辑的自动化包括转换和验证。

KCL 可用于创建函数来转换和/或验证 YAML Kubernetes 资源模型 (KRM) 输入/输出格式，但我们提供 KPT KCL SDK 来简化函数编写过程。

## 先决条件

- 安装 [kpt](https://github.com/GoogleContainerTools/kpt)
- 安装 Docker

## 快速开始

让我们编写一个仅向 Deployment 资源添加 annotation `managed-by=kpt` 的 KCL 函数

## 获取示例

```bash
git clone https://github.com/kcl-lang/kpt-kcl-sdk.git/
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
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata: # kpt-merge: /set-annotation
  name: set-annotation
spec:
  # 编辑此源代码
  # 您在此的 KCL 代码将 `ResourceList` 预加载到 `option("resource_list")`
  source: |
    [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kpt"}} for resource in option("resource_list").items]
```

## 测试和运行

通过 kpt 运行 KCL 代码

```bash
# 注意：您需要添加 sudo 和 --as-current-user 标志以确保 KCL 有权在容器文件系统中写入临时文件。
sudo kpt fn eval ./data -i docker.io/kcllang/kpt-kcl:v0.2.0 --as-current-user --fn-config kcl-fn-config.yaml

# 验证 annotation 是否添加到 `Deployment` 资源并且其他资源 `Service` 没有这个 annotation。
cat ./data/resources.yaml | grep annotations -A1 -B5
```

## 更多文档和示例

- [KPT KCL SDK](https://github.com/kcl-lang/kpt-kcl-sdk)
