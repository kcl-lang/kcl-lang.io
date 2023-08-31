---
title: "datetime"
linkTitle: "datetime"
type: "docs"
description: datetime 包 - 时间处理
weight: 100
---
## time

`ticks() -> float`

返回从 1970 年 1 月 1 日 0 时 0 分 0 秒（Epoch）开始到当前时间经过的秒数。如果系统时钟能提供更精确的时间，则秒数后可能会有小数部分。

## date

`date() -> str`

返回以 `%Y-%m-%d %H:%M:%S` 格式表示的时间。

## now

`now() -> str`

返回当地时间，例如 `'Sat Jun 06 16:26:11 1998'`。

## today

`today() -> str`

返回以 `%Y-%m-%d %H:%M:%S.%{ticks}` 格式表示的时间。
