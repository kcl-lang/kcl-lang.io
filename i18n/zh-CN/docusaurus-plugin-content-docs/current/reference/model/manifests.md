---
title: "manifests"
linkTitle: "manifests"
type: "docs"
description: manifests system module
weight: 100
---

## yaml_stream

```python
yaml_stream(values: [any], opts: {str:} = {
    sort_keys = False
    ignore_private = True
    ignore_none = False
    sep = "---"
})
```

这个函数的功能是将 KCL 对象列表序列化为带 `---` 分隔符的样式 YAML 输出，它具有两个参数:

+ `values` - 一个 KCL 对象列表
+ `opts` - YAML 序列化选项
  + `sort_keys`：是否按属性名称的字典序对序列化结果进行排序（默认为 `False`）。
  + `ignore_private`：是否忽略名称以 `_` 开头的属性序列化输出（默认为 `True`）。
  + `ignore_none`：是否忽略值为 `None` 的属性（默认为 `False`）。
  + `sep`：在多个 YAML 文档之间选择怎样的分隔符（默认为 `"---"`）。

下面我们通过一个例子来说明:

```python
# 使用 `import` 关键词导入 `manifests` 模块
import manifests

# `Deployment` schema 
schema Deployment:
    apiVersion: str = "v1"
    kind: str = "Deployment"
    metadata: {str:} = {
        name = "deploy"
    }
    spec: {str:} = {
        replica = 2
    }

# `Service` schema 定义
schema Service:
    apiVersion: str = "v1"
    kind: str = "Service"
    metadata: {str:} = {
         name = "svc"
    }
    spec: {str:} = {}    

# 定义两个 `Deployment` 资源
deployments = [Deployment {}, Deployment {}]
# 定义两个 `Service` 资源
services = [Service {}, Service {}]
# 将它们放入 KCL 列表，并调用 `manifests.yaml_stream` 函数。
manifests.yaml_stream(deployments + services)

首先我们通过 `import` 关键字导入 `manifests` 模块并定义 2 个 Deployment 以及 2 个 Service 资源，当我们想以 YAML stream 并以 `---` 作为分隔符的格式依次输出这 4 个资源时，我们可以将它们合并为一个 KCL 列表并作为 `manifests.yaml_stream` 函数的 `values` 形参进行传入 (如无特殊需求，opts 参数一般使用默认值即可)，最终得到 YAML 输出为:

```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Deployment
metadata:
  name: deploy
spec:
  replica: 2
---
apiVersion: v1
kind: Service
metadata:
  name: svc
---
apiVersion: v1
kind: Service
metadata:
  name: svc
```
