# Support for OCI Registries

KCL package management tool supports saving and sharing KCL packages through OCI Registries.

## Default OCI Registry

KCL package management tool uses `ghcr.io` to save KCL packages by default.

Default registry - [https://github.com/orgs/kcl-lang/packages](https://github.com/orgs/kcl-lang/packages)

## Use Custom OCI Registry

There are several hosted container registries with OCI support that you can use to store your KCL module.

+ [Docker Hub](https://docs.docker.com/docker-hub/oci-artifacts/)
+ [Harbor](https://goharbor.io/docs/main/administration/user-defined-oci-artifact/)
+ [Amazon ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/push-oci-artifact.html)
+ [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-oci-artifacts)
+ [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/helm/manage-charts)
+ [Alibaba Cloud Container Registry](https://help.aliyun.com/acr/)
+ [IBM Cloud Container Registry](https://cloud.ibm.com/docs/Registry)
+ [JFrog Artifactory](https://jfrog.com/help/r/jfrog-artifactory-documentation/docker-registry)

You can adjust the registry and repository name of the OCI registry by the follow methods.

### By environment variable

You can adjust the configuration of OCI Registry by setting the three environment variables `KPM_REG`, `KPM_REGO`, and `OCI_REG_PLAIN_HTTP`.

```shell
# set default registry
export KPM_REG="ghcr.io"
# set default repository
export KPM_REPO="kcl-lang"
# set support for 'http'
export OCI_REG_PLAIN_HTTP=off
```

### By configuration file

The configuration file of the KCL package management tool is located at `$KCL_PKG_PATH/.kpm/config/kpm.json`, if the environment variable `KCL_PKG_PATH` is not set, it is saved by default in `$HOME/.kcl/kpm/.kpm/config/kpm.json`.

The default content of the configuration file is as follows:

```json
{
  "DefaultOciRegistry": "ghcr.io",
  "DefaultOciRepo": "kcl-lang",
  "DefaultOciPlainHttp": true
}
```

## Quick start

In the following content, we will use `localhost:5001` as an example OCI Registry, and add an account `test` with a password `1234` to this OCI Registry, and upload a package named `MyPkg` with `v0.1.0`.

### `kcl registry login` to login OCI Registry

You can use `kcl registry login` in four ways.

#### 1. Login OCI Registry with account and password

```shell
$ kcl registry login -u <account_name> -p <password> <oci_registry>
Login succeeded
```

For the example, the command is as follows:

```shell
kcl registry login -u test -p 1234 localhost:5001
```

#### 2. Login OCI Registry with account and interactive input password

```shell
$ kcl registry login -u <account_name> <oci_registry>
Password:
Login succeeded
```

For the example, the command is as follows:

```shell
$ kcl registry login -u test localhost:5001
Password: 1234
Login succeeded
```

#### 3. Login OCI Registry with interactive input account and password

```shell
$ kcl registry login <oci_registry>
Username: <account_name>
Password:
Login succeeded
```

For the example, the command is as follows:

```shell
$ kcl registry login localhost:5001
Username: test
Password: 1234
Login succeeded
```

### `kcl registry logout` to logout OCI Registry

You can use `kcl registry logout` to logout an OCI Registry.

```shell
kcl registry logout <registry>
```

For the example, the command is as follows:

```shell
kcl registry logout localhost:5001
```

### `kcl mod push` to upload a KCL package

You can use `kcl mod push` to upload a KCL package to an OCI Registry.

```shell
# Create a new kcl package.
$ kcl mod init <package_name>
# Enter the root directory of the kcl package
$ cd <package_name>
# Upload the kcl package to an oci registry
$ kcl mod push
```

For the example, the commands are as follows:

```shell
$ kcl mod init MyPkg
$ cd MyPkg
$ kcl mod push
```

You can also specify the url of the OCI registry in the `kcl mod push` command.

```shell
# Create a new kcl package.
$ kcl mod init <package_name>
# Enter the root directory of the kcl package
$ cd <package_name>
# Upload the kcl package to an oci registry
$ kcl mod push <oci_url>
```

For the example, you can push the kcl package to `localhost:5001` by the command

```shell
$ kcl mod init MyPkg
$ cd MyPkg
$ kcl mod push oci://localhost:5001/test/MyPkg --tag v0.1.0
```

### `kcl mod pull` to download a KCL package

You can use `kcl mod pull` to download a KCL package from the default OCI registry. KPM will automatically search for the kcl package from the OCI registry in `kpm.json`.

```shell
kcl mod pull <package_name>:<package_version>
```

For the example, the command is as follows:

```shell
kcl mod pull MyPkg:v0.1.0
```

Or, you can download a kcl package from the specified OCI registry url.

```shell
kcl mod pull <oci_url>
```

For the example, the command is as follows:

```shell
kcl mod pull oci://localhost:5001/test/MyPkg --tag v0.1.0
```

### `kcl run` to compile a KCL package

KCL package management tool can directly compile a kcl package through the url of OCI.

```shell
kcl run <oci_url>
```

For the example, the command is as follows:

```shell
kcl run oci://localhost:5001/test/MyPkg --tag v0.1.0
```
