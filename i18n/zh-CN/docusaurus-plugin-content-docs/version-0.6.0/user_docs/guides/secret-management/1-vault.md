---
id: vault
sidebar_label: Vault
---
# Vault

## 简介

This guide will show you that KCL solves the secret management problem by integrating [Vault](https://developer.hashicorp.com/vault) and [Vals](https://github.com/helmfile/vals).

## 先决条件

+ Install [KCL](/docs/user_docs/getting-started/install)
+ Prepare a [Kubernetes Cluster](https://kubernetes.io/)
+ Install [Vault](https://developer.hashicorp.com/vault/downloads)
+ Install [Vals](https://github.com/helmfile/vals)

## 具体步骤

### 1. 获得示例

We put the application source code and infrastructure deployment code in different repos, which can be maintained by different roles to achieve the separation of concerns.

+ Get the application code

```shell
git clone https://github.com/kcl-lang/kcl-lang.io.git/
cd ./kcl-lang.io/examples/secret-management/vault
```

+ Show the config

```shell
cat main.k
```

The output is

```python
# Secret Management using Vault and Vals

apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
    annotations: {
        "secret-store": "vault"
        # Valid format:
        #  "ref+vault://PATH/TO/KV_BACKEND#/KEY"
        "foo": "ref+vault://secret/foo#/foo"
        "bar": "ref+vault://secret/bar#/bar"
    }
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

The main.k file extends the configuration of the Nginx application and customizes annotations. Among them, the value of annotation `foo` and `bar` follow secret reference format (`ref+vault://PATH/TO/KV_BACKEND#/KEY`):

+ `ref+vault`: indicates that this is a secret reference, and the external storage service is `Vault`.
+ `PATH/TO/KV_BACKEND`: specifies the path where a secret is stored.
+ `KEY`: specifies the key to reading secret.

The complete format is concatenated using a style similar to URI expressions, which can retrieve a secret stored externally.

### 2. 预存敏感信息

Start the Vault Server

```shell
vault server -dev
export VAULT_ADDR='http://127.0.0.1:8200'
# Note: Replace with your token 
export VAULT_TOKEN=yourtoken
```

After Vault is started in development mode and unpacked, secrets are pre-stored, and the path and keys are consistent with `main.k`:

```shell
vault kv put secret/foo foo=foo
vault kv put secret/bar bar=bar
```

### 3. 部署配置

Using the following command to apply the deployment manifest.

```shell
kcl main.k | vals eval -f - | kubectl apply -f -
```

The expect output is

```shell
deployment.apps/nginx created
```

### 4. 验证敏感信息

Next, verify that the secrets have been retrieved from Vault and replace the values of annotations of Nginx:

+ Verify the `foo` annotation

```shell
kubectl get deploy nginx -o yaml | grep 'foo:'
```

The output is

```yaml
    foo: foo
```

+ Verify the `bar` annotation

```shell
kubectl get deploy nginx -o yaml | grep 'bar:'
```

The output is

```yaml
    bar: bar
```

So far, we have retrieved the secrets hosted in `Vault` and put them into use.

## 小结

This guide introduces how KCL solves the secret management by integrating Vault and Vals. By following these steps, we can retrieve the secrets hosted in Vault and utilize them.
