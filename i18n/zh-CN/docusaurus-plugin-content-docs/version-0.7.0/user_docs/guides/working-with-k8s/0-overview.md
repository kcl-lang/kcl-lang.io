---
title: "概述"
sidebar_position: 0
---

import DocsCard from '@site/src/components/global/DocsCard';
import DocsCards from '@site/src/components/global/DocsCards';

## Kubernetes

[Kubernetes](https://kubernetes.io/) 是一个开源项目，用于在一组机器集群上运行和管理容器化应用程序。

[KCL](https://github.com/kcl-lang) 可以将 Kubernetes 资源 API 公开为跨常见云原生工具和应用程序的 KCL 代码模块。此外，可以使用 KCL 围绕这些 API 模块进行编程和配置、策略管理。

## 用例

- **动态配置策略管理**：使用现代语言（包括函数、类型、条件语句和丰富的 IDE 集成开发环境功能）来创建、编排、更改或验证应用负载的 Kubernetes API 资源，而不是使用 YAML、JSON、脚本和模板等方式。
- **接入 Kubernetes 已有生态**：将 Kubernetes 配置清单和自定义资源类型转换为 KCL 配置和 Schema 并使用。
- **Kubernetes 包管理**：使用 KCL 包管理工具从 Registry 下载安装和发布应用负载、容器和服务等模型。

## 文档

<DocsCards>
  <DocsCard header="Adopt from Kubernetes" href="adopt-from-kubernetes">
    <p>将 Kubernetes 清单和 CRD 转换为 KCL 代码的指南。</p>
  </DocsCard>
  <DocsCard header="Generate Kubernetes" href="generate-k8s-manifests">
    <p>使用 KCL 生成 Kubernetes 清单的指南。</p>
  </DocsCard>
  <DocsCard header="Kubernetes Tool Integrations" href="mutate-manifests/kubectl-kcl-plugin">
    <p>提供一些 Kubernetes 工具集成，以及使用 KCL 模块对 Kubernetes 清单进行变异或验证的指南。</p>
  </DocsCard>
</DocsCards>
