---
title: "使用 KCL Schema 编写复杂配置"
linkTitle: "使用 KCL Schema 编写复杂配置"
type: "docs"
weight: 2
description: 使用 KCL Schema 编写复杂配置
sidebar_position: 2
---
## 1. Introduction

KCL is a simple and easy-to-use configuration language, where users can simply write the reusable configuration code.

In this codelab, we will learn how to write customized config using KCL, such that we can define a schema and write the config in a collaborative way.

### What We Will Learn

1. Define a simple schema
2. Set default immutable values to schema fields
3. Create config based on a simple schema
4. Write complex logic in schema
5. Create a new schema via schema combinations
6. Create a config of a deeply nested schema using dict/map
7. Create new schema via schema inheritance
8. Create new schema via multiple mixin schemas
9. Declare validation rules for the schema
10. Config schema output layout
11. Share and reuse schema

## 2. Write Simple Schema

Suppose we want to define a workload with certain attributes, we can create a simple config by creating a `my_config.k`, we can fill in the following code as below which defines a reusable schema of the configuration of deploy.

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: str
    replica: int
    command: [str]
    labels: {str:str}
```

In the code above, `cpu` and `memory` are defined as int value; `name`, `image` and `service` are string; `command` is a list of string type; `labels` is a dict type, whose key type and value type are both string.

Besides, each attribute **must** be assigned with a not-None value as a schema instance unless it is modified by a question mark **?** as an optional attribute.

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: str
    replica: int
    command: [str]
    labels?: {str:str}  # labels is an optional attribute 
```

When there is an inheritance relationship:

- If the attribute is optional in the base schema, it could be optional or required in the sub-schema.
- If the attribute is required in the base schema, it must be required in the sub-schema.

## 3. Enhance Schema as Needed

Suppose we need to set default values to service and replica, we can make them as below:

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: str = "my-service"  # defaulting
    replica: int = 1  # defaulting
    command: [str]
    labels?: {str:str}  # labels is an optional attribute 
```

And then we can set the service type annotation as the string literal type to make it immutable:

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: "my-service" = "my-service"
    replica: int = 1
    command: [str]
    labels?: {str:str}
```

In the schema, type hint is a `must`, for example we can define cpu as `cpu: int`.

Specially, we can define a string-interface dict as `{str:}`, and in case we want to define an object or interface, just define as `{:}`.

## 4. Create Config Based on Simple Schema

Now we have a simple schema definition, we can use it to define config as:

```python
nginx = Deployment {
    name = "my-nginx"
    cpu = 256
    memory = 512
    image = "nginx:1.14.2"
    command = ["nginx"]
    labels = {
        run = "my-nginx"
        env = "pre-prod"
    }
}
```

Run with the following KCL command, we should be able to see the generated yaml files as the output as below:

KCL command:

```
    kcl my_config.k
```

Stdout:

```yaml
nginx:
  name: my-nginx
  cpu: 256
  memory: 512
  image: nginx:1.14.2
  service: my-service
  replica: 1
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
```

> Check the manual and specification out for more details about collection data types and block.

In addition, the **config selector expressions** can be used to init a schema instance, and we can ignore the comma at the end of the line in the config expression.

```python
nginx = Deployment {
    name = "my-nginx"
    cpu = 256
    memory = 512
    image = "nginx:1.14.2"
    command = ["nginx"]  # Ignore the comma at the end of the line
    labels.run = "my-nginx"  # A dict variable in schema can use selector expressions
    labels.env = "pre-prod"  # A dict variable in schema can use selector expressions
}
```

## 5. Write More Complex Logic in Schema

Suppose we have some schema logic, we can wrapper it into schema:

```python
schema Deployment[priority]:
    name: str
    cpu: int = _cpu
    memory: int = _cpu * 2
    image: str
    service: "my-service" = "my-service"
    replica: int = 1
    command: [str]
    labels?: {str:str}

    _cpu = 2048
    if priority == 1:
        _cpu = 256
    elif priority == 2:
        _cpu = 512
    elif priority == 3:
        _cpu = 1024
    else:
        _cpu = 2048
```

