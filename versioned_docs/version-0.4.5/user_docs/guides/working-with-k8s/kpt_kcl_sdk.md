# KPT KCL SDK

[kpt](https://github.com/GoogleContainerTools/kpt) is a package-centric toolchain that enables a configuration authoring, automation, and delivery experience, which simplifies managing Kubernetes platforms and KRM-driven infrastructure (e.g., Config Connector, Crossplane) at scale by manipulating declarative Configuration as Data for automating Kubernetes configuration editing including transforming and validating.

KCL can be used to create functions to transform and/or validate the YAML Kubernetes Resource Model (KRM) input/output format, but we provide KPT KCL SDKs to simplify the function authoring process.

## Prerequisites

+ Install [kpt](https://github.com/GoogleContainerTools/kpt)
+ Install Docker

## Quick Start

Let’s write a KCL function which add annotation `managed-by=kpt` only to Deployment resources.

## Get the Example

```bash
git clone https://github.com/KusionStack/kpt-kcl-sdk.git/
cd ./kpt-kcl-sdk/get-started/set-annotation
```

## Show the KRM

```bash
kpt pkg tree
```

The output is

```bash
set-annotation
├── [kcl-fn-config.yaml]  KCLRun set-annotation
└── data
    ├── [resources.yaml]  Deployment nginx-deployment
    └── [resources.yaml]  Service test
```

## Update the `FunctionConfig`

```yaml
# kcl-fn-config.yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata: # kpt-merge: /set-annotation
  name: set-annotation
spec:
  # EDIT THE SOURCE!
  # This should be your KCL code which preloads the `ResourceList` to `option("resource_list")
  source: |
    [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "kpt"}} for resource in option("resource_list").items]
```

## Test and Run

Run the KCL code via kpt

```bash
# Note: you need add sudo and --as-current-user flags to ensure KCL has permission to write temp files in the container filesystem.
sudo kpt fn eval ./data -i docker.io/peefyxpf/kpt-kcl:v0.1.0 --as-current-user --fn-config kcl-fn-config.yaml

# Verify that the annotation is added to the `Deployment` resource and the other resource `Service` 
# does not have this annotation.
cat ./data/resources.yaml | grep annotations -A1 -B5
```

## More Documents and Examples

+ [KPT KCL SDK](https://github.com/KusionStack/kpt-kcl-sdk)
