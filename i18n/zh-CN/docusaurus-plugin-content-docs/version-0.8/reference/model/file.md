---
title: "file"
linkTitle: "file"
type: "docs"
description: 文件系统操作
weight: 100
---

## read

`read(filepath: str) -> str`

读取文件 `filepath` 中的内容，并返回一个字符串实例。

## glob

`glob(pattern: str) -> str`

返回一个包含所有匹配 `pattern` 的文件名的列表。

## modpath

`modpath() -> str`

返回当前模块的根路径（kcl.mod 文件路径或单个 \*.k 文件路径）。

## workdir

`workdir() -> str`

返回当前工作目录的路径。

## exists

`exists(filepath: str) -> bool`

判断文件路径是否存在。如果路径指向一个存在的实体，则返回 True。此函数会遍历符号链接以查询目标文件的信息。

## abs

`abs(filepath: str) -> str`

返回路径的规范化绝对形式，其中所有中间路径均已规范化并解析为符号链接。

## mkdir

`mkdir(directory: str, exists: bool=False)`

如果指定路径上不存在目录，则创建一个新目录。

## delete

`delete(directory: str, exists)`

在指定路径上删除一个文件或空目录。

## cp

`cp(src: str, dest: str)`

将文件或目录从源路径复制到目标路径。

## mv

`mv(src: str, dest: str)`

将文件或目录从源路径移动到目标路径。