Now, we can define a config by creating a schema instance and pass in priority as an argument to schema:

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1.14.2"
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
}
```

Run with kcl, we should see the generated yaml files as output as below:

KCL command:

```
kcl my_config.k
```

Stdout:

```yaml
nginx:
  name: my-nginx
  cpu: 512
  memory: 1024
  image: nginx:1.14.2
  service: my-service
  replica: 1
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
```

## 6. Create New Schema via Schema Combinations

Now we want to define a detailed schema with service and volumes, we can do it as follows:

```python
schema Deployment[priority]:
    name: str
    cpu: int = _cpu
    memory: int = _cpu * 2
    volumes?: [Volume]
    image: str
    service?: Service
    replica: int = 1
    command: [str]
    labels?: {str:str}

    if priority == 1:
        _cpu = 256
    elif priority == 2:
        _cpu = 512
    elif priority == 3:
        _cpu = 1024
    else:
        _cpu = 2048

schema Port:
    name: str
    protocol: str
    port: int
    targetPort: int

schema Service:
    name: "my-service" = "my-service"
    ports: [Port]

schema Volume:
    name: str
    mountPath: str
    hostPath: str
```

In this case, Deployment is composed of Service and a list of Volumes, and Service is composed of a list of Ports.

## 7. Create Config of Deeply Nested Schema using Dict/Map

Now we have a new Deployment schema, however, we may notice that it contains multiple layers of nested structures, in fact, this is very common in complex structure definitions, and we often have to write imperative assembly code to generate the final structure.

With KCL, we can create the config with simple dict declaration, with the capability of full schema initialization and validation. For example, we can simply config nginx by the new Deployment schema as follows:

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1.14.2"
    volumes = [Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
    service.ports = [Port {
        name = "http"
        protocol = "TCP"
        port = 80
        targetPort = 9376
    }]
}
```

Run with KCL, we will see the generated yaml files as below:

KCL command:

```
kcl my_config.k
```

Stdout:

```yaml
nginx:
  name: my-nginx
  cpu: 512
  memory: 1024
  volumes:
  - name: mydir
    mountPath: /test-pd
    hostPath: /data
  image: nginx:1.14.2
  service:
    name: my-service
    ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
  replica: 1
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
```

Note that, the dict that we use to define Deployment config must be aligned with the schema definition, otherwise we will get an error. For example, suppose we define a wrong type of service port as below:

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1.14.2"
    volumes = [Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
    service.ports = [Port {
        name = "http"
        protocol = "TCP"
        port = [80]  # wrong data type, trying to assign List to int
        targetPort = 9376
    }]
}
```

Run with KCL, we will see the error message as output as below:

KCL command:

```python
kcl my_config.k
```

Stderr:

```
The type got is inconsistent with the type expected: expect int, got [int(80)]
```

## 8. Declare Schema Validation Rules

Now we have seen a complex schema, in which every field has a type hint to make it less error-prone. But this is not good enough, we want to support more enhanced verifications to our schemas, so that code errors in schemas and configs can be discovered as soon as possible.

Lots of validation rules, like None type check, range check, value check, length check, regular expression matching, enum check have already been added or in progress. Here is a code sample:

```python
import regex

schema Deployment[priority]:
    name: str
    cpu: int = _cpu
    memory: int = _cpu * 2
    volumes?: [Volume]
    image: str
    service?: Service
    replica: int = 1
    command: [str]
    labels?: {str:str}

    if priority == 1:
        _cpu = 256
    elif priority == 2:
        _cpu = 512
    elif priority == 3:
        _cpu = 1024
    else:
        _cpu = 2048

    check:
        multiplyof(cpu, 256), "cpu must be a multiplier of 256"
        regex.match(image, "^[a-zA-Z]+:\d+\.\d+\.\d+$"), "image name should be like 'nginx:1.14.2'"
        1 <= replica < 100, "replica should be in range (1, 100)"
        len(labels) >= 2 if labels, "the length of labels should be large or equal to 2"
        "env" in labels, "'env' must be in labels"
        len(command) > 0, "the command list should be non-empty"

schema Port:
    name: str
    protocol: str
    port: int
    targetPort: int

    check:
        port in [80, 443], "we can only expose 80 and 443 port"
        protocol in ["HTTP", "TCP"], "protocol must be either HTTP or TCP"
        1024 < targetPort, "targetPort must be larger than 1024"

