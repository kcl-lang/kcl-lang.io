# Git 提交指南

本文介绍了 Git 提交变更时需要注意的事项，如果拒绝接受本文的内容会导致提交的变更无法被接受。

## 1. 关于 issue

在提交一个 issue 之前，请先查阅已经关闭的 issue ，也许在关闭的 issue 中已经存在合适的解决方案。

如果没有找到合适的方案，我们提供了4种模版在创建 issue 的时候使用。

- Bug Report : 发现了一个 Bug，可以通过 Bug Report 模版创建 issue 与我们联系。
- Enhancement : 开发者对工具进行了增强，可以通过 Enhancement 模版创建 issue 来介绍增加的内容。
- Feature Request : 在使用的过程中想要为工具增加某些新的特性或者功能，可以通过 Feature Request 模版创建 issue 来描述新特性。
- Ask a Question : 如果有任何的疑问，可以通过 Ask a Question 模版来创建一个 issue 与我们联系。

在选择合适的模版后，只需要填写模版上的要求填写的内容即可。如果在创建 issue 的时候发现没有模版，或者模版内容为空，可以通过微信群，钉钉群或者邮件向我们反馈这个问题。

## 2. 关于 Git 分支

要向 kcl-lang 贡献代码，您必须拥有一个 GitHub 帐户，以便您可以将代码推送到您自己的分支并创建拉取请求。我们推荐参考 [Angular 规范](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines) 为您自己的分支命名。
推荐的格式如下：

```
{type}-{a_short_description}
```

分支名称主要包括两个字段，并通过 “-” 分割。其中：

- {type} : 当前分支内容的类型。
- {a_short_description}: 一个简短的描述，介绍这个分支的主要内容。

e.g. 张三首先 Fork 仓库到自己账户下，然后创建对应名称 `zhangsan:fix-output-fmt-bug` 的分支（冒号之前是张三的账号），用于修复输出格式化 bug。

## 3. 关于 Git Commit

我们参考 [Commitizen](https://github.com/commitizen/cz-cli) 书写 Commit Message。

```
注: 如果直接使用 Commitizen 生成 Commit Message，需要注意因为 Commitizen
是开发人员管理 commit 的工具，与项目本身无关联，因此由 Commitizen 生成的中间产物
(如: node_modules 文件目录)可能没有在项目 .gitignore 文件中。

您可以 git add {filename} 选择要提交的文件而忽视中间产物。
或者您可以向 .gitignore 文件中添加如下内容而自动忽视中间产物：
# commitizen
package.json
package-lock.json
node_modules/*
```

如果手动编写 Commit Message，我们也建议采用 [Commitizen](https://github.com/commitizen/cz-cli) 的 commit message 格式。

```
{type} ( {component_or_file} ) {a_short_description}
    {a_longer_description}
    BREAKING CHANGE: {breaking_change_description}.
    {linked issue}
```

其中主要包括6个字段：

- {type} : 当前 commit 对应的分支的类型。
- {component_or_file}: 当前 commit 改动的模块或者文件的名称。
- {a_short_description}: 简短的描述介绍 commit 中的内容。
- {a_longer_description}: 详细的描述用来介绍 commit 中的内容。
- {breaking_change_description}: 如果 commit 中包含破环兼容性的改动，需要对兼容性改动产生的影响进行介绍。
- {linked issue}: 与当前这个 commit 关联的 issue。

其中 {breaking_change_description} 和 {linked issue} 如果 commit 中不包含破坏兼容性的改动和关联的 issue，可以省略。

e.g. 张三在分支 `zhangsan:fix-output-fmt-bug` 中创建的 commit。

```

  fix(kclvm-printer): fix an output format bug in kclvm-printer

  There is an output format bug in kclvm-printer because ...,
  So, The calling of method "XXX" is replaced by "HHHH"...,
  ...

  -- 如果没有破坏兼容性的改动和关联的 issue 可以省略下面内容。

  BREAKING CHANGE: This change maybe cause .......

  fix #123

```

## 4. 关于 pull request

在提交一个 PR 之前，可能需要优先考虑以下几个问题:

- 请先查阅已经关闭的 PR ，也许在已经关闭的 PR 中，可能存在已经完成的解决方案。
- 我们建议在提交变更之前，提交一个对应的 issue 描述变更中将要解决的问题，并将变更对应的 PR 与 issue 关联。
- 在向我们提交 PR 之后，请签署 [Contributor License Agreement (CLA)](#cla) ，如果拒绝签署，我们将无法接受 PR。
- 请确保每次改动都创建了一个新的分支，并根据上文中提到的规范为分支命名。
- 一次 PR 请不要超过两个 commit ，请将多余的 commit 通过 squash 压缩，并根据上文中提到的规范，编写 commit message 。
- 我们提供了 [PR 模版](https://github.com/kcl-lang/.github/blob/main/.github/PULL_REQUEST_TEMPLATE.md)，只需要添加模版中要求的内容即可，如果在创建PR时发现没有模版或者模版内容为空，可以通过微信群，钉钉群或者邮件向我们反馈这个问题。

我们建议PR的标题与分支名、commit message 风格保持一致：

```
{type} ( {component_name_or_file_name} ) :{a_short_description}
```

e.g. 张三为分支`fix/zhangsan/fix_output_fmt_bug`创建的PR名称。

```
fix(kclvm-printer): fix an output format bug in kclvm-printer.
```

## 5. 目前 type 支持的类型

参考[Angular 规范](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)，type 支持类型的类型如下:

```
- feat:     -- 添加了新的功能特性。
- fix:      -- 进行了 Bug 的修复。
- docs:     -- 进行了文档部分的修改。
- style:    -- 对代码格式的修改，并不影响代码的功能，如：删除多余空格，代码缩进等。
- refactor: -- 在不改变代码功能的基础上对代码进行了的重构。
- perf:     -- 对代码进行了性能优化。
- test:     -- 添加或者调整已有的测试用例。
- build:    -- 对构建系统或者外部依赖库进行了调整。
- ci:       -- 调整了 CI 的配置文件或者脚本。
- chore:    -- 对源代码和测试文件之外其他部分的调整。
- revert:   -- 对 commit 进行回滚。
```

## <a name="cla"></a> 6. Contributor License Agreement (CLA)

在第一次向我们提交 PR 之后，在 PR 中的 CLA 检查将会失败并提示签署 CLA。您可以通过自己的账户之间在 PR 回复 "I have read the CLA Document and I hereby sign the CLA" 表示同意签署 CLA，然后手动重启失败的 CLA 检查 Action 即可。当 PR 被成功合并之后将会被锁定不能再修改。
