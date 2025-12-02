---
title: "math"
linkTitle: "math"
type: "docs"
description: math system module
weight: 100
---

## ceil

`ceil(x) -> int`

Return the ceiling of `x` as an Integral. This is the smallest integer >= x.

```python
import math

a = math.ceil(-45.17)
b = math.ceil(100.12)
```

## factorial

`factorial(x) -> int`

Return `x!`. Raise a error if `x` is negative or non-integral.

```python
import math

a = math.factorial(5)
```

## floor

`floor(x) -> int`

Return the floor of `x` as an Integral. This is the largest integer <= x.

```python
import math

a = math.floor(-45.17)
b = math.floor(100.12)
```

## gcd

`gcd(a: int, b: int) -> int`

Return the greatest common divisor of `x` and `y`

```python
import math

a = math.gcd(60, 48)
```

## isfinite

`isfinite(x) -> bool`

Return `True` if `x` is neither an infinity nor a `NaN`, and `False` otherwise.

```python
import math

a = math.isfinite(1)
b = math.isfinite(0)
c = math.isfinite(float("nan"))
```

## isinf

`isinf(x) -> bool`

Return `True` if `x` is a positive or negative infinity, and `False` otherwise.

```python
import math

a = math.isinf(1)
b = math.isinf(0)
c = math.isinf(float("nan"))
```

## isnan

`isnan(x) -> bool`

Return `True` if `x` is a `NaN` (not a number), and `False` otherwise.

```python
import math

a = math.isnan(1)
b = math.isnan(0)
c = math.isnan(float("nan"))
```

## modf

`modf(x) -> List[float, float]`

Return the fractional and integer parts of `x`. Both results carry the sign of `x` and are floats.

```python
import math

a = math.modf(100.12)
b = math.modf(100.72)
```

## exp

`exp(x) -> float`

Return `e` raised to the power of `x`.

```python
import math

a = math.exp(2)
b = math.exp(-6.89)
```

## expm1

`expm1(x) -> float`

Return `exp(x) - 1`. This function avoids the loss of precision involved in the direct evaluation of `exp(x) - 1` for small `x`.

```python
import math

a = math.expm1(32)
b = math.expm1(-10.89)
```

## log

`log(x, base=2.71828182845904523536028747135266250) -> float`

Return the logarithm of `x` to the base `e`.

```python
import math

a = math.log10(100) # 2
```

## log1p

`log1p(x) -> float`

Return the natural logarithm of `1+x` (base `e`). The result is computed in a way which is accurate for `x` near zero.

```python
import math

a = math.log1p(2.7183)
b = math.log1p(2)
c = math.log1p(1)
```

## log2

`log2(x) -> float`

Return the base 2 logarithm of `x`.

```python
import math

a = math.log2(2.7183)
b = math.log2(2)
c = math.log2(1)
```

## log10

`log10(x) -> float`

Return the base 10 logarithm of `x`.

```python
import math

a = math.log10(2.7183)
b = math.log10(2)
c = math.log10(1)
```

## pow

`pow(x, y) -> float`

Return `x**y` (`x` to the power of `y`).

```python
import math

a = math.pow(1, 1)
```

## sqrt

`sqrt(x) -> float`

Return the square root of `x`.

```python
import math

a = math.sqrt(9)
```
