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

## factorial

`factorial(x) -> int`

Return `x!`. Raise a error if `x` is negative or non-integral.

## floor

`floor(x) -> int`

Return the floor of `x` as an Integral. This is the largest integer <= x.

## gcd

`gcd(a: int, b: int) -> int`

Return the greatest common divisor of `x` and `y`

## isfinite

`isfinite(x) -> bool`

Return `True` if `x` is neither an infinity nor a `NaN`, and `False` otherwise.

## isinf

`isinf(x) -> bool`

Return `True` if `x` is a positive or negative infinity, and `False` otherwise.

## isnan

`isnan(x) -> bool`

Return `True` if `x` is a `NaN` (not a number), and `False` otherwise.

## modf

`modf(x) -> List[float, float]`

Return the fractional and integer parts of `x`. Both results carry the sign of `x` and are floats.

## exp

`exp(x) -> float`

Return `e` raised to the power of `x`.

## expm1

`expm1(x) -> float`

Return `exp(x) - 1`. This function avoids the loss of precision involved in the direct evaluation of `exp(x) - 1` for small `x`.

## log

`log(x, base=2.71828182845904523536028747135266250) -> float`

Return the logarithm of `x` to the base `e`.

## log1p

`log1p(x) -> float`

Return the natural logarithm of `1+x` (base `e`). The result is computed in a way which is accurate for `x` near zero.

## log2

`log2(x) -> float`

Return the base 2 logarithm of `x`.

## log10

`log10(x) -> float`

Return the base 10 logarithm of `x`.

## pow

`pow(x, y) -> float`

Return `x**y` (`x` to the power of `y`).

## sqrt

`sqrt(x) -> float`

Return the square root of `x`.
