# Installation

## Install `kpm`

Before installing and using kpm, ensure that KCL compiler has been installed successfully.

[How to install KCL compiler.](https://kcl-lang.io/docs/user_docs/getting-started/install)

### Go install

You can download kpm via go install.

```shell
go install kcl-lang.io/kpm@latest
```

### Download from GITHUB release page

You can get `kpm` from the [kpm github release](https://github.com/kcl-lang/kpm/releases) and set the `kpm` binary path to the environment variable PATH.

```shell
# KPM_INSTALLATION_PATH is the path of the `kpm` binary.
export PATH=$KPM_INSTALLATION_PATH:$PATH
```

Use the following command to ensure that you install `kpm` successfully.

```shell
kpm --help
```

If you get the following output, you have successfully installed `kpm` and you can proceed to the following steps.

```shell
NAME:
   kpm - kpm is a kcl package manager

USAGE:
   kpm  <command> [arguments]...

COMMANDS:
   init      initialize new module in current directory
   add       add new dependency
   pkg       package a kcl package into tar
   metadata  output the resolved dependencies of a package
   run       compile kcl package.
   login     login to a registry
   logout    logout from a registry
   push      push kcl package to OCI registry.
   pull      pull kcl package from OCI registry.
   help, h   Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --help, -h  show help
```
