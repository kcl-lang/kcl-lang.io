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

```kcl
import datetime

ticks = datetime.ticks()
```

## date

`date() -> str`

Return the `%Y-%m-%d %H:%M:%S` format date.

```kcl
import datetime

date = datetime.date()
```

## now

`now(format: str = "%a %b %d %H:%M:%S %Y", ticks: float = None) -> str`

Return the local time format. e.g. 'Sat Jun 06 16:26:11 1998' or format the combined date and time per the specified format string, and the default date format is `%a %b %d %H:%M:%S %Y`.

When the optional `ticks` argument (seconds since the Unix epoch, as returned by `ticks()`) is provided, that instant is formatted instead of the current time. This allows rendering arbitrary past or future dates in the local time zone.

```kcl
import datetime

date = datetime.now()
date2 = datetime.now("%Y-%m-%d %H:%M:%S", ticks=0)  # "1970-01-01 00:00:00" (in the local time zone)
```

## today

`today() -> str`

Return the `%Y-%m-%d %H:%M:%S.%{ticks}` format date.

```kcl
import datetime

date = datetime.today()
```

## validate

`validate(date: str, format: str) -> bool`

Validate whether the provided date string matches the specified format.

```kcl
import datetime

result = datetime.validate("2024-08-26", "%Y-%m-%d") # Valid date
```
