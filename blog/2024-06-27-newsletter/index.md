---
slug: 2024-06-27-newsletter
title: KCL Newsletter (2024.06.12 - 2024.06.27)
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang/kcl) is an open-source configuration and policy language hosted by the Cloud Native Computing Foundation (CNCF) as a Sandbox Project. Built on a foundation of constraints and functional programming principles, KCL enhances the process of writing complex configurations, particularly in cloud-native environments. By leveraging advanced programming language techniques, KCL promotes improved modularity, scalability, and stability in configuration management. It simplifies logic writing, offers easy-to-use automation APIs, and seamlessly integrates with existing systems.

This section will update the KCL language community's latest news, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Special Thanks

Special thanks to all community contributors over the past two weeks. The following list is in no particular order:

- Thanks to @liangyuanpeng for feedback and test case completion for KCL bugs. 🙌
- Thanks to @MatisseB for contributing to the KCL PROTOC environment variable setting feature. 🙌
- Thanks to @DavidChevallier for contributing to the KCL argo-cd third-party library. 🙌
- Thanks to @kukacz for contributing to the KCL cluster-api-provider-metal3, cluster-api-provider-gcp, and other third-party libraries. 🙌
- Thanks to @dennybaa for contributing to the victoria-metrics-operator, istio, and other third-party libraries. 🙌
- Thanks to @ihor-hrytskiv for contributing to the jsonpatch third-party library. 🙌
- Thanks to @XiaoK29 for contributing to the kcl-go SDK. 🙌
- Thanks to @patrycju, @kukacz, @dennybaa, @LinYunling, @liangyuanpeng, @riven-blade, @bozaro, @MatisseB, @ealap, @tvandinther, @leon-andria, @Wes McNamee, @Uladzislau Maher, @M Slane, @Tom van Dinther, @Lukáš Kubín, @Mohamed Asif, @Sergei Iakovlev, @Korada Vishal, @Asish Kumar and others for their invaluable suggestions and feedback during the recent period of using KCL 🙌

## Overview

Thanks to all contributors for their outstanding work over the past two weeks (2024.06.12 - 2024.06.27). Here is an overview of the key content:

**📦️ Modules Updates**

- Added the cluster-api package version 0.1.1, which supports managing clusters through the cluster API.
- Added the cluster-api-provider-metal3 package, which supports managing Metal3 through the cluster API.
- Added the cluster-api-provider-gcp package, which supports managing GCP through the cluster API.
- Added the cluster-api-addon-provider-helm package, which supports managing helm charts through Addon.
- Added the cluster-api-addon-provider-aws package, which supports managing AWS through the cluster API.
- Added the cluster-api-provider-azure package, which supports managing Azure through the cluster API.
- Bump the k8s package version to 1.30.
- Bump the argo-cd package version to 0.1.1.
- Bump the victoria-metrics-operator package version to 0.45.1, add some check statement prompt information.
- Bump the istio package version to 1.21.2, adjust some check rules, and add documentation.
- Bump the jsonpatch package version to 0.0.5, support rfc6901Decode.

**🏄 Language Updates**

- Added centos7 amd64 build environment.
- Fix some typos in the code comments.
- Fix the issue of the cache of file.modpath and file.workdir causing performance degradation.
- Fix the issue some of the schema instance types with inheritance structures are recognized incorrectly.
- Fix the repeated execution of the branch part in multiple if statements.
- Fix the environment variable PROTOC setting issue.

**💻 IDE Updates**

- Added support for go to def of the schema parameter and schema return value in lambda expressions.
- Added support for the completion of importing internal packages in the IDE.
- Added support for the completion of the schema attributes in the IDE.
- Fix the issue of missing auto-completion prompts in expressions.
- Fix the issue of the kcl.mod modification not taking effect due to the cache.
- Fix the issue of the IDE incorrectly prompting the type of the schema attribute.
- Fix the long string highlighting issue.

**📬️ Toolchain Updates**

- Fix the issue of replacing default third-party dependencies with oci dependencies in kcl.mod for kpm.
- kcl-openapi use case update, fixed some compilation errors, and added a check for the existence of optional attribute values when adding schema.

**⛵️ API Updates**

- Fix the issue of inserting configuration errors with the OverrideFile API.
- ListVariable API supports compile-time configuration merging.

**🔥 SDK Updates**

- go SDK supports importing schema from go.
- go SDK cleans up some deprecated code and adds some tests.
- Java SDK aligns with API updates.

**📚️ Documentation Updates**

- Added the kcl doc generation html/markdown file format error solution.
- Added the solution to the compilation error caused by the package name in the import statement containing `-`.
- Adjusted the document use case to adapt to the update.

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
