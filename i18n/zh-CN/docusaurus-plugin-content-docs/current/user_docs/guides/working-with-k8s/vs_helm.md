# KCL 与其他 Kubernetes 配置管理工具的异同 - Helm 篇

在[上一节](/docs/user_docs/guides/working-with-k8s/generate_k8s_manifests)中，我们介绍了如何使用 KCL 编写并管理 Kubernetes 配置并将配置下发到集群，这一节我们通过与其他 Kubernetes 配置管理工具的对比如 Helm 介绍 KCL 在 Kubernetes 配置管理场景更丰富的内容。

[Helm](https://helm.sh/) 是一个为 Kubernetes 对象生成可部署清单的工具，它承担了以两种不同形式生成最终清单的任务。Helm 是一个管理 Kubernetes 包（称为 charts）的必备模板工具。图表是 YAML 清单的模板化版本，其中混合了 Go template 的子集，它也是 Kubernetes 的包管理器，可以打包、配置和部署/应用 Helm 图表到 Kubernetes 集群。

在 KCL 中，用户可以使用更多的工具和 IDE 插件支持直接编写配置代码文件，而不是模板文件，这些工具和插件支持需要在相应位置的代码中进行修改，从而消除了读取 YAML 的成本。同时，用户可以通过代码重用配置片段，避免了YAML 配置的大量复制和粘贴。信息密度更高，更不容易出错。

下面以一个经典的 Helm Chart 配置管理的例子详细说明 Kustomize 和 KCL 在 Kubernetes 资源配置管理上的区别。

## Helm

Helm 具备 `values.yaml` 和 `template` 的概念, 通常一个 Helm Chart 由一个包含 `Chart.yaml` 的路径组成。我们可以执行如下命令获得一个典型的 Helm Chart 工程

+ 创建 `workload-helm` 目录来保存 chart 工程

```bash
# Create a directory to hold the chart project
mkdir workload-helm
# Create a workload-helm/Chart.yaml
cat <<EOF > workload-helm/Chart.yaml
apiVersion: v2
appVersion: 0.3.0
description: A helm chart to provision standard workloads.
name: workload
type: application
version: 0.3.0
EOF
# Create a workload-helm/values.yaml
cat <<EOF > workload-helm/values.yaml
service:
  type: ClusterIP
  ports:
    - name: www
      protocol: TCP
      port: 80
      targetPort: 80

containers:
  my-container:
    image:
      name: busybox:latest
    command: ["/bin/echo"]
    args: 
      - "-c"
      - "Hello World!"
    resources:
      limits:
        cpu: 100m
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi
EOF
```

+ 创建模版文件夹

```bash
# Create a directory to hold templates
mkdir workload-helm/templates
# Create a workload-helm/templates/helpers.tpl
cat <<EOF > workload-helm/templates/helpers.tpl
{{/*
Expand the name of the chart.
*/}}
{{- define "workload.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workload.fullname" -}}
{{- \$name := default .Chart.Name .Values.nameOverride }}
{{- if contains \$name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name \$name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "workload.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{/*
Common labels
*/}}
{{- define "workload.labels" -}}
helm.sh/chart: {{ include "workload.chart" . }}
{{ include "workload.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
{{/*
Selector labels
*/}}
{{- define "workload.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workload.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
EOF
cat <<EOF > workload-helm/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "workload.name" . }}
  labels:
    {{- include "workload.labels" . | nindent 4 }}
spec:
  selector:
    matchLabels:
      {{- include "workload.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "workload.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        {{- range \$name, \$container := .Values.containers }}
        - name: {{ \$name }}
          image: "{{ $container.image.name }}"
          {{- with \$container.command }}
          command:
            {{- toYaml \$container.command | nindent 12 }}
          {{- end }}
          {{- with \$container.args }}
          args:
            {{- toYaml \$container.args | nindent 12 }}
          {{- end }}
          {{- with \$container.env }}
          env:
            {{- toYaml \$container.env | nindent 12 }}
          {{- end }}
          {{- with \$container.volumeMounts }}
          volumeMounts:
            {{- toYaml \$container.volumeMounts | nindent 12 }}
          {{- end }}
          {{- with \$container.livenessProbe }}
          livenessProbe:
            {{- toYaml \$container.livenessProbe | nindent 12 }}
          {{- end }}
          {{- with \$container.readinessProbe }}
          readinessProbe:
            {{- toYaml \$container.readinessProbe | nindent 12 }}
          {{- end }}
          {{- with \$container.resources }}
          resources:
            {{- toYaml \$container.resources | nindent 12 }}
          {{- end }}
        {{- end }}
EOF
cat <<EOF > workload-helm/templates/service.yaml
{{ if .Values.service }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "workload.name" . }}
  labels:
    {{- include "workload.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  selector:
    {{- include "workload.selectorLabels" . | nindent 4 }}
  {{- with .Values.service.ports }}
  ports:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
EOF
```

可以得到如下的 Helm chart 工程

```txt
.
├── Chart.yaml
├── templates
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   └── service.yaml
└── values.yaml
```

我们可以通过如下的命令渲染真实的部署配置

```bash
helm template workload-helm
```

可以得到如下 YAML 输出

```yaml
---
# Source: workload-helm/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: release-name
  labels:
    helm.sh/chart: workload-0.3.0
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.3.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  selector:
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
  ports:
    - name: www
      port: 80
      protocol: TCP
      targetPort: 80
---
# Source: workload-helm/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name
  labels:
    helm.sh/chart: workload-0.3.0
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
    app.kubernetes.io/version: "0.3.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: release-name
      app.kubernetes.io/instance: release-name
  template:
    metadata:
      labels:
        app.kubernetes.io/name: release-name
        app.kubernetes.io/instance: release-name
    spec:
      containers:
        - name: my-container
          image: "busybox:latest"
          command:
            - /bin/echo
          args:
            - -c
            - Hello World!
          resources:
            limits:
              cpu: 100m
              memory: 128Mi
            requests:
              cpu: 100m
              memory: 128Mi
```

## KCL

在 KCL 中，我们提供了与 Helm `values.yaml` 相似的动态配置参数 `kcl.yaml` 文件，我们可以执行如下的命令获得一个典型的 KCL 工程。

+ 创建 `workload-kcl` 目录来保存 KCL 工程

```bash
# Create a directory to hold the KCL project
mkdir workload-kcl
# Create a workload-kcl/kcl.yaml
cat <<EOF > workload-kcl/kcl.yaml
kcl_options:
  - key: containers
    value:
      my-container:
        image:
          name: busybox:latest
        command: ["/bin/echo"]
        args: 
          - "-c"
          - "Hello World!"
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
          requests:
            cpu: 100m
            memory: 128Mi

  - key: service
    value:
      type: ClusterIP
      ports:
        - name: www
          protocol: TCP
          port: 80
          targetPort: 80
EOF
```

+ 创建如下 KCL 文件来保存 kubernetes 资源

```bash
# Create a workload-kcl/deployment.k
cat <<EOF > workload-kcl/deployment.k
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "release-name"
    labels = {
        "app.kubernetes.io/name" = "release-name"
        "app.kubernetes.io/instance" = "release-name"
    }
}
spec = {
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = name
            image = container.image.name
            command = container.command
            command = container.args
            env = container.env
            resources = container.resources
        } for name, container in option("containers") or {}
    ]
}
EOF
cat <<EOF > workload-kcl/service.k
apiVersion = "v1"
kind = "Service"
metadata = {
    name = "release-name"
    labels = {
        "app.kubernetes.io/name" = "release-name"
        "app.kubernetes.io/instance" = "release-name"
    }
}
spec = {
    selector.matchLabels = metadata.labels
    type = option("service", default={})?.type
    ports = option("service", default={})?.ports
}
EOF
```

上述 KCL 代码中我们分别声明了一个 Kubernetes `Deployment` 和 `Service` 资源的 `apiVersion`、`kind`、`metadata` 和 `spec` 等变量，并分别赋值了相应的内容，特别地，我们将 `metadata.labels` 字段分别重用在 `spec.selector.matchLabels` 和 `spec.template.metadata.labels` 字段。可以看出，相比于 Helm 模版 或者 YAML，KCL 定义的数据结构更加紧凑，而且可以通过定义局部变量实现配置重用。

在 KCL 中，我们可以通过条件语句和 `option` 内置函数接收动态参数，并设置不同的配置值以生成资源。

可以通过如下的命令得到 `Deployment` 和 `Service` YAML 输出:

+ `Deployment`

```yaml
$ kcl workload-kcl/deployment.k -Y workload-kcl/kcl.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: release-name
  labels:
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: release-name
      app.kubernetes.io/instance: release-name
  template:
    metadata:
      labels:
        app.kubernetes.io/name: release-name
        app.kubernetes.io/instance: release-name
    spec:
      containers:
      - name: my-container
        image: busybox:latest
        command:
        - -c
        - Hello World!
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
          requests:
            cpu: 100m
            memory: 128Mi
```

+ `Service`

```yaml
$ kcl workload-kcl/service.k -Y workload-kcl/kcl.yaml
apiVersion: v1
kind: Service
metadata:
  name: release-name
  labels:
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: release-name
      app.kubernetes.io/instance: release-name
  type: ClusterIP
  ports:
  - name: www
    protocol: TCP
    port: 80
    targetPort: 80
```

此外我们可以通过 `-D` 标志设置额外的参数并覆盖 `kcl.yaml` 文件的配置值

```yaml
$ kcl workload-kcl/service.k -Y workload-kcl/kcl.yaml -D service=None
apiVersion: v1
kind: Service
metadata:
  name: release-name
  labels:
    app.kubernetes.io/name: release-name
    app.kubernetes.io/instance: release-name
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: release-name
      app.kubernetes.io/instance: release-name
  type: null
  ports: null
```

## 小结

可以看出，与 Helm 相比，KCL 通过在配置重用和覆盖的基础上生成代码，减少了配置文件和代码行的数量。与 Helm 一样，它是一个纯客户端解决方案，可以将配置和策略验证尽可能地左移，而不会对集群造成额外的依赖或负担，或者甚至没有 Kubernetes 集群时也可以通过 KCL Schema 等特性对 YAML 进行充分验证和测试。

Helm 可以在 `.tpl` 文件中定义可重用模板，并支持其他模板引用它。但是，只有模板定义才能重用。在一个复杂的 Helm 图表项目中，我们需要定义许多附加的基本模板。与Helm繁 琐的写作方法相比，KCL 中的所有内容都是变量。指定模板不需要其他语法。任何变量都可以相互引用。

此外，Helm 中还有大量与实际逻辑无关的 `{{- include}}}`, `nindent` 和 `toYaml` 标记字符，我们需要计算每个 Helm 引用处的空格和缩进。在 KCL 中，无用代码更少，并且不需要很多的 `{{*}}` 来标记代码块，信息密度更高。

事实上，KCL 和 Helm Chart 并不对立。我们甚至可以使用 KCL 编写 Helm 模板或者使用 KCL 来生成 `values.yaml`，或者为现有的 Helm 图表提供可编程扩展功能，比如为 Helm 开发可选的 KCL Schema 插件来验证已有的 Helm 图表或者为 Helm Chart 编写额外的 Transformer 来 Patch 已有的 Helm Chart。

## 未来计划

我们后续计划 KCL 的模型和约束可以作为一个包来管理（这个包只有 KCL 文件）。例如，Kubernetes 的模型和约束可以开箱即用。用户可以通过已有的模型生成配置或验证现有配置，并且可以通过 KCL 继承手段简单地扩展用户想要的模型和约束。

在此阶段，您可以使用 Git 或 [OCI Registry as Storage（ORAS)](https://github.com/oras-project/oras) 等工具来管理 KCL 配置版本。

如果您喜欢这篇文章，一定记得收藏 + 关注！！更多精彩内容请访问:

+ KCL 仓库地址：https://github.com/KusionStack/KCLVM
+ Kusion 仓库地址：https://github.com/KusionStack/kusion
+ Konfig 仓库地址：https://github.com/KusionStack/konfig

如果您喜欢这些项目，欢迎 Github Star 鼓励一下 🌟🌟🌟，同时欢迎访问下面的链接加入我们的社区进行交流 👏👏👏

+ https://github.com/KusionStack/community
