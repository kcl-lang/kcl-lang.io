---
slug: 2024-04-03-newsletter
title: KCL Newsletter (2024 03.20 - 2024.04.03)
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

Thanks to to all contributors for their outstanding work over the past twenty days (2024 03.06 - 2024 03.20). Here is an overview of the key content:

Certainly! Here's the translation for the provided content:

**🏄 Language Updates**
**Release of versions 0.8.3 and 0.8.4 for KCL**

The mainly updates:

- Added file system built-in methods `file.abs` to compute the absolute file path and `file.exists` to determine if a file exists.

**🔧 Toolchain Updates**

- KCL package manager: Added support for oci URLs in the `kcl.mod` file.
- KCL package manager: Removed updates of indirect dependencies in `kcl.mod`.
- KCL package manager: Removed checksum verification for local dependencies.
- KCL package manager: Fixed an issue where local dependency version numbers were missing.
- KCL package manager: Fixed the issue of missing local dependencies.
- KCL package manager: Fixed an internal bug that caused the creation of symbolic links to fail.

**🔥 SDK Updates**

- Release of version 0.8.3 for the KCL Go SDK.
- KCL Go SDK fixed a panic issue that occurred during the ParseFile process.
- KCL Go SDK supports setting the kcl compiler automatic download through environment variables.

## Special Thanks

We'd like to thank all the community participants from the past two weeks.

the following are listed in no particular order:

- Thanks to @bozaro for the contributions to the KCL Go SDK 🙌
- Thanks to @reckless-huang, @steeling, @vfarcic, @wilsonwang371, and others for their valuable suggestions and feedback during the recent use of KCL 🙌

## Resources

❤️ See [here](https://github.com/kcl-lang/community) to join us!

For more resources, please refer to

- [KCL Website](https://kcl-lang.io/)
- [KusionStack Website](https://kusionstack.io/)
- [KCL v0.9.0 Milestone](https://github.com/kcl-lang/kcl/milestone/9)
