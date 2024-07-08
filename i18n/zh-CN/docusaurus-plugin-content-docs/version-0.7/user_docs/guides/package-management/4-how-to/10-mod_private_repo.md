# 集成私有的 Git Repo 与 OCI registry

KCL 包管理工具支持通过 OCI registry 和 Git 仓库保存和分享 KCL 包。本文将介绍如何使用 KCL 包管理工具与私有 OCI registry 和 Git 仓库集成。

## 私有 Git 仓库

KCL 包管理工具依赖本地环境中的 Git 工具完成与 Git 仓库的交互。因此，在使用 KCL 包管理工具之前，确保本地环境中完成了 Git 工具的安装，并且在环境变量 $PATH 中能够找到 Git 命令。

更多信息 - [如何安装 Git 工具](https://git-scm.com/downloads)

KCL 包管理工具与本地环境中的 Git 工具公用一份登录凭证，当您使用 KCL 包管理工具与私有 Git 仓库交互时，您需要先检查 Git 工具能否正常与私有 Git 仓库交互。如果您使用 `git clone` 命令能够成功下载私有 Git 仓库，您可以直接使用 KCL 包管理工具而不需要进行任何登录操作。

更多信息 - [使用 Git 下载私有仓库](https://docs.github.com/zh/repositories/creating-and-managing-repositories/cloning-a-repository)

## 私有 OCI Registry

关于私有的 OCI Registry, 主要包括两个部分

1. 需要先使用 `kcl registry login` 命令登录私有 Registry。

    更多信息 - [kcl registry login 登录 OCI registry](https://www.kcl-lang.io/zh-CN/docs/tools/cli/package-management/command-reference/login)

2. 更换 KCL 包管理工具使用的 OCI Registry，KCL 包管理工具支持通过三种方式指定下载 KCL 包时使用的 OCI registry.

    - 命令行或者 kcl.mod 中使用 OCI Url 指定使用的 OCI registry

      你可以通过以下命令行，指定 OCI Registry 为`ghcr.io`。

      ```shell
      kcl mod add oci://ghcr.io/kcl-lang/helloworld --tag 0.1.0
      ```

      或者在 `kcl.mod` 文件中添加如下内容，指定 OCI Registry 为`ghcr.io`。

      ```toml
      helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
      ```

    - 通过环境变量

      你可以通过设置三个环境变量 KPM_REG、KPM_REGO 和 OCI_REG_PLAIN_HTTP 来调整配置。

      ```shell
      # 设置默认仓库地址
      export KPM_REG="ghcr.io"
      # 设置默认仓库
      export KPM_REPO="kcl-lang"
      # 设置支持 'http'
      export OCI_REG_PLAIN_HTTP=off
      ```

    - 通过配置文件

      KCL 包管理工具的配置文件位于 `$KCL_PKG_PATH/.kpm/config/kpm.json`，如果环境变量 `KCL_PKG_PATH` 没有设置，它默认保存在 `$HOME/.kcl/kpm/.kpm/config/kpm.json`。

      配置文件的默认内容如下：

      ```json
      {
        "DefaultOciRegistry": "ghcr.io",
        "DefaultOciRepo": "kcl-lang",
        "DefaultOciPlainHttp": true
      }
      ```
