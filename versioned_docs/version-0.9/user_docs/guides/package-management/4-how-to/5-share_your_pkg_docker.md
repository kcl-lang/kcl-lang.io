# Share Your Package to docker.io

This article will show you how to use the kcl package management tool to push your kcl packages to docker.io.

## Step 1: Install KCL CLI

First, you need to install KCL CLI on your computer. You can follow the instructions in the [KCL CLI installation documentation](https://kcl-lang.io/docs/user_docs/getting-started/install).

## Step 2: Create a docker.io account

If you want to use `docker.io` as the OCI registry to share your kcl package with others, you need to create a `docker.io` account to support the push of your kcl package.

## Step 3: Log in to docker.io

You can use the following command to log in to docker.io.

```shell
kcl registry login -u <USERNAME> -p <TOKEN> docker.io
```

Where `<USERNAME>` is your `docker.io` username, and `<PASSWORD>` is your `docker.io` password.

For more information on how to log in to ghcr.io, see [kcl registry login](https://kcl-lang.io/docs/reference/package-management/command-reference/login).

## Step 4: Push your kcl package

Now, you can use kpm to push your kcl package to `docker.io`.

### 1. A valid kcl package

First, you need to make sure that what you are pushing conforms to the specifications of a kcl package, i.e., it must contain valid kcl.mod and kcl.mod.lock files.

If you don't know how to get a valid kcl.mod and kcl.mod.lock, you can use the `kcl mod init` command.

Create a new kcl package named `my_package`.

```shell
kcl mod init my_package
```

The `kcl mod init my_package` command will create a new kcl package `my_package` for you and create the `kcl.mod` and `kcl.mod.lock` files for this package.

If you already have a directory containing kcl files `exist_kcl_package`, you can use the following command to convert it into a kcl package and create valid `kcl.mod` and `kcl.mod.lock` files for it.

Run the `kcl mod init` command under the `exist_kcl_package` directory.

```shell
kcl mod init
```

For more information on how to use `kcl mod init`, see [kcl mod init](https://kcl-lang.io/docs/tools/cli/package-management/command-reference/init).

### 2. Pushing the KCL Package

You can use the following command in the root directory of your `kcl` package:

Run the `kcl mod push` command under the `exist_kcl_package` directory.

```shell
kcl mod push oci://docker.io/<USERNAME>/exist_kcl_package
```

After completing these steps, you have successfully pushed your KCL Package `exist_kcl_package` to `docker.io`.
For more information on how to use `kcl mod push`, see [kcl mod push](https://kcl-lang.io/docs/tools/cli/package-management/command-reference/push).
