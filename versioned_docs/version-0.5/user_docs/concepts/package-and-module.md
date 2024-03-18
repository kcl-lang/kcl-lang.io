# Module and Package

This section mainly describes how to organize files in KCL.

## Overview

Within a **module**, KCL organizes files grouped by **package**. A package can be defined within a module or be imported externally (through KCL package manager `kpm`). In the latter case, KCL maintains a copy of the package within the module in a dedicated location.

## Module

A KCL module contains a configuration laid out in a directory hierarchy. It contains everything that is needed to deterministically determine the outcome of a KCL configuration. The root of this directory is marked by containing a `kcl.mod` directory. The contents of this directory are mostly managed by the kcl tool such as `kpm`, etc. In that sense, `kcl.mod` is analogous to the `.git` directory marking the root directory of a repo, but where its contents are mostly managed by the git tool. Besides, a KCL module is the largest unit of the file organization, has a fixed location of all KCL files and dependencies.

> Note: The use of a KCL module e.g., `kcl.mod` is optional, but required if one wants to manage, distribute, share and reuse code with a semantic version.

### Creating a module

A module can be created by running the following command within the module root:

```bash
kpm init [module name]
```

The module name is **required** if a package within the module needs to import another package within the module. A module can also be created by setting up the `kcl.mod` file manually.

## Package

In KCL, a package is usually composed of a "folder" containing KCL files. This folder can be a real disk physical path, or it can be composed of multiple KCL files (usually main package). Different packages are uniquely located by different package paths (such as `kubernetes.core.v1`)

Within the same module, different packages can be imported from each other through the import statement of relative or absolute path. During the KCL parsing process, the relative import will be replaced by absolute import and the corresponding KCL code will be found through the package path.

### Relative Import Path

We can use the operator `.` to realize the relative path import of KCL entry files.

main.k:

```python
import .model1  # Current directory module
import ..service  # Parent directory
import ...root  # Parent of parent directory

s = service.ImageService {}
m = root.Schema {}
```

### Absolute Import Path

The semantics of `import a.b.c.d` is

1. If `kcl.mod` not exist, regard the current directory as the package root and search the path `a/b/c/d` from the current directory.
2. If the current directory search fails, search from the root path `ROOT_PATH/a/b/c/d`, else raise an import error.

The definition of the root path `ROOT_PATH` is the directory corresponding to the `kcl.mod` file from the current directory.

Code structure:

```
.
└── root
    ├── kcl.mod
    ├── model
    │   ├── model1.k
    |   ├── model2.k
    │   └── main.k
    ├── service
    │   └── service1.k
    └── mixin
        └── mixin1.k
```

### Builtin Package

KCL has a collection of builtin packages such as `math`, `regex`, etc. To use a builtin package, import it directly and invoke the functions using its qualified identifier. For instance,

```python
import regex

image = "nginx:1.14.2"
is_match = regex.match(image, "^[a-zA-Z]+:\d+\.\d+\.\d+$")

```

The output YAML is

```yaml
image: nginx:1.14.2
is_match: true
```

### Plugin Package

<!--TODO: scenario-related kcl-plugin examples-->

KCL also has a collection of plugin packages such as `hello`, `project_context`, etc. To use a plugin package, import it with a `kcl_plugin.` package path prefix and invoke the functions using its qualified identifier. For instance,

```python
import kcl_plugin.hello

result = hello.add(1, 1)
```

The output YAML is

```yaml
result: 2
```

### Main Package

In KCL, the composition of the main package is usually determined by the compiler parameters. This is because the KCL schema and constraints can be split across files in the package, or even organized across directories, considering the convenience of writing and maintaining the configuration in isolated blocks.

#### Files belonging to a main package

It is up to the user to decide which configurations and constraints to use using the KCL command line. For example,

```bash
kcl file1.k file2.k
```

Thus, the main package contains two KCL files named `file1.k` and `file2.k`.

If KCL is told to load the files for a specific directory, for example:

```bash
kcl ./path/to/package
```

It will only look KCL files with `.k` suffix and ignore files with `_` prefix or `_test.k` into the main package. Besides, if the `./path/to/package` contains `kcl.yaml` files, `kcl.yaml` files be ignored.

In addition, we can set main package files through configuring the command-line compilation setting file (e.g., `kcl.yaml`) as follows:

```yaml
kcl_cli_configs:
  files:
    - file1.k
    - file2.k
```

```bash
kcl -Y kcl.yaml
```

> Note: If we do not specify any input files for KCL, KCL will find the default `kcl.yaml` from the command line execution path to read the input file. Besides, if we tell KCL both the input files and the compilation setting file, KCL will take input files entered by the user as the final value.

```bash
# Whether the 'files' field is configured in `kcl.yaml` or not, the final value of input files is ["file1.k", "file2.k"]
kcl -Y kcl.yaml file1.k file2.k
```

## The relationship and difference between `kcl.mod` and `kcl.yaml`

First of all, in KCL, `kcl.mod` and `kcl.yaml` are both optional. The difference is that `kcl.mod` determines the root path of the package path and whether a KCL module has the requirement of distribution and reuse, and `kcl.yaml` determines the KCL file composition of the main package.

Secondly, for a kcl module for external use only, `kcl.yaml` is optional but `kcl.mod` is required, because it needs to declare the KCL version, module version, dependency and other information.

Finally, for the KCL IDE plug-in, it needs to know the main package information to form a complete compilation process, so it needs to automatically look up the composition of the main package according to the position of the cursor, because no one can specify this information through the KCL command line. The general query logic is to find whether `kcl.yaml` exists. If it is found, the main package consists of the `files` attribute in `kcl.yaml`, and if not found, the main package consists of the current file. The KCL IDE plug-in is selectively aware of the `kcl.mod` file. When the `kcl.mod` file exists, the IDE plug-in reads the corresponding information of all package paths and their real paths in the external dependencies.
