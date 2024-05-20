---
title: "使用 KCL Schema 编写复杂配置"
linkTitle: "使用 KCL Schema 编写复杂配置"
type: "docs"
weight: 2
description: 使用 KCL Schema 编写复杂配置
sidebar_position: 2
---

## 1. 介绍

KCL 是一种简单易用的配置语言，用户可以简单地编写可重用的配置代码。

在本节教程中，我们将学习如何使用 KCL 编写定制配置，这样我们就可以定义一个架构并以协作方式编写配置。

### 本节将会学习

1. 定义一个简单的 schema
2. 为 schema 字段设置默认的不可变值
3. 基于简单的 schema 创建配置
4. 在 schema 中编写复杂的逻辑
5. 通过 schema 的组合创建新的 schema
6. 使用 dict/map 创建具有深度嵌套 schema 的配置
7. 通过 schema 继承创建新的 schema
8. 通过多个 mixin schema 创建新的 schema
9. 声明 schema 验证规则
10. 配置 schema 的输出布局
11. 共享和重用 schema

## 2. 编写简单的 Schema

假设我们希望定义一个具有特定属性的工作负载，我们可以通过创建一个 `my_config.k` 文件来创建一个简单的配置。我们可以按以下方式填写下面的代码，定义一个可重复使用的部署配置的 schema：

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

在上述代码中，`cpu` 和 `memory` 被定义为 int 值；`name`、`image` 和 `service` 是字符串；`command` 是由字符串构成的列表；`labels` 是字典类型，其键和值的类型均为字符串。

另外，每个属性都**必须**被赋予非 None 值作为 schema 实例，除非它被标记问号 **?** 而作为可选参数。

```python
schema Deployment:
    name: str
    cpu: int
    memory: int
    image: str
    service: str
    replica: int
    command: [str]
    labels?: {str:str}  # labels 是一个可选的参数
```

当存在继承关系时：

- 如果在基 schema 中该属性为可选（optional）参数，则在子 schema 中它应该是可选的（optional）或必需的（required）。
- 如果在基 schema 中该属性为必需（required）属性，则在子 schema 中它需要是必需的（required）。

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

## 4. 基于简单 Schema 创建配置

现在我们有了一个简单的 schema 定义，我们可以用它来定义配置：

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

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
    kcl my_config.k
```

标准输出:

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

> 有关集合数据类型和块的更多详细信息，请查看手册和规范。

此外，**配置选择器表达式**（config selector expressions）可以用于初始化 schema 实例，我们可以忽略配置表达式中行末的逗号。

```python
nginx = Deployment {
    name = "my-nginx"
    cpu = 256
    memory = 512
    image = "nginx:1.14.2"
    command = ["nginx"]  # 忽略行尾的逗号
    labels.run = "my-nginx" # schema 中的字典变量可以使用选择器表达式
    labels.env = "pre-prod" # schema 中的字典变量可以使用选择器表达式
}
```

## 5. 在 Schema 中编写更为复杂的逻辑

假设我们有一些schema逻辑，我们可以将它包装进 schema 中：

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

现在，我们可以通过创建 schema 实例来定义配置，并将优先级作为参数传递给模式：

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1.14.2"
    command = ["nginx"]
    labels.run = "my-nginx"
    labels.env = "pre-prod"
}
```

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
kcl my_config.k
```

标准输出:

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

## 6. 通过 Schema 组合创建新 Schema

现在我们想要定义一个详细的 schema，包括服务（service）和卷（volumes），我们可以按以下方式进行操作：

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

在这种情况下，Deployment 由 Service 和一系列 Volume 组成，而 Service 又由一系列 Port 组成。

## 7. 使用 dict/map 创建具有深度嵌套 schema 的配置

现在我们有一个新的 Deployment schema，但我们可能会注意到，它包含多层嵌套的结构，在复杂的结构定义中，这是非常常见的，我们通常必须编写命令式组装代码来生成最终结构。

使用 KCL，我们可以使用简单的字典声明创建配置，并具有完整的 schema 初始化和验证功能。例如，我们可以按照以下方式使用新的 Deployment schema简单地配置 nginx：

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

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
kcl my_config.k
```

标准输出:

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

请注意，我们用于定义 Deployment 配置的字典必须与 schema 定义对齐，否则我们将会得到一个错误。例如，假设我们将服务端口的类型定义错误如下：

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
        port = [80]  # 错误的数据类型，试图将 List 分配给 int
        targetPort = 9376
    }]
}
```

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
kcl my_config.k
```

标准错误输出:

```
The type got is inconsistent with the type expected: expect int, got [int(80)]
```

## 8. 声明 Schema 验证规则

现在我们已经看到了一个复杂的 schema，在其中每个字段都有一个类型提示，以使其更加不容错（error-prone）。

