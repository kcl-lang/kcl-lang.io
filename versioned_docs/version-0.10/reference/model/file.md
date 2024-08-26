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

## glob

`glob(pattern: str) -> str`

Return a list containing all file names that match `pattern`.

## modpath

`modpath() -> str`

Return the root path of the current KCL module (kcl.mod file path or single \*.k file path).

## workdir

`workdir() -> str`

Return the path of the current working directory.

## exists

`exists(filepath: str) -> bool`

Whether this file path exists. Returns true if the path points at an existing entity. This function will traverse symbolic links to query information about the destination file.

## abs

`abs(filepath: str) -> str`

Returns the canonical, absolute form of the path with all intermediate components normalized and symbolic links resolved.

## mkdir

`mkdir(directory: str, exists: bool=False)`

Create a new directory at the specified path if it doesn't already exist.

## delete

`delete(directory: str)`

Delete a file or an empty directory at the specified path.

## cp

`cp(src: str, dest: str)`

Copy a file or directory from the source path to the destination path.

## mv

`mv(src: str, dest: str)`

Move a file or directory from the source path to the destination path.

## read_env

`read_env(key: str) -> str`

Read the environment variable `key` from the current process.

## current

`current() -> str`

Read the path of the current script or module that is being executed.
