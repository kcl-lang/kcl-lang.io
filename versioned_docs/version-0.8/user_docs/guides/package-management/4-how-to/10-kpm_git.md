# Use a Git-based repository

KCL package management tool supports saving and sharing KCL modules through the OCI registry and Git repository. This section will introduce how to integrate the KCL package management tool with the Git repository.

kpm does not provide the interaction between login/logout/push/pull and Git repository because users can use Git command line tools to login, logout, push, pull and other functions during interaction with Git repository. kpm only provides the ability to add a Git repository as a dependency to the a KCL package.

## Private Git Repository

KCL package management tool depends on the Git tool in the local environment to interact with the Git repository. Therefore, before using the KCL package management tool, ensure the Git tool is installed in the local environment and the Git command can be found in the environment variable $PATH.

More Details - [How to Install Git Tool](https://git-scm.com/downloads)

KCL package management tool shares the same login credentials with the Git tool in the local environment. When you use the KCL package management tool to interact with a private Git repository, you need to check whether the Git tool can interact with the private Git repository normally. If you can successfully download the private Git repository using the `git clone` command, you can directly use the KCL package management tool without any login operation.

More Details - [Download Private Repository Using Git](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

## Add a Git Repository as a Dependency

You can use `kcl mod add` to add a Git repository as a dependency to the KCL package. 

Take `https://github.com/kcl-lang/konfig` as an example. The command is as follows:

```shell
kcl mod add git://github.com/kcl-lang/konfig --tag v0.4.0 # Add a Git repository with a tag
kcl mod add git://github.com/kcl-lang/konfig --commit 78ba6e9 # Add a Git repository with a commit
kcl mod add git://github.com/kcl-lang/konfig --branch main # Add a Git repository with a branch
```

The way shown above is to add a Git repository as a dependency with Https protocol. 
You can also use the `ssh` protocol or some other protocols to add a Git repository as a dependency as follows:

```shell
kcl mod add --git https://github.com/kcl-lang/konfig --tag v0.4.0 # Add a Git repository with a tag and Https protocol
kcl mod add --git https://github.com/kcl-lang/konfig --branch main # Add a Git repository with a branch and Https protocol
kcl mod add --git ssh://github.com/kcl-lang/konfig --commit 78ba6e9 # Add a Git repository with a commit and ssh protocol
```
