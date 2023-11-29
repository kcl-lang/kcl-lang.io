---
title: "Adopt From Kubernetes"
sidebar_position: 1
---

## Introduction

KCL provides many out of the box support for Kubernetes configuration. Through KCL tools, we can integrate Kubernetes Schema and configuration into KCL. This section will introduce how to use KCL to integrate Kubernetes.

## Prerequisite

- Install kcl-openapi

## Quick Start

### 1. Kubernetes OpenAPI Spec

Starting from Kubernetes 1.4, the alpha support for the OpenAPI specification (known as Swagger 2.0 before it was donated to the OpenAPI Initiative) was introduced, and the API descriptions follow the [OpenAPI Spec 2.0](https://github.com/OAI/OpenAPI-Specification/blob/main/versions/2.0.md). And since Kubernetes 1.5, Kubernetes supports [directly extracting models from source code and then generating the OpenAPI spec file](https://github.com/kubernetes/kube-openapi) to automatically keep the specifications and documents up to date with the operation and models.

In addition, Kubernetes CRD uses [OpenAPI V3.0 validation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation) to describe a custom schema (in addition to the built-in attributes apiVersion, Kind, and metadata), that APIServer uses to validate the CR during the resource creation and update phases.

### 2. KCL OpenAPI Support

The `kcl-openapi` tool supports extracting and generating KCL schemas from Kubernetes OpenAPI/CRD. the [KCL OpenAPI Spec](/docs/tools/cli/openapi/spec) defines the mapping between the OpenAPI specification and the KCL language features. For a quick start with the tool, see [KCL OpenAPI tool](/docs/tools/cli/openapi/)

### 3. Migrate From Kubernetes To KCL

#### 3.1 Write configurations based on the Kusion_Models package

We provide an out-of-the-box `konfig` package for you to quickly start. It contains a well-designed frontend model called [`Server schema`](https://github.com/kcl-lang/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k). You can declare the configurations by initializing the `Server schema`.

#### 3.2 Build Your Custom Frontend Models

The existing KCL Models may not meet your specific business requirements, then you can also design your custom frontend model package. You can design your custom models based on the pre-generated Kubernetes KCL models among all versions.

##### 3.2.1 Get the k8s package

The [Kubernetes KCL models](https://github.com/orgs/kcl-lang/packages/container/package/k8s) among all versions are pre-generated, you get it by executing `kpm add k8s:<version>` under your project. For detailed information about kpm usage, please refer to [kpm quick start guide](https://github.com/kcl-lang/kpm#quick-start).

Alternatively, if you may want to generate them yourself, please refer to [Generate KCL Packages from Kubernetes OpenAPI Specs](https://github.com/kcl-lang/kcl-openapi/blob/main/docs/generate_from_k8s_spec.md).

##### 3.2.2 Design Custom Frontend Models

Since the Kubernetes built-in models are atomistic and kind of complex to beginners, we recommend taking the native model of Kubernetes as the backend output model and designing a batch of frontend models which could become a more abstract, friendlier and simpler interface to the user. You can refer to the design pattern in the [`Server Schema in the Konfig repo`](https://github.com/kal-lang/konfig/blob/main/base/pkg/kusion_models/kube/frontend/server.k).

##### 3.2.3 Migrate The Configuration Data

You can develop your custom scripts to migrate your configuration data automatically. KCL will later provide writing scaffolding and writing guidelines for this script.

### 4. Migrate From Kubernetes CRD

If you developed CRDs, you can generate the KCL version of the CRD schemas and declare CRs based on that.

- Generate KCL Schema from CRD

  ```
  kcl-openapi generate model --crd --skip-validation -f <your_crd.yaml>
  ```

- Define CR based on CRDs in KCL

  You can initialize the CRD schema to define a CR, or further, you can use the generated schema as a backend model and design a frontend interface for users to initialize. The practice is similar to what `KCL Models` does on Kubernetes built-in models.

## Summary

This section provides a quick start guide for using KCL with OpenAPI and Custom Resource Definitions (CRD). KCL also supports OpenAPI through the `kcl-openapi tool`, which maps OpenAPI specifications to KCL language features.
