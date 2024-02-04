# 如何在 github action 中使用 kcl 包管理发布您的 KCL 包

本文将指导您如何在 GitHub Action 中使用 kcl 包管理将您的 kcl 包推送到发布到 ghcr.io 中。

## 步骤 1：安装 KCL CLI

首先，您需要在您的计算机上安装 KCL CLI。您可以按照 [KCL CLI 安装文档](https://kcl-lang.io/zh-CN/docs/user_docs/getting-started/install)中的说明进行操作。

## 步骤 2：创建一个 GitHub 账号

如果您已经有 GitHub 帐号了，您可以选择跳过这一步

[注册新的一个 GitHub 账号](https://docs.github.com/zh/get-started/signing-up-for-github/signing-up-for-a-new-github-account)

## 步骤 3: 为您的 KCL 包创建一个 GitHub 仓库并进行相关配置

### 1. 为您的 KCL 程序包准备仓库

您需要为您的 KCL 程序包准备一个 GitHub 仓库。

[创建一个 GitHub 仓库](https://docs.github.com/zh/get-started/quickstart/create-a-repo)

在这个仓库中添加您的 KCL 程序，以仓库 https://github.com/awesome-kusion/catalog.git 为例，

```bash
├── .github
│   └── workflows
│       └── push.yaml # github action 文件
├── LICENSE
├── README.md
├── kcl.mod # kcl.mod 将当前仓库内容定义为一个 kcl 包
├── kcl.mod.lock # kcl.mod.lock 是 kcl 包管理工具自动生成的文件
└── main.k # 您的 KCL 程序
```

### 2. 为您的仓库设置 OCI Registry，账户和密码

以 docker.io 为例，您可以为您的仓库设置 secrets `REG`, `REG_ACCOUNT` 和 `REG_TOKEN`。`REG` 的值为 `docker.io`，`REG_ACCOUNT` 的值为您的 docker.io 账户, `REG_TOKEN` 为您的 `docker.io` 登录密码。

[为仓库添加 secrets](https://docs.github.com/zh/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

如果您使用 `ghcr.io` 作为 `Registry`, 您需要使用 GitHub token 作为 secrets。

[创建一个 GitHub Token](https://docs.github.com/zh/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#personal-access-tokens-classic)

## 步骤 4: 将您的 KCL 包添加到仓库中并编写 github action workflow

为这个仓库添加 github action 文件 `.github/workflows/push.yml`，内容如下：

```yaml
name: KPM Push Workflow

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Set up Go 1.21
        uses: actions/setup-go@v2
        with:
          go-version: 1.21

      - name: Install KCL CLI
        run: go install kcl-lang.io/cli/cmd/kcl@latest

      - name: Login and Push
        env:
          # 通过环境变量指定 OCI Registry 和账户
          KPM_REG: ${{ secrets.REG }}
          KPM_REPO: ${{ secrets.REG_ACCOUNT }}
          # kcl registry login 时使用 secrets.REG_TOKEN
        run: kcl registry login -u ${{ secrets.REG_ACCOUNT }} -p ${{ secrets.REG_TOKEN }} ${{ secrets.REG }} && kcl mod push

      - name: Run KCL project from oci registry
        run: kcl run oci://${{ secrets.REG }}/${{ secrets.REG_ACCOUNT }}/catalog --tag 0.0.1
```
