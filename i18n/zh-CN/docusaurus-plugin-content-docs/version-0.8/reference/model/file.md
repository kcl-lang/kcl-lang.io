---
title: "file"
linkTitle: "file"
type: "docs"
description: 文件系统操作
weight: 100
---

## read

`read(filepath: string) -> str`

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
