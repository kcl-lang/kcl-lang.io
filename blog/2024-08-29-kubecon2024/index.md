---
slug: 2024-08-29-kubecon2024
title: KCL at KubeCon China 2024
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

# KCL at KubeCon China 2024

At KubeCon China 2024, held from August 21st to 23rd, a 3-day event in Hong Kong, KCL participated in the event and shared its efforts in simplifying Kubernetes manifests management.

## Lighting Talk: KCL: Simplifying Kubernetes Manifests Management

The Lighting Talk PPT: [Download PDF](https://kcl-lang.io/talks/kcl-kubecon2024-lighting-talk.pdf)

![pptcover](img/blog/2024-08-29-kubecon2024/pptcover.png)

In this event, KCL introduced its efforts in simplifying Kubernetes manifests management, improving configuration management efficiency and stability through a Lighting Talk.

![kcllightingtalk](/img/blog/2024-08-29-kubecon2024/kcllightingtalk.png)

KCL is a domain-specific language (DSL) in IaC, mainly solving common issues such as **configuration scale explosion, high cognitive load, lack of effective dynamic configuration management, and configuration reliability assurance**, and can easily integrate with the community ecosystem.

For the effective reduction of configuration scale, KCL provides a **Schema to abstract common configuration structures**, and supports the distribution and reuse of configuration structures through package management mechanisms. Moreover, KCL can **merge the content of the same configuration in multiple files** to shield developers from unnecessary unfamiliar concepts and reduce cognitive load. As a language project, the **rich toolchain and powerful IDE** also greatly improve the development experience of developers.

![ppt1](/img/blog/2024-08-29-kubecon2024/ppt1.png)

KCL supports dynamic configuration management and provides two ways of **declarative** and **imperative** configuration management. Developers can write imperative code generation configurations in the code through **if/for/lambda expressions**.

![ppt2](/img/blog/2024-08-29-kubecon2024/ppt2.png)

KCL also supports **declarative configuration merge/override operators** to merge and override different configuration blocks and fields.

![ppt3](/img/blog/2024-08-29-kubecon2024/ppt3.png)

KCL improves the reliability of configuration through **type system**, **testing**, and **rule verification**. KCL, as a **type-safe configuration language**, can expose a large number of type errors in advance at the compilation stage, and developers can get error in the IDE.

![ppt4](/img/blog/2024-08-29-kubecon2024/ppt4.png)
![ppt5](/img/blog/2024-08-29-kubecon2024/ppt5.png)

At the same time, the most simple and effective method of software reliability assurance, **testing**, is also supported in KCL, and you can write unit tests for configuration content through lambda.

![ppt6](/img/blog/2024-08-29-kubecon2024/ppt6.png)
![ppt7](/img/blog/2024-08-29-kubecon2024/ppt7.png)

At last, **writing validation rules to check the configuration content** has always been a common topic in IaC, and KCL supports writing corresponding configuration verification rules through **Assert/Check/Rule** features to verify the configuration content.

![ppt8](/img/blog/2024-08-29-kubecon2024/ppt8.png)

KCL provides SDKs for 12 languages, supports integration with most projects, and supports extension of KCL language capabilities through plugin mechanisms. KCL also provides KCL-Operator to support validation, update, and generation of resources in Kubernetes clusters through KCL language. With the above capabilities, KCL can easily integrate with community tools such as Crossplane and ArgoCD, etc.

## KCL & Crossplane: A Very Nice Conversation

KCL also had a very nice conversation with partners from the Crossplane community, who also brought us wonderful sharing.

Crossplane is an open-source project designed to extend Kubernetes with the capability to manage not only containerized applications but also cloud resources across multiple providers. It acts as a universal control plane, enabling users to provision and manage infrastructure using Kubernetes-native APIs.

![crossplaneppt1](/img/blog/2024-08-29-kubecon2024/crossplaneppt1.png)

In this sharing, Crossplane mentioned the importance of exposing problems as early as possible in the software development lifecycle.

![crossplaneppt2](/img/blog/2024-08-29-kubecon2024/crossplaneppt2.png)

Crossplane also mentioned how to use KCL to improve the reliability of configuration in the process of ensuring configuration reliability.

![crossplaneppt3](/img/blog/2024-08-29-kubecon2024/crossplaneppt3.png)

KCL can be used to write corresponding test cases for configuration through KCL to expose problems in the configuration as early as possible.

![crossplaneppt4](/img/blog/2024-08-29-kubecon2024/crossplaneppt4.png)

KCL and Kusionstack communities also had a nice conversation with the Crossplane community, and look forward to more cooperations in the future.

![photo](/img/blog/2024-08-29-kubecon2024/photo.png)

## Other Resources

For more information about KCL, please refer to:

- [KCL HomePage](https://kcl-lang.io/)
- [KCL GitHub Repo](https://github.com/kcl-lang/)
- [KusionStack HomePage](https://kusionstack.io/)
- [KusionStack GitHub Repo](https://github.com/KusionStack/)
