---
slug: 2024-04-30-newsletter
title: KCL Newsletter (2024.04.17 - 2024.04.30)
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, Newsletter]
image: /img/biweekly-newsletter.png
---

![](/img/biweekly-newsletter.png)

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations and polices, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

This section will update the KCL language community's latest news, including features, website updates, and the latest community news, helping everyone better understand the KCL community!

**_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**

## Overview

Thanks to to all contributors for their outstanding work over the past twenty days (2024.04.04 - 2024.04.17). Here is an overview of the key content.

**🏄 Language Update**

- KCL has added support for the Alpine Linux and Fedora Linux platforms.
- Support for the evaluation of lambda closures.
- Fixed a bug of the union of schema instances failed within list comprehensions.
- Fixed the calling process error of lambda methods within schemas.
- Fixed a bug that APIs could not be found on the Windows system.
- Fixed a parallel compilation error caused by lock file failures.

**⛵️ API Update**

- OverrideFile API supports insertion of non-exist variables.

- Override API supports taking the variable name as one assignment value.

- Override API fixes configuration merge failure due to whitespace.

**🚪 CLI Update**

- Optimized the format of the output json.

**🔥 SDK Update**

- KCL Python SDK is released to pypi.

  **<https://pypi.org/project/kcl-lib/>**

- KCL Node JS SDK is released to npm.

  **<https://www.npmjs.com/search?q=kcl-lib>**
  
- KCL Java SDK is released to Github Package.

  **<https://github.com/orgs/kcl-lang/packages?repo_name=lib>**

**💻 IDE Update**
  
- KCL VScode supports the highlight of kcl.mod and kcl.mod.lock.
  
![kclmod](/img/blog/2024-04-30-biweekly-newsletter/kclmod.png)
![kclmodlock](/img/blog/2024-04-30-biweekly-newsletter/kclmodlock.png)

**📬️ KCL Package Management Tool Update**

- `downloader` is added for api to support custom three-party dependencies download process.

- Fixed an issue where the repository specified in the url was invalid when adding dependencies using the oci url.

- Fixed an issue where calling api output logs failed
  
**📦️ KCL Modules Update**
  
- Provide `Argo-cd-order` which is a module for ordering argocd sync operations.

- Provide crossplane-provider-gcp-upjet which is spec definition for crossplane-provider-upjet-gcp.

- crossplane is updated to version 1.15.2.
  
**📘 Doc Update**

- Added SDK related documents.

- Added rust api documentation.

- Added node-js api documentation.

- Updated the OverrideFile API spec specification.

- Added KCL Nix installation document.

- Add package management tool supports Registry list.

- Added more Q&A.

**🎈 Community**

- Viktor Farcic, a well-known KOL, YouTuber, and DevOpsToolkit channel manager, reviewed KCL and introduced KCL as a solution for how to better manage Kubernetes configuration lists and handle data structures.

![youtuber](/img/blog/2024-04-30-biweekly-newsletter/youtuber.png)

  The video link: **<https://www.youtube.com/watch?v=Gn6btuH3ULw>**

## Special Thanks

We'd like to thank all the community participants from the past two weeks.

The following are listed in no particular order:

- Thanks to @bozaro for the contribution to the KCL Go SDK 🙌
- Thanks to @jheyduk for the contribution to the Kubectl KCL plugin 🙌

-  
- Thanks to @shruti2522，@metacoma contribution to the KCL 🙌
- Thanks to @metacoma，@aleeriz contribution to the KCL modules 🙌
- Thanks to @XiaoK29 contribution to the KCL go SDK 🙌
- Thanks to @d4v1d03 contribution to the KCL Website Docs 🙌
- Thanks to @shruti2522 contribution to the KCL IDE 🙌
- Thanks to @Tom van Dinther contributions to Nix support for KCL Cli 🙌
- Thanks to @steeling, @Stephen C, @Henri Williams, @Hai Wu, @Even Solberg, @Sergey Ryabin, @Shashank Mittal @Abhishek and others for their valuable suggestions and feedback while using KCL recently 🙌

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
