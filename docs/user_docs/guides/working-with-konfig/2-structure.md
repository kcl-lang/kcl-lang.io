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
└── kube            # Cloud-native resource core models
    ├── backend         # Back-end models
    ├── frontend        # Front-end models
    │   ├── affinity        # Affinity
    │   ├── deployment      # Deplyment
    │   ├── common          # Common front-end models
    │   ├── configmap       # ConfigMap
    │   ├── container       # Container
    │   ├── ingress         # Ingress
    │   ├── rbac            # Role, RoleBinding, ClusterRole, ClusterRoleBinding
    │   ├── resource        # Resource
    │   ├── secret          # Secret
    │   ├── service         # Service
    │   ├── serviceaccount  # ServiceAccount
    │   ├── sidecar         # Sidecar
    │   ├── storage         # DataBase, ObjectStorage
    │   ├── strategy        # SchedulingStrategy
    │   ├── volume          # Volume
    │   ├── job.k           # The `Job` model
    │   └── server.k        # The `Server` model
    ├── metadata        # Kubernetes metadata
    ├── mixins          # Mixin
    ├── protocol        # ServerProtocol
    ├── render          # Front-to-back-end renderers.
    ├── resource        # ResourceMapping
    ├── templates       # Data template
    └── utils           # Helper utils
```
