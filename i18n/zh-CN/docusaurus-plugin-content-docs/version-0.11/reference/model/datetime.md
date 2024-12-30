---
title: "datetime"
linkTitle: "datetime"
type: "docs"
description: datetime 包 - 时间处理
weight: 100
---

## ticks

`ticks() -> float`

返回从 1970 年 1 月 1 日 0 时 0 分 0 秒（Epoch）开始到当前时间经过的秒数。如果系统时钟能提供更精确的时间，则秒数后可能会有小数部分。

```python
import datetime

ticks = datetime.ticks()
```

## date

`date() -> str`

返回以 `%Y-%m-%d %H:%M:%S` 格式表示的时间。

```python
import datetime

date = datetime.date()
```

## now

`now(format: str = "%a %b %d %H:%M:%S %Y") -> str`

返回本地时间格式。例如：`Sat Jun 06 16:26:11 1998`，或者根据指定的格式字符串格式化组合的日期和时间，默认日期格式为 `%a %b %d %H:%M:%S %Y`。

```python
import datetime

date = datetime.now()
```

## today

`today() -> str`

返回以 `%Y-%m-%d %H:%M:%S.%{ticks}` 格式表示的时间。

```python
import datetime

date = datetime.today()
```

## validate

`validate(date: str, format: str) -> bool`

验证提供的日期字符串是否与指定格式匹配。

```python
import datetime

result = datetime.validate("2024-08-26", "%Y-%m-%d") # Valid date
```
