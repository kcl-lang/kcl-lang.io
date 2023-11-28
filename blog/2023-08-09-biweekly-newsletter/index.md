---
slug: 2023-08-09-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 07.26 - 08.09) | KCL v0.5.1 and v0.5.2 is out!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest developments every two weeks, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

In the past two weeks (2023 07.26 to 08.09), a total of 34 PRs were merged in all KCL projects. Thanks to all contributors for their outstanding work. The following is a summary of the merged PRs.

- **🔧 Language and toolchain updates**
  - KCL document tool update - Markdown document export support
  - KCL import tool update - JsonSchema - KCL schema conversion support
  - KCL package management tool KPM supports setting compilation parameters in kcl.mod, optimizing command line prompts
  - KCL IDE extension autocomplete, jump, hover document display optimization and Vim and NeoVim KCL plugin support
- **🏄 API updates**
  - KCL Schema model parsing GetSchemaType API newly added decorator information and package information fields
- **🏠 Community extension updates**
  - Helmfile KCL plugin support
- **📰 Website and case updates**
  - KCL website adds v0.5.x document version selection
  - Add KCL use case repository: [https://github.com/kcl-lang/examples](https://github.com/kcl-lang/examples)

## Special Thanks

- Thanks to @jakezhu9 for contributing to the conversion of JsonSchema to KCL Schema in the KCL Import tool 🙌
- Thanks to @xxmao123 for contributing to Vim and NeoVim KCL plugins 🙌
- Thanks to @yyxhero for the help and support provided in Helmfile KCL plugin support 🙌
- Thanks to @nkabir, @mihaigalos, @prahaladramji, @dhhopen, etc. for their valuable suggestions and discussions on using KCL 🙌

## Featured Updates

### KCL Import Tool Update

On the basis of converting Protobuf, OpenAPI models, and Go structures into KCL Schema, the KCL Import tool adds support for converting JsonSchema to KCL Schema. For example, for the following JsonSchema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://example.com/schemas/customer.json",
  "type": "object",
  "$defs": {
    "address": {
      "type": "object",
      "properties": {
        "city": {
          "type": "string"
        },
        "state": {
          "$ref": "#/$defs/state"
        }
      }
    },
    "state": {
      "type": "object",
      "properties": {
        "name": {
          "type": "string"
        }
      }
    }
  },
  "properties": {
    "name": {
      "type": "string"
    },
    "address": {
      "$ref": "#/$defs/address"
    }
  }
}
```

After using the KCL Import tool, the output KCL code is as follows:

```python
schema Customer:
    """
    Customer

    Attributes
    ----------
    name: str, optional
    address: Address, optional
    """

    name?: str
    address?: Address

schema Address:
    """
    Address

    Attributes
    ----------
    city: str, optional
    state: State, optional
    """

    city?: str
    state?: State

schema State:
    """
    State

    Attributes
    ----------
    name: str, optional
    """

    name?: str
```

### Helmfile KCL Plugin

Helmfile is a declarative specification and tool for deploying Helm Charts. With the Helmfile KCL plugin, you can:

- Edit or verify Helm Chart through non-invasive hook methods, separating the data and logic parts of Kubernetes configuration management
  - Modify resource labels/annotations, inject sidecar container configuration
  - Use KCL schema to validate resources
  - Define your own abstract application models
- Maintain multiple environment and tenant configurations elegantly, rather than simply copying and pasting.

Here is a detailed explanation using a simple example. With the Helmfile KCL plugin, you do not need to install any components related to KCL. You only need the latest version of the Helmfile tool on your local device.

We can write a `helmfile.yaml` file as follows:

```yaml
repositories:
- name: prometheus-community
  url: https://prometheus-community.github.io/helm-charts

releases:
- name: prom-norbac-ubuntu
  namespace: prometheus
  chart: prometheus-community/prometheus
  set:
  - name: rbac.create
    value: false
  transformers:
  # Use KCL Plugin to mutate or validate Kubernetes manifests.
  - apiVersion: krm.kcl.dev/v1alpha1
    kind: KCLRun
    metadata:
      name: "set-annotation"
      annotations:
        config.kubernetes.io/function: |
          container:
            image: docker.io/kcllang/kustomize-kcl:v0.2.0
    spec:
      source: |
        [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "helmfile-kcl"}} for resource in option("resource_list").items]
```

In the above file, we referenced the Prometheus Helm Chart and injected the `managed-by="helmfile-kcl"` label into all deployment resources of Prometheus with just one line of KCL code. The following command can be used to deploy the above configuration to the Kubernetes cluster:

```shell
helmfile apply
```

For more use cases, please refer to [https://github.com/kcl-lang/krm-kcl](https://github.com/kcl-lang/krm-kcl)

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community. We will write more articles on the new features of KCL v0.5.x, so stay tuned!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
- [KCL v0.5.0 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.0)
- [KCL v0.5.1 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.1)
- [KCL v0.5.2 Release](https://github.com/kcl-lang/kcl/releases/tag/v0.5.2)
