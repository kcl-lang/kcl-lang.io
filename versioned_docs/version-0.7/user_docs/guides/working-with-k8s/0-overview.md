---
title: "Overview"
sidebar_position: 0
---

import DocsCard from '@site/src/components/global/DocsCard';
import DocsCards from '@site/src/components/global/DocsCards';

## Kubernetes

[Kubernetes](https://kubernetes.io/) is an open source project for running and managing containerized applications on a cluster of machines.

[KCL](https://github.com/kcl-lang) exposes the Kubernetes resource APIs as KCL modules which span common cloud native utilities and applications. In addition, KCL can be used to program, configure, and manage policies around these API modules.

## Use Cases

- **Dynamic configuration policy management**: **Create**, **orchestrate**, **mutate** or **validate** Kubernetes API resources for application workloads using the modern language including the use of **functions**, **schemas**, **conditionals** and **rich IDE features** (auto-completion, type & error checking, linting, refactoring, etc.) instead of YAML, JSON, scripts and templates.
- **Import from existing Kubernetes ecosystem**: Convert **Kubernetes manifests** and **custom resource types** to KCL.
- **Kubernetes package management**: **Install** or **publish** KCL modules from the [registry](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1) for application workload, container and service modules.

## Docs

<DocsCards>
  <DocsCard header="Adopt from Kubernetes" href="adopt-from-kubernetes">
    <p>Provides the guide to import Kubernetes manifests and CRDs to KCL.</p>
  </DocsCard>
  <DocsCard header="Generate Kubernetes" href="generate-k8s-manifests">
    <p>Provides the guide to generate Kubernetes manifests using KCL.</p>
  </DocsCard>
  <DocsCard header="Kubernetes Tool Integrations" href="mutate-manifests/kubectl-kcl-plugin">
    <p>Provides some Kubernetes tool integrations to mutate or validate Kubernetes manifests using KCL modules.</p>
  </DocsCard>
</DocsCards>