但是这还不够好，我们希望为我们的 schema 支持更多的增强验证，以便尽快发现 schema 和配置中的代码错误。许多验证规则，如 None 类型检查、范围检查、值检查、长度检查、正则表达式匹配、枚举检查已经被添加或陆续添加进来。以下是一段代码示例：

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

由于schema定义的属性默认是**必需的**（required），因此可以省略判断变量不能为 None/Undefined 的验证。

```python
schema Volume:
    name: str
    mountPath: str
    hostPath: str
```

现在我们可以基于新的 schema 编写配置，并及时暴露配置错误。例如，使用以下无效的配置：

```python
nginx = Deployment(priority=2) {
    name = "my-nginx"
    image = "nginx:1142"  # 镜像值不匹配正则表达式
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

每个字段都是类型有效的，但镜像名无效。

运行 KCL，我们将看到如下错误信息：

KCL 命令：

```python
kcl my_config.k
```

标准错误输出:

```
Schema check is failed to check condition: regex.match(image, "^[a-zA-Z]+:\d+\.\d+\.\d+$"), "image name should be like 'nginx:1.14.2'"
```

> KCL 的验证功能涵盖了 Openapi 定义的验证，因此我们可以通过 KCL 编写任何 API 验证。

## 9. 通过 Schema 继承创建新 Schema

现在，我们拥有了一个稳定的部署 schema 定义，可以用它来声明配置。

通常，部署 schema 将被用于多个场景中。我们可以直接使用 schema 在不同的用例中声明配置（见上文的部分），或者我们可以通过继承生成一个更具体的 schema 定义。

例如，我们可以使用部署 schema 作为基础，来定义 nginx 的基本 schema，并在每个场景中扩展定义。在这种情况下，我们定义了一些常用的属性。请注意，我们使用“final”关键字将名称标记为不可变，以防止被覆盖。

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

现在我们有了一些 nginx 的静态配置。建议将我们认为是静态的配置声明在那里，并将更多的动态配置放在下面：

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

现在，我们只需要通过运行时标签值 “prod” 来简单定义 不那么静态的 nginx 生产环境配置。

实际上，在某些复杂情况下，我们可以将所有配置分为基本配置、业务配置和环境配置定义，并基于此实现团队成员之间的协作。

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
kcl prod_config.k
```

标准输出:

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

现在，我们可以通过 Deployment schema 完成服务器配置的声明。

然而，通常实际情况更为复杂，部署可能有各种可选变量附件。

例如，我们想要在现有 schema 中支持声明持久卷，作为可重用的 Kubernetes schema。在这种情况下，我们可以通过以下 `mixin` 和 `protocal` 进行包装：

```python
import k8spkg.api.core.v1

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

有了 PersistentVolumeClaimMixin，我们使用清晰的用户界面（user interface）定义了一个 PVC schema，并使用 Kubernetes PVC 作为实现。然后，我们可以使用 Deployment schema 和 PVC mixin schema 定义一个 server schema。

```python
schema Server(Deployment):
    mixin [PersistentVolumeClaimMixin]
    pvc?: {str:}
    """ pvc user interface data defined by PersistentVolumeClaimMixin """
```

在 Server schema 中，Deployment schema 是基础 schema，而 PersistentVolumeClaimMixin 是一个可选附加项，其用户界面数据为`pvc？：{str：}`。

请注意，mixin 通常用于向宿主 schema 添加新属性，或修改宿主 schema 的现有属性。因此，mixin 可以使用宿主 schema 中的属性。由于其被设计为可重用，因此我们需要一个额外的协议来限制 mixin 中宿主 schema 中属性的名称和类型。

现在，如果我们想要使用 PVC 进行部署，只需声明用户界面：

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

使用以下 KCL 命令运行，我们应该能够看到生成的 yaml 文件作为输出，如下所示：

KCL 命令：

```python
kcl server.k
```

标准输出:

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

如果我们不需要持久卷，只需删除 pvc 配置块。

## 11. 共享和重用 Schema

可以通过导入来共享 Server schema，我们只需要将代码与 KCL 一起打包即可。

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

另一个关于共享代码的技巧是：在同一包下的模块不需要相互导入。

假设我们在 pkg 中有如下 models：

```
pkg/
    - deploy.k
    - server.k
    - pvc.k
```

在 `server.k` 中，我们可以只使用 `deploy.k` 中的 Deployment schema 和 `pvc.k` 中的 pvc schema 而无需导入：

```python
# 无需 import
schema Server(Deployment):
    mixin [PersistentVolumeClaimMixin]
    pvc?: {str:}
    """ pvc user interface data defined by PersistentVolumeClaimMixin """
```

然后用户必须导入 pkg 才能作为一个整体使用它：

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

运行 KCL 命令:

```python
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

## 12. 最后

恭喜！

我们已经完成了 KCL 的第二节课。我们使用 KCL 来替换我们的 key-value 文本文件，以便获得更好的可编程性。
