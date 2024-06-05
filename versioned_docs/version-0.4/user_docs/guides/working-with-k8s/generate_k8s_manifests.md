# Use KCL to Generate and Manage Kubernetes Resources

When we deploy software systems, we do not think they are fixed. Evolving business requirements, infrastructure requirements, and other factors mean that systems are constantly changing. When we need to change the system behavior quickly, and the change process needs expensive and lengthy reconstruction and redeployment process, business code change is often not enough. Configuration can provide us with a low overhead way to change system functions. For example, we often write JSON or YAML files as shown below for our system configuration.

- JSON configuration

```json
{
  "server": {
    "addr": "127.0.0.1",
    "listen": 4545
  },
  "database": {
    "enabled": true,
    "ports": [8000, 8001, 8002]
  }
}
```

- YAML configuration

```yaml
server:
  addr: 127.0.0.1
  listen: 4545
database:
  enabled: true
  ports:
    - 8000
    - 8001
    - 8002
```

We can choose to store the static configuration in JSON and YAML files as needed. In addition, the configuration can also be stored in a high-level language that allows more flexible configuration, which can be coded, rendered, and statically configured. KCL is such a configuration language. We can write KCL code to generate JSON/YAML and other configurations.

## Why use KCL

When we manage the Kubernetes resources, we often maintain it by hand, or use Helm and Kustomize tools to maintain our YAML configurations or configuration templates, and then apply the resources to the cluster through kubectl tools. However, as a "YAML engineer", maintaining YAML configuration every day is undoubtedly trivial and boring, and prone to errors. For example as follows:

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

- The structured data in YAML is untyped and lacks validation methods, so the validity of all data cannot be checked immediately.
- YAML has poor programming ability. It is easy to write incorrect indents and has no common code organization methods such as logical judgment. It is easy to write a large number of repeated configurations and difficult to maintain.
- The design of Kubernetes is complex, and it is difficult for users to understand all the details, such as the `toleration` and `affinity` fields in the above configuration. If users do not understand the scheduling logic, it may be wrongly omitted or superfluous added.

Therefore, KCL expects to solve the following problems in Kubernetes YAML resource management:

- Use **production level high-performance programming language** to **write code** to improve the flexibility of configuration, such as conditional statements, loops, functions, package management and other features to improve the ability of configuration reuse.
- Improve the ability of **configuration semantic verification** at the code level, such as optional/required fields, types, ranges, and other configuration checks.
- Provide **the ability to write, combine and abstract configuration blocks**, such as structure definition, structure inheritance, constraint definition, etc.

## How to use KCL to generate and manage Kubernetes resources

### Prerequisite

First, you can visit the [KCL Quick Start](/docs/user_docs/getting-started/kcl-quick-start) to download and install KCL according to the instructions, and then prepare a [Kubernetes](https://kubernetes.io/) environment.

### Generate Kubernetes manifests

We can write the following KCL code and name it `main.k`. KCL is inspired by Python. Its basic syntax is very close to Python, which is easy to learn. The configuration mode is simple, `k [: T] = v`, where `k` denotes the configured attribute name, `v` denotes the configured attribute value and `: T` denotes an optional type annotation.

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

In the above KCL code, we declare the `apiVersion`, `kind`, `metadata`, `spec` and other variables of a Kubernetes `Deployment` resource, and assign the corresponding contents respectively. In particular, we will assign `metadata.labels` fields are reused in `spec.selector.matchLabels` and `spec.template.metadata.labels` field. It can be seen that, compared with YAML, the data structure defined by KCL is more compact, and configuration reuse can be realized by defining local variables.

We can get a Kubernetes YAML file by executing the following command line

```bash
kcl main.k
```

The output is

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

Of course, we can use KCL together with kubectl and other tools. Let's execute the following commands and see the result:

```shell
$ kcl main.k | kubectl apply -f -

deployment.apps/nginx-deployment configured
```

It can be seen from the command line that it is completely consistent with the deployment experience of using YAML configuration and kubectl application directly.

Check the deployment status through kubectl

```shell
$ kubectl get deploy

NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           15s
```

### Write code to manage Kubernetes resources

When publishing Kubernetes resources, we often encounter scenarios where configuration parameters need to be dynamically specified. For example, different environments need to set different `image` field values to generate resources in different environments. For this scenario, we can dynamically receive external parameters through KCL conditional statements and `option` functions. Based on the above example, we can adjust the configuration parameters according to different environments. For example, for the following code, we wrote a conditional statement and entered a dynamic parameter named `env`.

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

Use the KCL command line `-D` flag to receive an external dynamic parameter:

```bash
kcl main.k -D env=prod
```

The output is

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

The `image=metadata.name+": 1.14.2" if option ("env")=="prod" else metadata.name + ": latest"` in the above code snippet means that when the value of the dynamic parameter `env` is set to `prod`, the value of the image field is `nginx: 1.14.2`; otherwise, it is' nginx: latest'. Therefore, we can set env to different values as required to obtain Kubernetes resources with different contents.

KCL also supports maintaining the dynamic parameters of the option function in the configuration file, such as writing the `kcl.yaml` file.

```yaml
kcl_options:
  - key: env
    value: prod
```

The same YAML output can be obtained by using the following command line to simplify the input process of KCL dynamic parameters.

```bash
kcl main.k -Y kcl.yaml
```

The output is:

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
