---
title: "file"
linkTitle: "file"
type: "docs"
description: file system functions
weight: 100
---

## read

`read(filepath: str) -> str`

Read the contents of the file `filepath` and return a string instance.

```kcl
import file

a = file.read("test.txt")
```

## glob

`glob(pattern: str) -> str`

Return a list containing all file names that match `pattern`.

```kcl
import file

json_files = file.glob("./*.json")
```

## modpath

`modpath() -> str`

Return the root path of the current KCL module (kcl.mod file path or single \*.k file path).

```kcl
import file

modpath = file.modpath()
```

## workdir

`workdir() -> str`

Return the path of the current working directory.

```kcl
import file

workdir = file.workdir()
```

## exists

`exists(filepath: str) -> bool`

Whether this file path exists. Returns true if the path points at an existing entity. This function will traverse symbolic links to query information about the destination file.

```kcl
import file

file_exists = file.exists("test.txt")
```

## abs

`abs(filepath: str) -> str`

Returns the canonical, absolute form of the path with all intermediate components normalized and symbolic links resolved.

```kcl
import file

abs_file_path = file.abs("test.txt")
```

## mkdir

`mkdir(directory: str, exists: bool=False)`

Create a new directory at the specified path if it doesn't already exist.

```kcl
import file

file.mkdir("path")
```

## delete

`delete(directory: str)`

Delete a file or an empty directory at the specified path.

```kcl
import file

file.delete("test.txt")
```

## cp

`cp(src: str, dest: str)`

Copy a file or directory from the source path to the destination path.

```kcl
import file

file.cp("src", "dest")
```

## mv

`mv(src: str, dest: str)`

Move a file or directory from the source path to the destination path.

```kcl
import file

file.mv("src", "dest")
```

## size

`size(filepath: str)`

Get the size of a file at the specified path.

```kcl
import file

size = file.size("test.txt")
```

## write

`write(filepath: str, content: str)`

Write content to a file at the specified path. If the file doesn't exist, it will be created. If it does exist, its content will be replaced.

```kcl
import file

file.write("test.txt", "content")
```

## read_env

`read_env(key: str) -> str`

Read the environment variable `key` from the current process.

```kcl
import file

value = file.read_env("ENV_VAR")
```

## current

`current() -> str`

Read the path of the current script or module that is being executed.

```kcl
import file

value = file.current()
```
