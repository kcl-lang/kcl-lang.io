---
title: "发布 Kubernetes 模块"
sidebar_position: 4
---

## 简介

社区官方的 KCL 模块 Registry 位于 [Artifact Hub](https://artifacthub.io/packages/search?org=kcl&sort=relevance&page=1)，欢迎通过在 [GitHub 仓库](https://github.com/kcl-lang/artifacthub) 提交 pull requests 参与共建。本部分介绍如何发布 Kubernetes 模块并使用模块 Registry。

> 注意：如果您想将您的 KCL 模块发布到 `kcl-lang` 官方 Registry 中，则您的 KCL 模块的源代码将需要保存在上述存储库中。但是，KCL 允许接入三方的 Registry，例如各种 OCI Registry，如Docker Hub、Github Packages 和 Harbor 等。只需通过 `kcl registry login` 命令登录到对应的 Registry 即可。

> 注意：KCL 模块不会限制模块中配置或策略代码的具体内容。它可以是一个与 Kubernetes Helm Chart 类似的用于发布的应用程序工作负载配置，也可以是一段策略代码用于校验 Kubernetes 配置或者使用 CRD 转换而来的 KCL Schema。但是，我们强烈建议您在文档中提供有关 KCL 模块的简要介绍文档和具体用法。

## 先决条件

+ 安装 [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

## 快速入门

### 通过 GitHub PR 发布 KCL 模块

#### 1. Fork 并克隆代码存储库

```shell
git clone https://github.com/{your_github_id}/artifacthub --depth=1
```

#### 2. 创建分支

我们建议您的分支名称为：`publish-pkg-<pkg_name>`，`<pkg_name>` 是您的 KCL 模块的称。以模块 helloworld 为例

进入您下载的 artifacthub 目录

```shell
cd artifacthub
```

为模块 `helloworld` 创建一个名为 `publish-pkg-helloworld` 的分支

```shell
git checkout -b publish-pkg-helloworld
```

#### 3. 添加您的 KCL 模块

在我们的示例中，使用 `kcl mod init` 命令创建模块 `helloworld`

```shell
kcl mod init helloworld
```

您可以在模块的根目录添加一个 `README.md` 文件，以在 Artifact Hub 的模块主页上显示。

```shell
echo "## Introduction" >> helloworld/README.md
echo "This is a kcl module named helloworld." >> helloworld/README.md
```

为模块生成参考文档（可选）

```shell
kcl doc generate
```

#### 4. 提交代码

您可以使用以下命令提交您的模块

使用 `git add .` 命令将您的模块添加到git的暂存区

```shell
git add .
```

使用 `git commit -s` 命令提交您的模块，我们建议您的提交消息遵循格式 `"publish module <pkg_name>"`。

```shell
git commit -m "publish module helloworld" -s
```

提交分支

```shell
git push
```

#### 5. 提交 PR

最后，您需要提交一个 PR 到存储库的主分支，包括您的分支 `publish-pkg-<pkg_name>`。

- [如何创建 PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
