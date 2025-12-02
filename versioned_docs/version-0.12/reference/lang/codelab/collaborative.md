---
title: "Co-configuration with config operations"
linkTitle: "Co-configuration with config operations"
type: "docs"
weight: 2
description: Co-configuration with config operations
sidebar_position: 3
---

## 1. Introduction

KCL is a simple and easy-to-use configuration language, where users can simply write the reusable configuration code.

In this codelab, we will learn how to write the config in a collaborative way using the KCL config operation features.

### What We Will Learn

1. Define schemas and organize project directories.
2. Create multiple environment configurations via the KCL config operation features.
3. Configure compiling parameters and tests.

## 2. Define Schemas and Organize Project Directories

### Schema Definitions

Suppose we want to define a server configuration with certain attributes, we can create a simple config by creating a `server.k`, we can fill in the following code as below which defines a reusable schema of the configuration of a server.

```python
import units

type Unit = units.NumberMultiplier

schema Server:
    replicas: int = 1
    image: str
    resource: Resource = {}
    mainContainer: Main = {}
    labels?: {str:str}
    annotations?: {str:str}

schema Main:
    name: str = "main"
    command?: [str]
    args?: [str]
    ports?: [Port]

schema Resource:
    cpu?: int = 1
    memory?: Unit = 1024Mi
    disk?: Unit = 10Gi

schema Port:
    name?: str
    protocol: "HTTP" | "TCP"
    port: 80 | 443
    targetPort: int

    check:
        targetPort > 1024, "targetPort must be larger than 1024"
```

In the code above, we define a schema named `Server`, which represents the configuration type that the user will write, which contains some basic type attributes (e.g., `replicas`, `image`, etc) and some composite type attributes (e.g., `resource`, `main`, etc). In addition to some basic types mentioned in the [schema codelab](./schema.md), we can see two types in the above code `Unit` and `units.NumberMultiplier`. Among them, `units.NumberMultiplier` denotes the KCL number unit type, which means that a natural unit or binary unit can be added after the KCL number, such as `1K` for `1000`, `1Ki` for `1024`. `Unit` is the type alias of `units.NumberMultiplier`, which is used to simplify the writing of type annotations.

### Project Directories

In order to complete the collaborative configuration development, we first need a configuration project, which contains the configuration of the test application and the differential configuration of different environments, so we are creating the following project directory:

```
.
├── appops
│   └── test_app
│       ├── base
│       │   └── base.k
│       ├── dev
│       │   ├── ci-test
│       │   │   └── stdout.golden.yaml
│       │   ├── kcl.yaml
│       │   └── main.k
│       └── prod
│           ├── ci-test
│           │   └── stdout.golden.yaml
│           ├── kcl.yaml
│           └── main.k
├── kcl.mod
└── pkg
    └── server.k
```

The directory of the project mainly contains three parts:

- `kcl.mod`: The file used to identify the root directory of the KCL project.
- `pkg`: `Server` Schema structure reused by different application configurations.
- `appops`: Server configurations of different applications, currently only one application `test_app` is placed.
  - `base`: Application common configurations for all environments.
  - `dev`: Application configuration for the development environment.
  - `prod`: Application configuration for the production environment.

The meaning of `base.k`, `main.k`, `kcl.yaml` and `ci-test/stdout.golden.yaml` will be mentioned in subsequent sections.

## 3. Create multiple environment configurations via the KCL config operation features

### Create a baseline configuration

After we have organized the project directory and the basic server configuration model, we can write the configuration of the user application. We can create our own test application folder `test_app` and place it in the application configuration folder `appops`.

For the configuration of an application, we often divide it into a basic configuration and the differential configuration of multiple environments and merge them. Through the configuration merging feature of KCL, we can easily do this. Assuming that we have two configurations of development environment and production environment, we can create three folders: `base`, `dev` and `prod` to store baseline, development environment and production environment configurations respectively. First, we write the configuration of `base/base.k`:

