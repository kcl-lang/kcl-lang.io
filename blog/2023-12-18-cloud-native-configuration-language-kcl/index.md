---
slug: 2023-12-18-cloud-native-configuration-language-kcl
title: Cloud Native Configuration and Policy Language - KCL
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Meeting]
---

> This blog is a review of the content of the KCL language part of the speech at the 2023 CNCF KCD ShenZhen meeting by KusionStack leader Dayuan Li and KCL project Maintainer Zhe Zong. The main content of this article is a review of the content of the KCL language part of the speech, the activity link: [https://community.cncf.io/events/details/cncf-kcd-hangzhou-presents-kcd-shenzhen-2023/](https://community.cncf.io/events/details/cncf-kcd-shenzhen-presents-kcd-shenzhen-2023/)

## In the cloud-native era, infrastructure as code (IaC) is the core of developer experience

In today's rapidly developing technical world, infrastructure as code (IaC) has become the key to automating and managing cloud resources, and IaC has also become the core part of developer experience, bringing convenience and efficiency, but it also brings a series of challenges.

![intro-iac-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/intro-iac-en.png)

First of all, application developers need to face the complex infrastructure and platform concepts provided by k8s, which has caused a high cognitive burden and affected the software delivery experience of higher-level application developers.

Therefore, we urgently need a way to reduce the cognitive burden of developers, provide efficient dynamic configuration management, and ensure the reliability of configuration through standard configuration testing and verification methods to ensure the efficiency and security of infrastructure.

## Cloud Native Configuration and Policy Language - KCL

So we tried to design a new configuration language KCL to solve many of the problems mentioned above by designing the language syntax and enhancing the surrounding tools.

![intro-kcl-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/intro-kcl-en.png)

KCL language starts from the three aspects of **dynamic configuration management**, **configuration reliability verification and testing** and **reducing developer cognitive burden** mentioned above. We propose three main design concepts, **Mutation**, **Validation** and **Abstraction**, and we also use these three design concepts as the core slogan of KCL homepage.

Around the three design concepts, KCL has done some design on the language syntax:

- To use KCL for dynamic configuration management, the language side needs to provide syntaxes such as flow control and lambda expressions that can describe program behavior.
- To do configuration reliability related verification and testing: you need to give this language the ability to check the configuration content through a strong type system, assert, check and other syntaxes to support the testing and verification process.
- To reduce developer cognitive burden and development cost: KCL provides a `Schema` model to abstract the data structure. For developers, it shields unnecessary fields, and provides rich third-party library resources through the package management mechanism, reducing the cost of developers directly writing models.

## KCL language features

I have listed some small code snippets that can reflect the language features in the ppt:

![kcl-feature-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-feature-en.png)

At first, the leftmost picture shows the flow control, lambda expression, and python-style loop expression that are similar to general-purpose programming languages. Then, the middle picture shows the assert statement provided for verification and testing, and the check block of the schema. Through the strategy written in check, the fields in the schema can be checked. Finally, the rightmost picture is to use the schema to define the data structure and instantiate the configuration. And you can see that in this example, the strong type system of KCL has also demonstrated the ability to check the configuration type. If the type of a field is written incorrectly in the process of instantiating the configuration using the schema, the error will be checked at the compilation stage. The last picture is to use the third-party library of k8s to create an nginx pod. Some unnecessary fields have been shielded, and the application developer only needs to fill in a few fields to complete the configuration writing.

## KCL & KRM & Dynamic Configuration Management

KCL provides some dynamic behaviors such as check, assert statements, type system, Schema abstraction, etc. However, when we try to use the above features for configuration management, we find that the language features of KCL alone are not enough. To solve the problems in the IaC field, we must also consider the stock configuration. It is obviously not a suitable way to push down all the stock configurations and use KCL to rebuild them, and it cannot be realized.

Therefore, in addition to working on language mechanisms, we also need to have the ability to integrate with the community ecology to make the role of KCL language features play on other configuration languages, so that KCL can truly solve the problems in the IaC field. Under the premise of minimizing the changes to the stock configuration, give full play to the role of KCL language features, and solve the problems of dynamic configuration, reliability verification, and reducing the cognitive burden of developers.

![kcl-krm-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-krm-en.png)

Therefore, we proposed the [KCL KRM specification](https://github.com/kcl-lang/krm-kcl), based on this specification, we can use the capabilities of the KCL language to dynamically configure, verify and abstract the resources in KRM.

## KCL Ecological Integration

Based on the KCL & KRM specification, we have developed some peripheral tools to better integrate KCL with the surrounding tool ecology.

![kcl-integration-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-integration-en.png)

- Data structure import and export: KCL provides import/export tools, which support using KCL to import/export data structures from JsonSchema, Terraform, etc., to reduce the process of duplicating data modeling in the development process, and make KCL effect is applied to stock configuration.
- Plugins: KCL provides plugins for tools such as kubectl, kustomize, helm/helmfile, etc. Users can choose the appropriate engine such as Kubectl, KusionStack, KubeVela or Helmfile according to different scenarios to combine with KCL to make the configuration effective to the cluster.
- KCL Operator: Developed [KCL Operator](https://github.com/kcl-lang/kcl-operator) to integrate with Kubernetes, and automatically modify the configuration at runtime without the need to repeatedly develop Kubernetes Webhook to write a large amount of configuration processing logic.

KCL is built in a completely open cloud-native world. KCL is almost not strongly bound to any orchestration/engineering tools, and can provide API abstraction, combination and verification capabilities for both clients and runtimes at the same time.

## KCL Toolchain

Although KCL is a domain language. KCL also provides a toolchain that is basically equivalent to the capabilities of general programming languages, such as formatting, testing, documentation , package management tools, etc. to help better write, understand and check the written configuration or strategy; through VS Code and other IDE plug-ins and Playground to reduce the cost of configuration writing and sharing; through Rust, Go, and Python multi-language SDK to automate the management and execution of configuration.

For IDE plug-ins, KCL currently mainly provides VS Code, IntelliJ and NeoVim. The three IDE plug-ins are based on the same KCL Language Server to implement the same capabilities such as completion, jump, hover, code refactoring, and formatting.

![kcl-tools-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-tools-en.png)

## **Artifacthub & KCL**

KCL has been integrated with ArtifactHub, which is used as the model market of KCL, providing more than 200+ KCL models, covering multiple aspects such as configuration editing, verification and model abstraction. If you are interested, you can take a look at whether there are models you are interested in, or if you have good ideas to share with everyone, you can also contribute your KCL package to ArtifactHub.

![kcl-ah-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-ah-en.png)

## Some practical cases

Finally, I will show some simple cases to of the use of KCL.

![kcl-mut-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-mut-en.png)

At first, if the KCL Operator is installed in the cluster, then the configuration on the right can be mutated through the configuration file on the left. The behavior code is written in KCL in the source field, and the annotation is dynamically added to the configuration file on the right.

![kcl-vet-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-vet-en.png)

Then, in this case, the configuration content generated by terraform plan is verified using the configuration verification tool kcl-vet provided by KCL.

![kcl-abs-en.png](/img/blog/2023-12-18-cloud-native-configuration-language-kcl/kcl-abs-en.png)

Finally, in this case, the abstraction of the configuration is demonstrated. We can get the Kubernetes manifests by directly writing the KCL program, or by writing the configuration using KCL & KRM and compiling it into the corresponding Kubernetes manifests.

## Summary

KCL language is a domain language focusing on cloud-native configuration management. It provides a series of language features, such as strong type system, Schema abstraction, flow control, lambda expression, assert statement, check statement, etc., to solve the problems in the cloud-native configuration management field, such as dynamic configuration management, configuration reliability verification and testing, and reducing developer cognitive burden. At the same time, KCL also provides a series of peripheral tools, such as IDE plug-ins, ArtifactHub integration, KCL Operator, etc., to improve the development experience of developers and reduce development costs.

## Other Resources

For more information about KCL, please refer to:

- [KCL HomePage](https://kcl-lang.io/)
- [KCL GitHub Repo](https://github.com/kcl-lang/)
- [KusionStack HomePage](https://kusionstack.io/)
- [KusionStack GitHub Repo](https://github.com/KusionStack/)
