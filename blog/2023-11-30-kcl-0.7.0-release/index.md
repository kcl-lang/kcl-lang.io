---
slug: 2023-09-15-kcl-0.7.0-release
title: KCL v0.7.0 Release Blog
authors:
  name: KCL Team
  title: KCL Team
tags: [Release Blog, KCL]
---

## Introduction

The KCL team is pleased to announce that KCL v0.7.0 is now available! This release has brought three key updates to everyone: **Language**, **Tools**, and **Integrations**.

- _Use KCL language, tools and IDE extensions with more complete features and fewer errors to improve code writing experience and efficiency._

- _The new KCL cli integrates KCL package management, doc, test and other peripheral ecosystems._

- _The rich KCL third-party library market artifacthub.io provides more than 200 KCL third-party libraries for you to choose from._

KCL v0.7.0 is now available for download at [KCL v0.7.0 Release Page](https://github.com/kcl-lang/kcl/releases/tag/v0.7.0) or [KCL Official Website](https://kcl-lang.io).

[KCL](https://github.com/kcl-lang/kcl) is an open-source, constraint-based record and functional language. KCL improves the writing of numerous complex configurations, such as cloud-native scenarios, through its mature programming language technology and practice. It is dedicated to building better modularity, scalability, and stability around configurations, simpler logic writing, faster automation, and great built-in or API-driven integrations.

This blog will introduce the content of KCL v0.7.0 and recent developments in the KCL community to readers.

## Language Updates

### ⭐️ New KCL Cli

When compiling, use `kcl`, when downloading packages, use `kpm`, if you have a KCL model that you want to send to the cluster, you also need to use `kusion`, kcl is the compilation command, `kpm run` can also be compiled, I also found `kusion compile` in the kusion command line, do you have the same confusion, what is the relationship between these tools? How do I use them?

For this reason, we provide you with a new KCL cli, the goal is to include the KCL ecosystem together, to provide you with a unified and concise operation page, everything, one-click direct.

The new KCL cli will continue to use `kcl` as the command prefix, and currently provides multiple sub-commands including compilation, package management, and formatting tools.

![cli-help](/img/blog/2023-11-30-kcl-0.7.0-release/cli-help.png)

### 🔧 Diagnostic Information Optimization

We have tried to add repair suggestions in some error messages. If you are frustrated by the KCL compilation failure, you may wish to listen to the compiler's suggestions.

```
import sub as s1

The_first_kcl_program = s.The_first_kcl_program
```

Let's listen to what the compiler says. You may have written `s1` as `s` by mistake.

![did you mean](/img/blog/2023-11-30-kcl-0.7.0-release/did-you-mean.png)

KCL cannot find the third-party library used in the package? Try `kcl mod add`, if it still doesn't work, we have prepared more than 200 KCL models for you on artifacthub.io, come and have a look, there is always one that suits you!

![try-kcl-mod-add](/img/blog/2023-11-30-kcl-0.7.0-release/try-kcl-mod-add.png)

### 🚀 Language Writing Experience Optimization

#### Removed indentation check in some code blocks

In some code blocks, whether the indentation is aligned has become less important. 

If your code is written like this

```
schema TestIndent:
    name: str
    msg: str
    id: int

test_indent = TestIndent {
                    name = "test"
  msg = "test"
              id = 1
}
```

In the past, you may have encountered a lot of red errors, but now this is not a mistake, `kcl fmt` will help you tidy it up.

![kcl-fmt](/img/blog/2023-11-30-kcl-0.7.0-release/kclfmt.gif)

#### Lambda expression type annotation

In the new version of KCL, we have added type annotations for lambda expressions, and you can write lambda with type annotations in the new version of KCL.

```
import sub as s

identity: (s.Test) -> s.Test = lambda res: s.Test {
  res {
    name = "world"
  }
}

c = identity(s.Test{name="hello"})
```

### 🏄 API Updates

- New KCL unit test API: https://github.com/kcl-lang/kcl/pull/904

- KCL schema parsing API enhancement version `GetFullSchemaType` supports obtaining KCL package related information with third-party libraries

### 🐞 Error Fixes

- Fix the type inference error of dictionary types https://github.com/kcl-lang/kcl/pull/900

- Fix the check of Schema parameters https://github.com/kcl-lang/kcl/pull/877/files

- Fix the problem that the compilation cache of KCL programs with third-party libraries is invalid https://github.com/kcl-lang/kcl/pull/841

- In the error message, complete the missing lambda type information https://github.com/kcl-lang/kcl/pull/771

- Fix the problem of singular and plural in diagnostic information https://github.com/kcl-lang/kcl/pull/769

- Fix the problem that the type check is invalid in the assignment statement with type annotation https://github.com/kcl-lang/kcl/pull/757

- Add a check to prohibit duplicate import statements https://github.com/kcl-lang/kcl/pull/727

## Toolchain Updates

### Test Tool Updates

Are you worried that your KCL program is written incorrectly? Why not come and test it? This update provides a new KCL test tool. 

The new KCL test tool supports writing unit tests using KCL lambda and executing tests using the tool.

You can write your test cases through lambda expressions in the file with the suffix `_test.k`.

```
import manifests

import .app

# Convert the `App` model into Kubernetes Deployment and Service Manifests
test_kubernetesRender = lambda {
    a = app.App {
        name = "app"
        containers.ngnix = {
            image = "ngnix"
            ports = [{containerPort = 80}]
        }
        service.ports = [{ port = 80 }]
    }
    deployment_got = kubernetesRender(a)
    assert deployment_got[0].kind == "Deployment"
    assert deployment_got[1].kind == "Service"
}
```

You can run this test case and view the test results through `kcl test`.

After the test is passed, you will get the following results:

![test-pass](/img/blog/2023-11-30-kcl-0.7.0-release/test-pass.png)

If your test fails, `kcl test` will output error information to help you troubleshoot the problem.

![test-failed](/img/blog/2023-11-30-kcl-0.7.0-release/test-failed.png)


### KCL Package Management

The `update` command is added to the `kcl mod` command. The `update` command is used to automatically update local dependencies. `kcl mod update` will automatically download the missing third-party libraries for you. For details, please refer to: https://github.com/kcl-lang/kpm/pull/212

### KCL Import Tool

The KCL Import tool supports one-click generation of KCL configuration/models from YAML/JSON/CRD/Terraform Schema, realizing automated migration.

If you have the following yaml file:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

You can convert it to a KCL program through the command `kcl import test.yaml`.

```
"""
This file was generated by the KCL auto-gen tool. DO NOT EDIT.
Editing this file might prove futile when you re-run the KCL auto-gen generate command.
"""

apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx-deployment"
    labels = {
        app = "nginx"
    }
}
spec = {
    replicas = 3
    selector = {
        matchLabels = {
            app = "nginx"
        }
    }
    template = {
        metadata = {
            labels = {
                app = "nginx"
            }
        }
        spec = {
            containers = [
                {
                    name = "nginx"
                    image = "nginx:1.14.2"
                    ports = [
                        {
                            containerPort = 80
                        }
                    ]
                }
            ]
        }
    }
}
```

More details: https://kcl-lang.io/docs/user_docs/guides/working-with-k8s/adopt-from-kubernetes

## Community Integrations & Extensions Updates

### KCL Marketplace artifacthub.io

Through the integration of artifacthub.io, we have built a KCL third-party library market, where you can share your KCL programs with us. You can also choose freely and find the KCL third-party library that suits you!

Open the homepage of artifacthub.io, search for the keyword you need directly, and you can see the relevant content about the KCL third-party library!

![artifachub-index](/img/blog/2023-11-30-kcl-0.7.0-release/artifachub-index.png)

Click on the third-party library homepage, you can view the detailed content and related documents about the third-party library.

![pkg-page](/img/blog/2023-11-30-kcl-0.7.0-release/pkg-page.png)

If you don't know how to use these third-party libraries, the button on the right can bring up the installation page for you.

![install-pkg](/img/blog/2023-11-30-kcl-0.7.0-release/install-pkg.png)

Welcome to contribute your third-party libraries to the KCL community on artifacthub.io and make the KCL community more colorful!

Contributing to KCL Marketplace: https://kcl-lang.io/docs/user_docs/guides/package-management/how-to/publish_pkg_to_ah

## Other Updates

The Full Update and Error Fix List of KCL v0.7.0 can be found at: https://github.com/kcl-lang/kcl/compare/v0.6.0...v0.7.0

## Document Updates

The versioning semantic option is added to the [KCL website](https://kcl-lang.io/). Currently, v0.4.x, v0.5.x, v0.6.x and v0.7.0 versions are supported.

## Community Updates

### KCL Officially Becomes CNCF Sandbox Project

🎉 🎉 🎉 On September 20, 2023, the KCL project passed the evaluation of the Technical Oversight Committee of the Cloud Native Computing Foundation (CNCF), the world's top open source foundation, and officially became a CNCF sandbox project.

More details - https://kcl-lang.io/blog/2023-09-19-kcl-joining-cncf-sandbox/

### Thanks to the community for their contributions

- Thanks to @jakezhu9 for his contribution to the KCL Import tool Terraform Schema to KCL Schema conversion 🙌 _[https://github.com/kcl-lang/kcl-go/pull/152](https://github.com/kcl-lang/kcl-go/pull/152)_

- Thanks to @jakezhu9 for his contribution to the KCL Import tool Terraform Schema to KCL Schema conversion _[https://github.com/kcl-lang/kpm/pull/194](https://github.com/kcl-lang/kpm/pull/194)_

- Thanks to @jakezhu9 for his contribution to the KCL Import tool Terraform Schema to KCL Schema conversion 🙌 _[https://github.com/kcl-lang/tree-sitter-kcl/pull/1](https://github.com/kcl-lang/tree-sitter-kcl/pull/1)_ 

- Thanks to @jakezhu9 for his contribution to the KCL Import tool Terraform Schema to KCL Schema conversion 🙌 _[https://github.com/kcl-lang/kcl/pull/794](https://github.com/kcl-lang/kcl/pull/794)_

- Thanks to @opsnull for his correction and contribution to the code examples in the KCL official website documentation 🙌 _[https://github.com/kcl-lang/kcl-lang.io/pull/182](https://github.com/kcl-lang/kcl-lang.io/pull/182)_

- Thanks to @prahaladramji for his correction and optimization of the KCL IntelliJ plugin formatting function 🙌 _[https://github.com/kcl-lang/intellij-kcl/pull/15](https://github.com/kcl-lang/intellij-kcl/pull/15)_

- Thanks to @jakezhu9 for his improvement of the KCL syntax parsing unit test, and unified some test cases to use the snaptest framework 🙌 _[https://github.com/kcl-lang/kcl-go/pull/170](https://github.com/kcl-lang/kcl-go/pull/170)_ 

- Thanks to @liangyuanpeng for his contribution of the karmada model package to the KCL model 🙌 _[https://github.com/kcl-lang/artifacthub/pull/48/files](https://github.com/kcl-lang/artifacthub/pull/48/files)_

- Thanks to @mrgleeco, @ghpu, @steeling, @prahaladramji, @zwpaper and others for their valuable feedback and discussion in the use of KCL and toolchain 🙌

## Next Steps

- We expect to release KCL v0.8.0 in November 2023. For more details, please refer to KCL 2024 Roadmap and KCL v0.8.0 Milestone. If you have more ideas and needs, please feel free to raise Issues or Discussions in the KCL Github repository, and welcome to join our community for discussion 🙌 🙌 🙌

- KCL 2024 Roadmap: https://kcl-lang.io/docs/community/release-policy/roadmap
- KCL v0.8.0 Milestone: https://github.com/kcl-lang/kcl/milestone/8
- KCL GitHub Issues: https://github.com/kcl-lang/kcl/issues
- KCL GitHub Discussion: https://github.com/orgs/kcl-lang/discussions
- KCL Community: https://github.com/kcl-lang/community

## Additional Resources

For more information, see [KCL FAQ](https://kcl-lang.io/docs/user_docs/support/).

## Resources

Thank all KCL users for their valuable feedback and suggestions during this version release. For more resources, please refer to:

- [KCL Website](https://kcl-lang.io/)
- [Kusion Website](https://kusionstack.io/)
- [KCL Repo](https://github.com/kcl-lang/kcl)
- [Kusion Repo](https://github.com/KusionStack/kusion)

See the [community](https://github.com/kcl-lang/community) for ways to join us. 👏👏👏

