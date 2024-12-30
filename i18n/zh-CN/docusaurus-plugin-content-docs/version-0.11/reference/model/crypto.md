---
title: "crypto"
linkTitle: "crypto"
type: "docs"
description: crypto 包 - 提供 SHA 相关的哈希函数
weight: 100
---

## md5

`md5(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `MD5` 算法对字符串 `value` 进行加密。

```python
import crypto

md5 = crypto.md5("ABCDEF")
```

## sha1

`sha1(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `SHA1` 算法对字符串 `value` 进行加密。

```python
import crypto

sha = crypto.sha1("ABCDEF")
```

## sha224

`sha224(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `SHA224` 算法对字符串 `value` 进行加密。

```python
import crypto

sha = crypto.sha224("ABCDEF")
```

## sha256

`sha256(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `SHA256` 算法对字符串 `value` 进行加密。

```python
import crypto

sha = crypto.sha256("ABCDEF")
```

## sha384

`sha384(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `SHA384` 算法对字符串 `value` 进行加密。

```python
import crypto

sha = crypto.sha384("ABCDEF")
```

## sha512

`sha512(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `SHA512` 算法对字符串 `value` 进行加密。

```python
import crypto

sha = crypto.sha512("ABCDEF")
```

## blake3

`sha512(value: str, encoding: str = "utf-8") -> str`

使用注册编码器和 `BLAKE3` 算法对字符串 `value` 进行加密。

```python
import crypto

blake3 = crypto.blake3("ABCDEF")
```

## fileblake3

`fileblake3(filepath: str) -> str`

使用注册编码器和 `BLAKE3` 算法对从文件`filepath`读取出的内容进行加密。

```python
import crypto

fileblake3 = crypto.fileblake3("test.txt")
```

## uuid

`uuid() -> str`

生成一个随机 UUID 字符串。

```python
import crypto

a = crypto.uuid()
```

## filesha256

`filesha256(filepath: str) -> str`

计算文件 `filepath` 的 SHA256 哈希。

```python
import crypto

sha = crypto.filesha256("test.txt")
```
