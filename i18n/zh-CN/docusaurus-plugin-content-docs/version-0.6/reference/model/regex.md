---
title: "regex"
linkTitle: "regex"
type: "docs"
description: regex 包 - 正则表达式
weight: 100
---

## replace

`replace(string: str, pattern: str, replace: str, count=0) -> str`

替换字符串 `string`中最左边、不重叠并且匹配模式 `pattern` 的部分替换为指定的字符串 `replace`，并返回替换后的字符串

## match

`match(string: str, pattern: str) -> bool`

尝试在字符串开头应用模式 `pattern`，找到了任何匹配项则返回 `True`，返回 `False` 表示没有找到匹配项

## compile

`compile(pattern: str) -> bool`

编译正则表达式模式 `pattern`，并返回一个布尔值，表示该模式是否有效

## findall

`findall(string: str, pattern: str) -> List[str]`

查找 `pattern` 在 `string` 中的所有非重叠匹配，并以字符串列表的形式返回

## search

`search(string: str, pattern: str) -> bool`

扫描字符串 `string` 以查找与模式匹配的项，如果找到任何匹配项，则返回布尔值 `True`，否则返回 `False`

## split

`split(string: str, pattern: str, maxsplit=0) -> List[str]`

返回一个由字符串内单词组成的列表，使用 `pattern` 作为分隔字符串，最多进行 `maxsplit` 次拆分
