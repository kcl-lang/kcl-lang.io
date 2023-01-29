---
id: structure
sidebar_label: Structure
---
# Konfig Structure

This article mainly explains the directory and code structure of the Konfig repository.

## Overview

```bash
.
├── .github             # CI Scripts
├── Makefile            # Building and testing scripts
├── README.md           # Documents
├── appops              # Application configuration. This folder is used to place KCL operation and maintenance configuration of all applications
│   ├── clickhouse-operator
│   ├── code-city
│   ├── guestbook
│   ├── http-echo
│   └── nginx-example
├── base                # Models
│   ├── examples        # Examples
│   │   ├── monitoring  # Monitoring example
│   │   ├── native      # Kubernetes resource example
│   │   ├── provider    # Basic resource configuration example such as Terraform resource
│   │   └── server      # Server example.
│   └── pkg
│       ├── kusion_kubernetes   # Kubernetes domain models
│       ├── kusion_models       # Core models
│       ├── kusion_prometheus   # Prometheus domain models
│       └── kusion_provider     # Basic resource models such as Terraform resource
└── kcl.mod             # The KCL module declaration file
```

## Core Model

The core model library is generally named `kusion_models`, mainly including front-end model, back-end model, renderer, etc. The directory structure is:

```bash
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

## Project and Stack

![](/img/docs/user_docs/concepts/project-stack.png)

Project and Stack are logical isolation concepts used to orginize the Konfig.

### Project

Any folder that contains the file `project.yaml` will be regarded as a Project, and the `project.yaml` is used to describe the metadata of this Project like `name` and `tenant`. Projects must have clear business semantics and must belong to a tenant. Users can map an application or an operation scenario to a Project.

### Stack

Like Project, any folder that contains the file `stack.yaml` will be regarded as a Stack and `stack.yaml` is used to describe the metadata of this Stack. Stack is a set of `.k` files that represents the smallest operation unit that can be configured and deployed individually. It tends to represent different stages in the CI/CD process, such as dev, gray, prod, etc.

### Relationship between Project and Stack

A Project contains one or more Stacks, and a Stack must belong to and can only belong to one Project. Users can interpret the meaning of Project and Stack according to their own needs and flexibly organize the Konfig structure. We provide the following example as a best practice according to our experiences:

```bash
appops/nginx-example
├── README.md       # Project readme
├── base            # common configurations for all stacks
│   └── base.k      
├── dev             # dev stack 
│   ├── ci-test     # CI test configs
│   │   ├── settings.yaml       # test data 
│   │   └── stdout.golden.yaml  # expected test result
│   ├── kcl.yaml    # kcl config
│   ├── main.k      
│   └── stack.yaml  # Stack metadata
└── project.yaml    # Project metadata
```

The Project represents an application and Stack represents different environments of this application, such as dev, pre and prod, etc. Common configurations can be stored in a `base` directory under this Project.
