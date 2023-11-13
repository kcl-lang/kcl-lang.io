---
slug: 2023-08-31-helmfile-kcl-plugin
title: 5-Minute Gameplay with Helmfile KCL Plugin for Easy Management of Kubernetes Helm Charts
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Biweekly-Newsletter]
---

## What is KCL

[KCL](https://github.com/kcl-lang) is an open-source, constraint-based record and functional language that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

## What is Helmfile

Helmfile is a declarative specification and tool for simplifying and managing Helm Charts. The Helmfile KCL Plugin provides additional functionality to the Helmfile tool, making it more convenient and efficient to use. With the Helmfile KCL Plugin, you can:

- Edit or validate Helm Chart configurations directly on the client-side using non-intrusive hooks. This allows you to separate the data and logic parts of Kubernetes configuration management without needing to fork the upstream Chart to modify internal logic include modifying resource labels/annotations and injecting Sidecar container configurations.
- Validate Kubernetes resources using KCL Schema, define your own abstract models, and share them for reusability.

In this blog, we will quickly guide you through getting started with the Helmfile KCL Plugin, enabling you to easily manage your Kubernetes Helm Charts.

We will explain in detail using a simple example. With the Helmfile KCL Plugin, you do not need to install any components related to KCL. You only need the latest version of the Helmfile tool (v0.156.0+) on your local machine.

## Using the Helmfile KCL Plugin

### 1. Tool Installation

First, make sure you have installed the Helmfile client tool. You can follow the instructions in the documentation link below.

https://github.com/helmfile/helmfile

### 2. Create the Helmfile Configuration File

Create a file named helmfile.yaml in the root directory of your project and write the configuration using Helmfile syntax. In this file, you can specify the Helm Charts to use, configuration values, and any other functionality supported by Helmfile. Additionally, you can use the features of the KCL Plugin in helmfile.yaml to load configurations and make in-place modifications and validations to the Helm Chart.

```yaml
repositories:
  - name: prometheus-community
    url: https://prometheus-community.github.io/helm-charts
releases:
  - name: prom-norbac-ubuntu
    namespace: prometheus
    chart: prometheus-community/prometheus
    set:
      - name: rbac.create
        value: false
    transformers:
      # Use KCL Plugin to mutate or validate Kubernetes manifests.
      - apiVersion: krm.kcl.dev/v1alpha1
        kind: KCLRun
        metadata:
          name: "set-annotation"
          annotations:
            config.kubernetes.io/function: |
              container:
                image: docker.io/kcllang/kustomize-kcl:v0.2.0
        spec:
          source: |
            # A single line of KCL code can be used to modify workload configurations in-place.
            items = [resource | {if resource.kind == "Deployment": metadata.annotations: {"managed-by" = "helmfile-kcl"}} for resource in option("resource_list").items]
```

In the above configuration, we reference the Prometheus Helm Chart and use a single line of KCL code to inject the label `managed-by="helmfile-kcl"` to all the Deployment resources of Prometheus.

### 3. Run the Helmfile Tool

Once everything is set up, you can run the Helmfile command to deploy, manage, and maintain your Helm Charts. Use the following command to apply the configuration mentioned above to the cluster.

```shell
helmfile apply
```

You should see the following output if everything goes well:

```shell
Adding repo prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories...

...
```

## Want More?

For the above helmfile configuration, you can encapsulate it as a reusable logic for configuration modification without constantly writing and copying/pasting KCL code. Additionally, many commonly used Kubernetes configuration editing and validation code snippets are already packaged in the KCL official Registry: https://github.com/orgs/kcl-lang/packages

![registry](/img/blog/2023-08-31-helmfile-kcl-plugin/registry.png)

In addition to supporting writing KCL code in configuration files, we also support directly referencing code snippets in Registry, as shown below

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: https-only
  annotations:
    krm.kcl.dev/version: 0.0.1
    krm.kcl.dev/type: validation
    documentation: >-
      Requires Ingress resources to be HTTPS only.  Ingress resources must
      include the `kubernetes.io/ingress.allow-http` annotation, set to `false`.
      By default a valid TLS {} configuration is required, this can be made
      optional by setting the `tlsOptional` parameter to `true`.
      More info: https://kubernetes.io/docs/concepts/services-networking/ingress/#tls
spec:
  # Use the OCI source
  source: oci://ghcr.io/kcl-lang/https-only
```

Specific example codes can be found [here](https://github.com/kcl-lang/krm-kcl/tree/main/examples)

If you want to contribute more KCL code repositories, feel free to contact us and refer to the documentation for contribution: https://kcl-lang.io/zh-CN/docs/user_docs/guides/package-management/share_your_pkg/

## Conclusion

This blog provided a quick getting started guide to help you master the basics of the Helmfile KCL Plugin in just 5 minutes. Now, you can start using this powerful tool to simplify and optimize your Kubernetes application deployment process!

## Resources

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.6.0 Milestone](https://github.com/kcl-lang/kcl/milestone/6)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
