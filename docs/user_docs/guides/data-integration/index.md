# Data Integration

In KCL, we can not only compile and output the configuration code written by KCL into YAML format data, but also directly embed JSON/YAML and other data into the KCL language. For example, for the following KCL code (main.k):

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

In the above code, we use the built-in `yaml` module of KCL and its `yaml.decode` function directly integrates YAML data, and uses the `Server` schema to directly verify the integrated YAML data. We can obtain the configuration output through the following command:

```cmd
$ kcl main.k
server:
  ports:
  - 80
  - 8080
```

In addition, we can use `yaml.encode` to serialize YAML data:

```kcl
import yaml

server = yaml.encode({
    ports = [80, 8080]
})
```

The output of the execution command is:

```cmd
$ kcl main.k
server: |
  ports:
  - 80
  - 8080
```

Similarly, for JSON data, we can use `json.encode` and `json.decode` function performs data integration in the same way:

```kcl
import json

server_json_encode = json.encode({
    ports = [80, 8080]
})
server_json_decode = json.decode('{"ports": [80, 8080]}')
```

The output of the execution command is:

```cmd
$ kcl main.k
server_json_encode: '{"ports": [80, 8080]}'
server_json_decode:
  ports:
  - 80
  - 8080
```
