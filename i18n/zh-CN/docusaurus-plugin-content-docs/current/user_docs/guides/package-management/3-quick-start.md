# 快速开始

## 0. 前置条件

+ 安装 [kcl](https://kcl-lang.io/docs/user_docs/getting-started/install/)

## 1. 初始化一个空的 KCL 包

使用 `kcl mod init` 命令创建一个名为 `my_package` 的 kcl 程序包, 并且在我们创建完成一个名为 `my_package` 的包后，我们需要通过命令 `cd my_package` 进入这个包来进行后续的操作。

```shell
kcl mod init my_package && cd my_package
```

`kcl` 将会在执行`kcl mod init my_package`命令的目录下创建两个默认的配置文件 `kcl.mod` 和 `kcl.mod.lock`。

```shell
- my_package
        |- kcl.mod
        |- kcl.mod.lock
        |- # 你可以直接在这个目录下写你的kcl程序。
```

`kcl.mod.lock` 是 `kcl` 用来固定依赖版本的文件，是自动生成的，请不要人工修改这个文件。

`kcl` 将会为这个新包创建一个默认的 `kcl.mod`。如下所示:

```shell
[package]
name = "my_package"
edition = "0.0.1"
version = "0.0.1"
```

## 2. 为 KCL 包添加依赖

然后，您可以通过 `kcl mod add` 命令来为您当前的库添加一个外部依赖。

如下面的命令所示，为当前包添加一个版本号为 `1.28` 并且名为 `k8s` 的依赖包。

```shell
kcl mod add k8s:1.28
```

`kcl` 会为您将依赖添加到 kcl.mod 文件中.

```shell
[package]
name = "my_package"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
k8s = "1.28" # The dependency 'k8s' with version '1.28'
```

## 编写一个程序使用包 `konfig` 中的内容

在当前包中创建 `main.k`。

```shell
- my_package
        |- kcl.mod
        |- kcl.mod.lock
        |- main.k # Your KCL program.
```

并且将下面的内容写入 `main.k` 文件中。

```kcl
# 导入并使用外部依赖 `k8s` 包中的内容。
import k8s.api.core.v1 as k8core

k8core.Pod {
    metadata.name = "web-app"
    spec.containers = [{
        name = "main-container"
        image = "nginx"
        ports = [{containerPort = 80}]
    }]
}

```

## 3. 运行 KCL 代码

你可以使用 kcl 编译刚才编写的 `main.k` 文件, 得到编译后的结果。

```shell
kcl run
```

输出为

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
    - image: nginx
      name: main-container
      ports:
        - containerPort: 80
```
