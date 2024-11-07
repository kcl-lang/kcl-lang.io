---
title: "regex"
linkTitle: "regex"
type: "docs"
description: regex system module
weight: 100
---

## replace

`replace(string: str, pattern: str, replace: str, count=0) -> str`

Return the string obtained by replacing the leftmost non-overlapping occurrences of the pattern in string by the replacement.

```python
import regex

regex_replace = regex.replace(regex_source, ",", "|")
```

## match

`match(string: str, pattern: str) -> bool`

Try to apply the pattern at the start of the string, returning a bool value `True` if any match was found, or `False` if no match was found.

```python
import regex

regex_result = regex.match("192.168.0.1", "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\."+"(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$")
```

## compile

`compile(pattern: str) -> bool`

Compile a regular expression pattern, returning a bool value denoting whether the pattern is valid.

```python
import regex

regex_compile = regex.compile("$^")
```

## findall

`findall(string: str, pattern: str) -> List[str]`

Return a list of all non-overlapping matches in the string.

```python
import regex

regex_find_all = regex.findall("aaaa", "a")
```

## search

`search(string: str, pattern: str) -> bool`

Scan through string looking for a match to the pattern, returning a bool value `True` if any match was found, or `False` if no match was found.

```python
import regex

regex_search = regex.search("aaaa", "a")
```

## split

`split(string: str, pattern: str, maxsplit=0) -> List[str]`

Return a list composed of words from the string, splitting up to a maximum of `maxsplit` times using `pattern` as the separator.

```python
import regex

regex_split = regex.split(regex_source, ",")
```
