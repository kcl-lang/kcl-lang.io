---
title: "units"
linkTitle: "units"
type: "docs"
description: units system module - Unit handlers
weight: 100
---

## Constants

- Fixed point unit constants: `n`, `u`, `m`, `k`, `K`, `G`, `T` and `P`.
- Power of 2 unit constants: `Ki`, `Mi`, `Gi`, `Ti` and `Pi`.

## Functions

- `to_n(num: int) -> str`
  Int literal to string with `n` suffix
- `to_u(num: int) -> str`
  Int literal to string with `u` suffix
- `to_m(num: int) -> str`
  Int literal to string with `m` suffix
- `to_K(num: int) -> str`
  Int literal to string with `K` suffix
- `to_M(num: int) -> str`
  Int literal to string with `M` suffix
- `to_G(num: int) -> str`
  Int literal to string with `G` suffix
- `to_T(num: int) -> str`
  Int literal to string with `T` suffix
- `to_P(num: int) -> str`
  Int literal to string with `P` suffix
- `to_Ki(num: int) -> str`
  Int literal to string with `Ki` suffix
- `to_Mi(num: int) -> str`
  Int literal to string with `Mi` suffix
- `to_Gi(num: int) -> str`
  Int literal to string with `Gi` suffix
- `to_Ti(num: int) -> str`
  Int literal to string with `Ti` suffix
- `to_Pi(num: int) -> str`
  Int literal to string with `Pi` suffix

```python
import units
# SI
n = units.to_n(1e-9)
u = units.to_u(1e-6)
m = units.to_m(1e-1)
K = units.to_K(1000)
M = units.to_M(1000000)
G = units.to_G(1000000000)
T = units.to_T(1000000000000)
P = units.to_P(1000000000000000)
# IEC
Ki = units.to_Ki(1024)
Mi = units.to_Mi(1024 ** 2)
Gi = units.to_Gi(1024 ** 3)
Ti = units.to_Ti(1024 ** 4)
Pi = units.to_Pi(1024 ** 5)
```
