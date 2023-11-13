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

## date

`date() -> str`

Return the `%Y-%m-%d %H:%M:%S` format date.

## now

`now() -> str`

Return the local time. e.g. `'Sat Jun 06 16:26:11 1998'`

## today

`today() -> str`

Return the `%Y-%m-%d %H:%M:%S.%{ticks}` format date.
