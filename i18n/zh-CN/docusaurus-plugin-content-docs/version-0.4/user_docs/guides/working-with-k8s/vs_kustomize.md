# KCL 与其他 Kubernetes 配置管理工具的异同 - Kustomize 篇

这一节我们通过与其他 Kubernetes 配置管理工具的对比如 Kustomize 介绍 KCL 在 Kubernetes 配置管理场景更丰富的内容。

## KCL 和 Kustomize 的区别

[Kustomize](https://kustomize.io/) 提供了一种无需模板和即可自定义 Kubernetes 资源基础配置和差异化配置的解决方案，通过文件级的 YAML 配置方式完成配置合并或覆盖。在 Kustomize 中用户需要更详细地了解将要发生更改的内容和位置，对于复杂递归过深的基础 YAML 可能不太容易通过选择器来匹配 Kustomize 文件。

而在 KCL 中，用户可以直接把对应代码需要修改的配置书写在对应的地方，免去了阅读基础 YAML 的成本，同时能够通过代码的方式复用配置片段，避免 YAML 配置的大量复制粘贴，信息密度更高，也不容易出错。

下面以一个经典的 Kustomize 多环境配置管理例子详细说明 Kustomize 和 KCL 在 Kubernetes 资源配置管理上的区别。

### Kustomize

Kustomize 有 base 和 overlay 的概念，bases 和 overlays 一般是一个包含 `kustomization.yaml` 文件的目录，一个 base 可以被多个 overlay 使用

我们可以执行如下命令行获得一个典型的 Kustomize 工程

- 创建 base 目录并新建一个 deployment 资源

```bash
# Create a directory to hold the base
mkdir base
# Create a base/deployment.yaml
cat <<EOF > base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ldap
  labels:
    app: ldap
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ldap
  template:
    metadata:
      labels:
        app: ldap
    spec:
      containers:
        - name: ldap
          image: osixia/openldap:1.1.11
          args: ["--copy-service"]
          volumeMounts:
            - name: ldap-data
              mountPath: /var/lib/ldap
          ports:
            - containerPort: 389
              name: openldap
      volumes:
        - name: ldap-data
          emptyDir: {}
EOF
# Create a base/kustomization.yaml
cat <<EOF > base/kustomization.yaml
resources:
- deployment.yaml
EOF
```

- 创建一个 prod 目录并放置生产环境的配置

```bash
# Create a directory to hold the prod overlay
mkdir prod
# Create a prod/deployment.yaml
cat <<EOF > prod/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ldap
spec:
  replicas: 6
  template:
    spec:
      volumes:
        - name: ldap-data
          emptyDir: null
          gcePersistentDisk:
            readOnly: true
            pdName: ldap-persistent-storage
EOF
cat <<EOF > prod/kustomization.yaml
resources:
  - ../base
patchesStrategicMerge:
  - deployment.yaml
EOF
```

此时我们可以得到一个基本的 Kustomzie 目录

```txt
.
├── base
│   ├── deployment.yaml
│   └── kustomization.yaml
└── prod
    ├── deployment.yaml
    └── kustomization.yaml
```

其中，base 目录存放的是基本的 deployment 配置，prod 环境存放的是需要覆盖的 deployment 配置，在其中指定了 `metadata.name` 等字段用于表示对哪个资源进行覆盖

我们可以通过如下命令行显示 prod 环境的真实 deployment 配置

```shell
$ kubectl kustomize ./prod
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ldap
  name: ldap
spec:
  replicas: 6
  selector:
    matchLabels:
      app: ldap
  template:
    metadata:
      labels:
        app: ldap
    spec:
      containers:
      - args:
        - --copy-service
        image: osixia/openldap:1.1.11
        name: ldap
        ports:
        - containerPort: 389
          name: openldap
        volumeMounts:
        - mountPath: /var/lib/ldap
          name: ldap-data
      volumes:
      - gcePersistentDisk:
          pdName: ldap-persistent-storage
          readOnly: true
        name: ldap-data
```

也可以通过如下命令行直接将配置下发到集群当中

```shell
$ kubectl apply -k ./prod

deployment.apps/ldap created
```

### KCL

我们可以编写如下 KCL 代码并命名为 main.k

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "ldap"
    labels.app = "ldap"
}
spec = {
    replicas = 1
    # When env is prod, override the `replicas` attribute with `6`
    if option("env") == "prod": replicas = 6
    # Assign `metadata.labels` to `selector.matchLabels`
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "osixia/openldap:1.1.11"
            args = ["--copy-service"]
            volumeMounts = [{ name = "ldap-data", mountPath = "/var/lib/ldap" }]
            ports = [{ containerPort = 80, name = "openldap" }]
        }
    ]
    template.spec.volumes = [
        {
            name = "ldap-data"
            emptyDir = {}
            # When env is prod
            # override the `emptyDir` attribute with `None`
            # patch a `gcePersistentDisk` attribute with the value `{readOnly = True, pdName = "ldap-persistent-storage"}`
            if option("env") == "prod":
                emptyDir = None
                gcePersistentDisk = {
                    readOnly = True
                    pdName = "ldap-persistent-storage"
                }
        }
    ]
}
```

上述 KCL 代码中我们分别声明了一个 Kubernetes Deployment 资源的 `apiVersion`、`kind`、`metadata` 和 `spec` 等变量，并分别赋值了相应的内容，特别地，我们将 `metadata.labels` 字段分别重用在 `spec.selector.matchLabels` 和 `spec.template.metadata.labels` 字段。可以看出，相比于 Kustomize 或者 YAML，KCL 定义的数据结构更加紧凑，而且可以通过定义局部变量实现配置重用。

在 KCL 中，我们可以通过条件语句和 option 函数动态地接收外部参数，为不同的环境需要设置不同的配置值生成不同环境的资源。比如对于如上代码，我们编写了一个条件语句并输入一个名为 `env` 的动态参数，当 `env` 为 `prod` 时，我们将 `replicas` 字段由 `1` 覆盖为 `6`，并且对名为 `ldap-data` 的 volume 配置进行一些调整，如将 `emptyDir` 字段修改为 `None`, 增加 `gcePersistentDisk` 的配置值等。

可以使用如下命令查看不同环境配置的 diff

```bash
diff \
  <(kcl main.k) \
  <(kcl main.k -D env=prod) |\
  more