```python
import pkg

server: pkg.Server {
    # Set the image with the value "nginx:1.14.2"
    image = "nginx:1.14.2"
    # Add a label app into labels
    labels.app = "test_app"
    # Add a mainContainer config, and its ports are [{protocol = "HTTP", port = 80, targetPort = 1100}]
    mainContainer.ports = [{
        protocol = "HTTP"
        port = 80
        targetPort = 1100
    }]
}
```

As in the above code, we use the `import` keyword in `base.k` to import the `Server` schema placed under `pkg` and use it to instantiate a configuration named `server`, in which we set `image` attribute to `"nginx:1.14.2"`, and a label `app` with the value `test_app` is added. In addition, we also added the configuration of the main container `mainContainer` with the value `[{protocol = "HTTP", port = 80, targetPort = 1100}]` for the ports attribute.

KCL command:

```bash
kcl appops/test_app/base/base.k
```

Output:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
```

At this point, we have a baseline configuration.

### Create multiple environment configurations

Next we configure a differentiated multi-environment configuration. First assume that we want to use a temporary image of our own `nginx:1.14.2-dev` in the development environment, and then use it to override the server configuration in the baseline, we can write the following configuration in `dev/main.k`:

```python
import pkg

server: pkg.Server {
    # Override the image declared in the base
    image = "nginx:1.14.2-dev"
}
```

KCL command:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

Output:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
```

It can be seen that the `image` field of the output YAML is overwritten to `nginx:1.14.2-dev`. Suppose we also want to add a label to the `dev` environment with a key of `env` and a value of `dev`, we add the following code to `dev/main.k`:

```python
import pkg

server: pkg.Server {
    # Override the image declared in the base
    image = "nginx:1.14.2-dev"
    # Union a new label env into base labels
    labels.env = "dev"
}
```

KCL command:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
    env: dev
```

It can be seen that there are two labels in the `labels` field of the output YAML.

In addition, we can also use the `+=` operator to add new values to list type attributes, such as the `mainContainer.ports` configuration in the baseline environment, continue to modify the code in `dev/main.k`:

```python
import pkg

server: pkg.Server {
    # Override the base image.
    image = "nginx:1.14.2-dev"
    # Union a new label env into base labels.
    labels.env = "dev"
    # Append a port into base ports.
    mainContainer.ports += [{
        protocol = "TCP"
        port = 443
        targetPort = 1100
    }]
}
```

KCL command:

```bash
kcl appops/test_app/base/base.k appops/test_app/dev/main.k
```

Output:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2-dev
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
      - protocol: TCP
        port: 443
        targetPort: 1100
  labels:
    app: test_app
    env: dev
```

Using the same method, we can build the production configuration, write the code in the `prod/main.k` file, and add a label to it.

```python
import pkg

server: pkg.Server {
    # Union a new label env into base labels
    labels.env = "prod"
}
```

KCL command:

```bash
kcl appops/test_app/base/base.k appops/test_app/prod/main.k
```

Output:

```yaml
server:
  replicas: 1
  image: nginx:1.14.2
  resource:
    cpu: 1
    memory: 1073741824
    disk: 10737418240
  mainContainer:
    name: main
    ports:
      - protocol: HTTP
        port: 80
        targetPort: 1100
  labels:
    app: test_app
    env: prod
```

## 4. Configure compiling parameters and tests

In the previous section, we built a multi-environment configuration through code. It can be seen that the KCL command line compilation parameters of different environments are similar, so we can configure these compilation parameters into a file and input them to the KCL command line for invocation. Configure the following code in `dev/kcl.yaml`:

```yaml
kcl_cli_configs:
  files:
    - ../base/base.k
    - main.k
  output: ./ci-test/stdout.golden.yaml
```

Then we can compile the configuration in the development environment with the following command:

```bash
cd appops/test_app/dev && kcl -Y ./kcl.yaml
```

In addition, we have configured the `output` field in `dev/kcl.yaml` to output YAML to a file for subsequent configuration distribution or testing. You can verify that the application's configuration is as expected by walking through the `kcl.yaml` builds in each environment and comparing with `./ci-test/stdout.golden.yaml`.

## 5. The Final Step

Congratulations!

We have completed the third lesson about KCL.
