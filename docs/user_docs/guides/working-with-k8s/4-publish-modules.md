---
title: "Publish Kubernetes Modules"
sidebar_position: 4
---

## Introduction

The community KCL module registry is located at [Artifact Hub](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1) and welcomes participation at the [GitHub repository](https://github.com/kcl-lang/artifacthub) using pull requests. This section explains how to publish Kubernetes modules and work with the module registry.

> NOTE: If you want to publish your KCL modules to the `kcl-lang` official registry, then the source code of your KCL modules will be saved in this repo, you need to submit the source code of your module to this repository via PRs. But KCL also makes it possible to create and run your own kcl module registry such as OCI registries e.g., Docker Hub, Github Packages and Harbor, etc.

> NOTE: The KCL module does not limit your configuration or policy code content. It can be a workload configuration for applications like Helm Chart, or it can be a Kubernetes validation code or a general code library. However, we strongly recommend that you provide a brief introduction and usage of a kcl module in the documentation.

## Prerequisite

+ Install [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

## Quick Start

### Publish KCL module by PR

#### 1. Fork and Clone the code repository

First, you need to clone the repository

```
git clone https://github.com/{your_github_id}/artifacthub --depth=1
```

#### 2. Create a branch for your module

We recommend that your branch name be: `publish-pkg-<pkg_name>`, `<pkg_name>` is the name of your module.

Take the module `helloworld` as an example

Enter the artifacthub directory you downloaded

```shell
cd artifacthub
```

Create a branch `publish-pkg-helloworld` for the module `helloworld`

```shell
git checkout -b publish-pkg-helloworld
```

#### 3. Add your KCL module

You need to move your module to the current directory. In our example, we use the `kcl mod init` command to create the module `helloworld`

```shell
kcl mod init helloworld
```

You can add a `README.md` file to the root directory of the module to display on the homepage of AH.

```shell
echo "## Introduction" >> helloworld/README.md
echo "This is a kcl module named helloworld." >> helloworld/README.md
```

Generate reference documents for your module (optional).

```shell
kcl doc generate
```

#### 4. Commit your module

You can use the following command to commit your module

Use `git add .` command to add your module to the staging area of git

```shell
git add .
```

Use `git commit -s` command to commit your module, we recommend that your commit message follow the format "publish module <pkg_name>".

```shell
git commit -m "publish module helloworld" -s
```

Use `git push` command to submit your module to your branch `publish-pkg-<pkg_name>`

```shell
git push
```

#### 5. Submit a PR

Finally, you need to submit a PR to the main branch of the repository with your branch `publish-pkg-<pkg_name>`.

- [How to create PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