```

输出如下:

```diff
8c8
<   replicas: 1
---
>   replicas: 6
30c30,33
<         emptyDir: {}
---
>         emptyDir: null
>         gcePersistentDisk:
>           readOnly: true
>           pdName: ldap-persistent-storage
```

可以看到生产环境的配置和基本配置的 diff 主要在于 `replicas` 和 `emptyDir` 等字段，与预期相符

此外，我们可以使用 KCL 命令行工具的 -o 参数将编译产生的 YAML 输出到文件中，并查看文件之间的 diff

```bash
# Generate base deployment
kcl main.k -o deployment.yaml
# Generate prod deployment
kcl main.k -o prod-deployment.yaml -D env=prod
# Diff prod deployment and base deployment
diff prod-deployment.yaml deployment.yaml
```

当然我们也可以将 KCL 工具与 kubectl 等工具结合使用，将生产环境的配置下发到集群当中

```shell
$ kcl main.k -D env=prod | kubectl apply -f -

deployment.apps/ldap created
```

可以从命令行的结果看出与我们使用直接使用 Kustomize 配置和 kubectl apply 的一个 Deployment 体验完全一致，并且无更多的副作用

最后，通过 kubectl 检查部署状态

```shell
$ kubectl get deploy

NAME   READY   UP-TO-DATE   AVAILABLE   AGE
ldap   0/6     6            0           15s
```

## 小结

本期内容大概简单介绍了用 KCL 编写复杂多环境 Kubernetes 配置的快速入门和使用 Kustomize 工具进行 Kubernetes 多环境配置管理的对比，可以看出相比于 Kustomize, KCL 在实现配置复用和覆盖的基础上，通过代码化的方式减少了配置文件的个数和代码行数，提升了信息密度比，并且同 Kustomize 一样是一个纯客户端方案，并不会对集群有额外依赖或造成负担。
