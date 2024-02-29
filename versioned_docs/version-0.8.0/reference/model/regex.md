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

## match

`match(string: str, pattern: str) -> bool`

Try to apply the pattern at the start of the string, returning a bool value `True` if any match was found, or `False` if no match was found.

## compile

`compile(pattern: str) -> bool`

Compile a regular expression pattern, returning a bool value denoting whether the pattern is valid.

## findall

`findall(string: str, pattern: str) -> List[str]`

Return a list of all non-overlapping matches in the string.

## search

`search(string: str, pattern: str) -> bool`

Scan through string looking for a match to the pattern, returning a bool value `True` if any match was found, or `False` if no match was found.

## split

`split(string: str, pattern: str, maxsplit=0) -> List[str]`

Return a list composed of words from the string, splitting up to a maximum of `maxsplit` times using `pattern` as the separator.
