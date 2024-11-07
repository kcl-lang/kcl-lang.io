---
title: "datetime"
linkTitle: "datetime"
type: "docs"
description: datetime system module
weight: 100
---

## ticks

`ticks() -> float`

Return the current time in seconds since the Epoch. Fractions of a second may be present if the system clock provides them.

```python
import datetime

ticks = datetime.ticks()
```

## date

`date() -> str`

Return the `%Y-%m-%d %H:%M:%S` format date.

```python
import datetime

date = datetime.date()
```

## now

`now(format: str = "%a %b %d %H:%M:%S %Y") -> str`

Return the local time format. e.g. 'Sat Jun 06 16:26:11 1998' or format the combined date and time per the specified format string, and the default date format is `%a %b %d %H:%M:%S %Y`.

```python
import datetime

date = datetime.now()
```

## today

`today() -> str`

Return the `%Y-%m-%d %H:%M:%S.%{ticks}` format date.

```python
import datetime

date = datetime.today()
```

## validate

`validate(date: str, format: str) -> bool`

Validate whether the provided date string matches the specified format.

```python
import datetime

result = datetime.validate("2024-08-26", "%Y-%m-%d") # Valid date
```
