---
id: structure
sidebar_label: Structure
---

# Konfig Structure

This article mainly explains the directory and code structure of the Konfig repository.

## Core Model

The core model library is generally named `models`, mainly including front-end model, back-end model, renderer, etc. The directory structure is:

```bash
models
├── commons         # Common models
├── kube            # Cloud-native resource core models
│   ├── backend         # Back-end models
│   ├── frontend        # Front-end models
│   │   ├── common          # Common front-end models
│   │   ├── configmap       # ConfigMap
│   │   ├── container       # Container
│   │   ├── ingress         # Ingress
│   │   ├── resource        # Resource
│   │   ├── secret          # Secret
│   │   ├── service         # Service
│   │   ├── sidecar         # Sidecar
│   │   ├── strategy        # strategy
│   │   ├── volume          # Volume
│   │   └── server.k        # The `Server` model
│   ├── metadata        # Kubernetes metadata
│   ├── mixins          # Mixin
│   ├── render          # Front-to-back-end renderers.
│   ├── templates       # Data template
│   └── utils
└── metadata        # Common metadata
```
