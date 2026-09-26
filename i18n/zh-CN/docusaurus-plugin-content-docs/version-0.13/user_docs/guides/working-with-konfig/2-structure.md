---
id: structure
sidebar_label: 工程结构
---

# Konfig 工程结构

本文主要解释 Konfig 配置库的目录和代码结构

## 核心模型库结构

核心模型库命名为 `models`，主要包含前端模型、后端模型、Mixin、渲染器等，目录结构为：

```bash
models
├── commons         # 基础资源核心模型库
├── kube            # 云原生资源核心模型库
│   ├── backend         # 后端模型
│   ├── frontend        # 前端模型
│   │   ├── common          # 通用前端模型
│   │   ├── configmap       # ConfigMap 前端模型
│   │   ├── container       # 容器前端模型
│   │   ├── ingress         # Ingress 前端模型
│   │   ├── resource        # 资源规格前端模型
│   │   ├── secret          # Secret 前端模型
│   │   ├── service         # Service 前端模型
│   │   ├── sidecar         # Sidecar 容器前端模型
│   │   ├── strategy        # 策略前端模型
│   │   ├── volume          # Volume 前端模型
│   │   └── server.k        # 云原生应用运维前端模型
│   ├── metadata        # 应用运维的元数据模型
│   ├── mixins          # 统一放置可复用的 Mixin
│   ├── render          # 渲染器，把前后端模型联系在一起的桥梁
│   ├── templates       # 静态配置
│   └── utils           # 工具方法
└── metadata        # 通用元数据模型
```
