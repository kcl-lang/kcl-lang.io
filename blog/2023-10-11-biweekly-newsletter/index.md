---
slug: 2023-10-11-biweekly-newsletter
title: KCL Biweekly Newsletter (2023 09.07 - 10.11) | v0.6.0 Is Out - Enhancement on IDE Extensions and Package Management!
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

Thank you to all contributors for their outstanding work over the past two weeks (09.07 - 10.11 2023). Here is an overview of the key content:

**🔧 Language and Toolchain Updates**

- **KCL v0.6.0 Release on 9/15** - Updates to the language, toolchain, and community integration. Detailed information could be found [here](/blog/2023-09-15-kcl-0.6.0-release/index.md).
- **KCL IDE Updates** - Supports for hover tooltips on standard library and built-in functions, and quick fixes for KCL code errors. And a plugin compatible with Intellij IDEA 2023.2 is released.
- **KCL Package Management Tool KPM Updates** - `kpm run` now could compile KCL files and embeded with the import tool.
- **KCL Documentation Tool Updates** - The docstring Examples section is added to the output documentation.
- **KCL Language Updates** - Optimized error message output and added suggestions for fixing some errors.

**📰 Official Website and Use Case Updates**

- KCL website adds v0.6.0 documentation version.
- More KCL model examples for containers, services, and Pod Security Policy (PSP): https://github.com/kcl-lang/krm-kcl/tree/main/examples

## Special Thanks

The following are listed in no particular order:

- Thanks to @jakezhu9 for contributing the KCL Import tool to convert Terraform Schema to KCL Schema 🙌 [https://github.com/kcl-lang/kcl-go/pull/152](https://github.com/kcl-lang/kcl-go/pull/152)
- Thanks to @jakezhu9 for contributing the integration of the Import tool to kpm 🙌 [https://github.com/kcl-lang/kpm/pull/194](https://github.com/kcl-lang/kpm/pull/194)
- Thanks to @zwpaper for contributions to KCL documentation and Tree Sitter Grammar 🙌 [https://github.com/kcl-lang/tree-sitter-kcl/pull/1](https://github.com/kcl-lang/tree-sitter-kcl/pull/1), etc.
- Thanks to @mrgleeco, @ghpu, @steeling, @prahaladramji, @zwpaper, and others for valuable feedback and discussions while using KCL and the toolchain 🙌

## Featured Updates

### IDE Extension Updates

In the recent v0.6.0 release, the KCL IDE plugin has enhanced on hover tooltips for the standard library and builtin functions, along with support for quick fixes for KCL code errors. Additionally, end-to-end tests for the language server and integration tests for the konfig repository have been added to ensure the stability and iteration of the IDE plugin. In the upcoming release, a new `kcl-language-server version` subcommand has been added to display version information. Please refer to [https://kcl-lang.io/docs/user_docs/getting-started/install/#2-install-kcl-ide-extension](https://kcl-lang.io/docs/user_docs/getting-started/install/#2-install-kcl-ide-extension) for instructions on how to upgrade and install the KCL IDE extension in various IDE platforms.

![](/img/docs/tools/Ide/vs-code/hover-built-in.png)

#### IntelliJ Plugin

Besides, the IntelliJ plugin is now compatible with version 2023.2+ and can be downloaded from the following link: [https://github.com/kcl-lang/intellij-kcl/releases](https://github.com/kcl-lang/intellij-kcl/releases)

### KCL Package Manager Updates

The kpm run command now supports compiling KCL files and has integrated an import tool. Additionally, the `--quiet` option has been added to suppress output logs.

![](/img/docs/tools/kpm/kpm-run-file.png)

### KCL Language Updates

In the upcoming release, the KCL compilation command has optimized error message output and added repair suggestions on some cases:

![](/img/blog/2023-10-11-kcl-biweekly-newsletter/error-suggestion.png)

### KCL Models Updates

In the past few weeks, we have provided more usage examples for configuring and validating containers, services, and Pod Security Policy (PSP).

- readonly-root-fs
- allowed-image-repos
- deny-all
- deny-endpoint-edit-default-role
- disallow-ingress-wildcard
- disallow-svc-lb
- disallow-svc-node-port
- disallowed-image-repos
- horizontal-pod-auto-scaler
- psp-allow-privilege-escalation
- psp-app-armor
- psp-capabilities
- psp-flexvolume-drivers
- required-image-digests
- required-probes
- validate-auto-mount-service-account-token
- validate-container-limits
- validate-container-requests
- validate-deprecated-api
- k8s_manifests_containers

You can refer to the corresponding examples to incorporate the above configurations and validations: [https://github.com/kcl-lang/krm-kcl/tree/main/examples](https://github.com/kcl-lang/krm-kcl/tree/main/examples). Now, let's explain using the Kubectl KCL plugin and the disallow-svc-lb model. The purpose of disallow-svc-lb is to validate Service resources and disallow the use of LoadBalancer as the Service type. Write the following YAML file (manifests.yaml):

```yaml
apiVersion: krm.kcl.dev/v1alpha1
kind: KCLRun
metadata:
  name: disallow-svc-lb
  annotations:
    krm.kcl.dev/version: 0.0.1
    krm.kcl.dev/type: validation
    documentation: >-
      A validation that prevents the creation of Service resources of type `LoadBalancer`
spec:
  source: oci://ghcr.io/kcl-lang/disallow-svc-lb
---
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - name: http
      protocol: TCP
      port: 80
  type: LoadBalancer # The service type is incorrectly set to LoadBalancer.
```

Using the Kubectl KCL tool for resource validation on the client-side, we will get the following result:

```shell
kubectl kcl apply -f manifests.yaml
```

The output is

```
A validation that prevents the creation of Service resources of type `LoadBalancer`, for Service: my-service
```

## Resources

❤️ Thanks to all KCL users and community members for their valuable feedback and suggestions in the community.

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)

- [KCL 2023 Roadmap](https://kcl-lang.io/docs/community/release-policy/roadmap)
- [KCL v0.7.0 Milestone](https://github.com/kcl-lang/kcl/milestone/7)
- [KCL Github Issues](https://github.com/kcl-lang/kcl/issues)
- [KCL Github Discussion](https://github.com/orgs/kcl-lang/discussions)
- [KCL Community](https://github.com/kcl-lang/community)
