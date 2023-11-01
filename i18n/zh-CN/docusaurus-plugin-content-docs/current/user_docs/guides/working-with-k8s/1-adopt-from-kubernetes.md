---
title: "从 Kubernetes 迁移"
sidebar_position: 1
---

## 简介

KCL 对 Kubernetes 配置提供了许多开箱即用的支持，通过 KCL 工具，我们可以将 Kubernetes Schema 和 配置集成到 KCL 中，本节内容将介绍如何使用 KCL 对 Kubernetes 进行集成

## 前置依赖

+ 安装 [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

## 快速开始

### 1. 从配置文件迁移

+ YAML

```shell
kcl import deployment.yaml
```

+ JSON

```shell
kcl import deployment.json
```

### 2. 从 Kubernetes CRD 迁移

如果您的项目中使用了 CRD，也可以采用类似的方式，生成 CRD 对应的 KCL schema，并基于该 schema 声明 CR。

* 从 CRD 生成 KCL Schema

    ```sh
    kcl import -m crd -s <your_crd.yaml>
    ```

* 使用 KCL 声明 CR

    使用 KCL 声明 CR 的模式与声明 Kubernetes 内置模型配置的模式相同，在此不做赘述。

### 3. 直接获取 k8s 包

所有版本的 Kubernetes KCL 模块及生态中可以直接使用的模块都是预先生成的，您可以在项目中执行 `kcl mod add k8s:<version>` 来获取它们。更多模块可以在[这里](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)找到。

## 小结

本节介绍了如何使用 kcl import 工具将 JSON, YAML, Kubernetes CRD 等迁移到 KCL 的快速入门指南帮助从 Kubernetes 进行迁移或集成。
