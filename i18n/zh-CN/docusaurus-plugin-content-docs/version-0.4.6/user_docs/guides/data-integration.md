---
title: "数据集成"
sidebar_position: 4
---

在 KCL 中，不仅可以将 KCL 编写的配置代码编译输出为 YAML 格式的数据，还可以将 JSON/YAML 等数据直接嵌入到 KCL 语言当中，比如对于如下的 KCL 代码 (main.k)：

```python
import yaml

schema Server:
    ports: [int]

server: Server = yaml.decode("""\
ports:
- 80
- 8080
""")
```

在上述代码中，我们通过 KCL 内置的 `yaml` 模块以及其中的 `yaml.decode` 直接完成 YAML 数据的集成，并且使用 `Server` schema 对集成的 YAML 数据直接进行校验，我们通过如下命令可以获得配置输出:

```bash
$ kcl main.k
server:
  ports:
  - 80
  - 8080
```

此外，我们可以使用 `yaml.encode` 完成 YAML 数据的序列化:

```kcl
import yaml

server = yaml.encode({
    ports = [80, 8080]
})
```

执行命令输出为:

```bash
$ kcl main.k
server: |
  ports:
  - 80
  - 8080
```

同样的，对于 JSON 数据，我们可以使用 `json.encode` 和 `json.decode` 函数以同样的方式进行数据集成

```kcl
import json

server_json_encode = json.encode({
    ports = [80, 8080]
})
server_json_decode = json.decode('{"ports": [80, 8080]}')
```

执行命令输出为:

```bash
$ kcl main.k
server_json_encode: '{"ports": [80, 8080]}'
server_json_decode:
  ports:
  - 80
  - 8080
```