schema Service:
    name: "my-service" = "my-service"
    ports: [Port]

    check:
        len(ports) > 0, "ports list must be non-empty"

schema Volume:
    name: str
    mountPath: str
    hostPath: str
```

Since the attributes defined by the schema are **required** by default, the verification that judges that the variable cannot be None/Undefined can be omitted.

```python
schema Volume:
    name: str
    mountPath: str
    hostPath: str
```

Now we can write the config based on the new schema and expose config errors in time. For example, with the invalid config as below:

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1142"  # image value is not matching the regex
    volumes = [Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
    service.ports = [Port {
        name = "http"
        protocol = "TCP"
        port = 80
        targetPort = 9376
    }]
}
```

Every field is type-valid, but the image name is invalid.

Run with KCL, we will see the error message as below:

KCL command:

```
kcl my_config.k
```

Stderr:

```
Schema check is failed to check condition: regex.match(image, "^[a-zA-Z]+:\d+\.\d+\.\d+$"), "image name should be like 'nginx:1.14.2'"
```

> The verification capability of KCL covers the verification defined by Openapi so that we can write any API verifications through KCL.

## 9. Create New Schema via Schema Inheritance

Now we have a solid Deployment schema definition and we can use it to declare config.

Usually, schema Deployment will be used in multiple scenarios. We can directly use the schema to declare the configurations in different use cases (see the above section), or we can produce a more specific schema definition through inheritance.

For example, we can use the Deployment schema as a basis, to define the nginx's base schema, and extend the definition
in each scenario.

In this case, we define some commonly used attributes. Please note that we mark the name to be immutable with the 'final' keyword to prevent it from being overwritten.

```python
schema Nginx(Deployment):
    """ A base nginx schema """
    name: "my-nginx" = "my-nginx"
    image: str = "nginx:1.14.2"
    replica: int = 3
    command: [str] = ["nginx"]

schema NginxProd(Nginx):
    """ A prod nginx schema with stable configurations """
    volumes: [Volume] = [{
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    """ A volume mapped to host path """
    service: Service = {
        ports = [{
            name = "http"
            protocol = "TCP"
            port = 80
            targetPort = 9376
        }]
    }
    """ An 80 port to target backend server """
```

Now we have some static configurations for nginx. It is recommended to declare configurations that we think are static there, and put more dynamic configurations as below:

```python
nginx = Nginx {
    labels.run = "my-nginx"
    labels.env = "pre-prod"
}
```

```python
nginx = NginxProd {
    labels.run = "my-nginx"
    labels.env = "pre-prod"
}
```

Now, we can simply define nginx prod config just with runtime label value "prod" which is not that static.

In fact, under some complex situation, we can split all configurations into the basic, business, and environment configuration definitions in this way, and achieve collaboration among team members based on this.

Run with KCL, we will see the generated yaml files as output as below:

KCL command:

```
kcl prod_config.k
```

Stdout:

```yaml
nginx:
  name: my-nginx
  cpu: 512
  memory: 1024
  volumes:
  - name: mydir
    mountPath: /test-pd
    hostPath: /data
  image: nginx:1.14.2
  service:
    name: my-service
    ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
  replica: 3
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
```

## 10. Create New Schema by Multiple Protocol and Mixin Schemas Inheritance

Now, we can complete the declaration of the server configuration through the Deployment schema.

However, usually, the actual situation is more complicated, and the deployment may have a variety of optional variable accessories.

For example, we want to support a persistent volume claim based on an existing schema, as a reusable Kubernetes schema. In this case, we can just wrapper it with a `mixin` and a `protocol` as follows:

```python
import kusion_kubernetes.api.core.v1

protocol PVCProtocol:
    pvc?: {str:}

mixin PersistentVolumeClaimMixin for PVCProtocol:
    """
    PersistentVolumeClaim (PVC) sample:
    Link: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims
    """
    
    # Mix in a new attribute `kubernetesPVC`
    kubernetesPVC?: v1.PersistentVolumeClaim

    if pvc:
        kubernetesPVC = v1.PersistentVolumeClaim {
            metadata.name = pvc.name
            metadata.labels = pvc.labels
            spec = {
                accessModes = pvc.accessModes
                resources = pvc.resources
                storageClassName = pvc.storageClassName
            }
        }
```

