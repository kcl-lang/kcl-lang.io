# 使用 KCL 生成并管理 Kubernetes 资源配置

## 简介

当我们管理 Kubernetes 资源清单时，我们常常会手写维护，或者使用 Helm 和 Kustomize 等工具来维护我们 YAML 配置或者配置模版，然后通过 kubectl 和 helm 命令行等工具将资源下发到集群。但是作为一个 "YAML 工程师" 每天维护 YAML 配置无疑是琐碎且无聊的，并且容易出错。

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: ... # Omit
spec:
  selector:
    matchlabels:
      cell: RZ00A
  replicas: 2
  template:
    metadata: ... # Omit
    spec:
      tolerations:
      - effect: NoSchedules
        key: is-over-quota
        operator: Equal
        value: 'true'
      containers:
      - name: test-app
          image: images.example/app:v1 # Wrong ident
        resources:
          limits:
            cpu: 2 # Wrong type. The type of cpu should be str
            memory: 4Gi
            # Field missing: ephemeral-storage
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: is-over-quota
                operator: In
                values:
                - 'true'
```

+ YAML 中的结构化数据是无类型的，缺乏验证方法，无法立即检查所有数据的有效性
+ YAML 编程能力欠佳，容易写出不正确的缩进，也没有逻辑判断等常见代码组织方式，容易写出大量重复配置，难以维护
+ Kubernetes 设计是复杂的，用户很难理解所有细节，比如上面配置中的 `toleration` 和 `affinity` 字段，如果用户不理解调度逻辑，它可能被错误地省略掉或者多余的添加

因此，KCL 期望在 Kubernetes YAML 资源管理解决如下问题：

+ 用**生产级高性能编程语言**以**编写代码**的方式提升配置的灵活度，比如条件语句、循环、函数、包管理等特性提升配置重用的能力
+ 在代码层面提升**配置语义验证**的能力，比如字段可选/必选、类型、范围等配置检查能力
+ 提供**配置分块编写、组合和抽象的能力**，比如结构定义、结构继承、约束定义等能力

## 使用 KCL 生成并管理 Kubernetes 资源

### 0. 前提条件

首先可以在 [KCL 快速开始](/docs/user_docs/getting-started/kcl-quick-start) 根据指导下载并安装 KCL，然后准备一个 [Kubernetes](https://kubernetes.io/) 环境

### 1. 生成 Kubernetes 资源

我们可以编写如下 KCL 代码并命名为 main.k ，KCL 受 Python 启发，基础语法十分接近 Python, 比较容易学习和上手, 配置模式写法很简单，`k [: T] = v`, 其中 `k` 表示配置的属性名称; `v` 表示配置的属性值; `: T` 表示一个可选的类型注解。

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
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

上述 KCL 代码中我们分别声明了一个 Kubernetes Deployment 资源的 `apiVersion`、`kind`、`metadata` 和 `spec` 等变量，并分别赋值了相应的内容，特别地，我们将 `metadata.labels` 字段分别重用在 `spec.selector.matchLabels` 和 `spec.template.metadata.labels` 字段。可以看出，相比于 YAML，KCL 定义的数据结构更加紧凑，而且可以通过定义局部变量实现配置重用。

我们可以执行如下命令行得到一个 Kubernetes YAML 文件

```bash
kcl main.k
```

输出为:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
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
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

当然我们可以将 KCL 工具与 kubectl 等工具结合使用，让我们执行如下命令并看看效果

```bash
$ kcl main.k | kubectl apply -f -

deployment.apps/nginx-deployment configured
```

可以从命令行的结果看出与我们使用直接使用 YAML 配置和 kubectl apply 的一个 Deployment 体验完全一致

通过 kubectl 检查部署状态

```bash
$ kubectl get deploy

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           15s
```

### 2. 编写代码管理 Kubernetes 资源

对于 Kubernetes 资源发布时，我们常常会遇到配置参数需要动态指定的场景，比如不同的环境需要设置不同的 `image` 字段值生成不同环境的资源。对于这种场景，我们可以通过 KCL 的条件语句和 `option` 函数动态地接收外部参数。我们可以在上述例子的基础上根据不同的环境调整配置参数，比如对于如下代码，我们编写了一个条件语句并输入一个名为 `env` 的动态参数

```python
apiVersion = "apps/v1"
kind = "Deployment"
metadata = {
    name = "nginx"
    labels.app = "nginx"
}
spec = {
    replicas = 3
    selector.matchLabels = metadata.labels
    template.metadata.labels = metadata.labels
    template.spec.containers = [
        {
            name = metadata.name
            image = "${metadata.name}:1.14.2" if option("env") == "prod" else "${metadata.name}:latest"
            ports = [{ containerPort = 80 }]
        }
    ]
}
```

使用 KCL 命令行 `-D` 标记接收一个外部设置的动态参数：

```bash
kcl main.k -D env=prod
```

输出为:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
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
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

上述代码片段中的 `image = metadata.name + ":1.14.2" if option("env") == "prod" else  metadata.name + ":latest"` 意思为：当动态参数 `env` 的值被设置为 `prod` 时，image 字段值为 `nginx:1.14.2`, 否则为 `nginx:latest`，因此我们可以根据需要为 env 设置为不同的值获得不同内容的 Kubernetes 资源。

并且 KCL 支持将 option 函数动态参数维护在配置文件中，比如编写下面展示的 `kcl.yaml` 文件

```yaml
kcl_options:
  - key: env
    value: prod
```

使用如下命令行也可以得到同样的 YAML 输出，以简化 KCL 动态参数的输入过程

```bash
kcl main.k -Y kcl.yaml
```

输出为:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
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
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
