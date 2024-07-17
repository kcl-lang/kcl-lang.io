# Integrate Private Git Repo and OCI Registry

KCL package management tool supports saving and sharing KCL modules through the OCI registry and Git repository. This section will introduce how to integrate the KCL package management tool with the private OCI registry and Git repository.

## Private Git Repository

KCL package management tool depends on the Git tool in the local environment to interact with the Git repository. Therefore, before using the KCL package management tool, ensure the Git tool is installed in the local environment and the Git command can be found in the environment variable $PATH.

More Details - [How to Install Git Tool](https://git-scm.com/downloads)

KCL package management tool shares the same login credentials with the Git tool in the local environment. When you use the KCL package management tool to interact with a private Git repository, you need to check whether the Git tool can interact with the private Git repository normally. If you can successfully download the private Git repository using the `git clone` command, you can directly use the KCL package management tool without any login operation.

More Details - [Download Private Repository Using Git](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository)

## Private OCI Registry

The KCL package management tool supports saving and sharing KCL packages through private OCI Registries. mainly including two parts.

1. Login to the private OCI Registry using the `kcl registry login` command.

   More Details - [kcl registry login Login OCI Registry](https://www.kcl-lang.io/docs/tools/cli/package-management/command-reference/login)

2. Replace the OCI Registry used by the KCL package management tool. The KCL package management tool supports specifying the OCI registry used to download KCL packages in three ways.

   - Use the OCI Url to specify the OCI registry in the command line or `kcl.mod`.

     You can specify the OCI Registry as `ghcr.io` by the following command.

     ```shell
     kcl mod add oci://ghcr.io/kcl-lang/helloworld --tag 0.1.0
     ```

     Or add the following content to the `kcl.mod` file to specify the OCI Registry as `ghcr.io`.

     ```toml
     helloworld = { oci = "oci://ghcr.io/kcl-lang/helloworld", tag = "0.1.0" }
     ```

   - By environment variable

     You can adjust the configuration of the OCI Registry by setting the three environment variables `KPM_REG`, `KPM_REGO`, and `OCI_REG_PLAIN_HTTP`.

     ```shell
     # set default registry
     export KPM_REG="ghcr.io"
     # set default repository
     export KPM_REPO="kcl-lang"
     # set support for 'http'
     export OCI_REG_PLAIN_HTTP=off
     ```

   - By configuration file

     The configuration file of the KCL package management tool is located at `$KCL_PKG_PATH/.kpm/config/kpm.json`, if the environment variable `KCL_PKG_PATH` is not set, it is saved by default in `$HOME/.kcl/kpm/.kpm/config/kpm.json`.

     The default content of the configuration file is as follows:

     ```json
     {
       "DefaultOciRegistry": "ghcr.io",
       "DefaultOciRepo": "kcl-lang",
       "DefaultOciPlainHttp": true
     }
     ```
