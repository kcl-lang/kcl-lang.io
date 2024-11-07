---
title: "math"
linkTitle: "math"
type: "docs"
description: math 包 - 数学函数
weight: 100
---

## ceil

`ceil(x) -> int`

返回 `x` 向上取整得到的整数，这是大于等于 `x` 的最小整数。

```python
import math

a = math.ceil(-45.17)
b = math.ceil(100.12)
```

## factorial

`factorial(x) -> int`

返回 `x` 的阶乘（即 `x!`），如果 `x` 是负数或者不是整数，则会引发一个错误。

```python
import math

a = math.factorial(5)
```

## floor

`floor(x) -> int`

返回 `x` 向下取整得到的整数，这是小于等于 `x` 的最大整数。

```python
import math

a = math.floor(-45.17)
b = math.floor(100.12)
```

## gcd

`gcd(a: int, b: int) -> int`

返回 `x` 和 `y` 的最大公约数。

```python
import math

a = math.gcd(60, 48)
```

## isfinite

`isfinite(x) -> bool`

如果 `x` 既不是无穷大也不是 `NaN` 返回 `True`，否则返回 `False`。

```python
import math

a = math.isfinite(1)
b = math.isfinite(0)
c = math.isfinite(float("nan"))
```

## isinf

`isinf(x) -> bool`

如果 `x` 是正无穷或负无穷返回 `True`，否则返回 `False`。

```python
import math

a = math.isinf(1)
b = math.isinf(0)
c = math.isinf(float("nan"))
```

## isnan

`isnan(x) -> bool`

如果 `x` 是 `NaN` 返回 `True`，否则返回 `False`。

```python
import math

a = math.isnan(1)
b = math.isnan(0)
c = math.isnan(float("nan"))
```

## modf

`modf(x) -> List[float, float]`

返回 `x` 的整数和小数部分，两个结果均与 `x` 的正负号相同，并且均为浮点数。

```python
import math

a = math.modf(100.12)
b = math.modf(100.72)
```

## exp

`exp(x) -> float`

返回以 `e` 为底数， `x` 的幂。

```python
import math

a = math.exp(2)
b = math.exp(-6.89)
```

## expm1

`expm1(x) -> float`

返回 `e` 的 `x` 次方减去 1，该函数能够避免由于直接计算 `exp(x) - 1` 而引起的精度损失。

```python
import math

a = math.expm1(32)
b = math.expm1(-10.89)
```

## log

`log(x, base=2.71828182845904523536028747135266250) -> float`

返回以 `e` 为底数，`x` 的对数。

```python
import math

a = math.log10(100) # 2
```

## log1p

`log1p(x) -> float`

返回以 `e` 为底数，`1 + x` 的自然对数，该函数能够在 `x` 靠近 0 时精确计算结果。

```python
import math

a = math.log1p(2.7183)
b = math.log1p(2)
c = math.log1p(1)
```

## log2

`log2(x) -> float`

返回 `x` 的以 2 为底的对数。

```python
import math

a = math.log2(2.7183)
b = math.log2(2)
c = math.log2(1)
```

## log10

`log10(x) -> float`

返回 `x` 的以 10 为底的对数。

```python
import math

a = math.log10(2.7183)
b = math.log10(2)
c = math.log10(1)
```

## pow

`pow(x, y) -> float`

返回 `x` 的 `y` 次幂（即 `x` 的 `y` 次方）。

```python
import math

a = math.pow(1, 1)
```

## sqrt

`sqrt(x) -> float`

返回 `x` 的平方根。

```python
import math

a = math.sqrt(9)
```
