# 快速开始

## 初始化一个空的 KCL 包

首先，为 KCL 包创建一个空的文件夹, 并且进入到这个文件夹中。

```shell
mkdir my_package # 创建一个新的文件夹 'my_package'
cd my_package    # 进入这个文件夹 'my_package' 中
```

创建一个叫做 `my_package` 的包。

```shell
kpm init
```

`kpm` 将会在执行`kpm init`命令的目录下创建两个默认的配置文件 `kcl.mod` 和 `kcl.mod.lock`。

```shell
- my_package
        |- kcl.mod
        |- kcl.mod.lock
        |- # 你可以直接在这个目录下写你的 kcl 程序
```

`kcl.mod.lock` 是 `kpm` 用来固定依赖版本的文件，是自动生成的，请不要人工修改这个文件。

`kpm` 将会为这个新包创建一个默认的 `kcl.mod`。如下所示:

```shell
[package]
name = "my_package"
edition = "0.0.1"
version = "0.0.1"
```

## 为 KCL 包添加依赖

如果你想要使用 [Konfig](https://github.com/awesome-kusion/konfig.git) 中的 KCL 程序。

```shell
kpm add -git https://github.com/awesome-kusion/konfig.git -tag v0.0.1
```

`kpm` 会为您将依赖添加到 kcl.mod 文件中。

```shell
[package]
name = "my_package"
edition = "0.0.1"
version = "0.0.1"

[dependencies]
# 'konfig' 是依赖的包的名称
# 如果你想在你的 kcl 程序中使用包 'konfig' 中的内容，
# 你需要在 import 语句中使用包名 'konfig' 作为导入内容的前缀。
konfig = { git = "https://github.com/awesome-kusion/konfig.git", tag = "v0.0.1" }
```

## 编写一个程序使用包 `konfig` 中的内容

在当前包中创建 `main.k`。

```shell
- my_package
        |- kcl.mod
        |- kcl.mod.lock
        |- main.k # 你的 KCL 程序
```

并且将下面的内容写入 `main.k` 文件中。

```kcl
import konfig.base.pkg.kusion_kubernetes.api.apps.v1 as apps

demo = apps.Deployment {
    metadata.name = "nginx-deployment"
    spec = {
        replicas = 3
        selector.matchLabels.app = "nginx"
        template.metadata.labels = selector.matchLabels
        template.spec.containers = [
            {
                name = selector.matchLabels.app
                image = "nginx:1.14.2"
                ports = [
                    {containerPort = 80}
                ]
            }
        ]
    }
}
```

## 编译 kcl 包

你可以使用如下命令编译刚才编写的 `main.k` 文件。

```shell
kcl main.k -S demo
```

如果你得到如下输出，恭喜你！你成功使用 `kpm` 编译了一个 kcl 包。

```shell
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
        - image: "nginx:1.14.2"
          name: nginx
          ports:
            - containerPort: 80
```

## 打包您的 kcl 包

你可以使用 `kpm pkg` 将您的包与其对应的依赖打包在一起。

```shell
kpm pkg --target my_package.tar
```

这个命令执行后，您可以看到您的 kcl 包已经被打包到了 `my_package.tar` 文件中，并且 `my_package` 的依赖也都被复制到了当前包的 `vendor` 子目录下。

```shell
- my_package
        |- kcl.mod
        |- kcl.mod.lock
        |- main.k
        |- my_package.tar # `kpm pkg` 命令生成的 tar 包
        |- vendor # 当前包所有的依赖都将被复制到 `vendor` 中 
             |- konfig_v0.0.1
```