With this PersistentVolumeClaimMixin, we define a PVC schema with a clear `user interface`, and use Kubernetes PVC as an implementation. Then, we can define a server schema with Deployment schema, and PVC mixin schema.

```
schema Server(Deployment):
    mixin [PersistentVolumeClaimMixin]
    pvc?: {str:}
    """ pvc user interface data defined by PersistentVolumeClaimMixin """
```

In the Server schema, Deployment is the base schema, and PersistentVolumeClaimMixin is an optional add-on whose user interface data is `pvc?: {str:}`.

Note, the `mixin` is often used to add new attributes to the host schema, or to modify the existing attributes of the host schema. Thus, `mixin` can use the attributes in the host schema. Since the `mixin` is designed to be reusable, we need an additional `protocol` to constrain the attribute names and types in the host schema for the `mixin`.

Now, if we want a deploy with a PVC, just declare as user interface:

```python
server = Server {
    name = "my-nginx"
    image = "nginx:1.14.2"
    volumes = [Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels = {
        run = "my-nginx"
        env = "pre-prod"
    }
    service.ports = [Port {
        name = "http"
        protocol = "TCP"
        port = 80
        targetPort = 9376
    }]
    pvc = {
        name = "my_pvc"
        accessModes = ["ReadWriteOnce"]
        resources.requests.storage = "8Gi"
        storageClassName = "slow"
    }
}
```

Run with kcl, we will see the generated yaml files as output as below:

KCL command:

```
kcl server.k
```

Stdout:

```yaml
server:
  name: my-nginx
  cpu: 512
  memory: 1024
  volumes:
  - name: mydir
    mountPath: /test-pd
    hostPath: /data
  image: nginx:1.14.2
  service:
    name: my-service
    ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
  replica: 1
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
  pvc:
    name: my_pvc
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 8Gi
    storageClassName: slow
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my_pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: slow
  resources:
    requests:
      storage: 8Gi
```

If we don't want a persistent volume, just remove the pvc config block.

## 11. Share and Reuse Schema

The Server schema could be shared via `import`, we can simply package our code with KCL.

```python
import pkg

server = pkg.Server {
    name = "my-nginx"
    image = "nginx:1.14.2"
    volumes = [Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
    service.ports = [Port {
        name = "http"
        protocol = "TCP"
        port = 80
        targetPort = 9376
    }]
}
```

Another skill we should know about sharing code is, modules under the same package do not need to import each other.

Suppose we have models in a pkg:

```
pkg/
    - deploy.k
    - server.k
    - pvc.k
```

And in `server.k`, we can just use Deployment schema in `deploy.k` and pvc schema in `pvc.k` without import:

```python
# no import needed
schema Server(Deployment):
    mixin [PersistentVolumeClaimMixin]
    pvc?: {str:}
    """ pvc user interface data defined by PersistentVolumeClaimMixin """
```

And then users must import the pkg to use it as a whole:

```python
import pkg

server = pkg.Server {
    name = "my-nginx"
    image = "nginx:1.14.2"
    volumes = [pkg.Volume {
        name = "mydir"
        mountPath = "/test-pd"
        hostPath = "/data"
    }]
    command = ["nginx"]
    labels = {
        run = "my-nginx"
        env = "pre-prod"
    }
    service.ports = [pkg.Port {
        name = "http"
        protocol = "TCP"
        port = 80
        targetPort = 9376
    }]
}
```

Run kcl command:

```
kcl pkg_server.k
```

Output:

```yaml
server:
  name: my-nginx
  cpu: 512
  memory: 1024
  volumes:
  - name: mydir
    mountPath: /test-pd
    hostPath: /data
  image: nginx:1.14.2
  service:
    name: my-service
    ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
  replica: 1
  command:
  - nginx
  labels:
    run: my-nginx
    env: pre-prod
```

## 12. The Final Step

Congratulations!

We have completed the second lesson about KCL, we have used KCL to replace our key-value text file to get better programming support.
