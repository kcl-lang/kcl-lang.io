# 将您的 KCL 包发布到 ArtifactHub

我们已经将 [(ArtifactHub, AH)](https://artifacthub.io/) 集成为 KCL 模块的市场，并且我们维护一个 github 仓库 [`modules`](https://github.com/kcl-lang/modules) 用来保存发布到 AH 的 KCL 模块。如果您希望将您的 KCL 模块发布到我们的市场，您可以通过提交 PR 的方式将您的 KCL 模块提交到这个仓库中。

## 注意事项

在您提交 PR 之前，有一些事情您需要仔细考虑：

- `modules` 仓库中的所有 KCL 模块的源代码都是**公开的**，如果您希望您的 KCL 模块是私有的，抱歉我们目前不支持，您可以尝试通过构建您自己的仓库来解决这个问题。

- 如果您希望将您的 KCL 模块发布到 `modules` 中并且能够在 AH 上被找到，**您的 KCL 模块必须带有一个版本号，并且版本号必须符合 [语义化版本](https://semver.org/) 的定义**，即 kcl.mod 中的 `version` 字段是非空的，并且符合语义化版本的定义。

```
[package]
name = "mynginx"
edition = "*"
version = "0.0.1" # 这个字段不可以为空，并且必须符合语义化版本的定义。
```

- **一旦一个 KCL 模块的某个版本被发布，其内容就不能被改变。我们不允许 KCL 模块的内容在不改变模块版本的情况下被改变**。也就是说，如果您提交了一个 PR，改变了 KCL 模块的内容，并且您希望所有人都能够使用您所做的改变，那么您必须升级您的 KCL 模块的版本，即改变 kcl.mod 中的 `version` 字段。如果您遇到了某些特殊情况必须要改变某个版本的 KCL 模块内容，请在仓库中提出 issue 并且联系我们。

## 快速开始

在下一节中，我们通过 `helloworld` 示例向您展示如何发布您的 KCL 包并且在 AH 上找到他们。

### 准备工作

- 安装 [KCL](https://kcl-lang.io/docs/user_docs/getting-started/install)
- 安装 [git](https://git-scm.com/book/zh/v2/%E8%B5%B7%E6%AD%A5-%E5%AE%89%E8%A3%85-Git)
- [注册一个 Github 账户(可选)](https://docs.github.com/zh/get-started/signing-up-for-github/signing-up-for-a-new-github-account)

### 代码仓库

注意：如果您希望将您的 KCL 包发布到 `kcl-lang` 官方的 Registry 中，那么您的 KCL 包的源代码将以开源的形式保存在当前仓库中，您需要将您的包的源代码通过 PR 提交到这个仓库中。

### 准备您的 KCL 包

通过 `kcl mod init <module_name>` 命令, 您可以创建一个合法的 KCL 程序模块。

目前，仓库能够识别的合法的程序的目录结构如下：

```
<module_name>
    |- kcl.mod (必选的)
    |- kcl.mod.lock (可选的)
    |- artifacthub-pkg.yaml （可选的）
    |- README.md （可选的）
    |- (*.k) kcl program files
```

- kcl.mod : 作为 KCL 程序包的标识文件，这个文件**必选的**，包含 kcl.mod 文件的目录会被标识为文件的根目录。
- kcl.mod.lock : 自动生成的用来固定依赖版本的文件，这个文件**可选的**，不需要手动改动。
- artifacthub-pkg.yaml : 这个文件是**可选的**，因为我们的仓库目前通过 artifacthub 展示所有的包，通过 artifacthub-pkg.yaml 来配置您想要包的信息，这里我们采取的策略是**如果在您的包的 kcl.mod 文件所在目录中有一个名为 artifacthub-pkg.yaml 的配置文件，那么，我们将使用您提供 artifacthub-pkg.yaml 来展示您的包的信息，否则，我们将会使用一些默认的信息生成对应的 artifacthub-pkg.yaml 文件。**
- README.md : 一个 markdown 文件作为您的包的文档，这个文件是**可选的**，**如果您不提供这个文件，artifacthub 上将不会展示您的包的文档。**
- (*.k) kcl program files: 您的 KCL 程序的源代码。

### 通过 PR 发布您的包

#### 1. 下载代码仓库

首先，您需要使用 git 将仓库 https://github.com/kcl-lang/modules 下载到您的本地 

```shell
git clone https://github.com/kcl-lang/modules --depth=1
```

#### 2. 为您的包创建一个分支

我们推荐您的分支名为：publish-pkg-<module_name>, <module_name> 为您包的名称。

以包 helloworld 为例

进入您下载的 modules 目录中

```shell
cd modules
```

为包 helloworld 创建一个分支 `publish-pkg-helloworld`

```shell
git checkout -b publish-pkg-helloworld
```

#### 3. 添加您的包

您需要将您的包移动到当前目录下，在我们的例子中，我们使用 `kcl mod init` 命令创建包 helloworld

```shell
kcl mod init helloworld
```

您可以为 helloworld 包增加一个 README.md 文件保存在包的根目录下，用来展示在 AH 的首页中。

```shell
echo "## Introduction" >> helloworld/README.md
echo "This is a kcl module named helloworld." >> helloworld/README.md
```

#### 4. 提交您的包

您可以使用如下命令提交您的包

使用 `git add .` 命令将您的包添加到 git 的暂存区中

```shell
git add .
```

使用 `git commit -s` 命令提交您的包, 我们推荐您的 commit message 遵循  “publish module <module_name>” 的格式。

```shell
git commit -m "publish module helloworld" -s
```

使用 `git push` 命令将您的包提交到您的分支 publish-pkg-<module_name> 中

```shell
git push
```

#### 5. 提交 PR

将您的分支 publish-pkg-<module_name> 向仓库的 main 分支提交 PR。

- [如何创建 PR](https://docs.github.com/zh/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)

### 通过 PR 升级您的包
完成包的内容上传后，您可以通过 PR 升级您的包。

注意：**我们没有提供任何改变包的内容但是不改变版本号的升级策略。** 如果您想要升级您的包，并希望您升级后的包被展示在 AH 上，您需要修改您的包的版本号。即在 kcl.mod 文件的 module 章节中的 version 字段。

```toml
[package]
name = "my_module"
edition = "*"
version = "0.1.0" # 改变这个字段来升级您的包
description = "This is my module."
```

同样，**您无法多次上传同一个版本号的 KCL 包**，一旦您的包的版本号已经被使用，您将无法再次使用这个版本号，再次上传这个包的方式就只有升级版本号。
