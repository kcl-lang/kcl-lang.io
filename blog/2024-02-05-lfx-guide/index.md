---
slug: 2024-02-05-lfs-guide
title: 2024 LFX Mentorship Internship Launch:KCL Open Source Community Welcomes Your Participation!!!
authors:
  name: KCL Team
  title: KCL Team
tags: [KCL, LFX-Mentorship]
---

[KCL](https://github.com/kcl-lang) is a constraint-based record and functional language hosted by Cloud Native Computing Foundation (CNCF) that enhances the writing of complex configurations, including those for cloud-native scenarios. With its advanced programming language technology and practices, KCL is dedicated to promoting better modularity, scalability, and stability for configurations. It enables simpler logic writing and offers ease of automation APIs and integration with homegrown systems.

- **_KCL Website: [https://kcl-lang.io](https://kcl-lang.io)_**
- **_KCL Github Repo: [https://github.com/kcl-lang](https://github.com/kcl-lang)_**

For those interested in cloud-native, platform engineering,compiler, package management tools, and IDEs, we invite you to apply for the 2024 Spring Linux Foundation LFX Mentorship project. You can earn a minimum of $3000 for completing the project! Apply now!

## LFX Mentorship Project

We have three Mentorship projects, covering package management tools, compiler, and IDEs.

### 1. Add version management for KCL package management tool

KCL package management tool (kpm) currently supports uploading, downloading, and distributing KCL packages, but does not support version management of KCL packages. In the process of using kpm to add third-party dependencies to KCL package, kpm will automatically download all third-party dependencies based on the dependency relationship. If different versions of the same package appear during the download, the corresponding selection strategy should be provided according to the package version management policy to select the appropriate version for download.

In this project, you need to add the package version management part of kpm to ensure that kpm can select the appropriate third-party dependencies.

- More details: https://github.com/kcl-lang/kpm/issues/246
- Pretest: https://github.com/kcl-lang/kpm/issues/263
- Apply Link: https://mentorship.lfx.linuxfoundation.org/project/06b5baee-bdcd-4f5e-9a1a-454191445a01

### 2. KCL IDE Quick Fix

For KCL IDE, develop a quick fix feature. When a KCL program has a compilation error in the IDE, the Quick Fix feature can provide quick problem fixes at the location of the KCL program error based on the user's error type.

In this project, you need to develop different Quick Fix functions for IDE based on the error type of the KCL program.

- More Details: https://github.com/kcl-lang/kcl/issues/997
- Pretest: https://github.com/kcl-lang/kcl/issues/1020
- Apply Link: https://mentorship.lfx.linuxfoundation.org/project/391edda7-239d-4471-a36a-c03c24e024cb

### 3. KCL IDE automatically loads KCL third-party dependencies

KCL IDE is the most direct interface for KCL users. It often fails to find third-party dependencies. Currently, KCL's package management tool kpm has provided the ability to automatically download and update third-party dependencies, but users still need to update third-party libraries through the command line, which affects the user's development experience. Therefore, KCL IDE needs to be integrated with KCL's package management tool kpm to provide the ability to automatically download and update third-party libraries for the IDE.

In this project, you need to use the ability of kpm to implement common functions in the IDE, such as automatically downloading third-party dependencies, automatically updating third-party dependencies when kcl.mod changes, and Quick Fix triggering third-party dependencies automatic download, to ensure that KCL IDE can provide a more complete development experience with the support of package management tools.

- More Details: https://github.com/kcl-lang/kcl/issues/998
- Pretest: https://github.com/kcl-lang/kcl/issues/1031
- Apply Link: https://mentorship.lfx.linuxfoundation.org/project/59d5fb6c-153d-4e46-9d1f-2948641b0471

### 4. How to Apply

Apply for your favorite project on the LFX mentorship platform. You can visit the LFX mentorship platform through the following link. The application starts on January 29, 2024, and ends on February 13, 2024.

- https://mentorship.lfx.linuxfoundation.org/

If you have any questions, please feel free to get more information directly from the corresponding issue or discuss with us:

- KCL package version management https://github.com/kcl-lang/kpm/issues/246

- KCL Quick Fix https://github.com/kcl-lang/kcl/issues/997

- KCL IDE dependency update https://github.com/kcl-lang/kcl/issues/998

### 5. Project Timeline

| Event                                                                                                      | Start Date                    | End Date                 |
| ---------------------------------------------------------------------------------------------------------- | ----------------------------- | ------------------------ |
| Mentee Applications Open                                                                                   | January 29                    | February 13, 5:00 PM PDT |
| Application Review/Admission Decisions/HR Paperwork                                                        | February 13                   | February 27, 5:00 PM PDT |
| Mentorship Program Begins with Initial Work Assignments                                                    | March 4 (Week 1)              |                          |
| Midterm Mentee Evaluations / First Stipend Payments                                                        | April 10 (Week 6)             |                          |
| Final Mentee Evaluations Due / Mentee Feedback Submission Due / Second and Final Stipend Payment Approvals | May 22, 5:00 PM PST (Week 12) |                          |
| Last Day of Term                                                                                           | May 31                        |                          |
