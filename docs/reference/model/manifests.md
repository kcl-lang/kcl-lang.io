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

This function is used to serialize the KCL object list into YAML output with the --- separator. It has two parameters:

+ `values` - A list of KCL objects
+ `opts` - The YAML serialization options
  + `sort_keys`: Whether to sort the serialized results in the dictionary order of attribute names (the default is `False`).
  + `ignore_private`: Whether to ignore the attribute output whose name starts with the character `_` (the default value is `True`).
  + `ignore_none`: Whether to ignore the attribute with the value of' None '(the default value is `False`).
  + `sep`: Set the separator between multiple YAML documents (the default value is `"---"`).

Here's an example:

```python
import manifests

schema Deployment:
    apiVersion: str = "v1"
    kind: str = "Deployment"
    metadata: {str:} = {
        name = "deploy"
    }
    spec: {str:} = {
        replica = 2
    }

schema Service:
    apiVersion: str = "v1"
    kind: str = "Service"
    metadata: {str:} = {
         name = "svc"
    }
    spec: {str:} = {}    
        
deployments = [Deployment {}, Deployment {}]
services = [Service {}, Service {}]

manifests.yaml_stream(deployments + services)
```

First, we use the `import` keyword to import the `manifests` module and define two deployment resources and two service resources. When we want to output these four resources in YAML stream format with `---` as the separator, we can put them into a KCL list and use the `manifests.yaml_stream` function pass it to the `values` parameter (if there is no special requirement, the `opts` parameter can generally use the default value). Finally, the YAML output is:

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
