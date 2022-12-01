
# KCL 与其他工具 Kubernetes 配置管理工具的异同

## KCL 和 Kustomize 的区别

[Kustomize](https://kustomize.io/)：提供了一种无需模板和即可自定义 Kubernetes 资源基础配置和差异化配置的解决方案，通过文件级的 YAML 配置方式完成配置合并或覆盖，在 KCL 中可以通过代码编写的方式，在 Kustomize 中用户需要更详细地了解将要发生更改的内容和位置，对于复杂递归过深的基础 YAML 可能不太容器选择器来匹配 Kustomize 文件。而在 KCL 中，用户可以直接把对应代码需要修改的配置书写在对应的地方，免去了阅读基础 YAML 的成本，信息密度也更高

+ Kustomize 基础配置 base.yaml

```yaml
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
```

+ Kustomize 生产环境的 patches.yaml

```yaml
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
            pdName: ldap-persistent-storage
```

+ KCL

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "ldap"
    labels.app = "ldap"
}
spec = {
    replicas = 1
    if option("env") == "prod": replicas = 6
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = _app
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
            if option("env") == "prod":
                emptyDir = None
                gcePersistentDisk.pdName = "ldap-persistent-storage"
        }
    ]
}
```

## KCL 和 Helm 的区别

[Helm](https://helm.sh/) 是 Kubernetes 资源的包管理工具，通过配置模版管理 Kubernetes 资源配置，它可以在 `.tpl` 文件中定义可复用的模版，而在 KCL 中均为高级语言的编程方式，不需要额外的语法去指定模版，不需要过多的 `{{ * }}` 来标记代码块，信息密度更高，并且可以通过常规编程语言变量定义和条件语句的方式，比较自然。而 Helm 中有大量的 `{{- include }}` 和 `nindent` 等和实际逻辑无关的标记字符，需要在每一次引用的地方计算空格和缩进，语法噪音较高

+ Helm

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "foo.deploymentName" . }}
  labels:
    {{- include "foo.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "foo.selectorLabels" . | nindent 6 }}
  template:
    metadata:
    {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
      labels:
        {{- include "foo.labels" . | nindent 8 }}
```

+ KCL

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = option("deploymentName")
    labels = option("labels")
}
spec = {
    replicas = option("replicaCount")
    selector.matchLabels = option("selectorLabels")
    template.metadata = {
        labels = option("labels")
        annotations = option("annotations")
    }
}
```
